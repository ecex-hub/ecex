<?php

namespace console\controllers;

use common\models\AccountInfo;
use common\models\Province;
use common\models\UserSignIn;
use yii\console\Controller;
use Yii;
use yii\db\Expression;

class SignController extends Controller
{
    //签到是否完成
    public function actionIndex()
    {
        $query = AccountInfo::find()
            ->select(["uid", "itime"]);
        $monthFirst = date("Y-m-01");
        $endDay = date("Y-m-d");
        foreach ($query->each(100) as $user) {
            $registerDate = date('Y-m-d', $user->itime);
            $startDate = $registerDate;
            if ($registerDate < $monthFirst) {
                $startDate = $monthFirst;
            }
            //总天数
            $total = $this->calculateDaysBetweenDates($startDate, $endDay);
            //本月已签天数
            $count = $this->getSignNum($user->uid, $registerDate);
            $n = max(0, $total - $count + 1);
            (new AccountInfo())->updateAll([
                'sort' => $n
            ], ['uid' => $user->uid]);
        }
    }

    function calculateDaysBetweenDates($startDate, $endDate)
    {
        // 将日期字符串转换为时间戳
        $startTimestamp = strtotime($startDate);
        $endTimestamp = strtotime($endDate);

        // 计算时间戳差值并转换为天数
        $diffInSeconds = $endTimestamp - $startTimestamp;
        $days = $diffInSeconds / (60 * 60 * 24); // 将秒数转换为天数

        return $days;
    }

    public function getSignNum($uid, $registerDate)
    {
        $firstDateOfMonth = date('Y-m-01');
        if ($registerDate < $firstDateOfMonth) {
            $registerDate = $firstDateOfMonth;
        }
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['>=', 'day', $registerDate],
        ];
        $signM = new UserSignIn();
        $count = $signM->find()
            ->where($where)
            ->count();
        return $count;
    }

}