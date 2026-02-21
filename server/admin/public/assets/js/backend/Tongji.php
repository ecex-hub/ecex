<?php

namespace app\admin\controller;

use app\common\controller\Backend;
use think\Loader;

/**
 * 统计
 *
 * @icon fa fa-circle-o
 */
class Tongji extends Backend
{

    /**
     * Tongji模型对象
     * @var \app\admin\model\Tongji
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Tongji;

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

    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
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
        $customWhere = $this->custombuildparams();
        $where1 = [];
        $registerNum = 0;
        $realNum = 0;
        $buyProductNum = 0;
        $rechargeMoney = 0;
        $buyProductMoney = 0;
        $withdrawMoney = 0;
        $rechargeNum = 0;
        $withdrawNum = 0;
        $baseQuery = new \app\admin\model\Tongji();
        if (isset($customWhere[0])) {
            $item = $customWhere[0];
            if (isset($item[0]) && $item[0] == 'day') {
                $startTime = $item[2][0];
                $endTime = $item[2][1];
                $registerNum = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("register_num");
                $realNum = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("real_num");
                $buyProductNum = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("buy_product_num");
                $rechargeMoney = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("recharge_money");
                $buyProductMoney = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("buy_product_money");
                $withdrawMoney = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("withdraw_money");
                $rechargeNum = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("recharge_num");
                $withdrawNum = $baseQuery->where("day", '>=', $startTime)
                    ->where("day", '<=', $endTime)->sum("withdraw_num");
            }
        } else {
            $registerNum = $baseQuery->sum("register_num");
            $realNum = $baseQuery->sum("real_num");
            $buyProductNum = $baseQuery->sum("buy_product_num");
            $rechargeMoney = $baseQuery->sum("recharge_money");
            $buyProductMoney = $baseQuery->sum("buy_product_money");
            $withdrawMoney = $baseQuery->sum("withdraw_money");
            $rechargeNum = $baseQuery->sum("recharge_num");
            $withdrawNum = $baseQuery->sum("withdraw_num");
        }
        $list = $this->model
            ->where($where)
            ->order($sort, $order)
            ->paginate($limit);
        $result = [
            'total' => $list->total(),
            'rows' => $list->items(),
            'register_num' => $registerNum,
            'real_num' => $realNum,
            'buy_product_num' => $buyProductNum,
            'recharge_money' => $rechargeMoney,
            'buy_product_money' => $buyProductMoney,
            'withdraw_money' => $withdrawMoney,
            'recharge_num' => $rechargeNum,
            'withdraw_num' => $withdrawNum,
        ];
        return json($result);
    }


}
