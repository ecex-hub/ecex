<?php

namespace common\models\Rbac;

use common\models\ChannelManage;
use Yii;
use yii\db\ActiveRecord;
use yii\behaviors\TimestampBehavior;

/**
 * This is the model class for table "auth_assignment".
 *
 */
class Menu extends ActiveRecord {

    protected $table = 't_menu_new';

    /**
     * {@inheritdoc}
     */
    public static function tableName() {
        return '{{t_menu}}';
    }

    /**
     * {@inheritdoc}
     */
    public static function getDb() {
        return Yii::$app->get('db');
    }

    /**
     * {@inheritdoc}
     */
    public function rules() {
        return [
            ['id', 'number'], //id
            ['front_id', 'number'], //前端路由id
            ['front_id', 'unique'], //前端路由id
//            ['parent_id', 'number'], //父类id
//            ['name', 'string'], //路由名称
//            ['front_route', 'string'], //前端路由
            ['backend_route', 'string'], //后端路由
            ['sort', 'number'], //排序
            ['is_display', 'number'], //是否展示 1 展示 2不展示.
            ['itime', 'number'], //加入时间
            ['utime', 'number'], //更新时间
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors() {
        return [
            'timestamp' => [
                'class' => TimestampBehavior::className(),
                'attributes' => [
                    ActiveRecord::EVENT_BEFORE_INSERT => ['itime', 'utime'],
                    ActiveRecord::EVENT_BEFORE_UPDATE => ['utime']
                ]
            ]
        ];
    }

    /**
     * 通过父级id 查找子集
     * getChildren.
     *
     * @param integer $parentId 父级id.
     *
     * @return array.
     */
    public static function getChildren($parentId) {
        $ret = static::find()->where(['parent_id' => $parentId])->asArray()->all();
        return $ret;
    }

    /**
     * x管理员拥有权限，菜单列表
     * adminMenuInfo service.
     *
     * @return mixed.
     */
    public function adminMenuInfo() {
        $userMenu = []; //管理员可见菜单集合
        $userAuth = []; //管理员拥有权限集合
        $superAdminId = Yii::$app->params['admin_id'];
        $userId = Yii::$app->user->identity->id;
        $role = Yii::$app->user->identity->role;
        if (Yii::$app->user->identity->authority == 3) {
            return ["140000", "140100"];
        }


        $authAssignment = AuthAssignment::find()->where(['user_id' => $userId])->asArray()->all();
        foreach ($authAssignment as $k => $v) {
            $userAuth[] = $v['item_name'];
        }
        //超级管理员不受限制
        if ($superAdminId == $userId) {
            $menu = Menu::find()->orderBy('front_id DESC')->andWhere(['is_display' => 1])->asArray()->all();
        } else {
            $authItemChild = AuthItemChild::find()->where(['=', 'parent', $role])->asArray()->all();
            $child_array = array_column($authItemChild, 'child');
            $userAuth = array_unique(array_merge_recursive($child_array, $userAuth));
            $menu = Menu::find()->where(['IN', 'backend_route', $userAuth])->andWhere(['is_display' => 1])->orderBy('front_id DESC')->asArray()->all();
        }
        $userMenu = array_column($menu, 'front_id');
        foreach ($userMenu as $key => $value) {
            $str = substr($value, 0, 2);
            if (!in_array($str . '0000', $userMenu)) {
                array_push($userMenu, $str . '0000');
            }
        }
        //渠道是否有添加子渠道权限处理
//        $channelManageModel = new ChannelManage();
//        $channelInfo = $channelManageModel->getAccountChannelData($userId);
//        if (empty($channelInfo) && Yii::$app->user->identity->authority == '5') {
//            $userMenu = [];
//        }
//        if (!empty($channelInfo)) {
//            if ($channelInfo['is_add_child'] != '1') {
//                $key = array_search('150500', $userMenu);
//                if ($key !== false) {
//                    unset($userMenu[$key]);
//                }
//            }
//            if ($channelInfo['order_switch'] != '1' || $channelInfo['parent_id'] != '0') {
//                $key2 = array_search('130550', $userMenu);
//                if ($key2 !== false) {
//                    unset($userMenu[$key2]);
//                }
//            }
////            if ($channelInfo['settlement_type'] != '2') {
////                $key2 = array_search('130553', $userMenu);
////                if ($key2 !== false) {
////                    unset($userMenu[$key2]);
////                }
////                $key2 = array_search('130551', $userMenu);
////                if ($key2 !== false) {
////                    unset($userMenu[$key2]);
////                }
////            }
//            if ($channelInfo['is_set_withdraw'] != '1') {
//                $key2 = array_search('130552', $userMenu);
//                if ($key2 !== false) {
//                    unset($userMenu[$key2]);
//                }
//            }
//            //渠道账号 如果不是包网 则取消包网配置的东西
//            if ($channelInfo['distributionType'] <> 2) {
//                $data = [
//                    570559,
//                    570558,
//                    570557,
//                    570556,
//                    570555,
//                    570554,
//                    570000
//                ];
//                foreach ($data as $key => $value) {
//                    $key2 = array_search($value, $userMenu);
//                    if ($key2 !== false) {
//                        unset($userMenu[$key2]);
//                    }
//                }
//            }
//        }
        return array_values($userMenu);
    }

    /**
     * x获取菜单树形列表
     *
     * @param array $menu 原始菜单数据.
     * @param integer $pid 父级id.
     *
     * @return mixed.
     */
    protected function getMenuInfoByTree($menu, $pid) {
        $userMenu = [];
        if (!empty($menu)) {
            foreach ($menu as $menuValue) {
                if ($menuValue['parent_id'] == $pid) {
                    $userMenu[] = [
                        'id' => $menuValue['id'],
                        'label' => $menuValue['name'],
                        'route' => $menuValue['front_route'],
                        'children' => $this->getMenuInfoByTree($menu, $menuValue['id']),
                    ];
                }
            }
        }
        return $userMenu;
    }

    /**
     * x菜单列表
     * menuList.
     * @param array $fields 查询字段.
     * @param string $sort 排序类型.
     * @param integer $page 当前页数.
     * @param integer $row 每页行数.
     * @param string $front_id 前端路由id.
     * @param string $backend_route 后端路由.
     * @param integer $is_display 是否展示 1 展示 2不展示.
     * @param string $start_time 开始时间.
     * @param string $end_time 结束时间.
     *
     * @return mixed.
     */
    public function menuList($fields = [], $sort = '', $page = 1, $row = 10, $front_id = '', $backend_route = '', $is_display = 1, $start_time = '', $end_time = '') {
        $query = self::find()->orderBy('itime DESC');
        if (!empty($fields) && is_array($fields)) {
            $query = $query->select($fields);
        }
        if (!empty($sort)) {
            if (strpos($sort, "-") === 0) {
                $sort = str_replace("-", '', $sort) . " DESC";
            } else {
                $sort = str_replace("-", '', $sort) . " ASC";
            }
            $query = $query->orderBy($sort);
        }
        if (!empty($front_id)) {
            $query = $query->andWhere(['front_id' => $front_id]);
        }
        if (!empty($backend_route)) {
            $query = $query->andWhere(['like', 'backend_route', $backend_route]);
        }
        if (!empty($is_display)) {
            $query = $query->andWhere(['is_display' => $is_display]);
        }
        if (!empty($start_time)) {
            $query = $query->andWhere(['>=', 'itime', $start_time]);
        }
        if (!empty($end_time)) {
            $query = $query->andWhere(['<=', 'utime', $end_time]);
        }
        $countQuery = clone $query;
        $dataInfo = $query->offset(($page - 1) * $row)->limit($row)->asArray()->all();
        $ret = [];
        if (!empty($dataInfo)) {
            $ret['count'] = $countQuery->count();
            $ret['page'] = ceil($ret['count'] / $row);
            foreach ($dataInfo as $k => $v) {
                $dataInfo[$k]['itime'] = date('Y-m-d H:i:s', $v['itime']);
                $dataInfo[$k]['utime'] = date('Y-m-d H:i:s', $v['utime']);
            }
            $ret['data'] = $dataInfo;
        }
        return $ret;
    }

    /**
     * x添加菜单
     * addMenu.
     * @param integer $front_id 前端id.
     * @param string $backend_route 后端路由.
     * @param integer $sort 排序.
     * @param integer $is_display 是否展示 1 展示 2不展示.
     * @return mixed.
     */
    public function addMenu($front_id, $backend_route = '', $sort = 100, $is_display = 1) {
        $menu = new Menu();
        $menu->front_id = $front_id;
        $menu->backend_route = $backend_route;
        $menu->sort = $sort;
        $menu->is_display = $is_display;
        if ($menu->save()) {
            return true;
        } else {
            $errs = $menu->getFirstErrors();
            if (!empty($errs) && is_array($errs)) {
                $it = array_shift($errs);
                throw new \Exception($it, 70002);
            }
        }
    }

    /**
     * x修改菜单
     * updateMenu.
     * @param integer $id 标识id.
     * @param integer $front_id 前端id.
     * @param string $backend_route 后端路由.
     * @param integer $sort 排序.
     * @param integer $is_display 是否展示 1 展示 2不展示.
     *
     * @return mixed.
     */
    public function updateMenu($id, $front_id, $backend_route, $sort, $is_display) {
        $menu = self::findOne(['id' => $id]);
        if (empty($menu)) {
            throw new \Exception('该id不存在', 201);
        }
        if (!empty($front_id)) {
            $menu->parent_id = $front_id;
        }
        if (!empty($backend_route)) {
            $menu->backend_route = $backend_route;
        }
        if (!empty($sort)) {
            $menu->sort = $sort;
        }
        if (!empty($is_display)) {
            $menu->is_display = $is_display;
        }
        if ($menu->save()) {
            return true;
        } else {
            $errs = $menu->getFirstErrors();
            if (!empty($errs) && is_array($errs)) {
                $it = array_shift($errs);
                throw new \Exception($it, 205);
            }
        }
    }

    /**
     * x删除菜单
     * deleteMenu.
     * @param integer $id 标识id.
     *
     * @return mixed.
     */
    public function deleteMenu($id) {
        // $boor = self::updateAll(['is_display' => 2], ['id' => $id]);
        $boor = self::deleteAll(['id' => $id]);
        if (!$boor) {
            throw new \Exception('删除失败', 203);
        }
        return true;
    }

}
