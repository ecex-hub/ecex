<?php

namespace app\admin\controller;

use app\common\controller\Backend;
use think\exception\DbException;
use think\response\Json;

/**
 *
 * @icon fa fa-circle-o
 */
class User extends Backend
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
        $map = [];
        $total = $this->request->request("total");
        if ($total) {
            $account = $this->model;
            $user = $account->where("uid", $total)->find();
            if ($user) {
                if ($user->path == "") {
                    $path = $total . "," . "%";
                } else {
                    $path = $user->path . $total . "," . "%";
                }
                $map['path'] = ['like', $path];
            }
        }
        $oneLevel = $this->request->request("oneLevel");
        if ($oneLevel) {
            $map['oneLevel'] = ['=', $oneLevel];
        }
        $twoLevel = $this->request->request("twoLevel");
        if ($twoLevel) {
            $map['twoLevel'] = ['=', $twoLevel];
        }
        $threeLevel = $this->request->request("threeLevel");
        if ($threeLevel) {
            $map['threeLevel'] = ['=', $threeLevel];
        }
        $otherLevel = $this->request->request("otherLevel");
        if ($otherLevel) {
            //增加
            $account = $this->model;
            $user = $account->where("uid", $otherLevel)->find();
            if ($user) {
                if ($user->path == "") {
                    $path = $otherLevel . "," . "%";
                } else {
                    $path = $user->path . $otherLevel . "," . "%";
                }
                $map['path'] = ['like', $path];
            }
            $map['oneLevel'] = ['<>', $otherLevel];
            $map['twoLevel'] = ['<>', $otherLevel];
            $map['threeLevel'] = ['<>', $otherLevel];
        }
        $list = $this->model
            ->where($where)
            ->where($map)
            ->order($sort, $order)
            ->paginate($limit);
        foreach ($list->items() as $v) {
            $v->total_income = bcadd($v->oneIncome, $v->twoIncome, $v->threeIncome);
            $path = $v->path;
            $uid = $v->uid;
            if ($path == "") {
                $path = $uid . "," . "%";
            } else {
                $path = $path . $uid . "," . "%";
            }
            $map['path'] = ['like', $path];
            $account = new \app\admin\model\Account();
            $count = $account->where($map)->count();
            $v->InviteTotal = $count;

            $tmpNum = $v->oneSharePeople + $v->twoSharePeople + $v->threeSharePeople;
            $v->other_num = max(0, $count - $tmpNum);
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }
}