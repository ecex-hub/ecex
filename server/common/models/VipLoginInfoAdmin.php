<?php

namespace common\models;

use Yii;

/**
 * This is the model class for table "t_vip_last_login_info".
 *
 * @property int $vip_id
 * @property int $login_type 登录类型
 * @property int $last_logout 上传退出时间
 * @property int $login_count 登录次数
 * @property int $itime 创建时间
 * @property int $utime 更新时间
 */
class VipLoginInfoAdmin extends BaseModel
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 't_vip_login_info_admin';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['vip_id', 'login_type'], 'required'],
            [['vip_id', 'login_type', 'last_logout', 'login_count', 'itime', 'utime'], 'integer'],
            [['vip_id', 'login_type'], 'unique', 'targetAttribute' => ['vip_id', 'login_type']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'vip_id' => 'Vip ID',
            'login_type' => 'Login Type',
            'last_logout' => 'Last Logout',
            'login_count' => 'Login Count',
            'itime' => 'Itime',
            'utime' => 'Utime',
        ];
    }
    static public function getEndLoginTime($_id){
        return self::find()->asArray()->where(['vip_id'=>$_id])->one();
    }
    
}
