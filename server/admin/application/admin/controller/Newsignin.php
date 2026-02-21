<?php

namespace app\admin\controller;

use app\admin\model\UserSignIn;
use app\common\controller\Backend;
use think\exception\DbException;
use think\response\Json;

/**
 *
 * @icon fa fa-circle-o
 */
class Newsignin extends Backend
{

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
        [$where, $sort, $order, $offset, $limit] = $this->buildparams();

        $list = $this->model
            ->where($where)
            ->order("sort", "desc")
            ->paginate($limit);
        $monthFirst = date("Y-m-01");
        $endDay = date("Y-m-d");
        foreach ($list->items() as $v) {
            $registerDate = date('Y-m-d', $v->itime);
            $startDate = $registerDate;
            if ($registerDate < $monthFirst) {
                $startDate = $monthFirst;
            }
            //可签到天数
            $total = $this->calculateDaysBetweenDates($startDate, $endDay);
            //本月已签天数
            $count = $this->getSignNum($v->uid, $registerDate);
            $v->diff_day = max(0, $total - $count + 1);
            $v->sign_in_num = $this->getConsecutiveSignInDays($v->uid, $registerDate);
            $v->normal_red_count = (new \app\admin\model\UserRedPacket())
                ->where("uid", $v->uid)
                ->where("type", 1)->where("is_receive", 0)->count();
            $v->red_count = (new \app\admin\model\UserRedPacket())
                ->where("uid", $v->uid)
                ->where("type", 2)->where("is_receive", 0)->count();

        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
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


    function getConsecutiveSignInDays($uid, $registerDate)
    {
        $firstDateOfMonth = date('Y-m-01');
        if ($registerDate < $firstDateOfMonth) {
            $registerDate = $firstDateOfMonth;
        }
        $signM = new UserSignIn();
        $days = $signM
            ->where('uid', $uid)
            ->where('day', ">=", $registerDate)
            ->order("day desc")
            ->limit(31)->column("day");
        $continuousDay = 0;
        $nowDate = Date("Y-m-d");
        $yesterday = date('Y-m-d', strtotime('-1 day'));
        $lastDay = null;
        foreach ($days as $index => $date) {
            if ($index == 0) {
                if ($date == $nowDate || $date == $yesterday) {
                    $continuousDay++;
                    $lastDay = date('Y-m-d', strtotime('-1 day', strtotime($date)));
                    continue;
                }
                break;
            }
            //下一次循环
            if ($lastDay != $date) {
                break;
            }
            $continuousDay++;
            $lastDay = date('Y-m-d', strtotime('-1 day', strtotime($date)));
        }
        return $continuousDay;
    }


}