<?php

namespace backend\controllers;

use backend\lib\BaseController;
use common\service\FuhaiService;
use common\service\PTZhongwaiService;
use common\service\QiaotouService;
use common\service\AlinService;
use common\service\SihaiService;
use common\service\YunsifangService;
use common\service\DashengService;

use Yii;


class CallbackController extends BaseController
{

    public $layout = false;

    /**
     * 获取回调数据
     * @return array
     */
    private function getCallbackData()
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
        return $data;
    }

    /**
     * 处理回调
     * @param callable $callback
     * @param string $successMsg
     * @return void
     */
    private function handleCallback($callback, $successMsg = "success")
    {
        $data = $this->getCallbackData();
        if (empty($data)) {
            echo "fail";
            return;
        }
        
        $bool = call_user_func($callback, $data);
        if (empty($bool)) {
            echo "fail";
        } else {
            echo $successMsg;
        }
    }

    public function actionFuhai()
    {
        $this->handleCallback(function($data) {
            return (new FuhaiService())->callback($data);
        });
    }

    public function actionQiaotou()
    {
        $this->handleCallback(function($data) {
            return (new QiaotouService())->callback($data);
        });
    }

    public function actionAlin()
    {
        $this->handleCallback(function($data) {
            return (new AlinService())->callback($data);
        }, "OK");
    }

    public function actionSihai()
    {
        $this->handleCallback(function($data) {
            return (new SihaiService())->callback($data);
        });
    }

    public function actionYunsifang()
    {
        $this->handleCallback(function($data) {
            return (new YunsifangService())->callback($data);
        });
    }

    public function actionDasheng()
    {
        $this->handleCallback(function($data) {
            return (new DashengService())->callback($data);
        });
    }

    public function actionPt()
    {
        $this->handleCallback(function($data) {
            return (new PTZhongwaiService())->callback($data);
        });
    }

}
