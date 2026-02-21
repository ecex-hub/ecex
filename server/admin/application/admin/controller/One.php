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


class One extends Backend
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
        $list = $this->model
            ->where($where)
            ->where("oneLevel", $oneLevel)
            ->order("uid", "desc")
            ->paginate($limit);
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }


}