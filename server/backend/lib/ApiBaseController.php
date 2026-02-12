<?php

/**
 * Created by PhpStorm.
 * User: dsh
 * Date: 2017/10/19
 * Time: 16:58
 */

namespace backend\lib;

use common\components\ApiBearerAuth;
use common\components\FuncHelper;
use common\components\RequestLogger;
use common\models\RequestLog;
use Yii;
use yii\base\UserException;
use yii\web\Controller;
use yii\web\Response;
use yii\web\UnauthorizedHttpException;

class ApiBaseController extends Controller
{
    private $startTime;
    public $enableCsrfValidation = false; //取消yii框架post验证
    protected $aesState = false;
    protected $errorAesState = false; //错误情况 。是否启用aes 加密返回数据
    protected $allowedOrigin = [
        'http://localhost:8080',
        '*',
    ];


    public function init()
    {
        parent::init();
        $this->setResponseCors();
    }


    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['authenticator'] = [
            'class' => ApiBearerAuth::class,
        ];
        $behaviors['requestLogger'] = [
            'class' => RequestLogger::class,
        ];
        return $behaviors;
    }

    /**
     * 获取ip
     * @return type
     */
    public function getUserIP()
    {
        $ip = '127.0.0.1';
//        if (!empty($_SERVER['HTTP_ALI_CDN_REAL_IP'])) {
//            $ip = $_SERVER['HTTP_ALI_CDN_REAL_IP'];
//        }
        if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            // 从 X-Forwarded-For 中获取第一个 IP 地址
            $ips = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
            // 确保有至少一个 IP 地址并且没有空值
            if (isset($ips[0]) && !empty($ips[0])) {
                // 获取第一个 IP 并去除空格
                $ip = trim($ips[0]);
            }
        }
//        if (!empty($_SERVER['REMOTE_ADDR'])) {
//            $ip = $_SERVER['REMOTE_ADDR'];
//        }
        return $ip;
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

    public function VerificationParameter($params, $fields)
    {
        foreach ($fields as $key => $value) {
            if (empty($params[$value]) && $params[$value] !== 0 && $params[$value] !== '0') {
                $this->output_error($value . '参数不足', 201);
            }
        }
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


    public function params($key = null)
    {

        $data = file_get_contents('php://input');
        if (empty($data)) {
            foreach ($key as $key => $value) {
                $params[$value] = "";
            }
            return $params;
        } else {
            if ($this->aesState) {
                $data = str_replace(' ', '+', $data);
                $data = self::aesDe($data, $this->aeskey);
            }
            if (empty($data)) {
                foreach ($key as $key => $value) {
                    $params[$value] = "";
                }
                return $params;
            }
            $data = json_decode($data, true);
            $params = [];
            foreach ($key as $value) {
                if (!empty($data[$value])) {
                    $params[$value] = $data[$value];
                } else {
                    $params[$value] = "";
                }
            }
            return $params;
        }
    }

    /**
     * 加密数据
     *
     */
    static public function aesEn($data, $key)
    {
        $enData = openssl_encrypt($data, self::$method, $key, 0, self::$iv);
        return $enData;
    }

    /**
     * 解密数据
     *
     */
    static public function aesDe($data, $key)
    {
        $decrypted = openssl_decrypt($data, self::$method, $key, 0, self::$iv);
        return $decrypted;
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
//    public function setResponseCors()
//    {
//        // Handle preflight OPTIONS request
//        if (Yii::$app->request->getMethod() === 'OPTIONS') {
//            Yii::$app->response->headers->set('Access-Control-Allow-Origin', Yii::$app->request->getOrigin());
//            Yii::$app->response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
//            Yii::$app->response->headers->set('Access-Control-Allow-Headers', 'Authorization, platform, Content-Type, origin, x-requested-with');
//            Yii::$app->response->headers->set('Access-Control-Allow-Credentials', 'true');
//            Yii::$app->response->statusCode = 200; // Make sure we send 200 OK for OPTIONS request
//            Yii::$app->end(); // Stop processing further
//        }
//
//        // Handle other requests (non-OPTIONS)
//        if (in_array('*', $this->allowedOrigin)) {
//            Yii::$app->response->headers->set('Access-Control-Allow-Origin', Yii::$app->request->getOrigin());
//        } elseif (in_array(Yii::$app->request->getOrigin(), $this->allowedOrigin)) {
//            Yii::$app->response->headers->set('Access-Control-Allow-Origin', Yii::$app->request->getOrigin());
//        }
//
//        Yii::$app->response->headers->set('Access-Control-Allow-Credentials', "true");
//        Yii::$app->response->headers->set('Access-Control-Allow-Headers', 'Authorization, platform, Content-Type, origin, x-requested-with');
//    }

    public function setResponseCors()
    {
        // Handle preflight OPTIONS request
        if (Yii::$app->request->getMethod() === 'OPTIONS') {
            Yii::$app->response->headers->set('Access-Control-Allow-Origin', "*");
            Yii::$app->response->headers->set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
            Yii::$app->response->headers->set('Access-Control-Allow-Headers', '*');
            Yii::$app->response->headers->set('Access-Control-Allow-Credentials', 'true');
            Yii::$app->response->statusCode = 200; // Make sure we send 200 OK for OPTIONS request
            Yii::$app->end(); // Stop processing further
        }
        Yii::$app->response->headers->set('Access-Control-Allow-Origin', "*");
        Yii::$app->response->headers->set('Access-Control-Allow-Credentials', "true");
        Yii::$app->response->headers->set('Access-Control-Allow-Headers', '*');
    }

    public function RecordResponse($data)
    {
        // 获取日志 ID
        $logId = Yii::$app->params['log_id'] ?? "";
        if ($logId) {
            // 查找之前保存的日志记录
            $log = RequestLog::findOne($logId);
            if ($log) {
                // 获取响应对象
                // 更新日志记录响应内容和状态码
                $log->response = json_encode($data);
                $log->utime = time();
                $log->save();  // 保存更新后的日志
            }
        }
    }

    /**
     * 成功输出信息
     * @param string $name .
     * @param mixed $data 成功返回数据.
     * @return mixed.
     */
    public function output($data = null)
    {

        $lists = array();
        $lists['code'] = 200;
        $lists['message'] = 'success';
        $lists['data'] = $data;

        $this->RecordResponse($lists);

        if ($this->aesState) {
            header('Content-Type:text/html;charset=utf-8');
            self::returnHtmlData(self::aesEn(json_encode($lists, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES), $this->aeskey));
        } else {
            header('Content-Type:application/json;charset=utf-8');
            self::returnJsonData($lists);
        }
    }

    public function output_error($msg = '', $code = 500)
    {
        header('Content-Type:application/json;charset=utf-8');
        $lists = array();
        $lists['code'] = $code;
        $lists['message'] = $msg;
        $this->RecordResponse($lists);
        if ($this->errorAesState) {
            self::returnHtmlData(self::aesEn(json_encode($lists), $this->aeskey));
        } else {
            $data = ['account' => 1, 'password' => 123456];
            self::returnJsonData($lists);
        }
    }
}
