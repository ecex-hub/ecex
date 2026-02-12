<?php

namespace backend\controllers;

use yii\web\Controller;

/**
 * @OA\OpenApi(
 *   @OA\Info(
 *     title="stock-api接口",
 *     version="1.0.0",
 *     description="这是api相关接口",
 *   ),
 *   @OA\Server(
 *     url="http://y2aa-backend.test/",
 *     description="开发环境"
 *   )
 * )
 */
class SwaggerController extends Controller
{

    public function actionIndex()
    {
        $rootPath = \Yii::getAlias('@app');
        return $this->renderFile($rootPath . "/web/swagger.html");
    }
}

