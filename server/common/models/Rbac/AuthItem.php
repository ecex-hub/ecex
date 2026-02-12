<?php

namespace common\models\Rbac;

use Yii;
use yii\db\ActiveRecord;
use yii\behaviors\TimestampBehavior;

/**
 * This is the model class for table "auth_item".
 *
 */
class AuthItem extends ActiveRecord
{
    /**
     * 存储角色或权限的表
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{t_auth_item}}';
    }

    /**
     * {@inheritdoc}
     */
    public static function getDb()
    {
        return Yii::$app->get('db');
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['name', 'string'], //权限路由名称
            ['name', 'unique', 'message' => '该路由已存在'], //
            ['id', 'number'], //id
            ['parent_id', 'number'], //父类id
            ['type', 'number'], //类型 1 角色 2权限
            ['description', 'string'], //权限描述
            ['rule_name', 'string'], //角色名称/权限名称
            ['data', 'string'], //扩展数据 JSON格式
            ['created_at', 'number'], //加入时间
            ['updated_at', 'number'], //更新时间
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [
            'timestamp' => [
                'class' => TimestampBehavior::className(),
                'attributes' => [
                    ActiveRecord::EVENT_BEFORE_INSERT => ['created_at', 'updated_at'],
                    ActiveRecord::EVENT_BEFORE_UPDATE => ['updated_at']
                ]
            ]
        ];
    }

    /**
     * x权限列表
     * authItemList service.
     * @param array $fields 查询字段.
     * @param integer $page 排序类型.
     * @param integer $row 当前页数.
     * @param string $name 权限路由名称.
     * @param integer $type 类型 1 角色 2权限.
     * @param string $description 权限描述.
     * @param string $rule_name 角色名称/权限名称.
     * @param integer $start_time 开始时间.
     * @param integer $end_time 结束时间.
     * @return mixed.
     */
    public function authItemList($fields, $page, $row, $name, $type, $description, $rule_name, $start_time, $end_time)
    {
        $query = self::find()->orderBy('created_at DESC');
        if (!empty($fields) && is_array($fields)) {
            $query = $query->select($fields);
        }
        if (!empty($name)) {
            $query = $query->andWhere(['like', 'name', $name]);
        }
        if (!empty($type)) {
            $query = $query->andWhere(['type' => $type]);
        }
        if (!empty($description)) {
            $query = $query->andWhere(['like', 'description', $description]);
        }
        if (!empty($rule_name)) {
            $query = $query->andWhere(['like', 'rule_name', $rule_name]);
        }
        if (!empty($start_time)) {
            $query = $query->andWhere(['>=', 'created_at', $start_time]);
        }
        if (!empty($end_time)) {
            $query = $query->andWhere(['<=', 'created_at', $end_time]);
        }
        $countQuery = clone $query;
        $dataInfo = $query->offset(($page - 1) * $row)->limit($row)->asArray()->all();
        $ret = [];
        if (!empty($dataInfo)) {
            $ret['count'] = $countQuery->count();
            $ret['page'] = ceil($ret['count'] / $row);
            foreach ($dataInfo as $k => $v) {
                $dataInfo[$k]['created_at'] =  date('Y-m-d H:i:s', $v['created_at']);
                unset($dataInfo[$k]['data']);
            }
            $ret['data'] = $dataInfo;
        }
        return $ret;
    }

    /**
     * x添加权限规则
     * addAuthItem .
     * @param string $name 权限路由.
     * @param string $parent_id 父类id.
     * @param string $type 类型 1 角色 2权限.
     * @param string $description 权限描述.
     * @param string $rule_name 角色名称/权限名称.
     * @return mixed.
     */
    public function addAuthItem($name = 0, $parent_id = 0, $type = 2, $description = '', $rule_name = '')
    {
        $authItem = new AuthItem();
        $authItem->name = $name;
        $authItem->parent_id = $parent_id;
        $authItem->type = $type;
        $authItem->description = $description;
        $authItem->rule_name = $rule_name;
        if ($authItem->save()) {
            return true;
        } else {
            $errs = $authItem->getFirstErrors();
            if (!empty($errs) && is_array($errs)) {
                $it = array_shift($errs);
                throw new \Exception($it, 70002);
            }
        }
    }

    /**
     * x修改权限规则
     * updateAuthItem.
     * @param integer $id 标识id.
     * @param string $name 权限路由.
     * @param string $parent_id 父类id.
     * @param string $description 权限描述.
     * @param string $rule_name 角色名称/权限名称.
     *
     * @return mixed.
     */
    public function updateAuthItem($id, $name, $parent_id, $description, $rule_name)
    {
        $authItem = AuthItem::findOne(['id' => $id]);
        if (empty($authItem)) {
            throw new \Exception('该id不存在', 201);
        }
        if (!empty($name)) {
            $authItem->name = $name;
        }
        if (!empty($parent_id)) {
            $authItem->parent_id = $parent_id;
        }
        if (!empty($description)) {
            $authItem->description = $description;
        }
        if (!empty($rule_name)) {
            $authItem->rule_name = $rule_name;
        }
        if ($authItem->save()) {
            return true;
        } else {
            $errs = $authItem->getFirstErrors();
            if (!empty($errs) && is_array($errs)) {
                $it = array_shift($errs);
                throw new \Exception($it, 205);
            }
        }
    }

    /**
     * x删除权限规则
     * deleteAuthItem.
     * @param integer $id 标识id.
     *
     * @return mixed.
     */
    public function deleteAuthItem($id)
    {
        $authItem = AuthItem::findOne(['id' => $id]);
        if (!empty($authItem)) {
            $authItem->delete();
        } else {
            throw new \Exception('该id不存在', 201);
        }
        return true;
    }

    /**
     * x权限规则分类分组信息
     * authItemInfo service.
     *
     * @return mixed.
     */
    public function authItemInfo()
    {
       // $dataInfo = AuthItem::find()->where(['not lik', 'name', ['rbac/', 'rbac/']])->asArray()->all();
        $dataInfo = AuthItem::find()->where(['type' => 2])->asArray()->all();
        if (!empty($dataInfo)) {
            $res = $this->getByTree($dataInfo, 0);
        }
        return $res;
    }

    /**
     * x获取权限树形列表
     *
     * @param array $data 原始数据.
     * @param integer $pid 父级id.
     *
     * @return mixed.
     */
    protected function getByTree($data, $pid)
    {
        $res = [];
        if (!empty($data)) {
            foreach ($data as $value) {
                if ($value['parent_id'] == $pid) {
                    $res[] = [
                        'id' => $value['id'],
                        'route' => $value['name'],
                        'label' => $value['description'],
                        'rule_name' => $value['rule_name'],
                        'children' => $this->getByTree($data, $value['id']),
                    ];
                }
            }
        }
        return $res;
    }

    /**
     * x获取权限规则id=>名称
     * authItemInfo service.
     *
     * @return mixed.
     */
    public function getAllAuthItemInfo()
    {
        $res = [];
        $dataInfo = AuthItem::find()->asArray()->all();
        if (!empty($dataInfo)) {
            foreach ($dataInfo as $key => $value) {
                $res[$key] = [
                    'id' => $value['id'],
                    'name' => $value['description'],
                ];
            }
        }
        return $res;
    }
}
