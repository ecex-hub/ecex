<?php

namespace common\components;

use common\models\RequestLog;
use Yii;
use yii\base\ActionFilter;

class RequestLogger extends ActionFilter
{
    // 在请求处理之前执行
    public function beforeAction($action)
    {
        $user = Yii::$app->user->identity;
        $uid = 0;
        if ($user) {
            $uid = Yii::$app->user->identity->uid;
        }
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        if ($request->pathInfo != 'upload/img') {
            $log = new RequestLog();
            $log->uid = $uid;
            $log->method = $request->method;
            $log->url = $request->url;
            $requestData = [
                'header' => $request->getHeaders()->toArray(),
                'body' => $request->getRawBody(),
            ];
            $log->request = json_encode($requestData);  // 请求参数
            $log->status_code = $response->statusCode;
            $log->itime = time();
            $log->save();
            Yii::$app->params['log_id'] = $log->id;
        }
        return parent::beforeAction($action);
    }

}
