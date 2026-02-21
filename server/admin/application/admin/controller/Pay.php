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

    /**
     * Pay模型对象
     * @var \app\admin\model\Pay
     */
    protected $model = null;
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Pay;

    }

    protected function custombuildparams($searchfields = null, $relationSearch = null)
    {
        $searchfields = is_null($searchfields) ? $this->searchFields : $searchfields;
        $relationSearch = is_null($relationSearch) ? $this->relationSearch : $relationSearch;
//        $search = $this->request->get("search", '');
        $filter = $this->request->get("filter", '');
        $op = $this->request->get("op", '', 'trim');
        //新增自动计算页码
        $filter = (array)json_decode($filter, true);
        $op = (array)json_decode($op, true);
        $filter = $filter ? $filter : [];
        $where = [];
        $bind = [];
        $name = '';
        $aliasName = '';

//        if ($search) {
//            $searcharr = is_array($searchfields) ? $searchfields : explode(',', $searchfields);
//            foreach ($searcharr as $k => &$v) {
//                $v = stripos($v, ".") === false ? $aliasName . $v : $v;
//            }
//            unset($v);
//            $where[] = [implode("|", $searcharr), "LIKE", "%{$search}%"];
//        }
        $index = 0;
        foreach ($filter as $k => $v) {
            if (!preg_match('/^[a-zA-Z0-9_\-\.]+$/', $k)) {
                continue;
            }
            $sym = $op[$k] ?? '=';
            if (stripos($k, ".") === false) {
                $k = $aliasName . $k;
            }
            $v = !is_array($v) ? trim($v) : $v;
            $sym = strtoupper($op[$k] ?? $sym);
            //null和空字符串特殊处理
            if (!is_array($v)) {
                if (in_array(strtoupper($v), ['NULL', 'NOT NULL'])) {
                    $sym = strtoupper($v);
                }
                if (in_array($v, ['""', "''"])) {
                    $v = '';
                    $sym = '=';
                }
            }

            switch ($sym) {
                case '=':
                case '<>':
                    $where[] = [$k, $sym, (string)$v];
                    break;
                case 'LIKE':
                case 'NOT LIKE':
                case 'LIKE %...%':
                case 'NOT LIKE %...%':
                    $where[] = [$k, trim(str_replace('%...%', '', $sym)), "%{$v}%"];
                    break;
                case '>':
                case '>=':
                case '<':
                case '<=':
                    $where[] = [$k, $sym, intval($v)];
                    break;
                case 'FINDIN':
                case 'FINDINSET':
                case 'FIND_IN_SET':
                    $v = is_array($v) ? $v : explode(',', str_replace(' ', ',', $v));
                    $findArr = array_values($v);
                    foreach ($findArr as $idx => $item) {
                        $bindName = "item_" . $index . "_" . $idx;
                        $bind[$bindName] = $item;
                        $where[] = "FIND_IN_SET(:{$bindName}, `" . str_replace('.', '`.`', $k) . "`)";
                    }
                    break;
                case 'IN':
                case 'IN(...)':
                case 'NOT IN':
                case 'NOT IN(...)':
                    $where[] = [$k, str_replace('(...)', '', $sym), is_array($v) ? $v : explode(',', $v)];
                    break;
                case 'BETWEEN':
                case 'NOT BETWEEN':
                    $arr = array_slice(explode(',', $v), 0, 2);
                    if (stripos($v, ',') === false || !array_filter($arr, function ($v) {
                            return $v != '' && $v !== false && $v !== null;
                        })) {
                        continue 2;
                    }
                    //当出现一边为空时改变操作符
                    if ($arr[0] === '') {
                        $sym = $sym == 'BETWEEN' ? '<=' : '>';
                        $arr = $arr[1];
                    } elseif ($arr[1] === '') {
                        $sym = $sym == 'BETWEEN' ? '>=' : '<';
                        $arr = $arr[0];
                    }
                    $where[] = [$k, $sym, $arr];
                    break;
                case 'RANGE':
                case 'NOT RANGE':
                    $v = str_replace(' - ', ',', $v);
                    $arr = array_slice(explode(',', $v), 0, 2);
                    if (stripos($v, ',') === false || !array_filter($arr)) {
                        continue 2;
                    }
                    //当出现一边为空时改变操作符
                    if ($arr[0] === '') {
                        $sym = $sym == 'RANGE' ? '<=' : '>';
                        $arr = $arr[1];
                    } elseif ($arr[1] === '') {
                        $sym = $sym == 'RANGE' ? '>=' : '<';
                        $arr = $arr[0];
                    }
                    $tableArr = explode('.', $k);
                    if (count($tableArr) > 1 && $tableArr[0] != $name && !in_array($tableArr[0], "")
                        && !empty($this->model) && $this->relationSearch) {
                        //修复关联模型下时间无法搜索的BUG
                        $relation = Loader::parseName($tableArr[0], 1, false);
                        $alias[$this->model->$relation()->getTable()] = $tableArr[0];
                    }
                    $where[] = [$k, str_replace('RANGE', 'BETWEEN', $sym) . ' TIME', $arr];
                    break;
                case 'NULL':
                case 'IS NULL':
                case 'NOT NULL':
                case 'IS NOT NULL':
                    $where[] = [$k, strtolower(str_replace('IS ', '', $sym))];
                    break;
                default:
                    break;
            }
            $index++;
        }
        return $where;
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
        //支付商户 1-福海支付 2-桥头支付 3-alin支付 4-四海 5-四海云四方 6-大圣支付
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
            //$sysData = (new \app\admin\model\Sys())->where("id", $v['sys_id'])->find();
            //$v->getRelation('sys')->visible(['pay_mch']);
            $v['pay_chnl'] = $payMchArr[$v['sys']['pay_mch']] ?? "";
        }
        //$where[$type] = ['like',"%".$key."%"];
        $where1['pay.type'] = 2;
        $customWhere = $this->custombuildparams();
        $whereA = [];
        $whereB = [];
        $whereC = [];
        if ($customWhere) {
//            var_dump($customWhere);
            foreach ($customWhere as $item) {
                if ($item[0] == 'id') {
                    $where1['pay.id'] = $item[2];
                } else if ($item[0] == 'uid') {
                    $where1['pay.uid'] = $item[2];
                } else if ($item[0] == 'otn') {
                    $where1['pay.otn'] = ['like', "%" . $item[2] . "%"];
                } else if ($item[0] == 'pay_type') {
                    $where1['pay.pay_type'] = $item[2];
                    $whereB['pay_type'] = $item[2];
                } else if ($item[0] == 'user.nickname') {
                    $where1['user.nickname'] = ['like', "%" . $item[2] . "%"];
                } else if ($item[0] == 'itime') {
                    $where1['pay.itime'] = ['between',
                        [strtotime($item[2][0]), strtotime($item[2][1])]
                    ];
                    $whereC['itime'] = ['between',
                        [strtotime($item[2][0]), strtotime($item[2][1])]
                    ];
                } else if ($item[0] == "sys.pay_mch") {
                    $payMch = $item[2];
                    $m1 = new \app\admin\model\Sys();
                    $sysIds = $m1->where("pay_mch", $payMch)->column("id");
                    $where1['pay.sys_id'] = ['in', $sysIds];
                    $whereA['sys_id'] = ['in', $sysIds];
                }
            }
        }
        $payM = new \app\admin\model\Pay();
        $buyMoney = $payM
            ->where($where1)
            ->with(['user'])
            ->sum("pay.money");
        $buyTotal = $payM
            ->field(['uid'])
            ->where($where1)
            ->with(['user'])
            ->group("uid")->count();

        $totalNumber = $payM
            ->where($whereA)
            ->where($whereB)
            ->where($whereC)
            ->count();

        $sucNumber = $payM
            ->where($whereA)
            ->where($whereB)
            ->where($whereC)
            ->where("type", 2)
            ->count();
        $successRate = 0;
        if ($totalNumber) {
            $successRate = $sucNumber / $totalNumber;
            $percentage = $successRate * 100; // 转换为百分比
            $successRate = number_format($percentage, 2) . '%'; // 保留两位小数，并添加百分号
        }
        $result = [
            'total' => $list->total(),
            'rows' => $list->items(),
            'buy_money' => $buyMoney,
            'buy_total' => $buyTotal,
            'where1' => $this->custombuildparams(),
            'success_rate' => $successRate
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
                'ext_id' => $this->auth->id,
                'itime' => time(),
                'utime' => time(),
            ];
            $boor = (new \app\admin\model\Bill())->insert($billData);
            if (empty($boor)) {
                throw new \Exception('Failed to save bill record');
            }
            //支付账单
            $payM = new  \app\admin\model\Pay();
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
