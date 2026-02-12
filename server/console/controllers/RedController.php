<?php

namespace console\controllers;

use common\components\FuncHelper;
use common\models\AccountInfo;
use common\models\UserRedPacket;
use common\models\UserRedPacketTotal;
use common\models\UserSignIn;
use yii\console\Controller;
use Yii;


class RedController extends Controller
{
    public function actionIndex()
    {
        $now=date("2025-02-15");
        $startDate=date("2025-02-01");
        $endDate = $now; // 今天的日期
        $date = $now;
        $query = AccountInfo::find()
            ->select(["uid"]);
        foreach ($query->each(100) as $user) {
            $uid = $user->uid;
            var_dump($uid) . PHP_EOL;
            // 查询 15 天内签到的用户
            $count = UserSignIn::find()
                ->where(['uid' => $uid])
                ->andWhere(['between', 'day', $startDate, $endDate])
                ->count();
            if ($count != 15) {
                continue;
            }
            //发红包
            $redM = new UserRedPacket();
            $info = $redM->find()
                ->where(['uid' => $uid])
                ->andWhere(['day' => $date])
                ->one();
            if ($info) {
                continue;
            }
            $transaction = Yii::$app->db->beginTransaction();
            try {
                $money = $this->generateRedEnvelopeAmount();
                $redM = new UserRedPacket();
                $boor = $redM->insertData([
                    'uid' => $uid,
                    'type' => 1,
                    'day' => $date,
                    'money' => $money,
                    'itime' => time(),
                    'utime' => 0,
                ]);
                if (empty($boor)) {
                    throw new \Exception('Failed to save bill record');
                }
                //用户信息
                $redTotalM = new UserRedPacketTotal();
                $boor = $redTotalM->insertData([
                    'uid' => $uid,
                    'type' => 1,
                    'money' => $money,
                    'num' => 1,
                    'itime' => time(),
                    'utime' => time(),
                ]);
                if (!$boor) {
                    throw new \Exception('Failed to save red total');
                }
                $transaction->commit();
            } catch (\Exception $e) {
                FuncHelper::ErrLog('sys_red', [
                    'uid' => $uid,
                ], $e->getMessage());
                $transaction->rollBack();
                var_dump($e->getMessage());
            }
        }
    }

    function generateRedEnvelopeAmount($minAmount = 10.00, $maxAmount = 20.00)
    {
        // 初始化红包金额数组
        $amounts = [];

        // 生成所有可能的金额，保留两位小数
        for ($i = $minAmount * 100; $i <= $maxAmount * 100; $i++) {
            $amounts[] = $i / 100;
        }

        // 随机选择一个红包金额
        $totalAmounts = count($amounts);
        $randomIndex = rand(0, $totalAmounts - 1);
        $selectedAmount = $amounts[$randomIndex];

        // 返回随机选中的红包金额，保留两位小数
        return number_format($selectedAmount, 2);
    }
}