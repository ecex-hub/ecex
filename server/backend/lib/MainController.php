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
class MainController extends ApiTouristAuthController {

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

        $v = isset($_SERVER['HTTP_V']) ? $_SERVER['HTTP_V'] : '';
        if (!$v) {
            $v = Yii::$app->request->get('v');
        }

        if (!in_array($v, array('vMH3KLaX'))) {
            return array('state' => 500, 'msg' => '加密版本错误');
        }
        $device = isset($_SERVER['HTTP_PLATFORM']) ? $_SERVER['HTTP_PLATFORM'] : ''; //设备类型
        if (!$device) {
            $device = Yii::$app->request->get('platform');
        }
        if (!in_array($device, array('ios', 'android', 'h5', 'h5direct','h5Android'))) {
            return array('state' => 500, 'msg' => '设备错误');
        }

        //新加数据
        if ($device == 'android') {
            $device_type = 1;
        } else if ($device == 'ios') {
            $device_type = 2;
        } else if ($device == 'h5direct') {//ios 浏览器打开
            $device_type = 3;
        } else if ($device == 'h5') {//h5 webclip打开
            $device_type = 4;
        } else if ($device == 'h5Android') {//安卓 浏览器打开
            $device_type = 5;
        } else {//
            $device_type = 4; //
        }
        $mac = isset($_SERVER['HTTP_MAC']) ? $_SERVER['HTTP_MAC'] : Yii::$app->request->get('mac');
        $system_version = isset($_SERVER['HTTP_SYSTEMVERSION']) ? $_SERVER['HTTP_SYSTEMVERSION'] : Yii::$app->request->get('system_version');
        $phone_model = isset($_SERVER['HTTP_PHONEMODEL']) ? $_SERVER['HTTP_PHONEMODEL'] : Yii::$app->request->get('phone_model');
        $versions = isset($_SERVER['HTTP_VERSIONS']) ? $_SERVER['HTTP_VERSIONS'] : '1.0.1'; //设备类型

        $deviceValue = $device;
        if (in_array($device, ['h5', 'h5direct', 'h5Android'])) {
            $deviceValue = 'h5';
        }
        $code = LibRsaHelper::privDecrypt($token, $v, $deviceValue);
        //return array('state' => 500, 'msg' => [$token,$v,$device,$code]);

        if (empty($code)) {
            return array('state' => 500, 'msg' => '解密失败1');
        }
        list($uuid, $time, $aesKey) = explode('_', $code);
        //获取登陆信息
        if (!$time) {
            return array('state' => 500, 'msg' => '解密失败');
        }
        //黑名单验证
        $ipInfo = BlacklistMessage::getIpBlacklist(self::ip());
        if (!empty($ipInfo)) {
            // return array('state' => 500, 'msg' => '非法地址');
        }
        //渠道
        $channelID = Yii::$app->redis->hget('register', $uuid . 'channelID');
        if (empty($channelID)) {
            $channelID = isset($_SERVER['HTTP_CHANNELID']) ? $_SERVER['HTTP_CHANNELID'] : ChannelManage::mainChannel;
            ;
        }
        //谷歌全部转入主渠道
        $phone_array = ['QEMU', 'Google', 'Letv', 'SHARP', 'TAOBAO', 'LeMobile', 'LGE', 'Meitu',
            'rockchip', 'HMD', 'Coolpad', 'YOUXUEPAI', 'rockchip', 'HMD', 'Coolpad', 'YOUXUEPAI',
            'K-Touch', 'koobee', 'Letv'];
        if (in_array($phone_model, $phone_array)) {
            $channelID = ChannelManage::mainChannel;
        }
        //安卓7.11以下转入主渠道
        if ($device_type == 1) {
            $version_string = ltrim($system_version, 'android:');
            $version_array = explode('.', $version_string);
            if (!empty($version_array[0])) {
                if ($version_array[0] < 7) {
                    $channelID = ChannelManage::mainChannel;
                }
                if ($version_array[0] == 7 && isset($version_array[1]) && $version_array[1] <= 11) {
                    $channelID = ChannelManage::mainChannel;
                }
            }
        }

        $uid = Yii::$app->redis->hget('register', $uuid);
        if (!empty($uid)) {
            //查询$uid 登陆mac 。是否存在
            $loginMac = Yii::$app->redis->hget('accountLoginMac', $uid);
            if (!empty($loginMac)) {
                if ($mac != $loginMac) {//该用户最后登陆mac与当前mac不一致 。需要更好账号
                    if ($uuid == $mac) {//绑定手机
                        // $uuid = $uuid . '1';
                    } else {
                        //  $uuid = $mac;
                    }
                    $uid = Yii::$app->redis->hget('register', $uuid);
                }
            }
        }
        if (!empty($uid)) {
            //Yii::$app->redis->hset('accountLoginMac', $uid, $mac); //redis缓存丢失，重新设置
        }
        //状态验证
        $state = Yii::$app->redis->hget('register', $uuid . 'state');
        if (!empty($state) && $state != 1) {
            return array('state' => 500, 'msg' => '黑名单用户');
        }
        if (!$uid) {
            //查询下数据库
            $userInfo = User::findOne(['account' => $uuid]);
            if (!empty($userInfo)) {
                if ($userInfo->state != 1) {
                    return array('state' => 500, 'msg' => '黑名单用户');
                }
                $uid = $userInfo->uid;
            }
            if (!$uid) {
                $redisAllChannel = ChannelManage::getRedisAllChannel();
                if (empty($channelID) || !in_array($channelID, $redisAllChannel)) {
                    $channelID = ChannelManage::mainChannel;
                }
                //如果不在限制中,允许注册
                if (!in_array(Yii::$app->requestedRoute, ['home-config/home', 'user-behavior-log/add-user-behavior-log'])) {
                    $uid = User::register($uuid, '', $device_type, $mac, $system_version, $phone_model, $channelID, null, $ROBOR = false, $versions);
                }
            } else {
                Yii::$app->redis->hset('register', $uuid, $uid); //redis缓存丢失，重新设置
                Yii::$app->redis->hset('register', $mac . 'state', $userInfo->state); //redis缓存丢失，重新设置
                Yii::$app->redis->hset('register', $uuid . 'channelID', $channelID); //redis缓存丢失，重新设置
            }
        }
        $GLOBALS['mac'] = $mac;
        $GLOBALS['uid'] = $uid;
        $GLOBALS['uuid'] = $uuid;
        $GLOBALS['aeskey'] = $aesKey;
        $GLOBALS['encrypt'] = true;
        $GLOBALS['device_type'] = $device_type;
        $GLOBALS['versions'] = $versions;
        $GLOBALS['channelID'] = $channelID;
        if (Yii::$app->request->get('debug')) {
            $GLOBALS['encrypt'] = false;
        }
        return array('state' => 200, 'uuid' => $uuid, 'token' => $token, 'v' => $v, 'time' => $time, 'platform' => $device, 'mac' => $mac, 'system_version' => $system_version, 'phone_model' => $phone_model, 'channelID' => $channelID, 'device_type' => $device_type);
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
        //$GLOBALS['encrypt'] = false;
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
        } else if ($device_type == 1) {
            $lists['data'] = array('content' => array());
        }
        //$GLOBALS['encrypt'] = false;
        if ($GLOBALS['encrypt']) {
            self::returnHtmlData(self::aesEn(json_encode($lists), $GLOBALS['aeskey']));
        } else {
            self::returnJsonData(json_encode($lists));
        }
    }

//    /**
//     * 接口操作返回失败
//     * @param string $msg 失败消息.
//     * @return mixed.
//     */
//    public function output_error($msg = '', $code = 500) {
//        header('Content-Type:application/json;charset=utf-8');
//        $lists = array();
//        $lists['code'] = $code;
//        $lists['message'] = $msg;
//        $device = isset($_SERVER['HTTP_PLATFORM']) ? $_SERVER['HTTP_PLATFORM'] : ''; //设备类型
//        $device_type = $device == 'android' ? 1 : 2;
//        if ($device_type == 2) {
//            $lists['data'] = array('content' => array());
//        }
//        if ($GLOBALS['encrypt']) {
//            self::returnHtmlData(self::aesEn(json_encode($lists), $GLOBALS['aeskey']));
//        } else {
//            self::returnJsonData(json_encode($lists));
//        }
//    }
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
        if (!empty($GLOBALS['device_type']) && in_array($GLOBALS['device_type'], [3, 4, 5])) {
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
                $tokenData = str_replace(' ', '+', $tokenData);
                $data = self::aesDe($tokenData, $GLOBALS['aeskey']);
                if (empty($data)) {
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
            $tokenDataKey = 'tokenData';
            $data = $request->get($tokenDataKey);
            $tokenData = empty($data) ? $request->post($tokenDataKey) : $request->get($tokenDataKey);
            // var_dump($tokenData);
            if (empty($tokenData)) {
                foreach ($key as $key => $value) {
                    $params[$value] = null;
                }
                return $params;
            } else {
                //$tokenData = rawurldecode(urlencode(urldecode($tokenData)));
                $tokenData = str_replace(' ', '+', $tokenData);
                $aeskey = $GLOBALS['aeskey'];
                $dataAes = self::aesDe($tokenData, $aeskey);
                //  return array('state' => 502, 'msg' => [$tokenData1, $aeskey1, $tokenData, $aeskey, $dataAes]);

                if (empty($dataAes)) {
                    foreach ($key as $key => $value) {
                        $params[$value] = null;
                    }
                    return $params;
                }
                //$dataAes = '&a=b&c=4&d=6&9=7';
                //对数据进行解密
                $dataAes = explode('&', $dataAes);
                // $x = [];
                $data = [];
                foreach ($dataAes as $key1 => $value1) {

                    $key_value = explode('=', $value1);
                    if (!empty($key_value[0])) {
                        if (!empty($key_value[1])) {
                            $data[$key_value[0]] = urldecode(urldecode($key_value[1]));
                        } else {
                            $data[$key_value[0]] = null;
                        }
                    }
                }

                //$data = json_decode($data, true);
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
        }
    }

}
