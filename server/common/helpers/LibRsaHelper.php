<?php
/**
 * x消息发送.
 *
 */

namespace common\helpers;

use Yii;
//openssl genrsa -out rsa_private_key.pem 1024
//openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pub
class LibRsaHelper extends BaseHelper {

    /**
     * 获取私钥
     * @$v 版本 app更新时可以用新的密钥
     * @device 设备 ios和android用不同的密钥
     * @return bool|resource
     */
    private static function getPrivateKey($v,$device)
    {
        $abs_path = Yii::$app->params['webrootUrl'] . '/rsa/' . $v . '/' . $device . '/rsa_private_key.pem';
        $content = file_get_contents($abs_path);
        return openssl_pkey_get_private($content);
    }

    /**
     * 获取公钥
     * @return bool|resource
     */
    private static function getPublicKey($v,$device)
    {
        //$abs_path = "/usr/local/webroot/rsa/{$v}/{$device}/rsa_public_key.pem";
        $abs_path = Yii::$app->params['webrootUrl'] . '/rsa/' . $v . '/' . $device . '/rsa_public_key.pem';
        $content = file_get_contents($abs_path);
        return openssl_pkey_get_public($content);
    }

    /**
     * 公钥加密
     * @param string $data
     * @return null|string
     */
    public static function publicEncrypt($data,$v,$device)
    {
        if (!is_string($data)) {
            return null;
        }
        return openssl_public_encrypt($data,$encrypted,self::getPublicKey($v,$device)) ? base64_encode($encrypted) : null;
    }

    /**
     * 私钥解密
     * @param string $encrypted
     * @return null
     */
    public static function privDecrypt($encrypted,$v,$device)
    {
        if (!is_string($encrypted)) {
            return null;
        }
        return (openssl_private_decrypt(base64_decode($encrypted), $decrypted, self::getPrivateKey($v,$device))) ? $decrypted : null;
    }

}