<?php

namespace app\admin\controller\points;

use app\common\controller\Backend;

/**
 * 商品分类
 *
 * @icon fa fa-circle-o
 */
class Category extends Backend
{

    /**
     * Category模型对象
     * @var \app\admin\model\points\Category
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\points\Category;
        $this->view->assign("statusList", $this->model->getStatusList());
    }

    /**
     * Selectpage搜索
     *
     * @internal
     */
    public function selectpage()
    {
        return parent::selectpage();
    }

    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */


}
