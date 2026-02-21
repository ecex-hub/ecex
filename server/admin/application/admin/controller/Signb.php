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
class Signb extends Backend
{

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
        $endDate = date('Y-m-d'); // 当前日期
        // 创建一个日期数组
        $registerTime = date("Y-m-d", $user->itime);
        $monthFirst = date("Y-m-01");
        $startDate = $registerTime;
        if ($registerTime < $monthFirst) {
            $startDate = $monthFirst;
        }
        $dateArr = (new UserSignIn())
            ->field(["uid", 'day'])
            ->where('uid', $uid) // 假设你已传入uid
            ->where('day', '>=', $startDate) // 签到日期 >= 当前月的第一天
            ->where('day', '<=', $endDate) // 签到日期 <= 当前月的最后一天
            ->select();
        $result = ['total' => 0, 'rows' => $dateArr];
        return json($result);
    }
}