<?php

namespace common\models\Rbac;

use Yii;
use yii\db\ActiveRecord;

/**
 * This is the model class for table "auth_assignment".
 *
 */
class AuthItemChild extends ActiveRecord
{
    /*
     *  权限和角色的上下级关联表:auth_item_child
     *  (包含关系：角色 可以包含 角色、角色 可以包含 权限、权限 可以包含 权限，但 权限 不可包含 角色)
    */

    protected $table = 't_auth_item_child';

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{t_auth_item_child}}';
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
            ['parent', 'string'], //角色
            ['parent', 'unique', 'message' => '该角色已存在'], //
            ['child', 'string'], //权限路由或者角色
        ];
    }

    /**
     * x给角色 分配权限
     * addAuthItem .
     * @param string $parent 角色.
     * @param array  $authItem 权限路由集合/角色.
     *
     * @return mixed.
     */
    public function allotAuthItem($parent, $authItem = [])
    {
//        $transaction = AuthItemChild::getDb()->beginTransaction();
//        try {
            if (!empty($authItem) && is_array($authItem)) {
                AuthItemChild::deleteAll(['parent' => $parent]);
                foreach ($authItem as $k => $v) {
                    if (!empty($v)) {
                        $data[$k] = [$parent, $v];
                    }
                }
                if (!empty($data)) {
                    Yii::$app->db->createCommand()->batchInsert('admindata.t_auth_item_child', ['parent', 'child'], $data)->execute();
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
     * x角色拥有权限
     * getRoleAuthItem service.
     * @param string $role 角色.
     * @return mixed.
     */
    public static function getRoleAuthItem($role)
    {
        $userAuthItem = []; //管理员拥有权限集合
        $dataInfo = self::find()->where(['parent' => $role])->asArray()->all();
        if (!empty($dataInfo)) {
            $userAuthItem = array_column($dataInfo, 'child');
        }
        return $userAuthItem;
    }
}
