<?php

namespace backend\controllers;

use common\models\BindBankCard;
use Yii;

/**
 * 收款账户控制器
 */
class PaymentAccountsController extends \backend\lib\ApiBaseController
{
    public $layout = false;

    /**
     * @OA\GET(
     *     path="/payment-accounts/list",
     *     summary="获取收款账户列表",
     *     description="获取当前用户的所有收款账户列表（银行卡和支付宝）",
     *     operationId="getPaymentAccountList",
     *     tags={"收款账户"},
     *     security={{"bearerAuth": {}}},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         required=false,
     *         description="页码，从1开始",
     *         @OA\Schema(type="integer", default=1, minimum=1),
     *         example=1
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         required=false,
     *         description="每页数量",
     *         @OA\Schema(type="integer", default=30, minimum=1, maximum=100),
     *         example=30
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回收款账户列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="HTTP状态码"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="响应消息"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="integer", example=1, description="账户ID"),
     *                     @OA\Property(property="type", type="string", example="alipay", description="账户类型：alipay-支付宝, bank-银行卡"),
     *                     @OA\Property(property="pay_type", type="integer", example=2, description="支付类型：1-银行卡 2-支付宝"),
     *                     @OA\Property(property="name", type="string", example="支付宝", description="账户名称"),
     *                     @OA\Property(property="accountName", type="string", example="张三", description="账户持有人姓名"),
     *                     @OA\Property(property="accountNumber", type="string", example="138****8888", description="账户号（脱敏）"),
     *                     @OA\Property(property="bankName", type="string", example="中国银行", description="银行名称（仅银行卡）"),
     *                     @OA\Property(property="itime", type="integer", example=1735035101, description="创建时间戳"),
     *                     @OA\Property(property="utime", type="integer", example=1735035101, description="更新时间戳")
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionList()
    {
        $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
        $size = isset($_GET['size']) ? intval($_GET['size']) : 30;
        
        $model = new BindBankCard();
        $uid = Yii::$app->user->identity->uid;
        $fields = ['id', 'realName', 'bankName', 'bankCard', 'alipay_card', 'pay_type', 'itime', 'utime'];
        
        $list = $model->getClientBindBankCardList($page, $size, $uid, $fields);
        
        $result = [];
        foreach ($list as $item) {
            $payType = intval($item['pay_type']);
            
            // 将 pay_type 转换为前端需要的 type 格式
            // 1-银行卡 -> bank, 2-支付宝 -> alipay
            $type = $payType == 1 ? 'bank' : 'alipay';
            
            // 账户名称
            $name = $payType == 1 ? ($item['bankName'] ?? '银行卡') : '支付宝';
            
            // 账户号（脱敏处理）
            $accountNumber = '';
            if ($payType == 1) {
                // 银行卡号脱敏
                $bankCard = $item['bankCard'] ?? '';
                if (strlen($bankCard) > 4) {
                    $accountNumber = substr($bankCard, 0, 4) . ' **** ' . ' **** ' . substr($bankCard, -4);
                } else {
                    $accountNumber = $bankCard;
                }
            } else {
                // 支付宝账号脱敏
                $alipayCard = $item['alipay_card'] ?? '';
                if (strlen($alipayCard) > 0) {
                    // 如果是手机号格式，脱敏中间部分
                    if (preg_match('/^1[3-9]\d{9}$/', $alipayCard)) {
                        $accountNumber = substr($alipayCard, 0, 3) . '****' . substr($alipayCard, -4);
                    } else {
                        // 其他格式，显示前3位和后4位
                        $len = strlen($alipayCard);
                        if ($len > 7) {
                            $accountNumber = substr($alipayCard, 0, 3) . '****' . substr($alipayCard, -4);
                        } else {
                            $accountNumber = $alipayCard;
                        }
                    }
                }
            }
            
            $result[] = [
                'id' => intval($item['id']),
                'type' => $type,
                'pay_type' => $payType,
                'name' => $name,
                'accountName' => $item['realName'] ?? '',
                'accountNumber' => $accountNumber,
                'bankName' => $item['bankName'] ?? '',
                'itime' => intval($item['itime'] ?? 0),
                'utime' => intval($item['utime'] ?? 0),
            ];
        }
        
        $this->output($result);
    }

    /**
     * @OA\POST(
     *     path="/payment-accounts/add",
     *     summary="添加收款账户",
     *     description="添加新的收款账户（银行卡或支付宝）",
     *     operationId="addPaymentAccount",
     *     tags={"收款账户"},
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         description="收款账户信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"pay_type"},
     *                 @OA\Property(
     *                     property="pay_type",
     *                     type="integer",
     *                     description="支付类型：1-银行卡 2-支付宝",
     *                     example=2
     *                 ),
     *                 @OA\Property(
     *                     property="bankNameId",
     *                     type="integer",
     *                     description="银行ID（pay_type=1时必填）",
     *                     example=1
     *                 ),
     *                 @OA\Property(
     *                     property="otherBankName",
     *                     type="string",
     *                     description="其他银行名称（pay_type=1且选择其他银行时填写）",
     *                     example=""
     *                 ),
     *                 @OA\Property(
     *                     property="bankCard",
     *                     type="string",
     *                     description="银行卡号（pay_type=1时必填）",
     *                     example="6222021234567890123"
     *                 ),
     *                 @OA\Property(
     *                     property="alipay_card",
     *                     type="string",
     *                     description="支付宝账号（pay_type=2时必填）",
     *                     example="13800138000"
     *                 ),
     *                 @OA\Property(
     *                     property="realName",
     *                     type="string",
     *                     description="真实姓名（必填，需与实名认证姓名一致）",
     *                     example="张三"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功添加收款账户",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="HTTP状态码"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="响应消息"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 nullable=true,
     *                 description="返回数据"
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=422,
     *         description="参数验证失败",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=422),
     *             @OA\Property(property="message", type="string", example="错误信息")
     *         )
     *     )
     * )
     */
    public function actionAdd()
    {
        $params = $this->params(['pay_type', 'bankNameId', 'bankCard', 'realName', 'alipay_card', 'otherBankName']);
        
        // 验证 pay_type 必填
        $this->VerificationParameter($params, ['pay_type']);
        
        $payType = intval($params['pay_type']);
        
        // 根据支付类型验证必填字段
        if ($payType == 1) {
            // 银行卡类型：需要 bankCard 和 realName
            $this->VerificationParameter($params, ['bankCard', 'realName']);
        } else if ($payType == 2) {
            // 支付宝类型：需要 alipay_card 和 realName
            $this->VerificationParameter($params, ['realName', 'alipay_card']);
        } else {
            $this->output_error('支付类型错误，1-银行卡 2-支付宝', 422);
            return;
        }
        
        $user = Yii::$app->user->identity;
        $model = new BindBankCard();
        
        $result = $model->addBindBankCard($user, $params);
        
        if ($result) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            if (!empty($error_mesg) && is_array($error_mesg[0])) {
                $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
            } else {
                $this->output_error('添加失败，请重试', 422);
            }
        }
    }
}
