<?php

/**
 * Created by PhpStorm.
 * User: dsh
 * Date: 2017/10/19
 * Time: 18:28
 *
 * v框架签名助手
 */

namespace common\components;

use yii\base\BaseObject;
use yii\web\NotAcceptableHttpException;

class vSinger extends BaseObject {

    /**
     * @var string 签名key
     */
    public $signKey = 'sign';

    /**
     * @var string 签名密钥
     */
    public $secretKey;

    /**
     * @var int 签名过期时间
     */
    public $timeout = 300;

    /**
     * http_build_query 使用的RFC标准类型，默认RFC3986，和v框架通信使用RFC1738
     * @var int
     */
    public $buildQueryType = PHP_QUERY_RFC3986;

    /**
     * 生成签名token
     *
     * @param       $url
     * @param array $data
     * @param null $time
     *
     * @return string
     */
    public function token($url, $data = [], $time = null) {
        if (empty($time)) {
            $time = time();
        }

        ksort($data); //升序排序 。 

        if (!empty($data)) {
            $url = $url . '?' . http_build_query($data) . '&' . $this->secretKey;
        } else {
            $url = $url . '?' . $this->secretKey;
        }


        //$data = empty($data) ? $url : $url . (strpos($url, '?') ? '&' : '?') . (is_array($data) ? http_build_query($data, null, '&', $this->buildQueryType) : $data);
        // 签名后面带时间
        //$token = substr(md5("{$this->secretKey}$data{$time}"), 8, 16) . $time;
        $url = urldecode($url);
        $token = md5($url);
        // \Yii::info([$this->secretKey, $data, $time, $token]);
        return $token;
    }

    /**
     * 生成url签名
     *
     * @param string $url
     * @param array $data
     *
     * @return string
     */
    public function sign($url = null, $data = []) {
        $sign = $this->token($url, $data);
        $url .= (strpos($url, '?') ? '&' : '?') . "s=$sign";
        return $url;
    }

    /**
     * 检查签名
     *
     * @param              $url
     * @param array|string $data
     *
     * @return bool
     * @throws NotAcceptableHttpException
     */
    public function check($url, $data = [], $validTime = true) {
        // 取签名
        $qstr = $this->signKey;
        $sign = !isset($_REQUEST[$qstr]) ? '' : $_REQUEST[$qstr];  // 从参数中取得签名

        if (empty($sign)) {
            if (is_array($data) && !empty($data[$qstr])) {
                $sign = $data[$qstr];  // 从数据中取签名
            } else {  // 从url中取签名
                preg_match("/[^\w]$qstr=(\w+)/", $url, $matches);
                if (!empty($matches)) {
                    $sign = $matches[1];
                }
            }
        }
        if (empty($sign)) {
            throw new NotAcceptableHttpException('sign token is null');
        } else {
            $time = intval(substr($sign, 32));
            //            \Yii::warning([$time,time() - $this->timeout]);

            if ($validTime && ($time < (time() - $this->timeout) || $time > time() + $this->timeout)) {
                throw new NotAcceptableHttpException('签名超时，请校准本地时间！');
            }
            if (is_array($data) && !empty($data)) {
                unset($data[$qstr]);
            }
            $url = trim(strtr($url, ["$qstr=$sign" => '']), '?&');

            $sign = substr($sign, 0, 32);
            $url = strtr($url, ['?&' => '?', '&&' => '&']);

            if ($this->token($url, $data, $time) === $sign) {
                return true;
            }
        }
        return false;
    }

}
