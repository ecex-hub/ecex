<?php

namespace backend\controllers;

use common\components\FuncHelper;
use common\helpers\RedisHelper;
use common\models\AccountInfo;
use common\models\SendSMSLog;

/**
 * Site controller
 */
class RegisterController extends \backend\lib\ApiBaseController
{

    public $layout = false;

    public function behaviors()
    {
        $behaviors = parent::behaviors();

        // 配置不需要鉴权的动作
        $behaviors['authenticator']['except'] = ['code', 'index', 'pwd'];

        return $behaviors;
    }

    /**
     * @OA\POST(
     *     tags={"注册"},
     *     path="/register/index",
     *     summary="注册用户",
     *     @OA\RequestBody(
     *         required=true,
     *         description="User registration details",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="account",
     *                     description="手机号",
     *                     type="string",
     *                 ),
     *                 @OA\Property(
     *                     property="password",
     *                     description="密码",
     *                     type="string",
     *                 ),
     *                 @OA\Property(
     *                     property="payPassword",
     *                     description="交易密码",
     *                     type="string",
     *                 ),
     *                @OA\Property(
     *                     property="invite_code",
     *                     description="邀请码",
     *                     type="string",
     *                     example="1234567890"
     *                 ),
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response="200",
     *         description="Successful operation",
     *         @OA\JsonContent(
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="login_token",
     *                     type="string",
     *                     description="用于后续请求的身份验证令牌",
     *                     example="PSlynQT9wtUCSZQdjZakx-3Yjnim1Add"
     *                 ),
     *                 @OA\Property(
     *                     property="uid",
     *                     type="integer",
     *                     description="用户ID",
     *                     example=3
     *                 ),
     *                 @OA\Property(
     *                     property="e_uid",
     *                     type="strig",
     *                     description="用户别名ID",
     *                     example="111111111111"
     *                 ),
     *                 @OA\Property(
     *                     property="invite_code",
     *                     type="string",
     *                     description="邀请码",
     *                     example="67777d"
     *                 ),
     *                 @OA\Property(
     *                     property="vipGrade",
     *                     type="int",
     *                     description="vip等级，大于1则已实名认证",
     *                     example=1
     *                 ),
     *                 @OA\Property(
     *                     property="is_real",
     *                     type="int",
     *                     description="真人认证 1-默认 2-已认证",
     *                     example=1
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionIndex()
    {
        // 支持前端字段名（phone）和后端字段名（account）
        $requestParams = $this->params([
            'account',
            'phone',
            'password',
            'payPassword',
            'invite_code',
            'inviteCode'
        ]);
        
        // 统一字段名：将 phone 转换为 account
        if (empty($requestParams['account']) && !empty($requestParams['phone'])) {
            $requestParams['account'] = $requestParams['phone'];
        }
        
        // 统一字段名：将 inviteCode 转换为 invite_code
        if (empty($requestParams['invite_code']) && !empty($requestParams['inviteCode'])) {
            $requestParams['invite_code'] = $requestParams['inviteCode'];
        }
        
        $params = [
            'account' => $requestParams['account'] ?? '',
            'password' => $requestParams['password'] ?? '',
            'payPassword' => $requestParams['payPassword'] ?? '',
            'invite_code' => $requestParams['invite_code'] ?? ''
        ];
        
        if (empty($params['invite_code'])) {
            $this->output_error('邀请码必填', 202);
        }
        
        $this->VerificationParameter($params, [
            'account',
            'password',
            'invite_code',
        ]);
        
        if (!FuncHelper::cleanEmojiStr($params['password'])) {
            $this->output_error('密码不能包含表情符号', 202);
        }
        
        if (!empty($params['payPassword']) && !FuncHelper::cleanEmojiStr($params['payPassword'])) {
            $this->output_error('交易密码不能包含表情符号', 202);
        }
        
        $sendIp = $this->getUserIP();
        $model = new AccountInfo();
        // 传递空字符串作为 nickname 和 IDCard
        $uid = $model->RegisterAccount(
            $params['account'], 
            $params['password'], 
            $params['invite_code'], 
            $sendIp,
            '', // nickname 为空
            '', // IDCard 为空
            $params['payPassword']
        );
        
        if ($uid > 0) {
            $identity = $model->getAccountInfo($uid);
            if (empty($identity)) {
                $this->output_error('登录失败', 401);
            }
            $accessToken = RedisHelper::getTokenByUid($identity['uid']);
            if (!empty($accessToken)) {
                $this->output([
                    'login_token' => $accessToken,
                    'uid' => (int)$identity['uid'],
                    'e_uid' => $identity['e_uid'] ?? '',
                    'invite_code' => $identity['invite_code'],
                    'is_real' => (int)($identity['is_real'] ?? 0),
                ]);
            } else {
                $this->output_error('登录失败', 401);
            }
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\POST(
     *     tags={"注册"},
     *     path="/register/code",
     *     summary="发送手机号",
     *     @OA\RequestBody(
     *         required=true,
     *         description="User registration details",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="phone",
     *                     description="Phone number for registration",
     *                     type="string",
     *                     example="1234567890"
     *                 ),
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response="200",
     *         description="Successful operation",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="status", type="string", example="success"),
     *             @OA\Property(property="message", type="string", example="Verification code sent successfully."),
     *             @OA\Property(property="data", type="string", example="ok")
     *         )
     *     )
     * )
     */
    public function actionCode()
    {
        $params = $this->params(['phone']);
        $this->VerificationParameter($params, ['phone']);
        $sendIp = $this->getUserIP();
        $model = new SendSMSLog();
        $boor = $model->userIDSendSMSReocrd($params['phone'], $sendIp);
        if (!empty($boor)) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }


    public function actionPwd()
    {
        $params = $this->params([
            'account',
            'password',
            'nickname',
        ]);
        $this->VerificationParameter($params, [
            'account',
            'password',
            'nickname',
        ]);
        if (!FuncHelper::isChinese($params['nickname'])) {
            $this->output_error('用户名必须是汉字', 202);
        }
        if (!FuncHelper::cleanEmojiStr($params['password'])) {
            $this->output_error('密码不能包含表情符号', 202);
        }
        $model = new AccountInfo();
        $identity = $model->find()
            ->where(['account' => $params['account']])
            ->andWhere(['nickname' => $params['nickname']])
            ->one();
        if (empty($identity)) {
            $this->output_error('账号不存在', 202);
        }
        $model = new AccountInfo();
        $boor = $model->updateAll([
            'password' => md5($params['password']),
            'utime' => time(),
        ], ['account' => $params['account']]);
        if (empty($boor)) {
            $this->output_error('找回密码失败', 202);
        }
        $accessToken = RedisHelper::getTokenByUid($identity->uid);
        if (!empty($accessToken)) {
            $this->output([
                'login_token' => $accessToken,
                'uid' => $identity->uid,
                'e_uid' => $identity->e_uid,
                'invite_code' => $identity->invite_code,
                'is_real' => $identity->is_real,
            ]);
        }
        $this->output_error('登录密码失败', 202);
    }

}
