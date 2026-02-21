<?php

namespace app\admin\controller;

use app\common\controller\Backend;
use think\Db;
use think\exception\PDOException;
use think\exception\ValidateException;

/**
 * 产品
 *
 * @icon fa fa-circle-o
 */
class Product extends Backend
{

    /**
     * Product模型对象
     * @var \app\admin\model\Product
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Product;

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
            ->where('type', 1)
            ->order($sort, $order)
            ->paginate($limit);
        $typeArr = [
            1 => '是',
            2 => '删除'
        ];
        $productTypeArr = [
            1 => '收益',
            2 => '补助',
        ];
        foreach ($list->items() as $k => &$v) {
            $v['type'] = $typeArr[$v['type']] ?? "";
            if ($v['is_hot']) {
                $v['is_hot'] = '是';
            } else {
                $v['is_hot'] = '否';
            }
            $v['day_income'] = $v['day_income'] . "%";
            $v['image'] = $this->view->config['upload']['cdnurl'] . $v['image'];
            $v['product_type_name'] = $productTypeArr[$v['product_type']] ?? "";
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }


    public function edit($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
        }
        $adminIds = $this->getDataLimitAdminIds();
        if (is_array($adminIds) && !in_array($row[$this->dataLimitField], $adminIds)) {
            $this->error(__('You have no permission'));
        }
        if (false === $this->request->isPost()) {
            $this->view->assign('row', $row);
            return $this->view->fetch();
        }
        $params = $this->request->post('row/a');
        if (empty($params)) {
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $params = $this->preExcludeFields($params);
        $result = false;
        Db::startTrans();
        try {
            //是否采用模型验证
            if ($this->modelValidate) {
                $name = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                $validate = is_bool($this->modelValidate) ? ($this->modelSceneValidate ? $name . '.edit' : $name) : $this->modelValidate;
                $row->validateFailException()->validate($validate);
            }
            if ($params['product_type'] == 1) {
                $params['month'] = 0;
                $params['month_income'] = 0.00;
            } else {
                $params['day'] = 0;
                $params['day_income'] = 0.00;
                $params['allowance'] = 0.00;
            }
            $result = $row->allowField(true)->save($params);
            Db::commit();
        } catch (ValidateException|PDOException|Exception $e) {
            Db::rollback();
            $this->error($e->getMessage());
        }
        if (false === $result) {
            $this->error(__('No rows were updated'));
        }
        $this->success();
    }

}
