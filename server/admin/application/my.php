<?php

use think\Env;

$config = [
    // 沙箱模式
    // 应用ID
    'appid' => Env::get('ali.appid', ''),
    // 应用私钥内容 ( 需1行填写，特别注意：这里的应用私钥通常由支付宝密钥管理工具生成 )
    'private_key' => Env::get('ali.private_key', ''),
    // 公钥模式，支付宝公钥内容 ( 需1行填写，特别注意：这里不是应用公钥而是支付宝公钥，通常是上传应用公钥换取支付宝公钥，在网页可以复制 )
    'public_key' => Env::get('ali.public_key', ''),
    // 支付成功通知地址
    'notify_url' => Env::get('ali.notify_url', ''),
    // 网页支付回跳地址
    'return_url' => '',

];
return $config;






##$host = \think\facade\Config::get('mail.host');
