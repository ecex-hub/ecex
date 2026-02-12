<?php

namespace backend\lib;

use common\controllers\ApiTouristAuthController;
use common\helpers\LibRsaHelper;
use common\models\BlacklistMessage;
use common\models\ChannelManage;
use common\models\User;
use Yii;

/**
 * 主页公用管理器
 */
class MainM3u8Controller extends ApiTouristAuthController {

    public $enableCsrfValidation = false; //取消yii框架post验证
    protected $validSign = false; //; //是否校验签名
    protected $validByUserKey = false; //是否根据用户的api Secret 校验签名
    protected $validUnique = false; //校验是否唯一请求(有效期内只能请求一次)
    protected $allowedOrigin = [
        '*',
    ];
    public static $iv = '1111111111111111'; //保证偏移量为16位
    public static $method = 'AES-128-CBC'; //加密方式

    /**
     * @throws \yii\base\ExitException
     */
    public function init() {
        parent::init();
        $this->setResponseCors();
        //接口验证
        try {
            $info = self::verify();
            if ($info['state'] == 500) {
                $this->output_error($info['msg'], $info['state']);
//            $this->returnJsonError($info['msg'], [], $info['state']);
            } else {
                Yii::$app->params['userBasicsInfo'] = $info;
            }
        } catch (\Exception $e) {
            Yii::info('verify-----' . $e, 'apiLog');
            $this->output_error('系统繁忙,请重试', 500);
        }
    }

    public function __construct($id, $module, $config = []) {
        parent::__construct($id, $module, $config);
    }

    /**
     * 解密验证
     * @return mixed.
     */
    public function verify() {
        $GLOBALS['RUNTIME'] = true;
        $GLOBALS['encrypt'] = false;
        //token是app登录的加密信息，包含imei码或其他硬件标识
        //当token信息过来，解析出值后，查询系统是否有，没有则注册一个用户到系统
        $token = Yii::$app->request->get('token');
        $token = str_replace(' ', '+', $token);
        $v = 'vMH3KLaX';
        $device = 'h5';

        //新加数据
        if ($device == 'android') {
            $device_type = 1;
        } else if ($device == 'ios') {
            $device_type = 2;
        } else {
            $device_type = 3;
        }
        //$device_type = $device == 'android' ? 1 : 2;
        //
        $code = LibRsaHelper::privDecrypt($token, $v, $device);
        if (empty($code)) {
            return array('state' => 500, 'msg' => '解密失败1');
        }
        list($uuid, $time, $aesKey) = explode('_', $code);
        //获取登陆信息
        if (!$time) {
            return array('state' => 500, 'msg' => '解密失败');
        }


        $GLOBALS['aeskey'] = $aesKey;
        $GLOBALS['encrypt'] = true;
        $GLOBALS['device_type'] = $device_type;
        if (Yii::$app->request->get('debug')) {
            $GLOBALS['encrypt'] = false;
        }
        return array('state' => 200);
    }

    /**
     * 成功输出信息
     * @param string $name .
     * @param mixed  $data 成功返回数据.
     * @return mixed.
     */
    public static function output($name, $data) {
        $lists = array();
        $lists['code'] = 200;
        $lists['message'] = 'success';
        $lists['data'] = $data;
        if ($GLOBALS['encrypt']) {
            header('Content-Type:text/html;charset=utf-8');
            self::returnHtmlData(self::aesEn(json_encode($lists, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES), $GLOBALS['aeskey']));
        } else {
            header('Content-Type:application/json;charset=utf-8');
            self::returnJsonData(json_encode($lists, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
        }
    }

    /**
     * 输出空信息
     * @return mixed.
     */
    public function output_empty() {
        header('Content-Type:application/json;charset=utf-8');
        $lists = array();
        $lists['code'] = 200;
        $lists['message'] = 'success';
        $lists['data'] = array('content' => array());
        if ($GLOBALS['encrypt']) {
            self::returnHtmlData(self::aesEn(json_encode($lists), $GLOBALS['aeskey']));
        } else {
            self::returnJsonData(json_encode($lists));
        }
    }

    /**
     * 接口操作返回失败
     * @param string $msg 失败消息.
     * @return mixed.
     */
    public function output_error($msg = '', $code = 500) {
        header('Content-Type:application/json;charset=utf-8');
        $lists = array();
        $lists['code'] = $code;
        $lists['message'] = $msg;
        $device = isset($_SERVER['HTTP_PLATFORM']) ? $_SERVER['HTTP_PLATFORM'] : ''; //设备类型
        $device_type = $device == 'android' ? 1 : 2;
        if ($device_type == 2) {
            $lists['data'] = array('content' => array());
        }
        if ($GLOBALS['encrypt']) {
            self::returnHtmlData(self::aesEn(json_encode($lists), $GLOBALS['aeskey']));
        } else {
            self::returnJsonData(json_encode($lists));
        }
    }

    /**
     * 安卓 接口操作返回失败
     * @param string $msg 失败消息.
     * @return mixed.
     */
    public function output_error_android($msg = '', $code = 500) {
        header('Content-Type:application/json;charset=utf-8');
        $lists = array();
        $lists['code'] = $code;
        $lists['message'] = $msg;
        if ($GLOBALS['encrypt']) {
            self::returnHtmlData(self::aesEn(json_encode($lists), $GLOBALS['aeskey']));
        } else {
            self::returnJsonData(json_encode($lists));
        }
    }

    //图片加密
    static public function img_encrypt($data) {
        $key = Application::$conf['IMG_ENCRYPT']['key'];
        $iv = Application::$conf['IMG_ENCRYPT']['iv'];
        //取出前n个字符进行加密
        $begin = substr($data, 0, 1000);
        return openssl_encrypt($begin, 'AES-128-CBC', $key, 0, $iv) . substr($data, 1000);
    }

    //图片解密
    static public function img_decrypt($data) {
        $key = Application::$conf['IMG_ENCRYPT']['key'];
        $iv = Application::$conf['IMG_ENCRYPT']['iv'];
        //取出前n个字符进行解密
        return openssl_decrypt(substr($data, 0, 1344), 'AES-128-CBC', $key, 0, $iv) . substr($data, 1344);
    }

    static public function get($key, $decode = false) {
        if ($decode) {
            return self::aesDe(str_replace(' ', '+', _get($key)), $GLOBALS['aeskey']);
        }
        return _get($key);
    }

    /**
     * 加密数据
     *
     */
    static public function aesEn($data, $key) {
        $enData = openssl_encrypt($data, self::$method, $key, 0, self::$iv);
        return $enData;
    }

    /**
     * 解密数据
     *
     */
    static public function aesDe($data, $key) {
        $decrypted = openssl_decrypt($data, self::$method, $key, 0, self::$iv);
        return $decrypted;
    }

    /**
     * 获取ip
     *
     */
    static public function ip() {
        $ip = isset($_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : $_SERVER['REMOTE_ADDR'];
        $ip = strip_tags($ip);
        if (stripos($ip, ',') !== false) {
            $ip = explode(',', $ip)[0];
        }
        return trim($ip);
    }

    /**
     * 获取参数
     * @param string $key  返回参数名
     * @return mixed.
     */
    public function params($key = null) {
        if (!empty($GLOBALS['device_type']) && $GLOBALS['device_type'] == 3) {
            $request = Yii::$app->request;
            $tokenDataKey = 'tokenData';
            $data = $request->get($tokenDataKey);
            $tokenData = empty($data) ? $request->post($tokenDataKey) : $request->get($tokenDataKey);
            if (empty($tokenData)) {
                foreach ($key as $key => $value) {
                    $params[$value] = null;
                }
                return $params;
            } else {
               // $tokenData = urlencode($tokenData);
                $tokenData = str_replace(' ', '+', $tokenData);
                $data = self::aesDe($tokenData, $GLOBALS['aeskey']);
                if (empty($data)) {
                    
                    $this->output_error('解密失败5', 500);
                    return [];
                }
                $data = json_decode($data, true);
                $params = [];
                foreach ($key as $value) {
                    if (!empty($data[$value])) {
                        $params[$value] = $data[$value];
                    } else {
                        $params[$value] = null;
                    }
                }
                return $params;
            }
        } else {
            $request = Yii::$app->request;
            if (!empty($key)) {
                if (is_array($key)) {
                    foreach ($key as $value) {
                        $data = $request->get($value);
                        $params[$value] = $data == '' ? $request->post($value) : $request->get($value);
                    }
                    return $params;
                } else {
                    $data = $request->get($key);
                    return empty($data) ? $request->post($key) : $request->get($key);
                }
            } else {
                $dataGet = $request->get();
                $dataPost = $request->post();
                return array_merge($dataGet, $dataPost);
            }
        }
    }

}
