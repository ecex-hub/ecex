<?php

namespace backend\controllers;

use Yii;
use common\controllers\BaseController;
use common\models\AccountInfo;
use common\models\SendSMSLog;
use common\models\WithdrawalOrder;

/**
 * 回调
 */

/**
 * Site controller
 */
class WithdrawalCallBackController extends BaseController {

    public $layout = false;

    /**
     * 提现回调处理
     *
     * @return mixed
     */
    public function actionManage1()
    {
        $data = Yii::$app->request->get();
        if (!empty($data['q'])) {
            unset($data['q']);
        }
        if (empty($data)) {
            $data = Yii::$app->request->post();
        }
        if (empty($data)) {
            $data = json_decode(file_get_contents("php://input"), true);
        }
        
        $orderId = Yii::$app->request->get('orderId');
        if (!empty($orderId)) {
            $model = new WithdrawalOrder();
            $boor = $model->FallBackWithdrawal($orderId);
            if ($boor) {
                echo 'OK';
            } else {
                return false;
            }
        }
    }

}
