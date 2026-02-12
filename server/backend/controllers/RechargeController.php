<?php

namespace backend\controllers;

use Yii;
use common\models\RechargeOrder;
use common\models\BankList;
use common\models\PayButton;

//支付获取
/**
 * Site controller
 */
class RechargeController extends \backend\lib\ApiBaseController {

    public $layout = false;

    /**
     * getSystemConfigureTypeInfo .
     * 投资下单
     *
     * @return mixed.
     */
    public function actionInvest() {


        $params = $this->params(['ProjectID', 'IncomeLevelID', 'payButtonId']);
        $this->VerificationParameter($params, ['ProjectID', 'IncomeLevelID', 'payButtonId']);

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderIncomeData($uid, $params['ProjectID'], $params['IncomeLevelID'], $params['payButtonId'], $sendIp);

        if (!empty($urlData)) {
            $this->output(['data' => $urlData['url'], 'orderId' => $urlData['orderId']]);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * 银行转账列表
     */
    public function actionBankList() {
        $model = new BankList();
        $fields = ['id', 'realName', 'bankName', 'bankCard'];
        $data = $model->getClientBankList($page = 1, $limit = 10, $fields);
        if (!empty($data['data'])) {
            $this->output($data);
        }
        $this->output_error('暂无数据', 401);
    }

    /**
     * 支付按钮
     */
    public function actionPayButton() {
        $params = $this->params(['type', 'payType']);
        $model = new PayButton();
        $fields = ['id', 'payConfigType', 'payname'];
        if (!empty($params['payType'])) {
            $payType = $params['payType'];
        } else {
            $payType = 1;
        }
        $data = $model->getClientPayButtonList($page = 1, $limit = 10, $fields, $params['type'], $payType);
        if (!empty($data)) {
            $this->output(['data' => $data]);
        }
        $this->output_error('暂无数据', 401);
    }

    /**
     * 银行卡投资
     */
    public function actionBankInvest() {


        $params = $this->params(['ProjectID', 'IncomeLevelID', 'bankId', 'money', 'payName', 'bankPayUrl']);

        if (empty($params['bankPayUrl'])) {
            $this->output_error('图片未上传成功，请重新上传', 401);
        }

        $this->VerificationParameter($params, ['ProjectID', 'IncomeLevelID', 'bankId', 'money', 'payName', 'bankPayUrl']);

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderBankData($uid, $params['ProjectID'], $params['IncomeLevelID'], $params['bankId'],
                $params['money'], $params['payName'], $sendIp, $params['bankPayUrl']);

        if (!empty($urlData)) {
            $this->output(['data' => 'ok']);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * getSystemConfigureTypeInfo .
     * 备付金投资下单
     *
     * @return mixed.
     */
    public function actionStandbyPay() {


        $params = $this->params(['ProjectID', 'IncomeLevelID']);
        $this->VerificationParameter($params, ['ProjectID', 'IncomeLevelID']);

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderStandbyPayData($uid, $params['ProjectID'], $params['IncomeLevelID'], $sendIp);

        if (!empty($urlData)) {
            $this->output(['data' => 'ok']);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * getSystemConfigureTypeInfo .
     * 三方 限时福利投资
     *
     * @return mixed.
     */
    public function actionWelfare() {


        $params = $this->params(['ProjectID', 'payButtonId']);
        $this->VerificationParameter($params, ['ProjectID', 'payButtonId']);

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderLimitedWelfareData($uid, $params['ProjectID'], $params['payButtonId'], $sendIp);

        if (!empty($urlData)) {
            $this->output(['data' => $urlData['url'], 'orderId' => $urlData['orderId']]);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * 银行卡投资
     */
    public function actionBankWelfare() {


        $params = $this->params(['ProjectID', 'bankId', 'money', 'payName', 'bankPayUrl']);
        if (empty($params['bankPayUrl'])) {
            $this->output_error('图片未上传成功，请重新上传', 401);
        }
        $this->VerificationParameter($params, ['ProjectID', 'bankId', 'money', 'payName']); //, 'bankPayUrl'

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderBankLimitedWelfareData($uid, $params['ProjectID'], $params['bankId'],
                $params['money'], $params['payName'], $sendIp, $params['bankPayUrl']);

        if (!empty($urlData)) {
            $this->output(['data' => 'ok']);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * getSystemConfigureTypeInfo .
     * 备付金限时福利
     *
     * @return mixed.
     */
    public function actionStandbyWelfare() {


        $params = $this->params(['ProjectID']);
        $this->VerificationParameter($params, ['ProjectID']);

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderStandbyPayLimitedWelfare($uid, $params['ProjectID'], $sendIp);

        if (!empty($urlData)) {
            $this->output(['data' => 'ok']);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * 银行卡购买备付金
     */
    public function actionBankRechargeStandby() {


        $params = $this->params(['bankId', 'money', 'payName', 'bankPayUrl']);
        if (empty($params['bankPayUrl'])) {
            $this->output_error('图片未上传成功，请重新上传', 401);
        }
        $this->VerificationParameter($params, ['bankId', 'money', 'payName', 'bankPayUrl']);

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderBankDataStandbyPay($uid, $params['bankId'],
                $params['money'], $params['payName'], $sendIp, $params['bankPayUrl']);

        if (!empty($urlData)) {
            $this->output(['data' => 'ok']);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * getSystemConfigureTypeInfo .
     * 三方 购买备付金
     *
     * @return mixed.
     */
    public function actionPayMentStandby() {


        $params = $this->params(['money', 'payButtonId']);
        $this->VerificationParameter($params, ['money', 'payButtonId']);

        $sendIp = $this->getUserIP();

        $uid = Yii::$app->user->identity->uid;

        $model = new RechargeOrder();
        $urlData = $model->addRechargeOrderPaymentStandbyPayData($uid, $params['money'], $params['payButtonId'], $sendIp);

        if (!empty($urlData)) {
            $this->output(['data' => $urlData['url'], 'orderId' => $urlData['orderId']]);
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

}
