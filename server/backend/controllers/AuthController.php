<?php

namespace backend\controllers;

use Yii;
use common\models\AccountInfo;
use common\models\Real;

/**
 * 认证相关接口控制器
 */
class AuthController extends \backend\lib\ApiBaseController
{
    public $layout = false;

    /**
     * @OA\Post(
     *     path="/auth/identity",
     *     tags={"认证"},
     *     summary="身份认证",
     *     description="提交身份认证信息",
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"realName", "IDCard"},
     *                 @OA\Property(
     *                     property="realName",
     *                     type="string",
     *                     description="真实姓名",
     *                     example="张三"
     *                 ),
     *                 @OA\Property(
     *                     property="IDCard",
     *                     type="string",
     *                     description="身份证号",
     *                     example="123456789012345678"
     *                 ),
     *                 @OA\Property(
     *                     property="IDFrontUrl",
     *                     type="string",
     *                     description="身份证正面图片URL",
     *                     example="http://example.com/idcard/front.jpg"
     *                 ),
     *                 @OA\Property(
     *                     property="IDOppositeUrl",
     *                     type="string",
     *                     description="身份证反面图片URL",
     *                     example="http://example.com/idcard/back.jpg"
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
    public function actionIdentity()
    {
        $params = $this->params(['realName', 'IDCard', 'IDFrontUrl', 'IDOppositeUrl']);
        $this->VerificationParameter($params, ['realName', 'IDCard']);

        $user = Yii::$app->user->identity;
        $model = new AccountInfo();
        $boor = $model->updateAccountIDCard(
            $user,
            $params['realName'],
            $params['IDCard'],
            $params['IDFrontUrl'] ?? '',
            $params['IDOppositeUrl'] ?? ''
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
     *     path="/auth/realname",
     *     tags={"认证"},
     *     summary="实名认证",
     *     description="提交实名认证信息（与身份认证相同）",
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"realName", "IDCard"},
     *                 @OA\Property(
     *                     property="realName",
     *                     type="string",
     *                     description="真实姓名",
     *                     example="张三"
     *                 ),
     *                 @OA\Property(
     *                     property="IDCard",
     *                     type="string",
     *                     description="身份证号",
     *                     example="123456789012345678"
     *                 ),
     *                 @OA\Property(
     *                     property="IDFrontUrl",
     *                     type="string",
     *                     description="身份证正面图片URL"
     *                 ),
     *                 @OA\Property(
     *                     property="IDOppositeUrl",
     *                     type="string",
     *                     description="身份证反面图片URL"
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
    public function actionRealname()
    {
        // 实名认证与身份认证逻辑相同
        $this->actionIdentity();
    }

    /**
     * @OA\Get(
     *     path="/auth/status",
     *     tags={"认证"},
     *     summary="获取认证状态",
     *     description="获取当前用户的认证状态",
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
     *                 @OA\Property(property="is_real", type="integer", example=1, description="1-未认证 2-已认证"),
     *                 @OA\Property(property="has_realname", type="boolean", example=false, description="是否已实名"),
     *                 @OA\Property(property="realName", type="string", example="", description="真实姓名"),
     *                 @OA\Property(property="IDCard", type="string", example="", description="身份证号")
     *             )
     *         )
     *     )
     * )
     */
    public function actionStatus()
    {
        $user = Yii::$app->user->identity;
        $data = [
            'is_real' => $user->is_real ?? 1,
            'has_realname' => !empty($user->realName) && !empty($user->IDCard),
            'realName' => $user->realName ?? '',
            'IDCard' => $user->IDCard ?? '',
        ];
        $this->output($data);
    }
}
