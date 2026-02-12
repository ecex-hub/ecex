<?php

namespace console\controllers;

use common\components\FuncHelper;
use common\models\AccountInfo;
use common\models\BillRecord;
use common\models\InviteRebate;
use common\models\UserProduct;
use yii\console\Controller;
use Yii;
use yii\db\Expression;

class AwardController extends Controller
{
    //统计-昨天达标用户数量
    //00:01 开始
    public function actionLast()
    {
        $yesterday = date('Y-m-d', strtotime('-1 day'));
        $where = [
            'and',
            ['=', 'register_date', $yesterday],
            ['>', 'oneLevel', 0],
        ];
        $list = (new UserProduct())->find()
            ->select(['oneLevel', 'COUNT(DISTINCT uid) as total'])
            ->where($where)
            ->groupBy("oneLevel")
            ->asArray()
            ->all();
        foreach ($list as $item) {
            $this->exec($item, $yesterday);
        }
    }

    public function exec($item, $yesterday)
    {
        $inviteUid = $item['oneLevel'];
        $count = $item['total'];
        $money = 0;
//        if ($count == 5) {
//            $money = 88;
//        } else if ($count == 10) {
//            $money = 288;
//        } else if ($count == 25) {
//            $money = 888;
//        } else if ($count == 50) {
//            $money = 2088;
//        } else if ($count == 100) {
//            $money = 6888;
//        }
        if ($count >= 5 && $count < 10) {
            $money = 88;
        }
        if ($count >= 10 && $count < 25) {
            $money = 288;
        }
        if ($count >= 25 && $count < 50) {
            $money = 888;
        }
        if ($count >= 50 && $count < 100) {
            $money = 2088;
        }
        if ($count >= 100) {
            $money = 6888;
        }
        if (empty($money)) {
            return true;
        }
        $inviteM = new InviteRebate();
        $info = $inviteM->getBuyCount($inviteUid, $count);
        if ($info) {
            return true;
        }
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $inviteData = [
                'uid' => $inviteUid,
                'money' => $money,
                'num' => $count,
                'day' => $yesterday,
                'bill_unit' => 'add',
                'itime' => time(),
                'utime' => time(),
            ];
            $inviteM = new InviteRebate();
            if (!$inviteM->insertData($inviteData)) {
                throw new \Exception('Failed to save invite record');
            }
            //账单
            $billData = [
                'uid' => $inviteUid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeInviteCountPayBack,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            //用户
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'pay_back' => new Expression('pay_back+' . $money)
            ], ['uid' => $inviteUid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('invite_count_pay_back', [
                'uid' => $inviteUid,
                'money' => $money,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        return false;
    }

}