<?php

/**
 * Sign Helper.
 *
 * 签名助手
 */

namespace common\helpers;

use common\helpers\HttpHelper;

/**
 * Sign Helper
 */
class AesSignHelper14 extends BaseHelper {

    //商户私钥
    public static $private = '-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDepG9mDhrGTzgy
BMF+AArfkEKqqEWb/0yzjbgjgFtLEpt6HDJ+X0HDeiJ7YtStCPDgl7PqBEjQu94/
QnfSC2Uj5jDwEIzOzLPUmO8Z7iaLptM6t732SsEU8J+Cwn6dJ7bu0qNqHUKkpdz0
Eg4bBoMPl75hGJ0ii9s2HT7kDeJ3xbdW6Fd9hjAsRaNiGPEgb/maL7yrnt1YotsV
y90H1NBP+RUiHzNnQRVt2d0z4/QqyeU77BMdqyl/Ca+u3Ldtq5R2l9tjze+ijeZt
6ENMEw8DC0LFOJypujF0xvEoPs7TKK/DsdnvNwYH7c5qOlwgXMn+R0DUpt0ULPfc
Y0r90aMBAgMBAAECggEAW2stirwz5kXVD0TAppoh3NaBaU2a94kG15tThtBHrDXB
vYwid51phXh6/CsCpOJM9guUhnyn4X2irlr+lDK1nt4ALjK9fpSzKpJ5ay5MiX9A
sJWN3LmpOo3rEWgHUURjawD2tLW7DZxFc7qOLC6qVha6x2ex7eN7aWbs0fuZiA/U
3HJNSiHGwIKVAdvLuQst64PhYB5oNsYhAMGnijWfhBxqZKY6ovCcBx+J26UxgDrT
m0EtyxqXsQs6T1yfUWlIR/iUGYxsru9bow4RRhPTaH5OL46Q6cE0O0cDOS0MxYve
kYKLmUc65jqp5e+FGCMaq7ZG0tlf2Y78LIdZOF0O2QKBgQD+LziqdNEpTBSxueZH
JnKV5VQxx8ukKoZ0yhj6JtraSxsGHgzop4dwhTNgMv9Vht7bLKu0lRHfT86GFiln
277qahz2XEQJCj4cRdkcbcNeHUYee9WV4vZxraIzjnjRE8Yoz1yyE5XARri4m2y9
qJ4hNP5FX3RvTymB1Hsib6ZoGwKBgQDgO4npOrek4xvKjbl9KVGhD1lWJhiXI+P4
LnytYL8dcbfPkmIE8vONINvAueVGU0f8F+uFSaMGEtDjItx1Wykry/jxmsxDOLQl
/i9XYmHKPNZpRxPVjVeG9eYGX/MabwfFLTX/u6OEEj6xOok/Vs7mcWmIA5asEnZE
0HMSi2hLEwKBgB/Kvjart8GHj4sPKls51tkivt4fFDxrSTfwUyFunK7y9+VS+uBa
m9kZ/+wHVOJYpSUauDs07fBVZgplWTZxSLa/IPI7ZhMPYeddYSNqIyZxWOTVLki6
A4MCaagzKK9V3tIZ5YksY+2RqucEIZyzK1wR6b+5ibGmYBWqAuCywEiDAoGBAM1Y
mP52oFEnDn9bdL/TRAb8GHMVZjWbT50rbVAVpk+foZY81vjzSOk4aya+1uGlSOnr
OeuROPNJ7fPkLAJpHnYWUH9ppJ/24LteYRpkZWugdTZqOha6XqqgrCuwWOAfR/1h
Xu84dhFv5+vD0Iapx8YvnFZL+wLP0XFJd+hGtJbzAoGBAPoFhjMM9BnRRWly5mxS
J41m3wQUXS3auUhSfw8b/oRSXQ7H9sqtn1M/wEglz5GMd83Tw88rDR1e0AVj7K7x
dR/5ONpTJQGLeRWpmYyeK/5pFnb21l3C6wsmG+qxZCz8D5O+opxXRD70iLQqYIay
BITtKNplHTrHaJUKIOTMxa++
-----END PRIVATE KEY-----';
    //平台公钥
    public static $plat = '-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1DeyXyImdMiMqIprqY8e
67RD1yE9YIEnJ8pgnGvAxSzPxPiaZW6c0JW2/BCFwv4PVmuWGXgTc+gTNT5O0H3/
ODiqE0XBi35N6fxMfgRpmQ3RXEXj+hvytZ0TlbhoyKt1+YLL6g0+cUWv9hQfD0v0
7+lbtbHOheLQPozIMF3C+YOmptK87DkVBJiz8SdKOsY1O8kABgEqdvAxgZUxJofL
y8EqbcJx+4iPN9TFV3CL62uN+Ps1xHjzIMAQWyIhe4f3lqhabBcIM3RxvI+mSY+o
bp+wOO8Oqudp/6F6nLZyOVdGOY/mW2sMXtsjNHi7+LLGkO1J51XXkAB+soPdWUzQ
JQIDAQAB
-----END PUBLIC KEY-----';
    public static $plat_pub_key;
    public static $company_pri_key;

    public static function AesSign($data, $full_url) {
        self::$plat_pub_key = openssl_pkey_get_public(self::$plat); //这个函数可用来判断公钥是否是可用的 
        self::$company_pri_key = openssl_pkey_get_private(self::$private); //这个函数可用来判断私钥是否是可用的，可用返回资源id Resource id
        $aeskey = self::getKey();
        $jdata = json_encode($data);
        $aesdata = self::aesEncrypt($jdata, $aeskey);
        $enckey = self::encrytPublicKey($aeskey, self::$plat_pub_key);
        $sign = self::generateSign($jdata, self::$company_pri_key);
        $message = [
            'req' => 1,
            'encryptedData' => $aesdata,
            'encryptedKey' => $enckey,
            'signData' => $sign,
            'companyID' => $data['companyID']
        ];
        return self::send($full_url, $message);
    }

    public static function aesEncrypt($data, $key) {
        return openssl_encrypt($data, 'AES-128-ECB', $key);
    }

    public static function encrytPublicKey($data, $publicKey) {
        $encrypt = '';
        openssl_public_encrypt($data, $encrypt, $publicKey);
        return base64_encode($encrypt);
    }

    public static function generateSign($data, $privateKey) {
        $signature = '';
        openssl_sign($data, $signature, $privateKey);
        return base64_encode($signature);
    }

    public static function getKey($n = 8) {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $randomString = '';

        for ($i = 0; $i < $n; $i++) {
            $index = rand(0, strlen($characters) - 1);
            $randomString .= $characters[$index];
        }

        return $randomString;
    }

    public static function send($full_url, array $data) {
        $res = HttpHelper::httpPostJsonData($full_url, $data, 5);
        self::$plat_pub_key = openssl_pkey_get_public(self::$plat); //这个函数可用来判断公钥是否是可用的 
        self::$company_pri_key = openssl_pkey_get_private(self::$private); //这个函数可用来判断私钥是否是可用的，可用返回资源id Resource id
        $data = json_decode($res, true);
       
        $key = self::decryptPrivateKey($data['encryptedKey'], self::$company_pri_key);
        $resdata = self::aesDecrypt($data['encryptedData'], $key);
        self::veritySign($resdata, $data['signData'], self::$plat_pub_key);
        return $resdata;
    }

    public static function decryptPrivateKey($data, $privateKey) {
        try {
            $data = base64_decode($data);
            $decrypt = '';
            $res = openssl_private_decrypt($data, $decrypt, $privateKey);
            if ($res === false) {
                $msf = openssl_error_string();
                //return false;
                throw new \Exception('解密失败', 203);
            }
            return $decrypt;
        } catch (\Exception $exception) {
            throw new \Exception('解密失败', 204);
        }
    }

    /**
     * 解密方法，对数据进行解密，返回解密后的数据
     *
     * @param string $data 要解密的数据
     *
     * @return string
     *
     */
    public static function aesDecrypt($data, $key) {
        $res = openssl_decrypt($data, 'AES-128-ECB', $key);
        if ($res === false) {
           // return false;
            throw new DxException('aes解密失败');
        }
        return $res;
    }

    public static function veritySign($data, $sign, $publicKey) {
        $sign = base64_decode($sign);
        $result = openssl_verify($data, $sign, $publicKey);
        if ($result === 0) {
            //return false;
            throw new DxException('签名错误');
        }
        return (bool) $result;
    }

}
