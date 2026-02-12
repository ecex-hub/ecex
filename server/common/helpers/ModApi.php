<?php

/**
 * Sign Helper.
 *
 * 签名助手
 */

namespace common\helpers;


/**
 * Sign Helper
 */
class ModApi extends BaseHelper {

  static $iv = '1111111111111111'; //保证偏移量为16位
  
  private static $imgkey = '3333333333333333';
  private static $imgiv  = '1111111111111111';

  static $method = 'AES-128-CBC';//加密方式

  static public function verify() {
    $GLOBALS['RUNTIME'] = true;
    //token是app登录的加密信息，包含imei码或其他硬件标识
    //当token信息过来，解析出值后，查询系统是否有，没有则注册一个用户到系统
    $token = _get('token');
    $token = str_replace(' ','+',$token);

    $v = $_SERVER['HTTP_V'];
    if (!$v) {
      $v = mod_api::get('v');
    }
    if (!in_array($v,array('vMH3KLaX'))) {
      return array('state'=>500,'msg'=>'加密版本错误');
    }

    $device = $_SERVER['HTTP_PLATFORM'];//设备类型
    if (!$device) {
      $device = mod_api::get('platform');
    }
    if (!in_array($device,array('ios','android'))) {
      return array('state'=>500,'msg'=>'设备错误');
    }
    $code = lib_rsa::privDecrypt($token, $v, $device);

    list($uuid,$time,$aeskey) = explode('_',$code);
    if (!$time) {
      return array('state'=>500,'msg'=>'解密失败');
    }

    $uid = RedisCache::get('register', $uuid);
    if (!$uid) {
      //查询下数据库
      $uid = DB::one("SELECT uid FROM user WHERE account='{$uuid}'");
      if (!$uid) {
        $uid = mod_user::register($uuid);
      } else {
        RedisCache::save('register', $uuid, $uid, false);//redis缓存丢失，重新设置
      }
    }
    $GLOBALS['uid'] = $uid;
    $GLOBALS['aeskey'] = $aeskey;
    $GLOBALS['encrypt'] = true;
    if (_get('debug')) {
      $GLOBALS['encrypt'] = false;
    }

    return array('state'=>200,'uuid'=>$uuid,'token'=>$token,'v'=>$v,'time'=>$time,'platform'=>$device);
  }

  static public function output($name, $data) {
    $lists = array();
    $lists['code'] = 200;
    $lists['message'] = 'success';
    $lists['data'] = $data;
    if ($GLOBALS['encrypt']) {
      header('Content-Type:text/html;charset=utf-8');
      return mod_api::aesEn(json_encode($lists,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES), $GLOBALS['aeskey']);
    } else {
      header('Content-Type:application/json;charset=utf-8');
      return json_encode($lists,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
    }
  }

  static public function output_empty() {
    header('Content-Type:application/json;charset=utf-8');
    $lists = array();
    $lists['code'] = 200;
    $lists['message'] = 'success';
    $lists['data'] = array('content' => array());
    if ($GLOBALS['encrypt']) {
      return mod_api::aesEn(json_encode($lists), $GLOBALS['aeskey']);
    } else {
      return json_encode($lists);
    }
  }

  //接口操作返回失败
  static public function output_error($msg = '') {
    header('Content-Type:application/json;charset=utf-8');
    $lists = array();
    $lists['code'] = 500;
    $lists['message'] = $msg;
    $lists['data'] = array('content' => array());
    if ($GLOBALS['encrypt']) {
      return mod_api::aesEn(json_encode($lists), $GLOBALS['aeskey']);
    } else {
      return json_encode($lists);
    }
  }

  //图片加密
  static public function img_encrypt($data) {
    $key = self::$imgkey;
    $iv  = self::$imgiv;
    //取出前n个字符进行加密
    $begin = substr($data,0,1000);
    return openssl_encrypt($begin, 'AES-128-CBC', $key, 0, $iv).substr($data,1000);
  }

  //图片解密
  static public function img_decrypt($data) {
    $key = self::$imgkey;
    $iv  = self::$imgiv;
    //取出前n个字符进行解密
    return openssl_decrypt(substr($data,0,1344), 'AES-128-CBC', $key, 0, $iv).substr($data,1344);
  }

  static public function get($key,$decode = false) {
    if ($decode) {
      return mod_api::aesDe(str_replace(' ','+',_get($key)), $GLOBALS['aeskey']);
    }
    return _get($key);
  }

  /**
   * 加密数据
   *
   */
  static public function aesEn($data, $key) {
      $enData = openssl_encrypt($data, self::$method, $key, 0, self::$iv);
      return  $enData;
  }

  /**
   * 解密数据
   *
   */
  static public function aesDe($data, $key) {
      $decrypted = openssl_decrypt($data, self::$method, $key, 0, self::$iv);
      return $decrypted;
  }

  static public function ip() {
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    $ip = strip_tags($ip);
    if (stripos($ip, ',') !== false) {
      $ip = explode(',',$ip)[0];
    }
    return trim($ip);
  }

}
