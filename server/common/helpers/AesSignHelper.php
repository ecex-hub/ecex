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
class AesSignHelper extends BaseHelper {

    //商户私钥
    public static $private = '-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDLdBpJXvGS9BnQ
FZj369Yow0m3qV5WVBfmOgBfiNiXa6SvOO60/TYIJ44sXdB6kXAZOEXW3lUynGxH
fkrkPC4YciubrKTgNGLjgG9lOfoYuRP6aQx2J6bcKUJ5hzL2TLat+Z/8h7mqHIti
mWO1dPhkbaVdFZkzlb36oH1bpMcWaI22vOJKvbHe6sbhQfdnZXMG/zXfPpwrXuaI
fhRROOTg+fSnyouG7mg/DBHcmSaFZok5jESC9DuMwLmAkkb1VjqYsxRP5T4ECYT+
Hl9iHUHyMUtIvURzgn/spYVEoPrFb7vx5K/nZ8RGTD2PUfWo2x7Cczl7AbZMGLaz
Bp7Gb2apAgMBAAECggEANCRBSGSIzPy6UNX4KjHK5Q+HqQZDIyTSKzLaPaG4wLXZ
sv6ITuJGIrjgewZgE8mKTSxa2cKJWzszlO8NColR1voLqw4IA13pqhyUcAD307Y7
JIYfp3hqDyqT2smHihAHEXdURUgTkUFXh6GAKFUeA78GDmEmrk3GLqFK/12vmFIm
STdKDO3PyBVXcBdLPsi4uWLUxdTXWJiTBH97cRTT77DZepOyLuwPduElRKEg5kqi
yGWP1uBwX4d0HbuB2Tfxj6MWbSHHgGG+Z53HKjLWM31XU37F1Xrvaatbrfz0lFag
l/GLyxyOjeXb1vRBvZ7SkiOVMwu59cvBCeOqYJ/cwQKBgQDuQMOUHfaAOtE7TjfU
d2cCusNSB/Cz4ShzmmTgGspii4y3ICsA9FgK6DBjFDANrHtlFIPmMnUf2RApFckx
OHQZwQLqItvOGxNKutIlvmklXwZ6/eD4kX3c2uYxXCbgE29eSWhGOD1fC0aLRJM+
5rR5tuy6NZbJe1R2lNvhQk8lxQKBgQDam7/TI/Cj/Gx3rWWJNVBTH5zqmSeKj9aN
zNVZRZu7JZ3fxXyYfn676kRMuJVljXLWTf9H3zc9Wysc7YEW4pgxrQBdoO6KhQSi
X6UC89gyq583rfXxdxIJPZnvOzMJ6OI7534+77ll/FeMa0zBlPdFQFnRiVIYoKM5
Yu1IFuZvlQKBgQC30BuUMLG3KKm4OZZ1Q1GkF3cN2LZp8TKGTf25sLGn6cY8moLT
D7DFaXG7Xx3bztC8oWFJvnACjDMdn4NDiCx6miCnhxFSKC1wIEZ1fDwe6vtS9IAX
Bhi2xeOG/XO4uQXZFoVud4FRzJ82X0fC5bcjmG93ElUtSQtXGW2ykrgBiQKBgCUc
x+YadeIBGpD+uPwgNvDFrygMtC/L14rfOWEcdiHBcxnoNwzUfMN+M/YqaAKDjvle
6HXVKVWbQqh4ka/G7DuSuTsr9RNDHdRLFIJ5zzxa8n7LY7OImWFEOfvpOvL1vGKb
HE2m+PydaGeIV9GNbqUtFZKDE5Lmwo8dglb4vEo5AoGAEbpJgpZ936GHfyBsgWPW
Dz66hUmkCx1STGfDxhfIFkrnz/E1A/CA45vUaeIFBWu1aLCFxQdlx7VcfNG8rvDW
KUaQ6zx6kcE8WOeVbRN+X044/gODg/WOTONi5QieOWm37OXur3ib623AmGkcyrs1
0FgciWH+H3MuBO8v/B2Rm40=
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
