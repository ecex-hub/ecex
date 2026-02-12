<?php
/**
 * Created by PhpStorm.
 * User: dsh
 * Date: 2017/11/14
 * Time: 14:05
 */

namespace common\components;

use common\models\AccountInfo;
use common\models\RequestLog;
use yii\filters\auth\HttpBearerAuth;

use common\helpers\RedisHelper;
use Yii;
use yii\filters\auth\AuthMethod;

class ApiBearerAuth extends HttpBearerAuth
{

    /**
     * 登录认证类型
     * @var
     */
    public $loginType;

    /**
     * 授权验证
     * @param \yii\web\User $user
     * @param \yii\web\Request $request
     * @param \yii\web\Response $response
     * @return null|void|\yii\web\IdentityInterface
     */
    public function authenticate($user, $request, $response)
    {
        $authHeader = $request->getHeaders()->get('Authorization');
        if ($authHeader !== null) {
            if (preg_match('/^Bearer\s+(.*?)$/', $authHeader, $matches)) {
                $token = $matches[1];
                // 在这里添加你的自定义校验逻辑
                // 例如，从 Redis 或数据库中查找 token
                // 注意：确保你有一个方法来验证 token 的有效性
                // 根据 token 获取用户信息
                $identity = $this->GetToken($token);
                if ($identity != null) {
                    // 这里不再依赖 account_type 字段，避免老库无该字段时报 UnknownPropertyException
                    Yii::$app->user->login($identity);

                    //更新用户最后时间
                    $account = new AccountInfo();
                    $account->updateAll([
                        'login_ip' => $this->getUserIP(),
                        'last_login_time' => time(),
                    ], ['uid' => $identity->uid]);
                    //打日志
                    try {
                        Yii::$app->db->createCommand()->upsert(
                            't_user_login', // 表名
                            [
                                'uid' => $identity->uid,
                                'day' => date("Y-m-d"),
                                'itime' => time(),
                                'utime' => time(),
                            ], false
                        )->execute();
                    } catch (\Exception $e) {
                    }
                    return $identity;
                }
                $request = Yii::$app->request;
                if ($request->pathInfo != 'upload/img') {
                    //打印失败日志
                    $requestData = [
                        'request' => [
                            'header' => $request->getHeaders()->toArray(),
                            'body' => $request->getRawBody(),
                        ],
                        'method' => $request->method,
                        'url' => $request->url,
                    ];
                    $log = new RequestLog();
                    $log->method = $request->method;
                    $log->url = $request->url;
                    $log->request = json_encode($requestData);  // 请求参数
                    $log->itime = time();
                    $log->save();
                }

            }
        }

        // 设置响应格式为 JSON 并返回 JSON 错误信息
        \Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        \Yii::$app->response->data = [
            'code' => 401,
            'message' => '登录已失效，请重新登录！'
        ];
        \Yii::$app->response->setStatusCode(401);
        \Yii::$app->end();
    }

    /**
     * 检查令牌是否有效，并且续签
     *
     * @param string $token
     * @return bool
     */
    protected function GetToken($token)
    {
        $uid = RedisHelper::getUidByAccessToken($token);
        if ($uid <= 0) {
            return false;
        }
        return AccountInfo::findOne(['uid' => $uid]);
    }

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
}