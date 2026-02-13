<?php
return [
    'timeZone'=>'Asia/Shanghai',
    'components' => [
        'db' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=rm-3ns7k0jw3l5o744w4.mysql.rds.aliyuncs.com;dbname=stockdata',
            'username' => 'root',
            'password' => 'VsboO4aEtoJ7drZ0',
        ],
        'stockData' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=rm-3ns7k0jw3l5o744w4.mysql.rds.aliyuncs.com;dbname=stockdata',
            'username' => 'root',
            'password' => 'VsboO4aEtoJ7drZ0',
        ],
        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            'viewPath' => '@common/mail',
            // send all mails to a file by default. You have to set
            // 'useFileTransport' to false and configure a transport
            // for the mailer to send real emails.
            'useFileTransport' => true,
        ],
        'redis' => [
            'class' => 'yii\redis\Connection',
            'hostname' => 'r-3nsrp5k12xksku0dms.redis.rds.aliyuncs.com',
            'password' => 'r5O0OT6R1tsSTVt4',
            'port' => 6379,
            'database' => 0,
        ],
    ],
];
