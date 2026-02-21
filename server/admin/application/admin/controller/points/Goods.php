<?php

namespace app\admin\controller\points;

use app\common\controller\Backend;

/**
 * 积分商品
 *
 * @icon fa fa-circle-o
 */
class Goods extends Backend
{

    /**
     * Goods模型对象
     * @var \app\admin\model\points\Goods
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\points\Goods;
        $this->view->assign("statusList", $this->model->getStatusList());
    }

    public function index()
    {
        // 当前是否为关联查询
        $this->relationSearch = true;
        // 设置过滤方法
        $this->request->filter(['strip_tags', 'trim']);
        if ($this->request->isAjax()) {
            // 如果发送的来源是Selectpage，则转发到Selectpage
            if ($this->request->request('keyField')) {
                return $this->selectpage();
            }
            
            // 清理错误的过滤条件：如果 filter 中包含 points="goods" 这样的错误条件，移除它
            $filter = $this->request->get("filter", '');
            if (!empty($filter)) {
                $filterArr = json_decode($filter, true);
                if (is_array($filterArr) && isset($filterArr['points']) && $filterArr['points'] === 'goods') {
                    // 移除错误的过滤条件
                    unset($filterArr['points']);
                    $op = $this->request->get("op", '');
                    if (!empty($op)) {
                        $opArr = json_decode($op, true);
                        if (is_array($opArr) && isset($opArr['points'])) {
                            unset($opArr['points']);
                            $this->request->get(['op' => json_encode($opArr)]);
                        }
                    }
                    $this->request->get(['filter' => json_encode($filterArr)]);
                }
            }
            
            list($where, $sort, $order, $offset, $limit) = $this->buildparams();
            $total = $this->model
                ->with('category')  // 预载入分类
                ->where($where)
                ->order($sort, $order)
                ->count();
    
            $list = $this->model
                ->with('category')
                ->where($where)
                ->order($sort, $order)
                ->limit($offset, $limit)
                ->select();
    
            $result = array("total" => $total, "rows" => $list);
            return json($result);
        }
        return $this->view->fetch();
    }

    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */


}
