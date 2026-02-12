<?php

/**
 * x消息发送.
 *
 */

namespace common\helpers;

use Yii;
use common\helpers\HttpHelper;

/**
 * Currency Helper
 */
class FileHelper extends BaseHelper {

    /**
     * construct.
     *
     * @return void.
     */
    public function __construct() {
        
    }

    /**
     * 向磁盘写数据
     *
     * @param string $url 缓存路径
     * @param string $addata 对象数据可以先序列化为字符串格式
     * @param string $type 格式，默认为w
     */
    public static function writeFile($url, $addata, $type = 'w') {
        $f = fopen($url, $type);
        flock($f, LOCK_EX);
        fwrite($f, $addata);
        flock($f, LOCK_UN);
        fclose($f);
        unset($f);
        unset($addata);
    }

    public static function random($len) {
        $str = '';
        $chars = md5(mt_rand(1000, 999999)) . strtoupper(md5(mt_rand(1000, 999999))) . md5(mt_rand(1000, 999999)) . strtoupper(md5(mt_rand(1000, 999999))) . md5(mt_rand(1000, 999999));
        $lc = strlen($chars) - 1;
        for ($i = 0; $i < $len; $i++) {
            $str .= $chars[mt_rand(0, $lc)];
        }
        return $str;
    }
    
    /**
     * 删除目录
     * @param type $directory
     */
    public static function delDir($directory) {//自定义函数递归的函数整个目录
        if (file_exists($directory)) {//判断目录是否存在，如果不存在rmdir()函数会出错
            if ($dir_handle = @opendir($directory)) {//打开目录返回目录资源，并判断是否成功
                while ($filename = readdir($dir_handle)) {//遍历目录，读出目录中的文件或文件夹
                    if ($filename != '.' && $filename != '..') {//一定要排除两个特殊的目录
                        $subFile = $directory . "/" . $filename; //将目录下的文件与当前目录相连

                        if (is_dir($subFile)) {//如果是目录条件则成了
                            delDir($subFile); //递归调用自己删除子目录
                        }

                        if (is_file($subFile)) {//如果是文件条件则成立
                            unlink($subFile); //直接删除这个文件
                        }
                    }
                }

                closedir($dir_handle); //关闭目录资源

                rmdir($directory); //删除空目录
            }
        }
    }

}
