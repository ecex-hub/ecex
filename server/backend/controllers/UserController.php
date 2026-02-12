<?php

namespace backend\controllers;

use Yii;
use common\models\AccountInfo;
use common\helpers\RedisHelper;

/**
 * 用户相关接口控制器
 */
class UserController extends \backend\lib\ApiBaseController
{
    public $layout = false;

    /**
     * @OA\Get(
     *     path="/user/info",
     *     tags={"用户"},
     *     summary="获取用户信息",
     *     description="获取当前登录用户的详细信息",
     *     security={{"bearerAuth": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(property="uid", type="integer", example=5),
     *                 @OA\Property(property="e_uid", type="string", example=""),
     *                 @OA\Property(property="avatar", type="string", example=""),
     *                 @OA\Property(property="nickname", type="string", example="千千阙歌"),
     *                 @OA\Property(property="account", type="string", example="18081077689"),
     *                 @OA\Property(property="money", type="number", format="float", example=0),
     *                 @OA\Property(property="pay_back", type="integer", example=0),
     *                 @OA\Property(property="allowance", type="integer", example=0),
     *                 @OA\Property(property="dream_fund", type="integer", example=20000),
     *                 @OA\Property(property="has_pay_pwd", type="boolean", example=false),
     *                 @OA\Property(property="is_real", type="int", example=1)
     *             )
     *         )
     *     )
     * )
     */
    public function actionInfo()
    {
        $data = Yii::$app->user->identity;
        $returnData = [
            'uid' => $data['uid'],
            'e_uid' => $data['e_uid'],
            'avatar' => \common\components\FuncHelper::getCdnUrl($data['avatar']),
            'nickname' => $data['nickname'],
            'account' => $data['account'],
            'money' => $this->changeDecimalReserve($data['money']),
            'pay_back' => $this->changeDecimalReserve($data['pay_back']),
            'allowance' => $this->changeDecimalReserve($data['allowance']),
            'dream_fund' => $this->changeDecimalReserve($data['dream_fund']),
            'has_pay_pwd' => !empty($data['payPassword']),
            'is_real' => $data['is_real'],
        ];
        $this->output($returnData);
    }

    /**
     * @OA\Put(
     *     path="/user/password",
     *     tags={"用户"},
     *     summary="修改密码",
     *     description="修改用户登录密码",
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"oldPassword", "newPassword"},
     *                 @OA\Property(
     *                     property="oldPassword",
     *                     type="string",
     *                     description="旧密码"
     *                 ),
     *                 @OA\Property(
     *                     property="newPassword",
     *                     type="string",
     *                     description="新密码"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="null", example=null)
     *         )
     *     )
     * )
     */
    public function actionPassword()
    {
        $params = $this->params(['oldPassword', 'newPassword']);
        $this->VerificationParameter($params, ['oldPassword', 'newPassword']);
        
        $model = new AccountInfo();
        $boor = $model->modifyAccountPassword(
            Yii::$app->user->identity,
            $params['oldPassword'],
            $params['newPassword'],
            null,
            null
        );
        
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\Post(
     *     path="/user/logout",
     *     tags={"用户"},
     *     summary="退出登录",
     *     description="用户退出登录，清除token",
     *     security={{"bearerAuth": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="null", example=null)
     *         )
     *     )
     * )
     */
    public function actionLogout()
    {
        $user = Yii::$app->user->identity;
        if ($user) {
            // 清除Redis中的token
            RedisHelper::deleteTokenByUid($user->uid);
        }
        $this->output();
    }
}
