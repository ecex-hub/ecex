<?php

namespace app\admin\controller;

use app\admin\model\Account;
use app\admin\model\Real as RealModel;
use app\common\controller\Backend;
use app\common\Constants;
use think\Db;

/**
 * 用户账单管理
 *
 * @icon fa fa-circle-o
 */
class Bill extends Backend
{

    /**
     * Record模型对象
     */
    protected $model = null;

    protected $relationSearch = true;


    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Bill;

    }


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
            // 关联账单所属用户及其上级账号信息和管理员
            ->with(['user.upuser', 'admin'])
            ->order($sort, $order)
            ->paginate($limit);
        //奖励类型: 1充值余额, 2 回报钱包, 3补助钱包, 4圆梦基金
        $moneyTypeArr = [
            1 => '充值余额',
            2 => '回报钱包',
            3 => '补助钱包',
            4 => '国众基金'
        ];
        $billUnitArr = [
            "sub" => '扣减',
            "add" => '添加',
        ];
        $billTypeArr = [
            1 => "充值",
            2 => "购买产品",
            3 => '回报钱包转出',
            4 => "转入充值钱包",
            5 => '产品每日收益',
            6 => "提现",
            7 => "用户打卡",
            8 => "下级用户购买产品返利",
            9 => "每日购买成员数",
            10 => '邀请好友成功',
            11 => '绑定社交账号',
            12 => '产品到期补助',
            13 => "内需补助金",
            14 => '完成实名认证',
            15 => '邀请用户完成实名认证',
            16 => '每月分红',
            17 => '提现驳回',
            18 => '系统操作',
            19 => '领取红包',
            20 => "每月补助",
        ];
        foreach ($list->items() as $k => &$v) {
            $v['bill_type'] = $billTypeArr[$v['bill_type']] ?? "";
            $v['bill_unit'] = $billUnitArr[$v['bill_unit']] ?? "";
            $v['money_type'] = $moneyTypeArr[$v['money_type']] ?? "";
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }

public function recharge()
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
            ->where('bill_type', 18)             // 固定条件：充值类型
            ->where('money_type', 1)              // 固定条件：货币类型
            // 关联充值记录的用户及其上级账号信息和管理员
            ->with(['user.upuser', 'admin'])
            ->order($sort, $order)
            ->paginate($limit);
        //奖励类型: 1充值余额, 2 回报钱包, 3补助钱包, 4圆梦基金
        $moneyTypeArr = [
            1 => '充值余额',
            2 => '回报钱包',
            3 => '补助钱包',
            4 => '国众基金'
        ];
        $billUnitArr = [
            "sub" => '扣减',
            "add" => '添加',
        ];
        $billTypeArr = [
            1 => "充值",
            2 => "购买产品",
            3 => '回报钱包转出',
            4 => "转入充值钱包",
            5 => '产品每日收益',
            6 => "提现",
            7 => "用户打卡",
            8 => "下级用户购买产品返利",
            9 => "每日购买成员数",
            10 => '邀请好友成功',
            11 => '绑定社交账号',
            12 => '产品到期补助',
            13 => "内需补助金",
            14 => '完成实名认证',
            15 => '邀请用户完成实名认证',
            16 => '每月分红',
            17 => '提现驳回',
            18 => '系统操作',
            19 => '领取红包',
            20 => "每月补助",
        ];
        foreach ($list->items() as $k => &$v) {
            $v['bill_type'] = $billTypeArr[$v['bill_type']] ?? "";
            $v['bill_unit'] = $billUnitArr[$v['bill_unit']] ?? "";
            $v['money_type'] = $moneyTypeArr[$v['money_type']] ?? "";                    
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }
    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */


}
