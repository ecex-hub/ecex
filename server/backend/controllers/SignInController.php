<?php

namespace backend\controllers;

use common\helpers\RedisHelper;
use common\models\UserSignIn;
use common\models\SystemConfigure;
use Yii;
use common\models\SignInRecord;

//签到
class SignInController extends \backend\lib\ApiBaseController
{

    public $layout = false;

    /**
     * @OA\POST(
     *     path="/sign-in/receive",
     *     summary="签到",
     *     tags={"签到"},
     *     @OA\Response(
     *         response=200,
     *         description="成功返回签到数据列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionReceive()
    {
        $user = Yii::$app->user->identity;
        $model = new UserSignIn();
        $apiSecret = $model->addSignInRecord($user);
        if (!empty($apiSecret)) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\POST(
     *     path="/sign-in/upload",
     *     summary="会议签到",
     *     tags={"签到"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="User registration details",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="img",
     *                     description="图片地址",
     *                     type="string",
     *                     example="1234567890"
     *                 ),
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回签到数据列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionUpload()
    {
        $params = $this->params(['img']);
        $this->VerificationParameter($params, ['img']);
        $model = new SignInRecord();
        $uid = Yii::$app->user->identity->uid;
        $bl = $model->addSignInFundRecord($uid, $params['img']);
        if ($bl) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\POST(
     *     path="/sign-in/list",
     *     summary="签到列表",
     *     tags={"签到"},
     *     @OA\Response(
     *         response=200,
     *         description="成功返回签到数据列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="data",
     *                     type="array",
     *                     @OA\Items(
     *                         type="object",
     *                         @OA\Property(property="type", type="integer", example=1, description="1-未领取 2-已领取"),
     *                         @OA\Property(property="time", type="string", format="date", example="2024-12-01")
     *                     )
     *                 ),
     *                 @OA\Property(property="continuous_day", type="integer", example=0, description="连续日期")
     *             )
     *         )
     *     )
     * )
     */
    public function actionList()
    {
        $params = $this->params(['time']);
        $time = time();
        if (!empty($params['time'])) {
            $time = $params['time'];
        }
        $user = Yii::$app->user->identity;
        $uid = $user->uid;
        $model = new UserSignIn();
        $checkedArr = $model->signList($uid);
        $t = date('t', $time);
        $data = [];
        for ($i = 0; $i < $t; $i++) {
            $a = $i + 1;
            if ($a <= 9) {
                $name = "0" . $a;
            } else {
                $name = $a;
            }
            $tmpDate = date('Y-m', $time) . '-' . $name;
            $tmp = [
                'time' => $tmpDate,
                'is_checked' => false,
            ];
            if (in_array($tmpDate, $checkedArr)) {
                $tmp['is_checked'] = true;
            }
            $data[] = $tmp;
        }
        $continuous_day = $model->getConsecutiveSignInDays($uid, date("Y-m-d", $user->itime));
        $count = $model->getCount($uid);
        $returnData = [
            'data' => $data,
            'continuous_day' => $continuous_day,
            'count' => $count,
        ];
        $this->output($returnData);
    }

    /**
     * @OA\POST(
     *     path="/sign-in/detail",
     *     summary="签到详情",
     *     tags={"签到"},
     *     @OA\Response(
     *         response=200,
     *         description="成功返回签到详情",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(property="sign_in_days", type="integer", example=19, description="累计签到天数"),
     *                 @OA\Property(property="is_signed_today", type="boolean", example=true, description="今日是否已签到"),
     *                 @OA\Property(
     *                     property="signed_dates",
     *                     type="array",
     *                     @OA\Items(type="string", format="date", example="2026-02-01")
     *                 ),
     *                 @OA\Property(
     *                     property="rules",
     *                     type="array",
     *                     @OA\Items(
     *                         type="string",
     *                         example="1. 每日签到积分50+基金补贴10000基金补贴连续签到增加额基金补贴;"
     *                     ),
     *                     description="签到说明"
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionDetail()
    {
        $user = Yii::$app->user->identity;
        $uid = $user->uid;
        $userSignIn = new UserSignIn();

        // 累计签到天数
        $signInDays = $userSignIn->getCount($uid);

        // 本月已签到日期（用于前端日历高亮）
        $signedDates = $userSignIn->signList($uid);

        // 今日是否已签到
        $today = date("Y-m-d");
        $isSignedToday = in_array($today, $signedDates, true);

        // 签到说明，从系统配置中读取，可在后台维护
        $rules = [];
        $rule1 = SystemConfigure::getSystemConfigure('sign_in_rule_1');
        $rule2 = SystemConfigure::getSystemConfigure('sign_in_rule_2');
        if (!empty($rule1)) {
            $rules[] = $rule1;
        }
        if (!empty($rule2)) {
            $rules[] = $rule2;
        }
        // 如果后台暂未配置，给一份默认文案，避免前端为空
        if (empty($rules)) {
            $rules = [
                '1. 每日签到积分50+基金补贴10000基金补贴，连续签到增加额外基金补贴；',
                '2. 每周7个自然日送基金补贴礼包，遇法定节假日可增加基金补贴礼包，且自然日需往后顺延到法定节假日相隔7天。'
            ];
        }

        $data = [
            'sign_in_days' => (int)$signInDays,
            'is_signed_today' => (bool)$isSignedToday,
            'signed_dates' => array_values($signedDates),
            'rules' => $rules,
        ];

        $this->output($data);
    }


    /**
     * @OA\POST(
     *     path="/sign-in/meeting-list",
     *     summary="会议签到列表",
     *     tags={"签到"},
     *     @OA\Response(
     *         response=200,
     *         description="成功返回签到数据列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="data",
     *                     type="array",
     *                     @OA\Items(
     *                         type="object",
     *                         @OA\Property(property="type", type="integer", example=1, description="1-未领取 2-已领取"),
     *                         @OA\Property(property="time", type="string", format="date", example="2024-12-01")
     *                     )
     *                 ),
     *                 @OA\Property(property="continuous_day", type="integer", example=0, description="连续日期")
     *             )
     *         )
     *     )
     * )
     */
    public function actionMeetingList()
    {
        $params = $this->params(['page', 'size']);
        if (empty($params['page'])) {
            $params['page'] = 1;
        }
        if (empty($params['size'])) {
            $params['size'] = 10;
        }
        $uid = Yii::$app->user->identity->uid;
        $model = new SignInRecord();
        $list = $model->getSignInRecordFundList($uid, $params['page'], $params['size']);
        $data = [
            'list' => $list,
            'count' => $model->getSignInRecordFundCount($uid),
            'has_sign' => $model->hasSign($uid),
        ];
        $this->output($data);
    }

    /**
     * @OA\POST(
     *     path="/sign-in/notice",
     *     summary="会议签到通知",
     *     tags={"签到"},
     *     @OA\Response(
     *         response=200,
     *         description="成功返回签到数据列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(property="money", type="string", example=1, description="金额"),
     *             )
     *         )
     *     )
     * )
     */
    public function actionNotice()
    {
        $uid = Yii::$app->user->identity->uid;
        $money = RedisHelper::getSignToken($uid);
        $data = [
            'money' => (int)$money,
        ];
        $this->output($data);
    }

    /**
     * @OA\POST(
     *     path="/sign-in/notice-clean",
     *     summary="会议签到通知取消",
     *     tags={"签到"},
     *     @OA\Response(
     *         response=200,
     *         description="成功返回签到数据列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object"
     *             )
     *         )
     *     )
     * )
     */
    public function actionNoticeClean()
    {
        $uid = Yii::$app->user->identity->uid;
        RedisHelper::cleanSignToken($uid);
        $this->output();
    }

    public function actionTest()
    {

    }

}
