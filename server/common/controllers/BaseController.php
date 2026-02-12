<?php

/**
 * Created by PhpStorm.
 * User: dsh
 * Date: 2017/10/19
 * Time: 16:58
 */

namespace common\controllers;

use common\components\FuncHelper;
use common\components\Speed;
use common\components\vSinger;
use common\components\ZxPayer;
use common\models\OnlineTradeOrder;
use common\pay\AlipayNew;
use common\pay\Wxpay;
use Yii;
use yii\web\Controller;
use yii\web\Response;

class BaseController extends Controller
{

    public $enableCsrfValidation = false; //取消yii框架post验证
    protected $allowedOrigin = [
        '*',
    ];
    protected $hostold = ["http://image.aiotglshop.com"]; //更换新域名 需要在这儿加入旧域名
    protected $host = 'https://image.anprrro.cn'; //

    public function init()
    {
        parent::init();
        $this->setResponseCors();
        //$this->provingLoginMessage(); //手动校验登录信息
    }

    /**
     * 获取v框架签名助手实例
     *
     * @param null $secretKey
     *
     * @param int $timeout
     *
     * @return vSinger
     */
    public function getVSigner($secretKey = null, $timeout = 300)
    {
        return new vSinger([
            'secretKey' => is_null($secretKey) ? Yii::$app->params['vSignKey'] : $secretKey,
            'timeout' => $timeout,
        ]);
    }


    /**
     * 获取ip
     * @return type
     */
    public function getUserIP()
    {
        $ip = '127.0.0.1';
        if (!empty($_SERVER['HTTP_ALI_CDN_REAL_IP'])) {
            $ip = $_SERVER['HTTP_ALI_CDN_REAL_IP'];
        }
        if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
        }
        if (!empty($_SERVER['REMOTE_ADDR'])) {
            $ip = $_SERVER['REMOTE_ADDR'];
        }
        return $ip;
    }

    /**
     * 获取speed 模型
     * @return Speed
     */
    protected function getSpeedModel()
    {
        return new Speed(Yii::$app->params['speedHost'], Yii::$app->params['speedSignKey'], Yii::$app->params['speedProductId']);
    }

    /**
     * 返回json数据
     *
     * @param     $data
     * @param int $status
     *
     * @throws \yii\base\ExitException
     */
    public function returnJson($data, $status = 200)
    {
        $response = Yii::$app->response;
        $response->format = Response::FORMAT_JSON;
        $response->statusCode = $status;
        $response->data = $data;
        Yii::$app->end();
    }

    /**
     * 返回Html数据
     *
     * @param     $data
     * @param int $status
     *
     * @throws \yii\base\ExitException
     */
    public static function returnHtmlData($data, $status = 200)
    {
        $response = Yii::$app->response;
        $response->format = Response::FORMAT_HTML;
        $response->statusCode = $status;
        $response->data = $data;
        Yii::$app->end();
    }

    /**
     * 返回json数据
     *
     * @param     $data
     * @param int $status
     *
     * @throws \yii\base\ExitException
     */
    public static function returnJsonData($data, $status = 200)
    {
        $response = Yii::$app->response;
        $response->format = Response::FORMAT_JSON;
        $response->statusCode = $status;
        $response->data = $data;
        Yii::$app->end();
    }

    /**
     * @param $callback
     * @param $data
     *
     * @throws \yii\base\ExitException
     */
    public function returnJsonPCallback($callback, $data)
    {
        $response = Yii::$app->response;
        $response->format = Response::FORMAT_HTML;
        $response->data = $callback . '(' . $data . ');';
        Yii::$app->end();
    }

    /**
     * 对外,返回json错误
     *
     * @param       $msg
     * @param int $resultCode
     * @param array $extraData
     *
     * @throws \yii\base\ExitException
     * @internal param int $status
     * @internal param int $errorCode
     */
    public function returnExternalJsonError($msg, $resultCode = 422, $extraData = [], $key = null)
    {
        if (is_array($resultCode) && empty($extraData) && is_array($extraData)) {
            $extraData = 422;
        }
        if (is_numeric($extraData) && is_array($resultCode)) {
            $resultCodeTmp = $extraData;
            $extraData = $resultCode;
            $resultCode = $resultCodeTmp;
        }
        $this->returnJson(FuncHelper::returnExternalErrorData($msg, $resultCode, $extraData, $key));
    }

    /**
     * 返回json错误
     *
     * @param       $msg
     * @param int $resultCode
     * @param array $extraData
     *
     * @throws \yii\base\ExitException
     * @internal param int $status
     * @internal param int $errorCode
     */
    public function returnJsonError($msg, $resultCode = 422, $extraData = [])
    {
        if (is_array($resultCode) && empty($extraData) && is_array($extraData)) {
            $extraData = 422;
        }
        if (is_numeric($extraData) && is_array($resultCode)) {
            $resultCodeTmp = $extraData;
            $extraData = $resultCode;
            $resultCode = $resultCodeTmp;
        }

        $this->returnJson(FuncHelper::returnErrorData($msg, $resultCode, $extraData));
    }

    /**
     * @param      $errors
     * @param null $msg
     *
     * @throws \yii\base\ExitException
     */
    public function returnFormError($errors, $msg = null)
    {
        if ($msg === null) {
            if (!empty($errors) && is_array($errors)) {
                foreach ($errors as $error) {
                    if (is_string($error)) {
                        $msg = $error;
                        break;
                    }
                }
            } elseif (is_string($errors)) {
                $msg = $errors;
            }
        }
        $this->returnJsonError($msg, ['errors' => $errors]);
    }

    /**
     * 返回成功json
     *
     * @param array|string $data
     * @param string $msg
     *
     * @throws \yii\base\ExitException
     */
    public function returnJsonSuccess($data = [], $msg = null)
    {
        if (!is_array($data) && empty($msg)) {
            $msg = $data;
            $data = [];
        }
        $this->returnJson(FuncHelper::returnSuccessData($data, $msg));
    }

    /**
     * 返回成功json
     *
     * @param array|string $data
     * @param string $msg
     *
     * @throws \yii\base\ExitException
     */
    public function returnJsonExternalSuccess($data = [], $msg = null, $key = null)
    {
        if (!is_array($data) && empty($msg)) {
            $msg = $data;
            $data = [];
        }
        $this->returnJson(FuncHelper::returnExternalSuccessData($data, $msg, $key));
    }

    /** 兼容v7写法
     * @param $data
     */
    public function resp($data)
    {
        exit(json_encode($data = ['errno' => [], 'data' => $data]));
    }

    /**
     * 获取参数
     * @param string $key 返回参数名
     * @return mixed.
     */
    public function params($key = null)
    {
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

    /**
     * 获取数组部分键值
     * @param type $data 数组
     * @param type $fields 返回键值
     * @return type
     */
    public function setArrayData($data, $fields)
    {
        if (empty($fields))
            return $data;
        $array = [];
        foreach ($data as $key => $value) {
            if (is_array($value)) {
                foreach ($value as $key1 => $value1) {
                    if (in_array($key1, $fields))
                        $array[$key][$key1] = $value1;
                }
            } else {
                if (in_array($key, $fields))
                    $array[$key] = $value;
            }
        }
        return $array;
    }

    /**
     * 转换比例
     * @param number $Score
     * @return mixed
     */
    public function changeScoreScale($Score)
    {
        $scale = Yii::$app->params['proportion']; //金钱比例
        return $Score / $scale;
    }

    /**
     * 保留小数位数
     * @param number $Score
     * @return mixed
     */
    public function changeDecimalReserve($value, $decimal = 2)
    {
        return round($value, $decimal); //保留小数位数
    }

    /**
     * 设置跨域头
     */
    public function setResponseCors()
    {
        if (in_array('*', $this->allowedOrigin)) {
            Yii::$app->response->headers->set('Access-Control-Allow-Origin', Yii::$app->request->getOrigin());
            //Yii::$app->response->headers->set('Access-Control-Allow-Origin', '*');
        } elseif (in_array(Yii::$app->request->getOrigin(), $this->allowedOrigin)) {
            Yii::$app->response->headers->set('Access-Control-Allow-Origin', Yii::$app->request->getOrigin());
        }
        Yii::$app->response->headers->set('Access-Control-Allow-Credentials', "true");
        Yii::$app->response->headers->set('Access-Control-Allow-Headers', 'Login-Type,Authorization,platform,Content-Type, origin, x-requested-with');
    }

}
