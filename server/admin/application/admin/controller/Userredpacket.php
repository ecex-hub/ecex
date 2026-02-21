<?php

namespace app\admin\controller;

use app\common\controller\Backend;
use think\exception\DbException;
use think\response\Json;

/**
 * 系统账号
 *
 * @icon fa fa-circle-o
 */
class Userredpacket extends Backend
{

    /**
     * Sys模型对象
     * @var \app\admin\model\Sys
     */
    protected $model = null;
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\UserRedPacket();

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
        $uid = $this->request->get("uid");
        $query = $this->model
            ->where($where)
            ->with(["user"]);
        if ($uid) {
            $query = $query->where("t_account_info.uid", $uid);
        }
        $list = $query
            ->where("is_receive", 1)
            ->order("utime", "desc")
            ->paginate($limit);
        foreach ($list->items() as $k => $v) {
            $v->type_name = '是';
            if ($v->type == 1) {
                $v->type_name = '否';
            }
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }


}
