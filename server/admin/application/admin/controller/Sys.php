<?php

namespace app\admin\controller;

use app\common\controller\Backend;
use think\Db;
use think\exception\DbException;
use think\exception\PDOException;
use think\response\Json;

/**
 * 系统账号
 *
 * @icon fa fa-circle-o
 */
class Sys extends Backend
{

    /**
     * Sys模型对象
     * @var \app\admin\model\Sys
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Sys;

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
        $list = $this->model
            ->where($where)
            ->where("type", 1)
            ->order($sort, $order)
            ->paginate($limit);
        $payTypeArr = [
            1 => "1-支付宝",
            2 => '2-微信',
            3 => '3-银联',
            4 => '4-云闪付'
        ];
        $payMchArr = [
            1 => '福海支付',
            2 => '桥头支付',
            3 => 'alin支付',
            4 => '四海支付',
            5 => '四海-云四方',
            6 => '大圣支付',
            7 => "PT中外支付",
        ];
        foreach ($list->items() as $k => &$v) {
            $v['pay_type'] = $payTypeArr[$v['pay_type']] ?? "";
            $v['pay_mch_name'] = $payMchArr[$v['pay_mch']] . "-" ?? "";
            if ($v['pay_mch'] == 1) {
                if ($v->pay_type == 1) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 126;
                } else if ($v->pay_type == 2) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 132;
                } else if ($v->pay_type == 3) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 118;
                } else if ($v->pay_type == 4) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 128;
                }
            } else if ($v['pay_mch'] == 2) {
                if ($v->pay_type == 1) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 8020;
                } else if ($v->pay_type == 2) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 8017;
                }
            } else if ($v['pay_mch'] == 3) {
                if ($v->pay_type == 1) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 3;
                } else if ($v->pay_type == 2) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 2;
                } else if ($v->pay_type == 4) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 10;
                }
            } else if ($v['pay_mch'] == 4) {
                if ($v->pay_type == 3) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 8025;
                }
            } else if ($v['pay_mch'] == 5) {
                $v['pay_mch_name'] = $v['pay_mch_name'] . 8036;
            } else if ($v['pay_mch'] == 6) {
                if ($v->pay_type == 2) {
                    $v['pay_mch_name'] = $v['pay_mch_name'] . 8001;
                }
            } else if ($v['pay_mch'] == 7) {
                $v['pay_mch_name'] = $v['pay_mch_name'] . 333;
            }
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }

    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */


    public function multi($ids = null)
    {
        if (false === $this->request->isPost()) {
            $this->error(__('Invalid parameters'));
        }
        $ids = $ids ?: $this->request->post('ids');
        if (empty($ids)) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }

        if (false === $this->request->has('params')) {
            $this->error(__('No rows were updated'));
        }
        parse_str($this->request->post('params'), $values);
        $values = $this->auth->isSuperAdmin() ? $values : array_intersect_key($values, array_flip(is_array($this->multiFields) ? $this->multiFields : explode(',', $this->multiFields)));
        if (empty($values)) {
            $this->error(__('You have no permission'));
        }
        $adminIds = $this->getDataLimitAdminIds();
        if (is_array($adminIds)) {
            $this->model->where($this->dataLimitField, 'in', $adminIds);
        }
        $count = 0;
        Db::startTrans();
        try {
            $list = $this->model->where($this->model->getPk(), 'in', $ids)->select();
            foreach ($list as $item) {
                $count += $item->allowField(true)->isUpdate(true)->save($values);
            }
            Db::commit();
        } catch (PDOException|Exception $e) {
            Db::rollback();
            $this->error($e->getMessage());
        }
        $this->success();
        $this->error(__('No rows were updated'));
    }
}
