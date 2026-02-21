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


class Conf extends Backend
{

    /**
     * Video模型对象
     * @var \app\admin\model\Video
     */
    protected $model = null;


    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Conf;
    }

    public function index()
    {

        if (false === $this->request->isPost()) {
            $row = $this->model->where('key', 4)->find();
            $group = $this->model->where('key', 6)->find();
            $group1 = $this->model->where('key', 7)->find();

            $this->view->assign('row', $row);
            $this->view->assign('group', $group);
            $this->view->assign('group1', $group1);

            return $this->view->fetch();
        }
        $params = $this->request->post('row/a');
        if (empty($params)) {
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $content = $params['content'];
        $this->model->where("key", 4)->update([
            "content" => $content,
        ]);
        $group = $params['group'];
        $this->model->where("key", 6)->update([
            "content" => $group,
        ]);
        $group1 = $params['group1'];
        $this->model->where("key", 7)->update([
            "content" => $group1,
        ]);
        $this->success();
    }


}