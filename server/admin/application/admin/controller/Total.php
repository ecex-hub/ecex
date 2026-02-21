<?php

namespace app\admin\controller;

use app\admin\model\Bill;
use app\common\controller\Backend;
use common\models\AccountInfo;
use think\Db;
use think\exception\DbException;
use think\exception\PDOException;
use think\exception\ValidateException;
use think\response\Json;


class Total extends Backend
{

    /**
     * Video模型对象
     * @var \app\admin\model\Video
     */
    protected $model = null;


    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Account;
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
        $oneLevel = $this->request->request("oneLevel");
        $account = $this->model;
        $user = $account->where("uid", $oneLevel)->find();
        if ($user->path == "") {
            $path = $oneLevel . "," . "%";
        } else {
            $path = $user->path . $oneLevel . "," . "%";
        }
        $map['path'] = ['like', $path];
        $list = $this->model
            ->where($where)
            ->where($map)
            ->order("uid", "desc")
            ->paginate($limit);
        foreach ($list->items() as $v) {
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
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }


}