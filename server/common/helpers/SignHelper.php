<?php

/**
 * Sign Helper.
 *
 * 签名助手
 */

namespace common\helpers;

use phpDocumentor\Reflection\Types\Self_;

/**
 * Sign Helper
 */
class SignHelper extends BaseHelper {

    public static function checkSignNew1($param, $appSecret) {
        $params = array_filter($param);
        ksort($params);

        $dataStr = http_build_query($params);
        $dataStr = urldecode($dataStr);

        $dataStr .= $appSecret;
        $sign = md5($dataStr);
        return $sign;
    }

    public static function checkSignNew2($data, $signkey) {

        $data = array_filter($data); //去空
        ksort($data); //排序
        $tmp_string = http_build_query($data); //进行键值对排列  a=1&b=2&c=3
        $tmp_string = urldecode($tmp_string); //参数无需进行urlencode ,上一步进行了urlencode,这里还原一下
        return md5($tmp_string . '&key=' . $signkey);  //签名生成
    }

    public static function checkSignNew4($data, $signkey) {
        ksort($data);
        $md5str = "";
        foreach ($data as $key => $val) {
            if (!empty($val))
                $md5str = $md5str . $key . "=" . $val . "&";
        }

        return strtoupper(md5($md5str . "key=" . $signkey));
    }

    public static function checknotifySignNew4($data, $signkey) {
        ksort($data);
        reset($data);
        $md5str = "";
        foreach ($data as $key => $val) {
            $md5str = $md5str . $key . "=" . $val . "&";
        }
        return strtoupper(md5($md5str . "key=" . $signkey));
    }

    public static function checkSignNew5($data, $signkey) {
        ksort($data);
        $md5str = "";
        foreach ($data as $key => $val) {
            $md5str = $md5str . $key . "=" . $val . "&";
        }

        return md5($md5str . "key=" . $signkey);
    }

    public static function checkSignNew9($data, $signkey) {
        // ksort($data);
        $md5str = "";
        foreach ($data as $key => $val) {

            $md5str = $md5str . $key . "=" . $val . "&";
        }
        $md5str = substr($md5str, 0, strlen($md5str) - 1);
        $md5str = htmlspecialchars($md5str); //&not
        //   var_dump($str);
        var_dump($md5str . $signkey);
        return strtoupper(md5($md5str . $signkey));
    }

    public static function checkSignNew10($api_key, $api_secret, $action, $timestamp) {
        //大写，并且拼接
        $str = strtoupper($api_key) . strtoupper($api_secret) . strtoupper($action) . strtoupper($timestamp);
        //加密并且转化为大写
        $sign = strtoupper(hash_hmac('sha256', $str, $api_secret));

        //计算出来结果
        return $sign;
    }

    public static function checkSignNew11($paramArray, $mchKey) {
        ksort($paramArray);  //字典排序
        reset($paramArray);

        $md5str = "";
        foreach ($paramArray as $key => $val) {
            if (strlen($key) && strlen($val)) {
                $md5str = $md5str . $key . "=" . $val . "&";
            }
        }
      //  var_dump($md5str . "key=" . $mchKey);
        $sign = strtoupper(md5($md5str . "key=" . $mchKey));  //签名

        return $sign;
    }

//     function($data, $signkey){
//        $data = array_filter($data); //去空
//        ksort($data); //排序
//        $tmp_string = http_build_query($data); //进行键值对排列  a=1&b=2&c=3
//        $tmp_string = urldecode($tmp_string); //参数无需进行urlencode ,上一步进行了urlencode,这里还原一下
//        return md5( $tmp_string .'&key='. $signkey );  //签名生成
//    }

    public static function get_client_ip_simple() {
        $client_ip = '127.0.0.1';
        $param_keys = [
            'X-FORWARDED-FOR',
            'X-REAL-FORWARDED-FOR',
            'HTTP_X_FORWARDED_FOR',
            'HTTP_X_REAL_IP',
            'X-REAL-IP',
            'HTTP_CLIENT-IP',
            'REMOTE_ADDR'
        ];
        foreach ($param_keys as $key => $value) {
            if (isset($_SERVER[$value])) {
                $client_ip = $_SERVER[$value];
                break;
            }
        }
        $client_ip_arr = explode(' ', $client_ip);

        return current($client_ip_arr);
    }

    ////////
    //毫秒时间戳
    public static function msectime() {
        list($msec, $sec) = explode(' ', microtime());
        $msectime = (float) sprintf('%.0f', (floatval($msec) + floatval($sec)) * 1000);
        return $msectime;
    }

    public static function checkSign1($data, $signKey) {
        array_filter($data);
        ksort($data);
        $signStr = '';
        foreach ($data as $k => $v) {
            if ($k !== 'sign' && ($v !== null && $v !== '')) {
                $signStr .= $k . '=' . $v . '&';
            }
        }
        //下单完成签钥示例
        //amount=3000&appid=用户appid&body=test&clientIp=127.0.0.1&currency=cny&method=aliapy.sdk&notifyUrl=http://127.0.0.1:8000/notify/test&outTradeNo=T1594532628&productCode=903&returnUrl=https://www.baidu.com&subject=test&key=用户签钥
        return md5($signStr . 'key=' . $signKey);
    }

    //9平台加密算法
    public static function delarray9($data, $codepay_key) {
        ksort($data); //重新排序$data数组
        reset($data); //内部指针指向数组中的第一个元素
        foreach ($data as $key => $val) {
            //遍历需要传递的参数
            if ($val == '' || $key == 'sign') {
                continue;
            }
            //跳过这些不参数签名
            if (!empty($sign)) {
                //后面追加&拼接URL
                $sign .= "&";
                //$urls .= "&";
                $sign .= "$key=$val"; //拼接为url参数形式
            } else {
                $sign = "$key=$val";
            }
        }
        return md5($sign . '&key=' . $codepay_key);
    }

    /**
     * 1号签名
     * @param type $sign
     * @return type
     */
    public static function check_new_sign1($data, $Secret_key, $iv) {
        $str = $Secret_key . '|' . $data['bid'] . '|' . $data['money'] . '|' . $data['order_sn'] . '|' . $data['notify_url'] . '|' . $iv;
        return md5($str);
    }

    /**
     * 1号回调签名
     * @param type $sign
     * @return type
     */
    public static function check_new_call_sign1($data, $Secret_key, $iv) {
        $str = $Secret_key . '|' . $data['pay_time'] . '|' . $data['money'] . '|' . $data['pay_money'] . '|' . $data['order_sn'] . '|' . $data['sys_order_sn'] . '|' . $iv;
        return md5($str);
    }

    /**
     * 2号签名
     * @param type $args
     * @param type $key
     * @return type
     */
    static function check_new_sign2($args, $key) {

        ksort($args);
        $requestString = '';
        foreach ($args as $k => $v) {
            if ($v != null && $v != "") {
                $requestString .= $k . '=' . $v . "&";
            }
        }
        $requestString .= "key=" . $key;

        $newSign = strtoupper(md5($requestString));
        return $newSign;
    }

    //3通道获得签名
    public static function getSign3($data) {
        //获取签名字符串
        $requestString = '';
        foreach ($data as $k => $v) {
            if ($v != null && $v != "") {
                $requestString .= $k . '=' . $v . "&";
            }
        }
        $signData = trim($requestString, "&");
        $str = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCNOkLgL3qed1z9HWBDjNpdwbXfEA23qy3mAjCQEdKNNVM1nnCx6Eq6ZwU7T1qin9sSA+PbbhNa7vCj7ocqgWx7y7FrgmGkcYpzHV/IJrHGHtnbMIomBvASDnnfdONjk+w/wFpo4/rMEF/toqH0lx2fvHqJwj0+hk2ktnuIctIaQyukrDgfe8LGLVHAJkS4Cz25BsMNg3Dz6k8nCxKKzEY9eJWt82L4pdtP1fDQCyTuauB793eQT+iH9FKFiaXuivNhVjBxKLUz6QEDjWwUBbRhQJEcVg/3bnlgMeR6WK8t0dGXwI00yZNs1Q0qIbhtuw3kWvMX8w92lYLlmnBOzVw7AgMBAAECggEBAIGqmHRVo3OTjGEpc5UR4fxrOp0PlEiqdn3UTNo6QuM7rqZwTnBKIzJ6HCeUeFcQBofH4pE5w7Od5nvdKWUxZ3VSVBetohDl3oRK2AJg5KBO+x9wtaasgAdUGzm7jHuE+UifR2M+zqpF7o204JY9mQlsd+W73ZdmoCs3ELz7D0TkOpdR1ZGZU/662CkQTcngx8dFrx5/CSWZF+PdxGzJEzuWW58ZfIGsqt3ROyCGNS2lpSnW7FqhzZ4P7kVsHSAn8aaPlnCCCNO//paD7kLv9XUL5cTHkY1+7kTqfcoi7GJIZS04yebDxVs9WBMw9AjjW01Fzaha81czopyrmK1QNkECgYEA6hI2L+Hmib8chogbJgo2b34XCvwBCX0rXrMqWtMxJgxuTXUjUux1W0kxvMMe4li0WJgOesCm7l1U/CRjf2elWqYH2yoj/wey4i3qjkyTlf2eh2vsQ01pdA4EGwTGuYkJXkqcfggyP/q2ZUF1/q+O/FKyScOICV0R+o+fwv/hqbMCgYEAmnVb0iSjrmH2ijpfdyDyQamL4cdJBXjhbZ12Y4B6iVNBoKy3ge9SdyqDw2J3Uq8xm/TgZrTzKDerJXs6L8zwGyEIm0ngGbg/gR5+/URY+0tGTKsqhF4eKD4LIIUjc6OSSOck8qvPR73fMvoKq+77ZYyvVkX3oHoLKEkfDjRIr1kCgYA82zVJZ7M3lv+EnrhoQHl8rUyyZ2ihnfB7s5tMd+IsYUkATHc9pQqyDCqpSBWshaGF8yq4kYQVLyDcWV2hD0J3eflK6v7m3IqOsZ9tFc29Tm48CTwpF2RWbxp0J96++Dj+Uemz/s+JwNZRJx7Vc7F6Osnt0a95t7/n5BWGbl6ubwKBgF40Q8tYQ2hhIT/POFhtBLQdl04eAKBQyJTVW9Z2DsZgu/8mOEoMT+yURobNMF+CsKwg3xhlNoSJ511V2fg7cxnovNoRZZfqMvkqQ2Nu4yJpF7g9ERJoYNZEeP7dlPC7i8XhDDzhoutrl4z8ybNxb2zRMENbKxt6NAHfDwzXwJkJAoGAT4OgS2Pi/QdIyWLftFLDFFKZwTCnB/IMt09vRgTkjZxRsU+Ob3QKbVyDQORPNyYj9QZS6ag/K64pDYlEtJXUICMVKSWZkSOq+QaAy+0PdgNAMUlmHdtX16qHiIEIyRP/cYPpBJDDFeLY/GnDZFn69CGZzIbA3N5+YNV3WMjvzR8=';
        $str = chunk_split($str, 64, "\n");
        $private_key = "-----BEGIN RSA PRIVATE KEY-----\n$str-----END RSA PRIVATE KEY-----\n";
        openssl_sign($signData, $sign, $private_key);
//        openssl_free_key($private_key);
        return base64_encode($sign);
    }

    //3通道验证签名
    public static function checkSign3($data, $sign) {
        //获取签名字符串
        $requestString = '';
        foreach ($data as $k => $v) {
            if ($v != null && $v != "") {
                $requestString .= $k . '=' . $v . "&";
            }
        }
        $signData = trim($requestString, "&");
        $pem = 'my_rsa_public_key.pem';
        $str = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkA2p5K0YUzRqqZ8ottb2I5BJ2EKrFE0GtL4ZWNk/EB2A2e2cVZe0j8LvuTonRimmBvHMblYRW6/q/y0F6DBDc9GlPxBXk1olFJaBcYNFFGEfWjaWZG6FJUv0Y+w4TLyou3LGkNRZdlW6C+o36qPlogj8F2MzoeRZH4aOJKaiLgDSIQptIXzaAhoNc66WRFXCBNNoQ0YeUNGQ9x08QS6HeYVY2gbK7vvvByjqkNqb88rBZ5C0SkD5X+quuhqBq74T5ytHp0CpZeJH/5IsA1A6msNeQYHF9/R6xjfSghlSO7a94PYTuo7sSoPmlgc+FNdACbxMEmSwdpx1jdimOwNNQQIDAQAB';
        $str = chunk_split($str, 64, "\n");
        $publicKey = "-----BEGIN PUBLIC KEY-----\n$str-----END PUBLIC KEY-----\n";
        $result = openssl_verify($signData, $sign, $publicKey);
//        openssl_free_key($publicKey);
        return $result;
    }

    /**
     * 4号签名
     * @param type $sign
     * @return type
     */
    public static function check_sign4($data, $Secret_key) {
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($k != '') {
                $buff .= $v;
            }
        }
        $string = trim($buff, "");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 6号签名
     * @param array $data
     * @param string $Secret_key
     * @return mixed.
     */
    public static function check_sign6($data, $Secret_key) {
        ksort($data);
        $query = http_build_query($data);
        return strtolower(md5(md5($query) . $Secret_key));
    }

    /**
     * 7号签名
     * @param array $data
     * @param string $Secret_key
     * @return mixed.
     */
    public static function checkSign7($data, $Secret_key) {
        $sort = true;
        $sort && ksort($data);
        $sort && reset($data);
        $temp = [];
        foreach ($data as $key => $value) {
            if ($key == 'sign' || $key == 'sign_type') {
                continue;
            }
            $temp[] = $key . '=' . $value;
        }
        $string = implode('&', $temp);
        $signStr = $string . $Secret_key;
        return md5($signStr);
    }

    /**
     * 10签名
     * @param type $args
     * @param type $key
     * @return type
     */
    static function checkSign10($args, $key) {
        ksort($args);
        $requestString = $key;
        foreach ($args as $k => $v) {
            if ($v != null && $v != "") {
                $requestString .= $k . $v;
            }
        }
        $requestString .= $key;
        $newSign = md5(urlencode($requestString));
        return $newSign;
    }

    /**
     * 11签名
     * @param type $args
     * @param type $key
     * @return type
     */
    static function checkSign11($args, $key) {

        ksort($args);
        $requestString = '';
        foreach ($args as $k => $v) {
            if ($v != null && $v != "") {
                $requestString .= $k . '=' . $v . "&";
            }
        }
        $requestString .= "key=" . $key;
        $newSign = md5(strtoupper($requestString));
        return $newSign;
    }

    /**
     * 67号签名
     * @param type $sign
     * @return type
     */
    public static function check_sign67($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($v !== "" && !is_array($v) && $k != 'sign' && $k != 'pay_productname') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . '&key=' . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 115号签名
     * @param type $sign
     * @return type
     */
    public static function check_sign115($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($v !== "" && !is_array($v) && $k != 'sign') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 开元棋牌AEC签名
     * @param string $data 要加密的字符串
     * @param string $key 秘钥
     * @return mixed.
     */
    public static function checkSignKy($data, $key) {
        $buff = '';
        foreach ($data as $key => $value) {
            $buff .= $key . '=' . $value . '&';
        }
        $string = trim($buff, "&");

        return self::encrypt($string, $key);
    }

    /**
     * 开元棋牌MD5签名
     * @param array $data 要加密的字符串
     * @param string $key 秘钥
     * @return mixed.
     */
    public static function md5SignKy($data, $key) {
        $buff = '';
        foreach ($data as $key => $value) {
            $buff .= $value;
        }
        return md5($buff . $key);
    }

    /**
     * AES加密
     * @param string $key 秘钥
     * @param string $str 要加密的字符串
     * @return mixed.
     */
    public static function desEncode($key, $str) {
        $str = self::pkcs5_pad(trim($str), 16);
        $encrypt_str = openssl_encrypt($str, 'AES-128-ECB', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING);
        return base64_encode($encrypt_str);
    }

    public static function pkcs5_pad($text, $blocksize) {
        $pad = $blocksize - (strlen($text) % $blocksize);
        return $text . str_repeat(chr($pad), $pad);
    }

    /**
     * AES解密
     * @param string $key 秘钥
     * @param string $str 要解密的字符串
     * @return mixed.
     */
//    public static function desDecode($key, $str) {
//        $str = base64_decode($str);
//        $decrypt_str = openssl_decrypt($str, 'AES-128-ECB', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING);
//        return trim(self::pkcs5_unpad($decrypt_str));
//    }
//
//    public static function pkcs5_unpad($text) {
//        $pad = ord($text{strlen($text) - 1});
//        if ($pad > strlen($text))
//            return false;
//        if (strspn($text, chr($pad), strlen($text) - $pad) != $pad)
//            return false;
//        return substr($text, 0, -1 * $pad);
//    }

    /**
     * 118号签名
     * @param type $sign
     * @return type
     */
    public static function check_sign118($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if (!is_array($v) && $k != 'sign') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 120号签名
     * @param  array  $data 数据
     * @param  array  $Secret_key 秘钥
     * @return string
     */
    public static function check_sign120($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($v != "" && !is_array($v) && $k != 'Sign') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . '&Key=' . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 代付13签名
     * @param  array  $data 数据
     * @param  array  $Secret_key 秘钥
     * @return string
     */
    public static function agentCheckSign13($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($v != "" && !is_array($v) && $k != 'Sign') {
                $buff .= $v . "|";
            }
        }
        $string = trim($buff, "|");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . '|' . $Secret_key;
        //签名步骤三：MD5加密
        $sign = hash("sha256", $string);
        return $sign;
    }

    /**
     * 127号签名
     * @param type $sign
     * @return type
     */
    public static function check_sign127($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $md5str = "";
        foreach ($data as $key => $val) {
            if ($key != 'lockid' && !empty($val)) {
                $md5str = $md5str . $key . "=" . $val . "&";
            }
        }
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $md5str = stripslashes($md5str);
        }
        //签名步骤二：在string后加入KEY
        $md5str = $md5str . 'key=' . $Secret_key;
        //签名步骤三：MD5加密
        $sign = strtoupper(md5($md5str));
        return $sign;
    }

    /**
     * 123号签名
     * @param string $sign
     * @return mixed
     */
    public static function check_sign123($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if (!is_array($v) && $k != 'sign') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . "&" . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 代付9通道组装字符串
     * 字段sign不参与组装
     * @param array $params
     * @return mixed.
     */
    public static function agent9getSignContent($params) {
        unset($params['sign']);
        ksort($params);
        $stringToBeSigned = "";
        $i = 0;
        foreach ($params as $k => $v) {
            if (isset($v) && !empty($v) && $v != "" && "@" != substr($v, 0, 1)) {
                if ($i == 0) {
                    $stringToBeSigned .= "$k" . "=" . "$v";
                } else {
                    $stringToBeSigned .= "&" . "$k" . "=" . "$v";
                }
                $i++;
            }
        }
        unset($k, $v);
        return $stringToBeSigned;
    }

    /**
     * 代付9通道签名
     * @param string $data
     * @param string $rsaPrivateKey
     * @return mixed
     */
    public static function agentSign9($data, $rsaPrivateKey = '') {
        //格式化密钥，添加头尾
        $rsaPrivateKey = 'MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC0kuYDrvdasZNjyzqSVg6fmGqEeMvNvFwyRwqmV6wGL4X1TRzBcWbCahZxyA68ujzJqexBEjGS2JSd8im7IENa0wN9eSb/N5eg2gAexVAbCAFf+SdsLAIdyo4NxV5zzOdouGcGa3szE+UWeZrdRvFVkoAE7rea5pO33yAuafYjv3reirmANJWwFGOjhpewL+k38U33DTcGevrbJoOTnZZMWUVVUoyeA//GNidsOmeQIgfivRWDeGxcovaEbq2mvNts87voIfw5mb7WVn6l766I/UKvtFV3TZFLwC07sCBr8iWl+i3o9LoQV/3haQxOtjS2hy7xTIfiwCh0SDEOG5IFAgMBAAECggEAFXPmU8WzqVizdAWu/bevoRJQhVB8lgKsyWRbRYvg6hM3TP9OTUUVuj80T2w/I/jUQ/kmEk0BCrskXOdqQcsBdYbgQUXldii6oOeFYCJ889ktoKNPJbDMx5FK8yPhpsxPKcfOpZqbVmQksVjdJzDIdywifXOG6KZAInYlsp3wGirwLT6XmC5L9/u/57Rj7MoRqHkVBe8upR4D+kWq1PpRS92v7r1ue8ivD2DDIgN7MJa3MXh6JcDX9XbSoJX3noX1+Pj2t0rb3JahqfNQG94LFLzzblEnfMd3SC/74tTZE2VSAP5hXMJ0LUupJ882pPojFDGk0maR1iWea0NcDLoyeQKBgQDtb8A1p2qJrkSbwNCVT86ntAuyvQ/USUOp4OGxaMio6DT/9NsZ9tZLlP95SWunARMqdE3mmiCxFJ5u7MU/bjZtzNkEaX/4SmJ1EW+zOuyvn+dmjtIRvxaaxgOZf2GlG8d4GPugRrwupBTRH7QjL/59dvefP8tux4xRUElNhRoiiwKBgQDCsQ0JHXH9mLzpX/jl/twDa70uXKNXroe0If+81xUqNldOgNdIylI8+BMnTezlYa/7WHtLpAAEuVxQoyZuiJFT8t0+B33PWGoLvT3KuLvhB7piK2LUdRvvGmBQkZrUvMmjJodzr+ehVDMuOIVq7A62lG6VJmDNdbRyTZAKqLF/rwKBgQC48ohNAth44Hbuv9V5yM2XUiaelqhC2sLLC7GhyJYtA5ttGOSmJ+CqxSfu6OLjFnJAapHXo4z9gqsainHmw8m/44XT6v3UgNSKjgdtG+QLtUnBWFSHoEpSSxW4tkFwI+BPS16NbSveRM82SjS+B/966XVe5YloBCXnnNtMd/ZwmwKBgQCIuJsF5qaxRzyKyvnYUiShRlzBHQ8cORVVW3bjX0uerDCdkX8dv+8Gn9Obi26sGvDhml5jXRUiPCVm/1uyzbb49BmIQOyJ2nYGLmwhW5+cxLePzxYFSwRF4gj3K3lGohkbuKfwhvwr4Bxc/hY7YvBmKVCK7zuVrW39wxg/U/3qQwKBgQCXVsKTu1ARz7kDI0E8fm7nsvZTDbEOIqGPqx6Pj10rR4VXFfEmzcmUO/XLRBvZy+Jsn5kB0LIeoD1IHOj7VOwznbHufK+9oymznTToKC4wfyPlDcsAoQvVjlJ3JdfBZ72pT4Xh2OP3eCEGpDMJ1PRDJRhQ223FKpj5BPkzUY/mEQ==';
        $res = "-----BEGIN RSA PRIVATE KEY-----\n" .
                wordwrap($rsaPrivateKey, 64, "\n", true) .
                "\n-----END RSA PRIVATE KEY-----";
        ($res) or die('您使用的私钥格式错误，请检查RSA私钥配置');
        openssl_sign($data, $sign, $res, OPENSSL_ALGO_SHA256);
        $sign = base64_encode($sign);
        return $sign;
    }

    /**
     * 代付9通道验签
     * @param string $data
     * @param string $rsaPrivateKey
     * @return mixed
     */
    public static function agent9verify($data, $sign, $rsaPublicKey = '') {
        $rsaPublicKey = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1w++up73u1BMD7E6dyiKJqEWU7ZwIQnmQyPvLgwtnCqANpBYvhqnoCefGy82Np9uTSPp0n/+yKMIbZqRDE0vBNVGzSdIvwAs2kCQB/1Lc483kmiYIKUgJcMSdvwo9jwdE7XDcr4fXb1w62W+T4fbKgxoA+6QSgh7Bc1y/N2hcu6pKRsNoNgoUHlIJhDchLDzViVP3Xc2gk8aa7DP6AZ/+WrI7c0AtspZA3NW0UTaidDegBmyl3w1JvliBksSN1CEwNBHkAgyr8eWWMoCfh8Q1/h4MYBYEX6EFmYIZWWa3KtOY7+0OGu+RHN5gDDFEZvemnKiuLMcrR3S6S65YkPqiwIDAQAB';
        $res = "-----BEGIN PUBLIC KEY-----\n" .
                wordwrap($rsaPublicKey, 64, "\n", true) .
                "\n-----END PUBLIC KEY-----";

        ($res) or die('RSA公钥错误。请检查公钥文件格式是否正确');

        //调用openssl内置方法验签，返回bool值
        $result = FALSE;
        $result = (openssl_verify($data, base64_decode($sign), $res, OPENSSL_ALGO_SHA256) === 1);
        return $result;
    }

    /**
     * 130号签名
     * @param type $sign
     * @return type
     */
    public static function check_sign130($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($v !== "" && !is_array($v) && $k != 'sign') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        $sign = strtoupper($sign);
        return $sign;
    }

    /**
     * 134号签名
     * @param array $data
     * @return string
     */
    public static function check_sign134($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($v !== "" && !is_array($v) && $k != 'sign') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $string = stripslashes($string);
        }
        //签名步骤二：在string后加入KEY
        $string = $string . "&token=" . $Secret_key;
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 30号签名
     * @param type $sign
     * @return type
     */
    public static function check_sign30($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $buff = "";
        foreach ($data as $k => $v) {
            if ($v !== "" && !is_array($v) && $k != 'sign') {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $string = trim($buff, "&");
        //如果存在转义字符，那么去掉转义
//        if (get_magic_quotes_gpc()) {
//            $string = stripslashes($string);
//        }
        //签名步骤三：MD5加密
        $sign = md5($string);
        return $sign;
    }

    /**
     * 34号签名
     * @param array $data
     * @return mixed
     */
    public static function check_sign34($data, $Secret_key) {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $md5str = "";
        foreach ($data as $key => $val) {
            if ($key != 'sign') {
                $md5str = $md5str . $key . "=" . $val . "&";
            }
        }
        //如果存在转义字符，那么去掉转义
        if (get_magic_quotes_gpc()) {
            $md5str = stripslashes($md5str);
        }
        //签名步骤二：在string后加入KEY
        $md5str = $md5str . 'key=' . $Secret_key;
        //签名步骤三：MD5加密
        $sign = strtoupper(md5($md5str));
        return $sign;
    }

}
