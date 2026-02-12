<?php

/**
 * x小助手.
 *
 */

namespace common\helpers;

use Yii;

/**
 * AssistantHelper
 */
class AssistantHelper extends BaseHelper {

    /**
     * construct.
     *
     * @return void.
     */
    public function __construct() {
        
    }

    /**
     * 生成字母加数字随机数
     * @param number $length 随机码长度
     * @return mixed.
     */
    public static function getRandStr($length = 6)
    {
        //字符组合
        $str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        $len = strlen($str) - 1;
        $rand_str = '';
        for ($i = 0; $i < $length; $i++) {
            $num = mt_rand(0, $len);
            $rand_str .= $str[$num];
        }
        return $rand_str;
    }

}
