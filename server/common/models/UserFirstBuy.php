<?php

namespace common\models;

use Yii;
use yii\base\Model;
use yii\db\Expression;
use common\helpers\HashidsHelper;
use common\helpers\RandName;
use yii\web\IdentityInterface;
use Lcobucci\JWT\Signer\Hmac\Sha256;
use yii\web\Cookie;

/**
 * ContactForm is the model behind the contact form.  后台账号登录信息 。
 */
class UserFirstBuy extends BaseModel
{

    protected $table = 't_user_first_buy';

    public static function tableName()
    {
        return '{{t_user_first_buy}}';
    }

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
            ['id', 'number'], //用户id
            ['uid', 'number'], //账号
            ['money', 'number'], //初次用户基金
            ['next_reward_time', 'number'], //下次发放时间
            ['reward_count', 'number'], //已发放次数
            ['itime', 'number'], //角色
            ['utime', 'number'], //权限 。2超级管理员 。3管理员
        ];
    }

}