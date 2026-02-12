<?php

namespace console\controllers;

use common\components\FuncHelper;
use common\models\AccountInfo;
use common\models\BillRecord;
use common\models\Province;
use common\models\UserFirstBuy;
use yii\console\Controller;
use Yii;
use yii\db\Expression;

class FundController extends Controller
{
    //圆梦基金
    //每分钟运行一次。
    public function actionMonth()
    {
        $now = time();
        $where = [
            'and',
            ["<", 'next_reward_time', $now]
        ];
        $query = UserFirstBuy::find()
            ->where($where);
        foreach ($query->each(10) as $userFirstBuy) {
            $this->addMoneyByDreamFund($userFirstBuy);
        }
    }

    public function addMoneyByDreamFund($userFirstBuy)
    {
        $accountM = new AccountInfo();
        $user = $accountM->find()->where(["uid" => $userFirstBuy->uid])->one();
        if (empty($user)) {
            return true;
        }
        $total = floor(($userFirstBuy->next_reward_time - $userFirstBuy->itime) / (86400 * 30));
        if ($total <= $userFirstBuy->reward_count) {
            return true;
        }
        $uid = $user->uid;
        $originMoney = $user->dream_fund;
        if ($userFirstBuy->reward_count == 0) {
            $originMoney = $userFirstBuy->money;
        }
        $money = $originMoney * (0.008);
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeThree,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeFundMonth,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $userFirstBuyM = new UserFirstBuy();
            $boor = $userFirstBuyM->updateAll([
                'next_reward_time' => new Expression('next_reward_time+' . (86400 * 30)),
                'reward_count' => new Expression('reward_count+' . 1)
            ], ["uid" => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user first buy');
            }
            if ($money) {
                $accountInfo = new AccountInfo();
                $boor = $accountInfo->updateAll([
                    'allowance' => new Expression('allowance+' . $money)
                ], ['uid' => $uid]);
                if (empty($boor)) {
                    throw new \Exception('Failed to update user fail');
                }
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('dream_fund_month', [
                'uid' => $uid,
                'money' => $money,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        return false;
    }

    //每天
    public function actionProvince()
    {

        $m = new Province();
        $list = $m->find()->where(['<>', 'id', 35])->all();
        foreach ($list as $item) {
            $randomNumber = mt_rand(1, 85) / 100;
            $m->updateAll([
                'value' => new Expression('value+' . $randomNumber)
            ], ['id' => $item->id]);
        }
    }
}