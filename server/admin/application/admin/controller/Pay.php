<?php

namespace app\admin\controller;

use app\common\controller\Backend;
use think\Loader;
use think\Db;
use think\Log;

/**
 * 支付管理
 *
 * @icon fa fa-circle-o
 */
class Pay extends Backend
{
    protected $model = null;
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Pay;
    }

    public function index()
    {
        $this->request->filter(['strip_tags', 'trim']);
        if (false === $this->request->isAjax()) {
            return $this->view->fetch();
        }
        
        if ($this->request->request('keyField')) {
            return $this->selectpage();
        }
        
        [$where, $sort, $order, $offset, $limit] = $this->buildparams();
        $list = $this->model
            ->where($where)
            ->with(['user', 'sys'])
            ->order($sort, $order)
            ->paginate($limit);
            
        $payTypeArr = [
            1 => '支付宝',
            2 => '微信',
            3 => '银行卡',
            4 => '云闪付',
        ];
        
        $typeArr = [
            1 => '待支付',
            2 => '成功',
            3 => '失败',
        ];
        
        $payMchArr = [
            1 => '福海支付',
            2 => '桥头支付',
            3 => 'alin支付',
            4 => '四海',
            5 => '四海云四方',
            6 => '大圣支付',
            7 => 'PT中外支付'
        ];
        
        foreach ($list->items() as $k => &$v) {
            $v['pay_type'] = $payTypeArr[$v['pay_type']] ?? "";
            $v['_type'] = $v['type'];
            $v['type'] = $typeArr[$v['type']] ?? "";
            $v['pay_chnl'] = $payMchArr[$v['sys']['pay_mch']] ?? "";
        }
        
        // 获取今日开始时间戳
        $todayStart = strtotime(date('Y-m-d'));
        $todayEnd = $todayStart + 86400;
        
        // 总金额统计
        $totalWhere = ['type' => 2]; // 成功的支付
        $totalMoney = $this->model->where($totalWhere)->sum('money');
        
        // 今日金额统计
        $todayMoney = $this->model
            ->where($totalWhere)
            ->where('itime', '>=', $todayStart)
            ->where('itime', '<', $todayEnd)
            ->sum('money');
        
        // 总充值人数统计
        $totalUsers = $this->model
            ->where($totalWhere)
            ->distinct(true)
            ->field('uid')
            ->count();
        
        // 今日充值人数统计
        $todayUsers = $this->model
            ->where($totalWhere)
            ->where('itime', '>=', $todayStart)
            ->where('itime', '<', $todayEnd)
            ->distinct(true)
            ->field('uid')
            ->count();
        
        // 完成金额统计（与总金额相同，因为都是成功的支付）
        $completedMoney = $totalMoney;
        $todayCompletedMoney = $todayMoney;
        
        $result = [
            'total' => $list->total(),
            'rows' => $list->items(),
            'stats' => [
                'total_money' => sprintf('%.2f', $totalMoney),
                'today_money' => sprintf('%.2f', $todayMoney),
                'total_users' => $totalUsers,
                'today_users' => $todayUsers,
                'completed_money' => sprintf('%.2f', $completedMoney),
                'today_completed_money' => sprintf('%.2f', $todayCompletedMoney)
            ]
        ];
        
        return json($result);
    }

//    充值钱包	充值获得	-	充值后展示，+
    const BillTypeBuyRecharge = 1;
//    充值钱包	购买产品	-	购买产品消耗，-
    const BillTypeBuyProduct = 2;
//    充值钱包	回报钱包转换	-	回报钱包转入，+
    const BillTypePayBackConvert = 3;//回报钱包转出
//    回报钱包	转换到充值钱包	-	转出到充值钱包，-
    const BillTypePayBackMoney = 4;//金额转入
//    回报钱包	产品收益	每日1.3%等等	每日产生的收益，+
    const BillTypeProductIncome = 5;//金额转入
//    回报钱包	提现
    const BillTypWithdrawal = 6;//金额转入

//    回报钱包	累计签到	每次3-8元随机	累计签到奖励获得，+
    const BillTypeSign = 7;//这个是后台操作
//    回报钱包	邀请返利	-	下级购买产品返利，+
    const BillTypeInvitePayBack = 8;//金额转入
//    回报钱包	邀请认购补贴	-	邀请认购人数奖励，+
    const BillTypeInviteCountPayBack = 9;//金额转入
//    回报钱包	邀请好友	每个2元	邀请成功1人，+
    const BillTypeInvite = 10;//金额转入
//    回报钱包	绑定社交账号	2元	绑定社交账号，+
    const BillTypeBindSocial = 11;//金额转入
//    补助钱包	产品到期补助	-	持有产品到期，+
    const BillTypeProductEnd = 12;//金额转入
//    补助钱包	产品购买补助	2000一次性	购买产品第二天获得，+
    const BillTypeProductTwoDay = 13;//金额转入
//    圆梦基金	注册	20000	自己注册并且实名认证的奖励，+
    const BillTypeRegister = 14;//金额转入
//    圆梦基金	邀请奖励	每个10000	邀请的人完成实名认证，+
    const BillTypeInviteAuth = 15;//金额转入
    //补助钱包 每个月产生1.5%的分红到补助钱包
    const BillTypeFundMonth = 16;
    //提现返还
    const BillTypeFundWithdrawal = 17;
    const BillTypeSys = 18;
    const BillTypeRedPacket = 19;
    //购买产品每月补助
    const BillTypeBuyProductAllowance = 20;

    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */

    public function pass($ids = null)
    {
        $ids = $ids ?: $this->request->get("ids");
        if (empty($ids)) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        
        $payInfo = $this->model->get($ids);
        if (empty($payInfo)) {
            $this->error('支付记录不存在');
        }
        
        if ($payInfo->type != 1) {
            $this->error('已通过支付,禁止修改');
        }
        
        Db::startTrans();
        $uid = $payInfo['uid'];
        $money = $payInfo['money'];
        
        try {
            //系统支付
            $boor = (new \app\admin\model\Sys())
                ->where("id", $payInfo['sys_id'])
                ->inc("buy_money", $money)->update();
                
            if (empty($boor)) {
                throw new \Exception('Failed to inc sys money');
            }
            
            //账单
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => 1,
                'bill_unit' => 'add',
                'bill_type' => self::BillTypeBuyRecharge,
                'admin_uid' => $this->auth->id,
                'itime' => time(),
                'utime' => time(),
            ];
            
            $boor = (new \app\admin\model\Bill())->insert($billData);
            if (empty($boor)) {
                throw new \Exception('Failed to save bill record');
            }
            
            //支付账单
            $payM = new \app\admin\model\Pay();
            $boor = $payM->where("id", $payInfo['id'])
                ->update([
                    'type' => 2,
                    'callback' => "",
                ]);
                
            if (empty($boor)) {
                throw new \Exception('Failed to save bill record');
            }
            
            //用户
            $accountInfo = new \app\admin\model\Account();
            $boor = $accountInfo->where("uid", $uid)
                ->inc("money", $money)->update();
                
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            
            // 提交事务
            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            Log::record(json_encode([
                "msg" => 'pay',
                'err' => $e->getMessage(),
            ]), 'error');
            $this->error('支付失败');
        }
        
        $this->success();
    }
}
