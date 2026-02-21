<?php

namespace app\admin\controller;

use app\common\controller\Backend;

/**
 * 用户签到管理
 *
 * @icon fa fa-circle-o
 */
class UserSignIn extends Backend
{

    /**
     * UserSignIn模型对象
     * @var \app\admin\model\UserSignIn
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\UserSignIn;

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
            //return $this->view->fetch('user_sign_in/index');
            return $this->view->fetch();
            
        }
        //如果发送的来源是 Selectpage，则转发到 Selectpage
        if ($this->request->request('keyField')) {
            return $this->selectpage();
        }
        [$where, $sort, $order, $offset, $limit] = $this->buildparams();
        $list = $this->model
            ->where($where)
            ->with([
                'user' => function($query) {
                    // 只查询 account_info 表的特定字段
                    // 注意：必须包含 uid 字段，因为它是关联键
                    // 使用 setEagerlyType(1) 时，使用 IN 查询，不会有字段歧义问题
                    $query->field('uid,account,nickname,avatar');
                }
            ])
            ->order($sort, $order)
            ->paginate($limit);
        
        // 处理关联数据，将 user.nickname 添加到 account 字段
        foreach ($list->items() as $k => &$v) {
            if ($v->getRelation('user')) {
                $v['account'] = $v->getRelation('user')->nickname ?? '';
            }
        }
        
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }

}
