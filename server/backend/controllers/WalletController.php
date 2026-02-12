<?php

namespace backend\controllers;

use Yii;
use common\models\AccountInfo;
use common\models\RechargeOrder;
use common\models\WithdrawalOrder;
use common\models\BillRecord;
use common\models\PayConfig;

/**
 * 钱包相关接口控制器
 */
class WalletController extends \backend\lib\ApiBaseController
{
    public $layout = false;

    /**
     * @OA\Get(
     *     path="/wallet/info",
     *     tags={"钱包"},
     *     summary="获取钱包信息",
     *     description="获取当前用户的钱包信息，包括余额、积分等",
     *     security={{"bearerAuth": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(property="money", type="number", format="float", example=1000.00, description="余额"),
     *                 @OA\Property(property="pay_back", type="number", format="float", example=500.00, description="回报基金"),
     *                 @OA\Property(property="allowance", type="number", format="float", example=200.00, description="津贴基金"),
     *                 @OA\Property(property="dream_fund", type="number", format="float", example=300.00, description="圆梦基金"),
     *                 @OA\Property(property="points", type="integer", example=1000, description="积分")
     *             )
     *         )
     *     )
     * )
     */
    public function actionInfo()
    {
        $user = Yii::$app->user->identity;

        // 余额钱包：使用回报钱包（pay_back），对应前端的可提现余额
        $balance = $this->changeDecimalReserve($user->pay_back);

        // 充值钱包：使用 money 字段
        $rechargeBalance = $this->changeDecimalReserve($user->money);

        // 待审核金额：统计当前用户申请中的提现金额（type = 1）
        $pendingAmount = 0;
        try {
            $pendingAmount = (float)\common\models\WithdrawalOrder::find()
                    ->where([
                        'uid' => $user->uid,
                        'type' => 1,
                    ])
                    ->sum('money') ?? 0;
        } catch (\Throwable $e) {
            $pendingAmount = 0;
        }

        $data = [
            'balance' => $balance,
            'rechargeBalance' => $rechargeBalance,
            'pendingAmount' => $pendingAmount,
        ];

        $this->output($data);
    }

    /**
     * @OA\Post(
     *     path="/wallet/recharge",
     *     tags={"钱包"},
     *     summary="充值（创建订单并返回支付链接）",
     *     description="创建充值订单并返回第三方支付URL，由前端跳转完成支付",
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"amount", "paymentMethod"},
     *                 @OA\Property(
     *                     property="amount",
     *                     type="number",
     *                     format="float",
     *                     description="充值金额",
     *                     example=100.00
     *                 ),
     *                 @OA\Property(
     *                     property="paymentMethod",
     *                     type="string",
     *                     description="支付方式（wechat/alipay/unionpay 等）",
     *                     example="wechat"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="object")
     *         )
     *     )
     * )
     */
    public function actionRecharge()
    {
        // 前端传参：{ amount, paymentMethod }
        $params = $this->params(['amount', 'paymentMethod']);
        $this->VerificationParameter($params, ['amount', 'paymentMethod']);

        $amount = (float)$params['amount'];
        if ($amount <= 0) {
            $this->output_error('充值金额必须大于0', 422);
        }
        if ($amount < 100) {
            $this->output_error('最低充值金额为100元', 422);
        }

        $user = Yii::$app->user->identity;

        // 支付方式与 PayConfig::payConfigType 的映射
        $method = trim($params['paymentMethod']);
        $methodMap = [
            'alipay'  => 1,
            'wechat'  => 2,
            'unionpay'=> 3,
        ];
        if (!isset($methodMap[$method])) {
            $this->output_error('不支持的支付方式', 422);
        }
        $payConfigType = $methodMap[$method];

        $ip = $this->getUserIP();
        $model = new RechargeOrder();
        $result = $model->addWalletOnlineRechargeOrder($user->uid, $amount, $payConfigType, $ip);
        if ($result === false) {
            $error_mesg = $model->getErrors('mesg');
            $code = 500;
            $msg = '充值下单失败，请稍后重试';
            if (!empty($error_mesg) && isset($error_mesg[0][0], $error_mesg[0][1])) {
                $code = (int)$error_mesg[0][0];
                $msg = $error_mesg[0][1];
            }
            $this->output_error($msg, $code);
        }

        // 返回订单号和支付链接，由前端自行跳转
        $this->output($result);
    }

    /**
     * @OA\Post(
     *     path="/wallet/payment-channels",
     *     tags={"钱包"},
     *     summary="获取支付通道列表",
     *     description="根据充值金额和支付方式获取可用的支付通道列表",
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"amount", "paymentMethod"},
     *                 @OA\Property(
     *                     property="amount",
     *                     type="number",
     *                     format="float",
     *                     description="充值金额",
     *                     example=100.00
     *                 ),
     *                 @OA\Property(
     *                     property="paymentMethod",
     *                     type="string",
     *                     description="支付方式（wechat/alipay/unionpay）",
     *                     example="wechat"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="integer", example=1, description="通道ID"),
     *                     @OA\Property(property="name", type="string", example="微信支付01", description="通道名称"),
     *                     @OA\Property(property="method", type="string", example="wechat", description="支付方式"),
     *                     @OA\Property(property="minMoney", type="number", format="float", example=100, description="单笔最小金额"),
     *                     @OA\Property(property="maxMoney", type="number", format="float", example=1000, description="单笔最大金额"),
     *                     @OA\Property(property="limitText", type="string", example="单笔交易限额100~1000", description="限额文案")
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionPaymentChannels()
    {
        // 前端传参：{ amount, paymentMethod }
        $params = $this->params(['amount', 'paymentMethod']);
        $this->VerificationParameter($params, ['amount', 'paymentMethod']);

        $amount = (float)$params['amount'];
        if ($amount <= 0) {
            $this->output_error('充值金额必须大于0', 422);
        }

        $paymentMethod = trim($params['paymentMethod']);

        // 支付方式与 PayConfig::payConfigType 的映射
        // 1 => 支付宝, 2 => 微信, 3 => 银行卡
        $methodMap = [
            'alipay'  => 1,
            'wechat'  => 2,
            'unionpay'=> 3,
        ];

        if (!isset($methodMap[$paymentMethod])) {
            $this->output_error('不支持的支付方式', 422);
        }

        $payConfigType = $methodMap[$paymentMethod];

        // payType: 1投资 2备付金充值 3混合，这里取充值相关 2（或3）
        $payType = 2;

        // 直接从支付配置表中获取满足金额区间、已启用的通道
        // 避免使用 PayConfig 中依赖 Redis 的方法（如 getRedisCacheOperation）
        $query = PayConfig::find()
            ->where([
                'type'          => 1,              // 启用
                'payConfigType' => $payConfigType, // 支付方式
            ])
            ->andWhere(['<=', 'minMoney', $amount])
            ->andWhere(['>=', 'maxMoney', $amount])
            ->andWhere([
                'or',
                ['payType' => $payType],
                ['payType' => 3],                  // 混合
            ])
            ->orderBy(['sort' => SORT_DESC]);

        $list = $query->asArray()->all();

        $data = [];
        if (!empty($list)) {
            foreach ($list as $item) {
                $min = isset($item['minMoney']) ? (float)$item['minMoney'] : 0;
                $max = isset($item['maxMoney']) ? (float)$item['maxMoney'] : 0;
                $data[] = [
                    'id'        => (int)$item['id'],
                    'name'      => (string)$item['payname'],
                    'method'    => $paymentMethod,
                    'minMoney'  => $min,
                    'maxMoney'  => $max,
                    'limitText' => sprintf('单笔交易限额%s~%s', $min, $max),
                ];
            }
        }

        $this->output($data);
    }

    /**
     * @OA\Post(
     *     path="/wallet/withdraw",
     *     tags={"钱包"},
     *     summary="提现",
     *     description="创建提现订单",
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"amount", "accountType", "accountNumber"},
     *                 @OA\Property(
     *                     property="amount",
     *                     type="number",
     *                     format="float",
     *                     description="提现金额",
     *                     example=50.00
     *                 ),
     *                 @OA\Property(
     *                     property="accountType",
     *                     type="string",
     *                     description="账户类型（alipay/bank 等）",
     *                     example="alipay"
     *                 ),
     *                 @OA\Property(
     *                     property="accountNumber",
     *                     type="string",
     *                     description="账户号（支付宝账号或银行卡号）",
     *                     example="1234567890"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="null", example=null)
     *         )
     *     )
     * )
     */
    public function actionWithdraw()
    {
        // 前端传参：{ amount, accountType, accountNumber }
        $params = $this->params(['amount', 'accountType', 'accountNumber']);
        $this->VerificationParameter($params, ['amount', 'accountType', 'accountNumber']);

        $amount = (float)$params['amount'];
        if ($amount <= 0) {
            $this->output_error('提现金额必须大于0', 422);
        }

        $user = Yii::$app->user->identity;
        $sendIp = $this->getUserIP();

        $model = new WithdrawalOrder();
        $bool = $model->addClientWithdrawal(
            $user,
            $amount,
            $params['accountType'],
            $params['accountNumber'],
            $sendIp
        );

        if ($bool) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\Get(
     *     path="/wallet/transactions",
     *     tags={"钱包"},
     *     summary="资金明细",
     *     description="获取用户的资金明细列表",
     *     security={{"bearerAuth": {}}},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         required=false,
     *         description="页码",
     *         @OA\Schema(type="integer", default=1, minimum=1),
     *         example=1
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         required=false,
     *         description="每页数量",
     *         @OA\Schema(type="integer", default=10, minimum=1, maximum=100),
     *         example=10
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="integer", example=1),
     *                     @OA\Property(property="money", type="number", format="float", example=100.00),
     *                     @OA\Property(property="money_type", type="integer", example=1),
     *                     @OA\Property(property="bill_unit", type="integer", example=1),
     *                     @OA\Property(property="itime", type="integer", example=1735022121)
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionTransactions()
    {
        $params = $this->params(['page', 'size']);
        $page = $params['page'] ?? 1;
        $size = $params['size'] ?? 10;

        $user = Yii::$app->user->identity;
        $model = new BillRecord();
        $list = $model->getList($user->uid, $page, $size);
        $this->output($list);
    }
}
