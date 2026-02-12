<?php
/**
 * 环境检查脚本
 * 用于快速检查项目运行所需的环境和配置
 */

echo "========================================\n";
echo "  后端项目环境检查工具\n";
echo "========================================\n\n";

$errors = [];
$warnings = [];
$success = [];

// 1. 检查PHP版本
echo "1. 检查PHP版本...\n";
$phpVersion = PHP_VERSION;
$requiredVersion = '7.4.0';
if (version_compare($phpVersion, $requiredVersion, '>=')) {
    $success[] = "PHP版本: {$phpVersion} ✓";
    echo "   ✓ PHP版本: {$phpVersion}\n";
} else {
    $errors[] = "PHP版本过低: {$phpVersion}，需要 >= {$requiredVersion}";
    echo "   ✗ PHP版本过低: {$phpVersion}，需要 >= {$requiredVersion}\n";
}

// 2. 检查必需的PHP扩展
echo "\n2. 检查PHP扩展...\n";
$requiredExtensions = [
    'openssl',
    'pdo',
    'pdo_mysql',
    'mbstring',
    'json',
    'redis',
    'curl',
];
foreach ($requiredExtensions as $ext) {
    if (extension_loaded($ext)) {
        $success[] = "扩展 {$ext} 已安装 ✓";
        echo "   ✓ {$ext}\n";
    } else {
        $errors[] = "缺少扩展: {$ext}";
        echo "   ✗ 缺少扩展: {$ext}\n";
    }
}

// 3. 检查Composer
echo "\n3. 检查Composer...\n";
$composerPath = shell_exec('which composer 2>&1') ?: shell_exec('where composer 2>&1');
if ($composerPath) {
    $success[] = "Composer已安装 ✓";
    echo "   ✓ Composer已安装\n";
} else {
    $warnings[] = "Composer未找到，请确保已安装Composer";
    echo "   ⚠ Composer未找到\n";
}

// 4. 检查vendor目录
echo "\n4. 检查依赖包...\n";
if (file_exists(__DIR__ . '/vendor/autoload.php')) {
    $success[] = "依赖包已安装 ✓";
    echo "   ✓ vendor目录存在\n";
} else {
    $errors[] = "依赖包未安装，请运行: composer install";
    echo "   ✗ vendor目录不存在，请运行: composer install\n";
}

// 5. 检查配置文件
echo "\n5. 检查配置文件...\n";
$configFiles = [
    'common/config/main-local.php' => '数据库和Redis配置',
    'common/config/params-local.php' => '应用参数配置',
    'backend/config/main-local.php' => '后端应用配置',
];
foreach ($configFiles as $file => $desc) {
    $fullPath = __DIR__ . '/' . $file;
    if (file_exists($fullPath)) {
        $success[] = "配置文件 {$file} 存在 ✓";
        echo "   ✓ {$file}\n";
    } else {
        $warnings[] = "配置文件不存在: {$file}，请运行: php init";
        echo "   ⚠ {$file} 不存在，请运行: php init\n";
    }
}

// 6. 检查数据库配置
echo "\n6. 检查数据库配置...\n";
$dbConfigFile = __DIR__ . '/common/config/main-local.php';
if (file_exists($dbConfigFile)) {
    $config = require $dbConfigFile;
    if (isset($config['components']['db'])) {
        $db = $config['components']['db'];
        $dsn = $db['dsn'] ?? '';
        $username = $db['username'] ?? '';
        $password = $db['password'] ?? '';
        
        // 提取数据库名
        preg_match('/dbname=([^;]+)/', $dsn, $matches);
        $dbname = $matches[1] ?? '';
        
        if (empty($dbname) || empty($username)) {
            $warnings[] = "数据库配置不完整，请检查 common/config/main-local.php";
            echo "   ⚠ 数据库配置不完整\n";
        } else {
            echo "   ✓ 数据库配置存在\n";
            echo "     数据库: {$dbname}\n";
            echo "     用户: {$username}\n";
            
            // 尝试连接数据库
            try {
                $pdo = new PDO($dsn, $username, $password);
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                $success[] = "数据库连接成功 ✓";
                echo "   ✓ 数据库连接成功\n";
            } catch (PDOException $e) {
                $errors[] = "数据库连接失败: " . $e->getMessage();
                echo "   ✗ 数据库连接失败: " . $e->getMessage() . "\n";
            }
        }
    }
} else {
    $warnings[] = "数据库配置文件不存在";
}

// 7. 检查Redis配置
echo "\n7. 检查Redis配置...\n";
$redisConfigFile = __DIR__ . '/common/config/main-local.php';
if (file_exists($redisConfigFile)) {
    $config = require $redisConfigFile;
    if (isset($config['components']['redis'])) {
        $redis = $config['components']['redis'];
        $hostname = $redis['hostname'] ?? '127.0.0.1';
        $port = $redis['port'] ?? 6379;
        
        echo "   Redis地址: {$hostname}:{$port}\n";
        
        // 尝试连接Redis
        try {
            $redisClient = new Redis();
            $connected = @$redisClient->connect($hostname, $port);
            if ($connected) {
                $redisClient->ping();
                $success[] = "Redis连接成功 ✓";
                echo "   ✓ Redis连接成功\n";
                $redisClient->close();
            } else {
                $warnings[] = "Redis连接失败，请确保Redis服务已启动";
                echo "   ⚠ Redis连接失败，请确保Redis服务已启动\n";
            }
        } catch (Exception $e) {
            $warnings[] = "Redis连接失败: " . $e->getMessage();
            echo "   ⚠ Redis连接失败: " . $e->getMessage() . "\n";
        }
    } else {
        $warnings[] = "Redis配置不存在";
        echo "   ⚠ Redis配置不存在\n";
    }
} else {
    $warnings[] = "Redis配置文件不存在";
}

// 8. 检查目录权限
echo "\n8. 检查目录权限...\n";
$writableDirs = [
    'backend/runtime',
    'backend/web/assets',
    'console/runtime',
];
foreach ($writableDirs as $dir) {
    $fullPath = __DIR__ . '/' . $dir;
    if (file_exists($fullPath)) {
        if (is_writable($fullPath)) {
            $success[] = "目录 {$dir} 可写 ✓";
            echo "   ✓ {$dir} 可写\n";
        } else {
            $errors[] = "目录不可写: {$dir}";
            echo "   ✗ {$dir} 不可写\n";
        }
    } else {
        $warnings[] = "目录不存在: {$dir}";
        echo "   ⚠ {$dir} 不存在\n";
    }
}

// 9. 检查数据库文件
echo "\n9. 检查数据库文件...\n";
if (file_exists(__DIR__ . '/stock.sql')) {
    $success[] = "数据库SQL文件存在 ✓";
    echo "   ✓ stock.sql 存在\n";
    $fileSize = filesize(__DIR__ . '/stock.sql');
    echo "     文件大小: " . round($fileSize / 1024, 2) . " KB\n";
} else {
    $warnings[] = "数据库SQL文件不存在: stock.sql";
    echo "   ⚠ stock.sql 不存在\n";
}

// 10. 检查yii命令
echo "\n10. 检查yii命令...\n";
if (file_exists(__DIR__ . '/yii')) {
    if (is_executable(__DIR__ . '/yii') || PHP_OS_FAMILY === 'Windows') {
        $success[] = "yii命令文件存在 ✓";
        echo "   ✓ yii 文件存在\n";
    } else {
        $warnings[] = "yii文件不可执行，请运行: chmod +x yii";
        echo "   ⚠ yii 文件不可执行\n";
    }
} else {
    $errors[] = "yii命令文件不存在";
    echo "   ✗ yii 文件不存在\n";
}

// 总结
echo "\n========================================\n";
echo "  检查结果总结\n";
echo "========================================\n";
echo "成功: " . count($success) . " 项\n";
echo "警告: " . count($warnings) . " 项\n";
echo "错误: " . count($errors) . " 项\n\n";

if (count($errors) > 0) {
    echo "错误列表:\n";
    foreach ($errors as $error) {
        echo "  ✗ {$error}\n";
    }
    echo "\n";
}

if (count($warnings) > 0) {
    echo "警告列表:\n";
    foreach ($warnings as $warning) {
        echo "  ⚠ {$warning}\n";
    }
    echo "\n";
}

if (count($errors) === 0 && count($warnings) === 0) {
    echo "✓ 所有检查通过！项目可以正常运行。\n";
} elseif (count($errors) === 0) {
    echo "✓ 基本检查通过，但有一些警告需要注意。\n";
} else {
    echo "✗ 发现错误，请先解决这些问题再运行项目。\n";
}

echo "\n";
