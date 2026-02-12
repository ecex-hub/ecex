<?php

namespace backend\controllers;

use common\components\FuncHelper;
use common\helpers\RedisHelper;
use common\models\AccountInfo;
use common\models\BillRecord;
use common\models\UserRedPacket;
use Yii;
use yii\db\Expression;


class  RedController extends \backend\lib\ApiBaseController
{

    /**
     * @OA\POST(
     *     path="/red/info",
     *     summary="红包详情",
     *     tags={"红包"},
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
    public function actionInfo()
    {
        $uid = Yii::$app->user->identity->uid;
        $m = new UserRedPacket();
        $count = $m->find()->where(['uid' => $uid])
            ->andwhere(['is_receive' => 0])->count();
        $this->output([
            'count' => intval($count)
        ]);
    }


    /**
     * @OA\POST(
     *     path="/red/receive",
     *     summary="红包详情",
     *     tags={"红包"},
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
    public function actionReceive()
    {
        $uid = Yii::$app->user->identity->uid;
        $m = new UserRedPacket();
        $info = $m->find()
            ->where(['uid' => $uid])
            ->andwhere(['is_receive' => 0])
            ->orderby("type desc")
            ->limit(1)->one();
        if (empty($info)) {
            $this->output_error("暂无红包", 212);
        }
        $money = $info->money;
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $bool = $m->updateAll([
                'is_receive' => 1,
                'utime'=>time()
            ], ['id' => $info->id]);
            if (!$bool) {
                throw new \Exception('Failed to update user red packet');
            }
            //用户信息
            $account = new AccountInfo();
            $bool = $account->updateAll([
                'pay_back' => new Expression('pay_back+' . $money),
            ], ['uid' => $uid]);
            if (!$bool) {
                throw new \Exception('Failed to save bill record');
            }
            //账单
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeRedPacket,
                'ext_id' => $info->id,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $transaction->commit();
        } catch (\Exception $e) {
            FuncHelper::ErrLog('red', [
                'uid' => $uid,
                'red_id' => $info->id,
            ], $e->getMessage());
            $transaction->rollBack();
            $this->output_error("领取红包失败", 212);
        }
        $this->output([
            'type' => $info['type'],
            'money' => $info['money']
        ]);
    }
}