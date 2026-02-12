<?php

/**
 * Created by PhpStorm.
 * User: dsh
 * Date: 2016/12/3
 * Time: 16:37
 */

namespace common\components;

use common\helpers\SignHelper;

class FuncHelper
{

    static $idPool = [];

    static function clearIdPool()
    {
        self::$idPool = [];
    }

    public static function phoneCorrect($phoneNumber)
    {
        // 定义手机号码的正则表达式
        $pattern = '/^1[3-9]\d{9}$/';

        // 使用 preg_match 函数进行匹配
        if (preg_match($pattern, $phoneNumber)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 获取uniqid,使用idPool去重.适用于几百几千id，多了性能消耗太大，不建议使用。
     * @return string
     */
    static function getIdFromPool()
    {
        do {
            $id = self::uniqid12();
        } while (in_array($id, self::$idPool));
        self::$idPool[] = $id;
        return $id;
    }

    /**
     * generate nuiqid
     * @return string
     */
    static function uniqid12()
    {
        // 距2015年的微秒, 60年范围内
        $nowmics = explode(' ', microtime());
        $sec = substr('00' . base_convert(substr(($nowmics[1] - 1420041600), -9), 10, 36), -6);
        $msec = substr('00' . base_convert(substr($nowmics[0], 2, -2), 10, 36), -4);
        // 最后一位随机产生
        return $sec . $msec . base_convert(mt_rand(0, 35), 10, 36) . base_convert(mt_rand(0, 35), 10, 36);
    }


    //订单
    static function generateOrderNumber()
    {
        // 获取当前时间戳（秒级）
        $timestamp = time();
        // 生成随机数（4位）
        $random = mt_rand(100000, 999999);
        // 组合成订单号
        return "W" . date('YmdHis', $timestamp) . $random;
    }

    /**
     * 保存金额
     *
     * @param $money
     *
     * @return float
     */
    public static function formatMoneySave($money)
    {
        return round($money, 2) * 100;
    }

    /**
     * 获取金额
     *
     * @param $money
     *
     * @return float
     */
    public static function formatMoneyGet($money)
    {
        return round($money / 100, 2);
    }

    /**
     * 格式化金额展示
     *
     * @param $money
     *
     * @return mixed
     */
    public static function formatMoneyShow($money)
    {
        return number_format($money / 100, 2, '.', '');
    }


    /**
     * 模拟生成uuid
     * @return string
     */
    public static function uuid($length = 20)
    {
        // Combine timestamp with random number
        $baseString = microtime(true) . bin2hex(random_bytes(10));

        // Hash the base string using SHA-256 or another suitable algorithm
        $hashedString = hash('sha256', $baseString, true); // Use binary output

        // Encode the hashed string in Base64 and remove non-alphanumeric characters
        $encodedString = str_replace(['+', '/', '='], '', base64_encode($hashedString));

        // Ensure the length is exactly 20 characters
        return substr($encodedString, 0, $length);
    }

    /**
     * @param $arrayOne
     * @param $arrayTwo
     *
     * @return array
     */
    public static function arrayDiffValue($arrayOne, $arrayTwo)
    {
        $diffArr = [];
        foreach ($arrayOne as $key => $val) {
            if (isset($arrayTwo[$key]) && $val != $arrayTwo[$key]) {
                $diffArr[$key] = [$val => $arrayTwo[$key]];
            }
        }
        return $diffArr;
    }

    /**
     * 获取指定长度的随机数
     *
     * @param int $len
     *
     * @param int $min
     * @param int $max
     *
     * @return string
     */
    public static function getRandomNumber($len = 19, $min = 0, $max = 9)
    {
        $random = "";
        for ($i = 0; $i < $len; $i++) {
            $random .= rand($min, $max);
        }
        return $random;
    }

    /**
     * 生成30位订单号
     *
     * @param $orderType
     *
     * @return string
     */
    public static function generateOrderNo($orderType)
    {
        $hostIp = $_SERVER['SERVER_ADDR'];
        return date('YmdHis') . sprintf('%02d', $orderType) . ip2long($hostIp) . self::getRandomNumber(3);
    }

    /**
     * 生成16位订单号
     * @return string
     */
    public static function generateTradeNo()
    {
        return date('Ymd') . sprintf('%010d', crc32(self::uniqid12()));
    }

    public static function getClientIp()
    {
        return \Yii::$app->request->getUserIP();
    }

    /**
     * 将XML格式字符串转换为array
     * 参考： http://php.net/manual/zh/book.simplexml.php
     *
     * @param string $str XML格式字符串
     *
     * @return array
     * @throws \Exception
     */
    public static function xml2array($str)
    {
        libxml_disable_entity_loader(true);
        $xml = simplexml_load_string($str, 'SimpleXMLElement', LIBXML_NOCDATA);
        $json = json_encode($xml);
        $result = array();
        $bad_result = json_decode($json, true);  // value，一个字段多次出现，结果中的value是数组
        // return $bad_result;
        foreach ($bad_result as $k => $v) {
            if (is_array($v)) {
                if (count($v) == 0) {
                    $result[$k] = '';
                } else if (count($v) == 1) {
                    $result[$k] = $v[0];
                } else {
                    throw new \Exception('Duplicate elements in XML. ' . $str);
                }
            } else {
                $result[$k] = $v;
            }
        }
        return $result;
    }

    /**
     * 将array转换为XML格式的字符串
     *
     * @param array $data
     *
     * @return string
     * @throws \Exception
     */
    public static function array2xml($data)
    {
        $xml = '<xml>';
        foreach ($data as $key => $val) {
            if (is_numeric($val)) {
                $xml .= "<" . $key . ">" . $val . "</" . $key . ">";
            } else {
                $xml .= "<" . $key . "><![CDATA[" . $val . "]]></" . $key . ">";
            }
        }
        $xml .= '</xml>';
        return $xml;
    }


    /**
     * 隐藏手机号码中间四位
     *
     * @param $phone
     *
     * @return mixed
     */
    public static function hidePhone($phone)
    {
        return $phone;
        if (empty($phone)) {
            return $phone;
        }
        return substr_replace($phone, str_repeat('*', strlen($phone) - 7), 3, -4);
    }


    /**
     * 格式化数组金额
     *
     * @param      $data
     * @param      $field
     * @param bool $needDivide100
     * @param int $decimals
     */
    public static function array_format_number(&$data, $field, $needDivide100 = false, $decimals = 2)
    {
        foreach ($data as $key => $datum) {
            if (!isset($datum[$field])) {
                continue;
            }
            if ($needDivide100) {
                $datum[$field] /= 100;
            }
            $data[$key][$field] = number_format($datum[$field], $decimals, '.', '');
        }
    }

    /**
     * 检测参数是否为空
     *
     * @param $params
     * @param $checkVars
     *
     * @return bool
     * @throws \Exception
     */
    public static function checkParamRequired($params, $checkVars, $throwException = false)
    {
        foreach ($checkVars as $var) {
            if (!isset($params[$var]) || trim($params[$var]) == '') {
                if ($throwException) {
                    throw new \Exception($var . ' is required');
                }
                return false;
            }
        }

        return true;
    }

    /**
     * 获取两个时间 相差月份
     *
     * @param string $date1 2017-05-07
     * @param string $date2 2017-06-08
     * @param string $tags
     *
     * @return float|int
     */
    public static function getMonthDiffNum($date1, $date2, $tags = '-')
    {
        $time1 = strtotime($date1);
        $time2 = strtotime($date2);
        $date1 = explode($tags, $date1);
        $date2 = explode($tags, $date2);
        $months = abs($date1[0] - $date2[0]) * 12;
        if ($time1 > $time2) {
            return $months + $date1[1] - $date2[1];
        } else {
            return -($months + $date2[1] - $date1[1]);
        }
    }

    /**
     * 获取加密的卡号
     *
     * @param $card
     *
     * @return string 前三 后四
     */
    public static function getEncodeCard($card)
    {
        return mb_substr($card, 0, 3) . '****' . mb_substr($card, -4, 4);
    }

    /**
     * 获取图片自定义大小连接
     *
     * @param $url
     * @param $width
     * @param $height
     */
    public static function getImageResizeUrl($url, $width, $height)
    {
        $file = explode('.', $url);
        if (count($file) != 2) {
            return $url;
        }
        list($path, $ext) = $file;
        $path = $path . "_{$width}x{$height}";
        return implode('.', [$path, $ext]);
    }

    /**
     * 判断是否是时间戳
     *
     * @param $timestamp
     *
     * @return bool
     */
    public static function isTimestamp($timestamp)
    {
        if (!is_integer($timestamp)) {
            return false;
        }
        if (strtotime(date('m-d-Y H:i:s', $timestamp)) === $timestamp) {
            return $timestamp;
        } else return false;
    }


    /**
     * 过滤emoji
     *
     * @param $emoji
     *
     * @return mixed
     */
    public static function filterEmoji($emoji)
    {
        $str = preg_replace_callback(    //执行一个正则表达式搜索并且使用一个回调进行替换
            '/./u',
            function (array $match) {
                return strlen($match[0]) >= 4 ? '?' : $match[0];
            },
            $emoji);

        return $str;
    }


    /**
     * 设置url的get参数
     *
     * @param $url
     * @param $params
     *
     * @return string
     */
    public static function setUrlGet($url, $params)
    {
        if (!is_array($params)) {
            return $url;
        }

        $urlParams = [];
        foreach ($params as $key => $param) {
            $urlParams[] = $key . '=' . $param;
        }

        if (strpos($url, '?') === false) {
            $url = $url . '?' . implode('&', $urlParams);
        } else {
            $url = $url . '&' . implode('&', $urlParams);
        }

        return $url;
    }


    /**
     * 设置package重命名包，服务resource下载规范
     * rename 不带扩展名
     *
     * @param $package
     * @param $rename
     *
     * @return mixed
     */
    public static function getPackageRename($package, $rename)
    {
        $package = explode('.', $package);
        $package[0] = $package[0] . '_' . $rename;
        return implode('.', $package);
    }

    /**
     * 生成指定长度随机字符串 支持 字符串 数字 数字+字符串
     *
     * @param int $len
     * @param string $format
     *
     * @return string
     */
    public static function randStr($len = 6, $format = 'ALL')
    {
        $is_abc = $is_numer = 0;
        $restring = $tmp = '';
        switch ($format) {
            case 'ALL':
                $chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
                break;
            case 'CHAR':
                $chars = 'abcdefghijklmnopqrstuvwxyz';
                break;
            case 'NUMBER':
                $chars = '0123456789';
                break;
            default :
                $chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
                break;
        }
        while (strlen($restring) < $len) {
            $tmp = substr($chars, (mt_rand() % strlen($chars)), 1);
            if (($is_numer <> 1 && is_numeric($tmp) && $tmp > 0) || $format == 'CHAR') {
                $is_numer = 1;
            }
            if (($is_abc <> 1 && preg_match('/[a-zA-Z]/', $tmp)) || $format == 'NUMBER') {
                $is_abc = 1;
            }
            $restring .= $tmp;
        }
        if ($is_numer <> 1 || $is_abc <> 1 || empty($restring)) {
            $restring = self::randStr($len, $format);
        }
        return $restring;
    }


    /**
     * 过滤出数组中某几列的值
     *
     * @param array $array
     * @param       $keys
     *
     * @return array
     */
    public static function arrayColumnFilter(&$array, $keys)
    {
        $keys = array_flip(self::arrayVal($keys));

        if (!self::arrayIsColumn($array)) {
            $array = array_intersect_key($array, $keys);
        } else {
            foreach ($array as $k => $row) {
                $array [$k] = array_intersect_key($row, $keys);
            }
        }
        return $array;
    }

    /**
     * 把二维数组某一列作为key键
     *
     * @param array $array 数组
     * @param string $key 数组要作为key键所在列的键
     *
     * @return array
     */
    public static function array_column_askey(&$array, $key)
    {
        if (empty($array)) return $array;
        $data = array();
        foreach ($array as $row) {
            $data [$row [$key]] = $row;
        }
        $array = $data;
        return $array;
    }

    /**
     * 是否数组列表
     * 必须下标从0开始
     *
     * @param $array
     *
     * @return bool
     */
    public static function arrayIsColumn($array)
    {
        return isset($array[0]) && is_array($array[0]);
    }

    /**
     * 变量转换成数据
     *
     * @param string|array $var
     * @param string $spliter 分割字符，逗号必定会被分割，默认分号也会被分割
     *
     * @return array
     */
    public static function arrayVal($var, $spliter = ';')
    {
        if (empty($var))
            return [];
        switch (gettype($var)) {
            case 'string':
                $var = explode(',', strtr($var, [', ' => ',', "$spliter, " => ',', "$spliter" => ',']));
                break;
            case 'array':
                $var = array_values($var);
                break;
            default :
                $var = [$var];
        }
        return $var;
    }

    /**
     * 根据字符键获取多维数组中的值
     * 如arrayValue(array, 's.2')
     *
     * @param array $array 数组
     * @param string $key 键
     * @param mixed $default 默认值
     *
     * @return mixed
     */
    public static function arrayValue($array, $key, $default = null)
    {
        if (strpos($key, '.')) {
            $keys = explode('.', $key);
            $data = $array;
            foreach ($keys as &$key) {
                if (isset($data [$key])) {
                    $data = $data [$key];
                } else {
                    return $default;
                }
            }
            return $data;
        }
        return isset($array [$key]) && $array [$key] !== '' ? $array [$key] : $default;
    }

    /**
     * 重置数组键值名称
     *
     * @param       $data
     * @param array $keyMap ['key' => 'new_key']
     *
     * @return array
     */
    public static function arrayResetKey(&$data, $keyMap)
    {
        if (!is_array($data)) {
            return [];
        }
        // 循环遍历数组
        foreach ($data as &$datum) {
            //>> 循环处理 数组键值变化数据
            foreach ($keyMap as $key => $item) {
                $datum[$item] = isset($datum[$key]) ? $datum[$key] : null;
                if (isset($datum[$key])) {
                    unset($datum[$key]);
                }
            }
        }
        return $data;
    }

    /**
     * @param $array
     * @param $index
     */
    public static function removeArrayKeys(&$array, $index)
    {
        if (!is_array($index)) {
            unset($array[$index]);
            return;
        }

        foreach ($index as $key) {
            if (isset($array[$key])) unset($array[$key]);
        }
    }

    /**
     * @param $array
     * @param $keys
     *
     * @return array
     */
    public static function getArrayKeys($array, $keys)
    {
        if (!is_array($keys)) {
            $keys = [$keys];
        }
        $newArray = [];
        foreach ($keys as $key) {
            if (!isset($array[$key])) {
                $newArray[$key] = null;
            } else {
                $newArray[$key] = $array[$key];
            }
        }

        return $newArray;
    }

    /**
     * 从数组数据中 移除 某些数据
     *
     * @param array $array
     * @param array $items
     *
     * @return mixed
     */
    public static function arrayRemoveItem($array, $items)
    {
        if (!is_array($items)) {
            $items = [$items];
        }
        foreach ($items as $item) {
            if (in_array($item, $array)) {
                array_splice($array, array_search($item, $array), 1);
            }
        }
        return $array;
    }

    /**
     * 秒转天
     *
     * @param $second
     *
     * @return string
     */
    public static function formatSecondToDay($second)
    {
        return number_format($second / 60 / 60 / 24, 2);
    }


    /**
     * 重建图片地址。用于头像等既有完整的连接，又有相对路径的地方。
     *
     * @param      $imageUrl
     * @param      $imageHost
     * @param null $width
     * @param null $height
     *
     * @return string
     */
    public static function rebuildImageUrl($imageUrl, $imageHost, $width = null, $height = null)
    {
        $url = parse_url($imageUrl, PHP_URL_SCHEME);

        if ($url === null || $url === false) {
            if (!empty($width) && !empty($height)) {
                $imageUrl = self::getImageResizeUrl($imageUrl, $width, $height);
            }

            $imageUrl = $imageHost . $imageUrl;
        }

        return $imageUrl;
    }

    /**
     * 过滤出数组中某几列的值
     *
     * @param array $array
     * @param       $keys
     *
     * @return array
     */
    public static function array_column_filter(&$array, $keys)
    {
        $keys = array_flip(self::arrayVal($keys));

        if (!self::array_is_column($array)) {
            $array = array_intersect_key($array, $keys);
        } else {
            foreach ($array as $k => $row) {
                $array [$k] = array_intersect_key($row, $keys);
            }
        }
        return $array;
    }

    /**
     * 是否数组列表
     * 必须下标从0开始
     *
     * @param $array
     *
     * @return bool
     */
    public static function array_is_column($array)
    {
        return isset($array[0]) && is_array($array[0]);
    }

    /**
     * 重新设置Log名称
     *
     * @param string $fileName 不需要.log
     * @param bool $needDate
     */
    public static function setLogFileName($fileName, $needDate = true)
    {
        $fileName = ($needDate ? date('Ymd') . DIRECTORY_SEPARATOR : '') . $fileName . '.log';
        \Yii::$app->log->targets[0]->logFile = \Yii::getAlias('@runtime') . DIRECTORY_SEPARATOR . 'logs' . DIRECTORY_SEPARATOR . $fileName;
    }


    /**
     *
     * @param       $msg
     * @param       $resultCode
     * @param array $extraData
     *
     * @return array
     */
    public static function returnErrorData($msg, $resultCode, $extraData = [])
    {
        return array_merge(['code' => intval($resultCode), 'message' => $msg], $extraData);
    }

    /**
     * 返回成功数据
     *
     * @param array $data
     * @param null $msg
     *
     * @return array
     */
    public static function returnSuccessData($data = [], $msg = null)
    {
        return array_merge(['code' => 0], $data, is_null($msg) ? [] : ['message' => $msg]);
    }

    /**
     * 获取地址
     *
     * @param $url
     * @param $host
     *
     * @return string
     */
    public static function getUrl($url, $host = null)
    {
        if (empty($host)) $host = \Yii::$app->params['resourceHostCdn'];
        if (empty($url)) {
            return '';
        }
        if (strpos($url, 'http') !== 0) {
            if (strpos($url, '/') !== 0) {
                $url = '/' . $url;
            }
            return $host . $url;
        }
        return $url;
    }

    /**
     * 判断是否IOS
     * @return bool
     */
    public static function isIOS()
    {
        return strpos($_SERVER['HTTP_USER_AGENT'], 'iPhone') || strpos($_SERVER['HTTP_USER_AGENT'], 'iPad');
    }

    /**
     * 下划线转驼峰
     */
    public static function convertUnderline($str)
    {
        $str = preg_replace_callback('/([-_]+([a-z]{1}))/i', function ($matches) {
            return strtoupper($matches[2]);
        }, $str);
        return $str;
    }

    /**
     * 驼峰转下划线
     */
    public static function humpToLine($str, $d = '')
    {
        return strtolower(preg_replace('/(?<=[a-z])([A-Z])/', $d . '$1', $str));
    }

    /**
     * 三维数组转二维
     *
     * @param $data
     * @param $data
     *
     * @return string
     */
    public static function threeD($data)
    {
        foreach ($data as $value) {
            foreach ($value as $v) {
                $date[] = $v;
            }
        }
        return $date;
    }

    /**
     * 获取当月 天数
     *
     * @param $data 201803
     * @param $data
     *
     * @return string
     */
    public static function getmonthday($data)
    {
        $date = $data . "01000000";
        return date("t", strtotime($date));
    }

    /**
     *
     * @param       $msg
     * @param       $resultCode
     * @param array $extraData
     *
     * @return array
     */
    public static function returnExternalErrorData($msg, $resultCode, $extraData = [], $key = null)
    {
        $sign_data = array_merge(['code' => intval($resultCode), 'msg' => $msg, 'time' => date('Y-m-d H:i:s')], $extraData);
        $sign = SignHelper::check_sign67($sign_data, $key);
        $extraData['sign'] = $sign;
        return array_merge(['code' => intval($resultCode), 'msg' => $msg, 'time' => date('Y-m-d H:i:s')], $extraData);
    }

    /**
     * 返回成功数据
     *
     * @param array $data
     * @param null $msg
     *
     * @return array
     */
    public static function returnExternalSuccessData($data = [], $msg = null, $key = null)
    {
        $sign_data = array_merge(['code' => 0], $data, ['msg' => $msg], ['time' => date('Y-m-d H:i:s')]);
        $sign = SignHelper::check_sign67($sign_data, $key);
        $data['sign'] = $sign;
        return array_merge(['code' => 0], $data, ['msg' => $msg], ['time' => date('Y-m-d H:i:s')]);
    }

    /**
     * 获取当月 天数
     *
     * @param $data 201803
     * @param $data
     *
     * @return string
     */
    public static function getCdnUrl($url)
    {
        if (empty($url)) {
            return "";
        }
        return \Yii::$app->params['cdn_url'] . $url;
    }

    public static function checkIDCard($idNumber)
    {
        // 正则表达式校验身份证号码格式是否正确
        $pattern = '/^(\d{17}[\d|X])$/';
        if (!preg_match($pattern, $idNumber)) {
            return false;
        }
        return true;
//        // 加权因子，用于计算校验码
//        $weights = array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);
//
//        // 校验码映射表
//        $checkCodes = array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'X');
//
//        // 计算校验码
//        $checksum = 0;
//        for ($i = 0; $i < 17; $i++) {
//            $checksum += intval($idNumber[$i]) * $weights[$i];
//        }
//        $remainder = $checksum % 11;
//        $checkCode = $checkCodes[$remainder];
//
//        // 校验身份证号码最后一位是否与计算得到的校验码一致
//        return $checkCode === $idNumber[17];
    }

    /**
     * 记录日志
     *
     * @param $data 201803
     * @param $data
     *
     * @return string
     */
    public static function ErrLog($path, $params, $msg)
    {
        \Yii::error([
            'path' => $path,
            'params' => $params,
            'msg' => $msg,
        ], 'err');
    }

    public static function DebugLog($path, $params, $msg)
    {
        \Yii::error([
            'path' => $path,
            'params' => $params,
            'msg' => $msg,
        ], 'debug');
    }

    public static function isChinese($str)
    {
        return preg_match('/[\x{4e00}-\x{9fa5}]/u', $str);
    }

    public static function cleanEmojiStr(string $str): string
    {
        // 匹配的表情符号
        $regexEmoticons = '/[\x{1F600}-\x{1F64F}]/u';
        $clean_text = preg_replace($regexEmoticons, '', $str);

//        // 匹配各种符号和象形文字
//        $regexSymbols = '/[\x{1F300}-\x{1F5FF}]/u';
//        $clean_text = preg_replace($regexSymbols, '', $clean_text);
//
//        // 匹配交通和地图符号
//        $regexTransport = '/[\x{1F680}-\x{1F6FF}]/u';
//        $clean_text = preg_replace($regexTransport, '', $clean_text);
//
//        // 匹配其他符号
//        $regexMisc = '/[\x{2600}-\x{26FF}]/u';
//        $clean_text = preg_replace($regexMisc, '', $clean_text);
//
//        $regexDingbats = '/[\x{2700}-\x{27BF}]/u';
//        $clean_text = preg_replace($regexDingbats, '', $clean_text);

        return $clean_text;
    }

    public static function getCurrentMilliseconds()
    {
        return round(microtime(true) * 1000);
    }
}
