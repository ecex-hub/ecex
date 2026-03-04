<?php
/**
 * PHP内置服务器路由脚本
 * 用于支持Yii2的URL重写规则
 */

$requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?: '/';

// 1. 优先处理静态资源（当前应用 web 目录下的文件）
if (file_exists(__DIR__ . $requestUri)) {
    return false;
}

// 2. 特殊处理上传目录：将 /uploads/* 映射到 admin/public/uploads/*
$uploadsPrefix = '/uploads/';
if (strpos($requestUri, $uploadsPrefix) === 0) {
    // admin/public 目录
    $adminPublicDir = realpath(__DIR__ . '/../../admin/public');
    if ($adminPublicDir !== false) {
        $filePath = realpath($adminPublicDir . $requestUri);
        // 安全校验：必须仍在 adminPublicDir 之下，且为文件
        if ($filePath !== false && strpos($filePath, $adminPublicDir) === 0 && is_file($filePath)) {
            // 根据扩展名简单设置 Content-Type
            $ext = strtolower(pathinfo($filePath, PATHINFO_EXTENSION));
            switch ($ext) {
                case 'png':
                    header('Content-Type: image/png');
                    break;
                case 'jpg':
                case 'jpeg':
                    header('Content-Type: image/jpeg');
                    break;
                case 'gif':
                    header('Content-Type: image/gif');
                    break;
                default:
                    header('Content-Type: application/octet-stream');
            }

            readfile($filePath);
            return true;
        }
    }
}

// 3. 所有其他请求都转发到 index.php，由 Yii 处理
$_GET['r'] = ltrim($requestUri, '/');
require __DIR__ . '/index.php';
