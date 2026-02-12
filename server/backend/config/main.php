<?php

$params = array_merge(
    require __DIR__ . '/../../common/config/params.php',
    require __DIR__ . '/../../common/config/params-local.php',
    require __DIR__ . '/params.php',
    require __DIR__ . '/params-local.php'
);

return [
    'id' => 'app-backend',
    'basePath' => dirname(__DIR__),
    'controllerNamespace' => 'backend\controllers',
    'bootstrap' => ['log'],
    'modules' => [],
    'components' => [
//        'request' => [
//            'csrfParam' => '_csrf-backend',
//        ],
        'user' => [
            'identityClass' => 'common\models\AccountInfo',
            'enableAutoLogin' => false,
            'enableSession' => false,
            'loginUrl' => null,
        ],
//        'session' => [
//            'name' => 'advanced-backend',
//            //'cookieParams' => ['httpOnly'=>'true','sameSite'=>'None']
//            //'cookieParams' => ['sameSite'=>'None']
//        ],
        'log' => [
            'traceLevel' => YII_DEBUG ? 3 : 0,
            'targets' => [
                [
                    'class' => 'yii\log\DbTarget',
                    'levels' => ['error'],
                    'except' => [
                        'yii\web\HttpException:404',
                    ],
                    'logTable' => '{{t_system_log}}',
                    'logVars' => [],
                ],
//                [
//                    'class' => 'yii\log\FileTarget',
//                    'levels' => ['info', 'error'],
//                    'logFile' => '@runtime/logs/info.log',
//                ],
            ],
        ],
        'urlManager' => [
            'enablePrettyUrl' => true,
            'showScriptName' => false,
            'rules' => [
            ],
        ],


    ],
    'params' => $params,
];
