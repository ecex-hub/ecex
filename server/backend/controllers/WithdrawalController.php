<?php

namespace backend\controllers;

use Yii;
use common\models\WithdrawalOrder;


class WithdrawalController extends \backend\lib\ApiBaseController
{

    public $layout = false;

    /**
     * @OA\Post(
     *     path="/withdrawal/add",
     *     summary="用户提现",
     *     tags={"提现"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="card_id",
     *                     description="银行卡ID",
     *                     type="integral",
     *                     example=1
     *                 ),
     *                 @OA\Property(
     *                     property="money",
     *                     description="金额",
     *                     type="integral",
     *                     example="50"
     *                 ),
     *                 @OA\Property(
     *                     property="payPassword",
     *                     description="支付密码",
     *                     type="string",
     *                     example="123456"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionAdd()
    {

        $params = $this->params(['money', 'card_id', 'payPassword']);
        $this->VerificationParameter($params, ['money', 'card_id', 'payPassword']);
        $user = Yii::$app->user->identity;
        $sendIp = $this->getUserIP();
        $current_time = date('H:i');
        // 设置允许提现的时间范围
        $start_time = '08:00';
        $end_time = '17:00';
        // 判断当前时间是否在允许提现的时间范围内
        if ($current_time < $start_time || $current_time > $end_time) {
            // 不在允许时间范围内，提示用户
            $this->output_error("提现时间为每天的上午八点-下午五点，请在规定时间内操作", 212);
        }
        $now = time();
        if ($user->limit_time != 0) {
            if ($user->limit_time == -1) {
                $this->output_error("账户异常，请联系专属接待员", 212);
            }
            if ($user->limit_time > $now) {
                $this->output_error("账户异常，请联系专属接待员", 212);
            }
        }
        $model = new WithdrawalOrder();
        $bool = $model->addWithdrawalOrderData(
            $user, $params['money'],
            $params['card_id'], $sendIp, $params['payPassword']);
        if ($bool) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\POST(
     *     path="/withdrawal/list",
     *     summary="提现列表",
     *     description="Retrieve a paginated list of bank cards bound to the user.",
     *     operationId="getBankCardBindings",
     *     tags={"提现"},
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         description="The number of items per page.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=10
     *         )
     *     ),
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="The page number for pagination.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=1
     *         )
     *     ),
     *     @OA\Parameter(
     *         name="type",
     *         in="query",
     *         description="1-未支付 2-已支付",
     *         @OA\Schema(
     *             type="integer",
     *             example=10
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successful response with a list of bank card bindings",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="HTTP status code"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="Response message"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="integer", example=1),
     *                     @OA\Property(property="money", type="string", example="3"),
     *                     @OA\Property(property="type", type="integral", example="1"),
     *                     @OA\Property(property="pay_type", type="integral", example="1-支付宝 3-银行卡"),
     *                 )
     *             )
     *         )
     *     ),
     * )
     */
    public function actionList()
    {
        $params = $this->params(['page', 'size']);
        $page = $params['page'] ?? 1;
        $row = $params['size'] ?? 10;
        $uid = Yii::$app->user->identity->uid;
        $model = new WithdrawalOrder();
        $data = $model->getClientWithdrawalList($page, $row, $uid);
        $this->output($data);
    }


}
