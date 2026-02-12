<?php

namespace console\controllers;

use common\models\AccountInfo;
use common\models\Pay;
use common\models\Real;
use common\models\Tongji;
use common\models\UserLogin;
use common\models\UserProduct;
use common\models\UserSignIn;
use common\models\WithdrawalOrder;
use yii\console\Controller;
use Yii;

class TongjiController extends Controller
{
    //统计-昨天
    //00:30 开始
    public function actionLast()
    {
        $yesterday = date('Y-m-d', strtotime('-1 day'));
        $this->actionExec($yesterday);
    }

    //统计-当前天
    //每小时
    public function actionDay()
    {
        $date = date("Y-m-d");
        $this->actionExec($date);
    }

    public function actionTest()
    {
        $startDate = '2025-01-15';
        $endDate = '2025-02-11';
        // 将日期字符串转换为时间戳
        $startTimestamp = strtotime($startDate);
        $endTimestamp = strtotime($endDate);
        // 循环输出从开始日期到结束日期的每一天
        for ($currentTimestamp = $startTimestamp; $currentTimestamp <= $endTimestamp; $currentTimestamp += 86400) {
            $date = date('Y-m-d', $currentTimestamp);
            echo $date . "\n";
            $this->actionExec($date);
        }
    }

    public function actionExec($date)
    {
        $startDate = $date . " 00:00:00";
        $endDate = $date . " 23:59:59";
        $startTime = strtotime($startDate);
        $endTime = strtotime($endDate);
        $tongjiM = new  Tongji();
        $tongji = $tongjiM
            ->find()->where(["day" => $date])->one();

        $where = ['between', 'itime', $startTime, $endTime];
        //注册人数
        $accountM = new AccountInfo();
        $registerNum = $accountM->find()
            ->where($where)
            ->count();
        //认证人数
        $realM = new Real();
        $realNum = $realM->find()
            ->where($where)
            ->andWhere(["type" => 2])
            ->count();
        //认购人数即购买产品成功的人数
        $userProductM = new UserProduct();
        $buyProductNum = $userProductM->find()
            ->select(['uid'])
            ->where($where)
            //->andWhere(["type" => 2])
            ->groupBy("uid")->count();
        //充值金额
        $payM = new Pay();
        $rechargeMoney = $payM->find()
            ->where($where)
            ->andWhere(["type" => 2])
            ->sum("money");
        //认购金额
        $userProductM = new UserProduct();
        $buyProductMoney = $userProductM->find()
            ->where($where)
            //->andWhere(["type" => 2])
            ->sum("total_price");
        //提现金额
        $withdrawalM = new WithdrawalOrder();
        $withdrawalMoney = $withdrawalM->find()
            ->where($where)
            ->andWhere(["type" => 2])
            ->andWhere(['between', 'itime', $startTime, $endTime])
            ->sum("money");
        //充值次数
        $payM = new Pay();
        $rechargeNum = $payM->find()
            ->where($where)
            ->andWhere(["type" => 2])
            ->count();
        //提现次数
        $withdrawalM = new WithdrawalOrder();
        $withdrawalNum = $withdrawalM->find()
            ->where($where)
            ->andWhere(["type" => 2])
            ->andWhere(['between', 'itime', $startTime, $endTime])
            ->count();
        //签到总人数
        $userSignInM = new UserSignIn();
        $signInNum = $userSignInM->find()
            ->select(['uid'])
            ->where(["day" => $date])
            ->andWhere(["is_admin" => 0])
            ->groupBy("uid")->count();
        //登录总人数
        $userLoginM = new UserLogin();
        $loginNum = $userLoginM->find()
            ->select(['uid'])
            ->where($where)
            ->groupBy("uid")->count();
        if (empty($tongji)) {
            $data = [
                'day' => $date,
                'register_num' => $registerNum,
                'real_num' => $realNum,
                'buy_product_num' => $buyProductNum,
                'recharge_money' => $rechargeMoney ?? 0.00,
                'buy_product_money' => $buyProductMoney ?? 0.00,
                'withdraw_money' => $withdrawalMoney ?? 0.00,
                'recharge_num' => $rechargeNum,
                'withdraw_num' => $withdrawalNum,
                'sign_in_num' => $signInNum,
                'login_num' => $loginNum,
            ];
            $tongjiM->insertData($data);
        } else {
            $data = [
                'register_num' => $registerNum,
                'real_num' => $realNum,
                'buy_product_num' => $buyProductNum,
                'recharge_money' => $rechargeMoney ?? 0.00,
                'buy_product_money' => $buyProductMoney ?? 0.00,
                'recharge_num' => $rechargeNum,
                'withdraw_money' => $withdrawalMoney ?? 0.00,
                'withdraw_num' => $withdrawalNum,
                'sign_in_num' => $signInNum,
                'login_num' => $loginNum,
            ];
            $tongjiM->updateAll($data, [
                'day' => $date
            ]);
        }
    }
}