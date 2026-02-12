<?php

namespace common\models;

use phpDocumentor\Reflection\DocBlock\Tags\Var_;
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
class UserFundMonth extends BaseModel
{

    protected $table = 't_user_fund_month';

    public static function tableName()
    {
        return '{{t_user_fund_month}}';
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
            ['income', 'number'], //密码  md5
            ['day', 'string'], //名称
            ['itime', 'number'], //角色
            ['utime', 'number'], //权限 。2超级管理员 。3管理员
        ];
    }

    public function getOne($uid, $month)
    {
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'day', $month],
        ];
        $info = $this->find()
            ->select(['id'])
            ->where($where)
            ->one();
        return $info;
    }
}