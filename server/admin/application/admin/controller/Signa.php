<?php

namespace app\admin\controller;

use app\admin\model\Account;
use app\admin\model\Bill;
use app\admin\model\SignInRecord;
use app\admin\model\UserRedPacket;
use app\admin\model\UserSignIn;
use app\common\controller\Backend;
use app\common\library\GRedis;
use think\console\command\make\Model;
use think\Db;
use think\exception\DbException;

use think\Log;
use think\response\Json;
use think\Request;

/**
 *
 * @icon fa fa-circle-o
 */
class Signa extends Backend
{

    const redNum = 3;
    /**
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Account;

    }


    /**
     * 查看
     *
     * @return string|Json
     * @throws \think\Exception
     * @throws DbException
     */
    public function index()
    {
        //设置过滤方法
        $this->request->filter(['strip_tags', 'trim']);
        if (false === $this->request->isAjax()) {
            return $this->view->fetch();
        }
        //如果发送的来源是 Selectpage，则转发到 Selectpage
        if ($this->request->request('keyField')) {
            return $this->selectpage();
        }
        $uid = $this->request->request("uid");
        $user = $this->model->where('uid', $uid)->find();
        $registerTime = date("Y-m-d", $user->itime);
        $monthFirst = date("Y-m-01");
        $startDate = $registerTime;
        if ($registerTime < $monthFirst) {
            $startDate = $monthFirst;
        }
        $endDate = date('Y-m-d'); // 当前日期
        // 创建一个日期数组
        $dateList = [];
        $currentDate = $startDate;
        $startDate = date('Y-m-01'); // 当前月的第一天
        $dateArr = (new UserSignIn())
            ->where('uid', $uid) // 假设你已传入uid
            ->where('day', '>=', $startDate) // 签到日期 >= 当前月的第一天
            ->where('day', '<=', $endDate) // 签到日期 <= 当前月的最后一天
            ->column("day");
        while ($currentDate <= $endDate) {
            if (!in_array($currentDate, $dateArr)) {
                $dateList[] = [
                    'uid' => $uid,
                    'day' => $currentDate,
                ];
            }
            // 增加一天
            $currentDate = date('Y-m-d', strtotime($currentDate . ' +1 day'));
        }
        $result = ['total' => 0, 'rows' => $dateList];
        return json($result);
    }

    public function pass(Request $request)
    {
        $uid = $request->param('uid');
        $day = $request->param('day');
        if (empty($uid) || empty($day)) {
            $this->error("参数不足");
        }
        try {
            Db::transaction(function () use ($uid, $day) {
                $signModel = new UserSignIn();
                $signData = [
                    'uid' => $uid,
                    'day' => $day,
                    'itime' => time(),
                    'utime' => time(),
                    'is_admin' => 1,
                ];
                $signModel->data($signData);
                $signModel->save();


                //签到一次
                $money = 2;
                if (in_array($day, ['2025-01-28', '2025-01-29', '2025-01-30'])) {
                    $money = 4;
                }
                $accountModel = new Account();
                $accountModel->where('uid', $uid)
                    ->inc('pay_back', $money)->update();
                $billData = [
                    'uid' => $uid,
                    'money' => $money,
                    'money_type' => 2,
                    'bill_unit' => 'add',
                    'bill_type' => Bill::BillTypeSign,
                    'itime' => time(),
                    'utime' => time(),
                ];
                $billModel = new Bill();
                $billModel->data($billData);
                $billModel->save();

            });

            //计算签到//
            //计算用户连续签到天数
        } catch (\Exception $e) {
            Log::record("sign:" . $e->getMessage(), 'error');
            $this->error("发放签到奖励失败");
        }
        $this->updateSort($uid);
        $this->success();
    }

    public function updateSort($uid)
    {
        $monthFirst = date("Y-m-01");
        $endDay = date("Y-m-d");
        $accountM = new Account();
        $user = $accountM->where("uid", $uid)->find();
        if (empty($user)) {
            return;
        }
        $registerDate = date('Y-m-d', $user->itime);
        $startDate = $registerDate;
        if ($registerDate < $monthFirst) {
            $startDate = $monthFirst;
        }
        $total = $this->calculateDaysBetweenDates($startDate, $endDay);
        //本月已签天数
        $count = $this->getSignNum($uid, $registerDate);
        $n = max(0, $total - $count + 1);
        $accountM->where("uid", $uid)->update([
            'sort' => $n,
        ]);
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
        $signM = new UserSignIn();
        $count = $signM
            ->where('uid', $uid)
            ->where('day', ">=", $registerDate)
            ->count();
        return $count;
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


    public function multipass(Request $request)
    {
        $paramsStr = $request->param('params');
        $params = json_decode($paramsStr, true);
        if (empty($params)) {
            $this->error("参数不足");
        }
        foreach ($params as $item) {
            $uid = $item['uid'];
            $day = $item['day'];
            try {
                Db::transaction(function () use ($uid, $day) {
                    $signModel = new UserSignIn();
                    $signData = [
                        'uid' => $uid,
                        'day' => $day,
                        'itime' => time(),
                        'utime' => time(),
                        'is_admin' => 1,
                    ];
                    $signModel->data($signData);
                    $signModel->save();


                    //签到一次
                    $money = 2;
                    if (in_array($day, ['2025-01-28', '2025-01-29', '2025-01-30'])) {
                        $money = 4;
                    }
                    $accountModel = new Account();
                    $accountModel->where('uid', $uid)
                        ->inc('pay_back', $money)->update();
                    $billData = [
                        'uid' => $uid,
                        'money' => $money,
                        'money_type' => 2,
                        'bill_unit' => 'add',
                        'bill_type' => Bill::BillTypeSign,
                        'itime' => time(),
                        'utime' => time(),
                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();

                });
                //计算用户连续签到天数
            } catch (\Exception $e) {
                Log::record("sign:" . $e->getMessage(), 'error');
            }
            $this->updateSort($uid);
        }
        $this->success();
    }


}