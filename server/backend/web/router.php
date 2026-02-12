<?php
/**
 * PHP内置服务器路由脚本
 * 用于支持Yii2的URL重写规则
 */

// 如果请求的是实际存在的文件或目录，直接返回false（让服务器处理）
if (file_exists(__DIR__ . $_SERVER['REQUEST_URI'])) {
    return false;
}

// 所有其他请求都转发到index.php
$_GET['r'] = ltrim($_SERVER['REQUEST_URI'], '/');
require __DIR__ . '/index.php';
