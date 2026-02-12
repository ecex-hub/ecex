<?php

namespace backend\controllers;

use common\models\Pay;
use Yii;

/**
 * 支付控制器
 */
class PayController extends \backend\lib\ApiBaseController
{

    public $layout = false;


    /**
     * Login API endpoint
     *
     * @OA\Post(
     *     tags={"支付"},
     *     path="/pay/index",
     *     summary="支付",
     *     description="支付详情",
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 required={"sys_id", "moeny"},
     *                 @OA\Property(
     *                     property="sys_id",
     *                     type="integral",
     *                     description="支付渠道ID"
     *                 ),
     *                 @OA\Property(
     *                     property="money",
     *                     type="integral",
     *                     description="金额"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response="200",
     *         description="Successful operation",
     *         @OA\JsonContent(
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object"
     *             )
     *         )
     *     )
     * )
     */
    public function actionIndex()
    {

        $params = $this->params(['sys_id', 'money']);
        $this->VerificationParameter($params, ['sys_id', 'money']);
        $user = Yii::$app->user->identity;
        $payM = new Pay();
        $sendIp = $this->getUserIP();
        list($code, $msg) = $payM->addPay($user, $params['sys_id'], $params['money'], $sendIp);
        if (empty($code)) {
            $this->output($msg);
        } else {
            $this->output_error($msg, 402);
        }
    }
}
