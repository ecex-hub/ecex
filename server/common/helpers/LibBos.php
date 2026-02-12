<?php

/**
 * Sign Helper.
 *
 * 签名助手
 */

namespace common\helpers;

include 'BaiduBce.phar';

use BaiduBce\BceClientConfigOptions;
use BaiduBce\Util\MimeTypes;
use BaiduBce\Http\HttpHeaders;
use BaiduBce\Services\Bos\BosClient;
use Yii;

/**
 * Sign Helper
 */
class LibBos extends BaseHelper {

    public static function upload($objectKey, $content) {
        $filePath = Yii::$app->params['webrootUrl'] . '/imgTemp/' . $objectKey;
        //写入临时文件
        $fp = fopen($filePath, "w+");
        fwrite($fp, $content);
        fclose($fp);
        //上次到美国服务器
        $boscdn = "scp  $filePath root@47.90.208.249:/var/www/$objectKey";
        exec($boscdn);
    }
    
    public static function uploadTxt($objectKey, $content) {
        $filePath = Yii::$app->params['webrootUrl'] . '/imgTemp/' . $objectKey;
        //写入临时文件
        $fp = fopen($filePath, "w+");
        fwrite($fp, $content);
        fclose($fp);
        //上次到美国服务器
        $boscdn = "scp  $filePath root@47.90.208.249:/var/www/txt/$objectKey";
        exec($boscdn);
    }

    public static function upload1($objectKey, $content,$type) {

        error_reporting(-1);

        define('__BOS_CLIENT_ROOT', dirname(__DIR__));

        //$conf = require $GLOBALS['ROOT_PATH'] . 'app/conf/bos_conf.php';
        
        $conf = Yii::$app->params['bosConf'];

        // 设置BosClient的Access Key ID、Secret Access Key和ENDPOINT
        $BOS_TEST_CONFIG = array(
            'credentials' => array(
                'accessKeyId' => $conf['ak'],
                'secretAccessKey' => $conf['sk']
            ),
            'endpoint' => $conf['area'],
        );

        // 设置log的格式和级别
 //       $__handler = new \Monolog\Handler\StreamHandler(STDERR, \Monolog\Logger::DEBUG);
 //       $__handler->setFormatter(
 //               new \Monolog\Formatter\LineFormatter(null, null, false, true)
 //       );
//    \BaiduBce\Log\LogFactory::setInstance(
//        new \BaiduBce\Log\MonoLogFactory(array($__handler))
//    );
   //     \BaiduBce\Log\LogFactory::setLogLevel(\Psr\Log\LogLevel::DEBUG);

        //调用配置文件中的参数
        //global $BOS_TEST_CONFIG;
        //新建BosClient
        $client = new BosClient($BOS_TEST_CONFIG);
        $bucketName = $conf['dbname'];

        try {
            if ($type == 1) {//文件
                $client->putObjectFromFile($bucketName, $objectKey, $content);
            } else if ($type = 2) {//字符串
                $client->putObjectFromString($bucketName, $objectKey, $content);
            } else {
                return 0;
            }
        } catch (\BaiduBce\Exception\BceBaseException $e) {
            return 0;
        }
        return 1;
    }

    public static function del($objectKey) {
        error_reporting(-1);

        define('__BOS_CLIENT_ROOT', dirname(__DIR__));

        //$conf = require $GLOBALS['ROOT_PATH'] . 'app/conf/bos_conf.php';
        $conf = Yii::$app->params['bosConf'];
        // 设置BosClient的Access Key ID、Secret Access Key和ENDPOINT
        $BOS_TEST_CONFIG = array(
            'credentials' => array(
                'accessKeyId' => $conf['ak'],
                'secretAccessKey' => $conf['sk']
            ),
            'endpoint' => $conf['area'],
        );

        // 设置log的格式和级别
        $__handler = new \Monolog\Handler\StreamHandler(STDERR, \Monolog\Logger::DEBUG);
        $__handler->setFormatter(
                new \Monolog\Formatter\LineFormatter(null, null, false, true)
        );
//    \BaiduBce\Log\LogFactory::setInstance(
//        new \BaiduBce\Log\MonoLogFactory(array($__handler))
//    );
        \BaiduBce\Log\LogFactory::setLogLevel(\Psr\Log\LogLevel::DEBUG);

        //调用配置文件中的参数
        //global $BOS_TEST_CONFIG;
        //新建BosClient
        $client = new BosClient($BOS_TEST_CONFIG);
        $bucketName = $conf['dbname'];

        try {
            $client->getObjectMetadata($bucketName, $objectKey);
            $client->deleteObject($bucketName, $objectKey);
        } catch (\BaiduBce\Exception\BceBaseException $e) {
            
        }
    }

}
