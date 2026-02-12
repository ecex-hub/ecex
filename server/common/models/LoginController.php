<?php

/**
 * _______________#########_______________________
 * ______________############_____________________
 * ______________#############____________________
 * _____________##__###########___________________
 * ____________###__######_#####__________________
 * ____________###_#######___####_________________
 * ___________###__##########_####________________
 * __________####__###########_####_______________
 * ________#####___###########__#####_____________
 * _______######___###_########___#####___________
 * _______#####___###___########___######_________
 * ______######___###__###########___######_______
 * _____######___####_##############__######______
 * ____#######__#####################_#######_____
 * ____#######__##############################____
 * ___#######__######_#################_#######___
 * ___#######__######_######_#########___######___
 * ___#######____##__######___######_____######___
 * ___#######________######____#####_____#####____
 * ____######________#####_____#####_____####_____
 * _____#####________####______#####_____###______
 * ______#####______;###________###______#________
 * ________##_______####________####______________
 */

namespace backend\controllers;

use Yii;
use common\models\AccountInfo;

/**
 * Site controller
 */
class LoginController extends \backend\lib\ApiBaseController
{

    public $layout = false;

    public function behaviors()
    {
        $behaviors = parent::behaviors();

        // 配置不需要鉴权的动作
        $behaviors['authenticator']['except'] = ['index'];

        return $behaviors;
    }

    /**
     * Login API endpoint
     *
     * @OA\Post(
     *     tags={"登录"},
     *     path="/login/index",
     *     summary="账号登录",
     *     description="This endpoint allows users to log in and receive a login token.",
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 required={"password", "account"},
     *                 @OA\Property(
     *                     property="password",
     *                     type="string",
     *                     description="User password"
     *                 ),
     *                 @OA\Property(
     *                     property="account",
     *                     type="string",
     *                     description="User account (e.g., username or email)"
     *                 )
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

        $params = $this->params(['account', 'password']);
        $this->VerificationParameter($params, ['account', 'password']);
        //判断账号密码
        $identity = AccountInfo::provingAccountInfoPasswordExactness($params['account'], $params['password']);
        if (!empty($identity)) {
            //登录
            $sendIp = $this->getUserIP();
            $model = new AccountInfo();
            $token = $model->login($identity,$sendIp);
            if (!empty($token)) {
                $this->output([
                    'login_token' => $token,
                    'uid' => $identity->uid,
                    'e_uid' => $identity->e_uid,
                    'invite_code' => $identity->invite_code,
                    'is_real' => $identity->is_real,
                ]);
            } else {
                $this->output_error('登录失败', 401);
            }
        } else {
            $this->output_error('登录密码错误，请检查', 402);
        }
    }


}
