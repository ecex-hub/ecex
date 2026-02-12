<?php

namespace app\components;

use yii\web\Response;
use yii\web\ErrorAction;
use yii\web\NotFoundHttpException;
use yii\web\UnauthorizedHttpException;
use yii\base\BootstrapInterface;

class ErrorJsonHandler implements BootstrapInterface
{
    public function bootstrap($app)
    {
        $app->on(\yii\base\Application::EVENT_BEFORE_ACTION, function ($event) {
            if (\Yii::$app->request->getIsAjax() || \Yii::$app->request->getIsPjax() || strpos(\Yii::$app->request->getAcceptableContentTypes(), 'json') !== false) {
                \Yii::$app->response->format = Response::FORMAT_JSON;
            }
        });

        $app->errorHandler->register();
    }

    public function handleException($exception)
    {
        \Yii::$app->response->data = [
            'code' => $exception->getCode(),
            'message' => $exception->getMessage(),
        ];

        if ($exception instanceof UnauthorizedHttpException) {
            \Yii::$app->response->setStatusCode(401);
        } elseif ($exception instanceof NotFoundHttpException) {
            \Yii::$app->response->setStatusCode(404);
        } else {
            \Yii::$app->response->setStatusCode(500);
        }

        \Yii::$app->end();
    }
}