<?php

/**
 * _______________#########_______________________
 * ______________############_____________________
 * ______________#############____________________
 * _____________##__###########___________________
 * ____________###__######_#####__________________
 * ____________###_#######___####_________________
 * ___________###__##########_####________________
 * __________####__###########_####_______________
 * ________#####___###########__#####_____________
 * _______######___###_########___#####___________
 * _______#####___###___########___######_________
 * ______######___###__###########___######_______
 * _____######___####_##############__######______
 * ____#######__#####################_#######_____
 * ____#######__##############################____
 * ___#######__######_#################_#######___
 * ___#######__######_######_#########___######___
 * ___#######____##__######___######_____######___
 * ___#######________######____#####_____#####____
 * ____######________#####_____#####_____####_____
 * _____#####________####______#####_____###______
 * ______#####______;###________###______#________
 * ________##_______####________####______________
 */

namespace backend\controllers;

use common\components\FuncHelper;
use common\models\BillRecord;
use common\models\Pay;
use Yii;
use common\models\AccountInfo;
use yii\db\Expression;

/**
 * Site controller
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


    public function callback()
    {
        //https://opendocs.alipay.com/open/203/105286
        try {
            $payModel = new Pay();
            $pay = \AliPay\App::instance($payModel->alipayConf());
            $data = $pay->notify();
            if (in_array($data['trade_status'], ['TRADE_SUCCESS', 'TRADE_FINISHED'])) {
                $otn = $data['out_trade_no'];
                $transaction = Yii::$app->db->beginTransaction();
                try {
                    $payInfo = $payModel->getInfo($otn);
                    if (empty($payInfo)) {
                        throw new \Exception('订单不存在');
                    }
                    if ($payInfo['type'] != 1) {
                        throw new \Exception('订单已支付');
                    }
                    $uid = $payInfo['uid'];
                    $money = $payInfo['money'];
                    //账单
                    $billData = [
                        'uid' => $uid,
                        'money' => $money,
                        'money_type' => BillRecord::MoneyTypeOne,
                        'bill_unit' => 'add',
                        'bill_type' => BillRecord::BillTypeBuyRecharge,
                        'itime' => time(),
                        'utime' => time(),
                    ];
                    $billRecord = new BillRecord();
                    if (!$billRecord->insertData($billData)) {
                        throw new \Exception('Failed to save bill record');
                    }
                    //支付账单
                    $boor = $payModel->updateAll([
                        'type' => 2,
                        'response' => json_encode($data),
                    ], ['id' => $payInfo['id']]);
                    if (empty($boor)) {
                        throw new \Exception('Failed to save bill record');
                    }
                    //用户
                    $accountInfo = new AccountInfo();
                    $boor = $accountInfo->updateAll([
                        'money' => new Expression('money+' . $money)
                    ], ['uid' => $uid]);
                    if (empty($boor)) {
                        throw new \Exception('Failed to update user fail');
                    }
                    // 提交事务
                    $transaction->commit();
                    echo 'success';
                } catch (\Exception $e) {
                    $transaction->rollBack();
                    throw new \Exception('Failed to update user fail');
                }
            } else {
                throw new \Exception('订单无效');
            }
        } catch (\Exception $e) {
            // 异常处理
            FuncHelper::ErrLog('pay_callback', [
            ], $e->getMessage());
            echo 'fail';
        }
    }
}
