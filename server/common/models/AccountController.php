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

use common\components\FuncHelper;
use common\models\Invite;
use Yii;
use common\models\AccountInfo;
use common\models\BindBankCard;


class AccountController extends \backend\lib\ApiBaseController
{

    public $layout = false;

    /**
     * @OA\Post(
     *     path="/account/modify",
     *     summary="更改用户信息",
     *     description="This API allows users to change their password.",
     *     tags={"用户"},
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
     *                     description="The old password of the user"
     *                 ),
     *                 @OA\Property(
     *                     property="newPassword",
     *                     type="string",
     *                     description="The new password for the user"
     *                 ),
     *                 @OA\Property(
     *                     property="qq",
     *                     type="string",
     *                     description="qq"
     *                 ),
     *                 @OA\Property(
     *                     property="wechat",
     *                     type="string",
     *                     description="微信"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully changed the password",
     *         @OA\JsonContent(
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 description="Response code"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 description="Response message"
     *             ),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionModify()
    {
        $params = $this->params(['oldPassword', 'newPassword', 'qq', 'wechat']);
        $model = new AccountInfo();
        $boor = $model->modifyAccountPassword(Yii::$app->user->identity,
            $params['oldPassword'], $params['newPassword'], $params['qq'], $params['wechat']);
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\Post(
     *     path="/account/modify-pay",
     *     summary="更改用户支付密码",
     *     description="This API allows users to change their password.",
     *     tags={"用户"},
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
     *                     description="不是必填项"
     *                 ),
     *                 @OA\Property(
     *                     property="newPassword",
     *                     type="string",
     *                     description="The new password for the user"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully changed the password",
     *         @OA\JsonContent(
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 description="Response code"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 description="Response message"
     *             ),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionModifyPay()
    {
        $params = $this->params(['oldPassword', 'newPassword']);
        $this->VerificationParameter($params, ['newPassword']);
        $model = new AccountInfo();
        $boor = $model->modifyAccountPayPassword(Yii::$app->user->identity, $params['oldPassword'], $params['newPassword']);
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }


    /**
     * @OA\Post(
     *     path="/account/update-id-card",
     *     summary="添加身份证",
     *     tags={"用户"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="realName",
     *                     description="真实姓名",
     *                     type="string",
     *                     example="张三"
     *                 ),
     *                 @OA\Property(
     *                     property="IDCard",
     *                     description="身份证号",
     *                     type="string",
     *                     example="123456789012345678"
     *                 ),
     *                 @OA\Property(
     *                     property="IDFrontUrl",
     *                     description="身份证正面图片URL",
     *                     type="string",
     *                     format="url",
     *                     example="http://example.com/idcard/front.jpg"
     *                 ),
     *                 @OA\Property(
     *                     property="IDOppositeUrl",
     *                     description="身份证反面图片URL",
     *                     type="string",
     *                     format="url",
     *                     example="http://example.com/idcard/back.jpg"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 description="签到数据列表或其它返回数据",
     *                 nullable=true,
     *                 example={}
     *             )
     *         )
     *     )
     * )
     */
    public function actionUpdateIdCard()
    {
        $params = $this->params(['realName', 'IDCard', 'IDFrontUrl', 'IDOppositeUrl']);
        $this->VerificationParameter($params, ['realName', 'IDCard']);

        $user = Yii::$app->user->identity;
        $model = new AccountInfo();
        $boor = $model->updateAccountIDCard($user, $params['realName'], $params['IDCard'], $params['IDFrontUrl'], $params['IDOppositeUrl']);
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }


    /**
     * @OA\POST(
     *   path="/account/bank-list",
     *   summary="银行列表",
     *   tags={"用户"},
     *   @OA\Response(
     *     response=200,
     *     description="成功返回银行列表",
     *     @OA\JsonContent(
     *       type="object",
     *       @OA\Property(property="code", type="integer", example=200),
     *       @OA\Property(property="message", type="string", example="success"),
     *       @OA\Property(
     *         property="data",
     *         type="object",
     *         @OA\Property(
     *           property="data",
     *           type="array",
     *           @OA\Items(
     *             type="object",
     *             @OA\Property(property="type", type="integer", description="银行类型标识"),
     *             @OA\Property(property="name", type="string", description="银行名称")
     *           )
     *         )
     *       )
     *     )
     *   )
     * )
     */
    public function actionBankList()
    {
        $model = new BindBankCard();
        $data = $model->bankNameList;
        if ($data) {
            $returnData = [];
            foreach ($data as $key => $value) {
                $returnData[] = [
                    'type' => $key,
                    'name' => $value
                ];
            }
            $this->output($returnData);
        } else {
            $this->output_error('暂无数据', 401);
        }
    }

    /**
     * @OA\Post(
     *     path="/account/bank-card-bind",
     *     summary="添加银行卡",
     *     tags={"用户"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="bankNameId",
     *                     description="银行ID",
     *                     type="integer",
     *                     example="123456789012345678"
     *                 ),
     *                 @OA\Property(
     *                     property="bankCard",
     *                     description="银行卡号",
     *                     type="string",
     *                     example="644444"
     *                 ),
     *                 @OA\Property(
     *                     property="realName",
     *                     description="真实姓名",
     *                     type="string",
     *                     example="张三"
     *                 ),
     *                 @OA\Property(
     *                     property="alipay_card",
     *                     description="支付宝账号",
     *                     type="string",
     *                     example="12232323"
     *                 ),
     *                 @OA\Property(
     *                     property="pay_type",
     *                     description="1-银行卡 2-支付宝",
     *                     type="integer",
     *                     example=1
     *                 ),
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 description="签到数据列表或其它返回数据",
     *                 nullable=true,
     *                 example={}
     *             )
     *         )
     *     )
     * )
     */
    public function actionBankCardBind()
    {
        $params = $this->params(['bankNameId', 'bankCard', 'realName',
            'alipay_card', 'pay_type',
        ]);
        if ($params['pay_type'] == 1) {
            $this->VerificationParameter($params, ['bankNameId', 'bankCard', 'realName']);

        } else {
            $this->VerificationParameter($params, ['realName', 'alipay_card']);
        }
        $user = Yii::$app->user->identity;
        $model = new BindBankCard();
        $boor = $model->addBindBankCard($user, $params);
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\POST(
     *     path="/account/bank-card-list",
     *     summary="获取用户绑定的银行卡列表",
     *     description="Retrieve a paginated list of bank cards bound to the user.",
     *     operationId="getBankCardBindings",
     *     tags={"用户"},
     *     security={{"bearerAuth": {}}},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         required=false,
     *         description="The page number to retrieve (starting from 1).",
     *         @OA\Schema(type="integer", default=1, minimum=1),
     *         example=1
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         required=false,
     *         description="The number of items per page.",
     *         @OA\Schema(type="integer", default=10, minimum=1, maximum=100),
     *         example=10
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successful response with a list of bank card bindings",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="HTTP status code"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="Response message"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="integer", example=1),
     *                     @OA\Property(property="uid", type="integer", example=5),
     *                     @OA\Property(property="bankName", type="string", example="中国农业银行"),
     *                     @OA\Property(property="bankCard", type="string", example="weww ****  **** "),
     *                     @OA\Property(property="subBranchName", type="string", example="sdsd"),
     *                     @OA\Property(property="real_name", type="string", example="姓名"),
     *                     @OA\Property(property="alipay_card", type="string", example="支付宝账号"),
     *                     @OA\Property(property="pay_type", type="integer", example="1"),
     *                     @OA\Property(property="itime", type="integer", example=1735035101),
     *                     @OA\Property(property="utime", type="integer", example=1735035101)
     *                 )
     *             )
     *         )
     *     ),
     * )
     */
    public function actionBankCardList()
    {
        $page = 1;
        $row = 30;
        $model = new BindBankCard();
        $uid = Yii::$app->user->identity->uid;
        $fields = ['id', 'realName', 'bankName', 'bankCard', 'realName', 'alipay_card', 'pay_type'];
        $list = $model->getClientBindBankCardList($page, $row, $uid, $fields);
        foreach ($list as &$value) {
            $value['bankCard'] = substr($value['bankCard'], 0, 4) . ' **** ' . ' **** ' . substr($value['bankCard'], 11);
        }
        $this->output($list);
    }

    /**
     * @OA\POST(
     *     path="/account/bank-card-del",
     *     summary="删除用户的银行卡",
     *     description="Unbind a user's bank card by its unique identifier.",
     *     operationId="deleteBankCardBinding",
     *     tags={"用户"},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         description="The unique identifier of the bank card binding to delete.",
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 description="签到数据列表或其它返回数据",
     *                 nullable=true,
     *                 example={}
     *             )
     *         )
     *     )
     * )
     */
    public function actionBankCardDel()
    {
        $params = $this->params(['id']);
        $this->VerificationParameter($params, ['id']);

        $uid = Yii::$app->user->identity->uid;
        $model = new BindBankCard();
        $boor = $model->closeBindBankCardData($params['id'], $uid);
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\POST(
     *     path="/account/index",
     *     tags={"用户"},
     *     summary="获取用户信息",
     *     operationId="getUserInfo",
     *     description="根据用户ID获取用户的详细信息。",
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="响应状态码"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="响应消息"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="data",
     *                     type="object",
     *                     @OA\Property(property="uid", type="integer", example=5, description="用户ID"),
     *                     @OA\Property(property="e_uid", type="string", example="", description="扩展用户ID"),
     *                     @OA\Property(property="avatar", type="string", example="", description="用户头像URL"),
     *                     @OA\Property(property="nickname", type="string", example="千千阙歌", description="用户昵称"),
     *                     @OA\Property(property="is_real", type="int", example=1, description="真人认证 1-未认证 2-已认证"),
     *                     @OA\Property(property="account", type="string", example="18081077689", description="用户账号"),
     *                     @OA\Property(property="money", type="number", format="float", example=0, description="账户余额"),
     *                     @OA\Property(property="pay_back", type="integer", example=0, description="返现金额"),
     *                     @OA\Property(property="allowance", type="integer", example=0, description="津贴或补贴"),
     *                     @OA\Property(property="dream_fund", type="integer", example=20000, description="梦想基金"),
     *                     @OA\Property(property="has_pay_pwd", type="boolean", example=false, description="true 存在支付密码"),
     *                     @OA\Property(property="qq", type="string", example=20000, description="qq"),
     *                     @OA\Property(property="wechat", type="string", example=false, description="微信")
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionIndex()
    {

        $data = Yii::$app->user->identity;
        $inviteM = new Invite();
        $invite = $inviteM->find()
            ->where(['uid' => $data['uid']])
            ->asArray()->one();
        $returnData = [
            'uid' => $data['uid'],
            'e_uid' => $data['e_uid'],
            'avatar' => FuncHelper::getCdnUrl($data['avatar']),
            'nickname' => $data['nickname'],
            'account' => $data['account'],
            'is_real' => $data['is_real'],
            'money' => $this->changeDecimalReserve($data['money']),
            'pay_back' => $this->changeDecimalReserve($data['pay_back']),
            'allowance' => $this->changeDecimalReserve($data['allowance']),
            'dream_fund' => $this->changeDecimalReserve($data['dream_fund']),
            'has_pay_pwd' => is_bool($data['payPassword']),
            'qq' => $data['qq'],
            'wechat' => $data['wechat'],
            'realName' => $data['realName'],
            'IDCard' => $data['IDCard'],
            'IDFrontUrl' => $data['IDFrontUrl'],
            'IDOppositeUrl' => $data['IDOppositeUrl'],
        ];
        if ($invite) {
            $returnData['invite_code'] = $invite['invite_code'];
        }
        $this->output($returnData);
    }


    /**
     * @OA\Post(
     *     path="/account/update",
     *     summary="用户信息更新",
     *     tags={"用户"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="payPassword",
     *                     description="支付密码",
     *                     type="string",
     *                     example="123456"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 description="签到数据列表或其它返回数据",
     *                 nullable=true,
     *                 example={}
     *             )
     *         )
     *     )
     * )
     */
    public function actionUpdate()
    {
        $params = $this->params(['payPassword','avatar']);
        $data = [];
        if ($params['payPassword']) {
            $data['payPassword'] = $params['payPassword'];
        }
        if ($params['avatar']) {
            $data['avatar'] = $params['avatar'];
        }
        $user = Yii::$app->user->identity;
        $model = new AccountInfo();
        $boor = $model->updateAll(
            [
                'payPassword' => md5($params['payPassword']),
                'utime' => time(),
            ],
            ['uid' => $user['uid']]);
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }


}
