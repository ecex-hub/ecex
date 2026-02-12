<?php

namespace common\models\Rbac;

use common\models\UserMemberForm;
use Yii;
use yii\db\ActiveRecord;
use yii\behaviors\TimestampBehavior;

/**
 * This is the model class for table "auth_assignment".
 *
 */
class AuthAssignment extends ActiveRecord
{
    protected $table = 't_auth_assignment';

    /**
     * 用户与权限（角色）的分配表:auth_assignment
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{t_auth_assignment}}';
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
            ['item_name', 'string'], //权限路由或者角色
            ['user_id', 'string'], //id
            ['created_at', 'number'], //创建时间
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [
            'timestamp'=>[
                'class'=>TimestampBehavior::className(),
                'attributes'=>[
                    ActiveRecord::EVENT_BEFORE_INSERT => ['created_at'],
                ]
            ]
        ];
    }


    /**
     * x分配管理员 权限/角色
     * addAuthItem .
     * @param string $admin_id 管理员id.
     * @param string $role 角色.
     * @param array  $authItem 权限路由集合.
     *
     * @return mixed.
     */
    public function allotAuthAssignment($admin_id, $role, $authItem = [])
    {
//        $transaction = AuthAssignment::getDb()->beginTransaction();
//        try {
            $authAssignment = new AuthAssignment();
            if (!empty($role)) {
                $where = [
                    'and',
                    ['not like', 'item_name', '/'],
                    ['user_id' => $admin_id],
                ];
                AuthAssignment::deleteAll($where);
                $authAssignment->user_id = $admin_id;
                $authAssignment->item_name = $role;
                UserMemberForm::updateAll(['role' => $role], ['_id' => $admin_id]);
                if (!$authAssignment->save()) {
                    $errs = $authAssignment->getFirstErrors();
                    if (!empty($errs) && is_array($errs)) {
                        $it = array_shift($errs);
                        throw new \Exception($it, 70002);
                    }
                }
            }
            if (!empty($authItem) && is_array($authItem)) {
                $where = [
                    'and',
                    ['like', 'item_name', '/'],
                    ['user_id' => $admin_id],
                ];
                AuthAssignment::deleteAll($where);
                $time = time();
                foreach ($authItem as $k => $v) {
                    if (!empty($v)) {
                        $data[$k] = [$v, $admin_id, $time];
                    }
                }
                if (!empty($data)) {
                    Yii::$app->db->createCommand()->batchInsert('admindata.t_auth_assignment', ['item_name', 'user_id', 'created_at'], $data)->execute();
                }
            }
//            $transaction->commit();
//        } catch (\Exception $e) {
//            $transaction->rollBack();
//            throw  $e;
//        } catch (\Throwable $e) {
//            $transaction->rollBack();
//            throw  $e;
//        }
        return true;
    }

    /**
     * x获取管理员 拥有权限
     * getAdminAuthItem service.
     * @param string $admin_id 管理员id.
     * @param string $role 管理员角色.
     * @return mixed.
     */
    public static function getAdminAuthItem($admin_id, $role = '')
    {
        $userAuthItem = []; //管理员拥有权限集合
        $authAssignment = AuthAssignment::find()->where(['user_id' => $admin_id])->asArray()->all();
        if (!empty($authAssignment)) {
            $item_name = array_column($authAssignment, 'item_name');
        } else {
            $item_name = [];
        }
        if (!empty($role)) {
            $data = AuthItemChild::find()->where(['=', 'parent', $role])->asArray()->all();
        } else {
            $data = AuthItemChild::find()->where(['in', 'parent', $item_name])->asArray()->all();
        }
        if (!empty($data)) {
            $child = array_column($data, 'child');
            $parent = array_column($data, 'parent');
            $userAuthItem = array_unique(array_merge_recursive($child, array_diff($item_name, $parent)));
            $userAuthItem = array_values($userAuthItem);
        } else {
            $userAuthItem = $item_name;
        }

        return $userAuthItem;
    }

    /**
     * 验证管理员 拥有权限
     * verifyPermissions.
     * @param string $permission 请求路由.
     * @param string $admin_id 管理员id.
     * @param string $role 管理员角色.
     * @return mixed.
     */
    public static function verifyPermissions($permission, $admin_id, $role = '') {

        $authAssignment = self::getAdminAuthItem($admin_id, $role);
        $accessAllow = Yii::$app->params['accessAllow'];
        if (in_array('/' . $permission, $authAssignment) || in_array('/' . $permission, $accessAllow) || in_array($permission, $authAssignment) || in_array($permission, $accessAllow)) {
            return true;
        }
        return false;
    }
}
