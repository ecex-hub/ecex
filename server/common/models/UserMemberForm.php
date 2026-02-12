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
class UserMemberForm extends BaseModel implements IdentityInterface {

    protected $table = 't_user_member';

    public static function tableName() {
        return '{{t_user_member}}';
    }

    public static function getDb() {
        return Yii::$app->get('db');
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //用户id
            ['account', 'string'], //账号
            ['password', 'string'], //密码  md5
            ['username', 'string'], //名称
            ['role', 'string'], //角色
            ['authority', 'number'], //权限 。2超级管理员 。3管理员
            ['type', 'number'], //状态 1启用 。2关闭
            ['jwtToken', 'string'], //登录凭证
            ['apiSecret', 'string'], //登录凭证
            ['auth_key', 'string'], //登录凭证
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * {@inheritdoc}
     */
    public static function findIdentity($id) {
        return static::findOne(['id' => $id]);
    }

    /**
     * {@inheritdoc}
     */
    public function getAuthKey() {
        return $this->auth_key;
    }

    /**
     * @inheritdoc
     * 用以标识 Yii::$app->user->id 的返回值
     */
    public function getId() {
        return $this->getPrimaryKey();
    }

    /**
     * {@inheritdoc}
     */
    public function validateAuthKey($authKey) {
        return $this->getAuthKey() === $authKey;
    }

    /**
     * {@inheritdoc} 验证登录
     */
    public static function findIdentityByAccessToken($token, $type = null) {
        $jwtToken = Yii::$app->jwt->loadToken($token, true, false);
        if (empty($jwtToken)) {
            return null;
        }

        $uid = $jwtToken->getClaim('id');
        $vip = self::find()->asArray()->select([])->where(['id' => $uid])
                ->one();
        $auth_key_data = VipLoginInfoAdmin::find()->asArray()->select([])->where(['vip_id' => $uid, 'login_type' => $type])
                ->one();
        if (empty($vip)) {
            return null;
        }
        $authKey = $auth_key_data['auth_key'];
        Yii::$app->jwt->key = $authKey;
        if (empty(Yii::$app->jwt->key)) {
            return null;
        }
        if (!Yii::$app->jwt->verifyToken($jwtToken)) {
            return null;
        } else {
            $vipModel = new self;
            $vipModel->setAttributes($vip);
            $vipModel->jwtToken = $jwtToken;
            $vipModel->apiSecret = $auth_key_data['api_secret'];
            return $vipModel;
        }
    }

    /**
     * 生成jwt token
     * @param VipInfo $vip
     * @param $authKey string authKey
     * @return Token
     */
    public static function generateJwtToken($vip, $authKey) {
        /**
         * @var Builder $builder
         */
        $builder = Yii::$app->jwt->getBuilder();
        return $builder
                        ->setIssuer('db')
                        ->setIssuedAt(time())
                        ->set('id', $vip->id)
                        ->sign(new Sha256(), $authKey)
                        ->getToken();
    }

    /**
     * 验证密码算法正确  md5
     * @return type
     */
    public static function provingAccountInfoPasswordExactness($account, $password) {
        $data = self::find()->where(['account' => $account, 'type' => 1])->one();
        $passwordOriginal = md5($password); //加密

        if (!empty($data['password']) && $data['password'] == $passwordOriginal) {
            return $data;
        }
        return false;
    }

    /**
     * 用户登录
     * @param type $identity
     * @param type $loginType
     * @param type $cookie_name
     * @return type
     */
    public function login($identity, $loginType, $cookie_name = 'frontend_token') {
        $authKey = Yii::$app->security->generateRandomString();
        $apiSecret = Yii::$app->security->generateRandomString();

        $loginInfo = VipLoginInfoAdmin::findOne(['vip_id' => $identity->id, 'login_type' => $loginType]);
        if (empty($loginInfo)) {
            $data = VipLoginInfoAdmin::addData([
                        'vip_id' => $identity->id,
                        'login_type' => $loginType,
                        'login_count' => 1,
                        'auth_key' => $authKey,
                        'api_secret' => $apiSecret,
                        'itime' => time(),
                        'utime' => time(),
            ]);
        } else {
            //更新authKey 和accessToken
            $data = VipLoginInfoAdmin::updateAll(['auth_key' => $authKey, 'api_secret' => $apiSecret, 'utime' => time(), 'login_count' => new Expression('login_count+1')], ['vip_id' => $identity->id, 'login_type' => $loginType]);
        }
        //生成jwt token
        $token = self::generateJwtToken($identity, $authKey);
        //self::findIdentityByAccessToken(strval($token), 1);
        $identity->jwtToken = $token;
        $identity->apiSecret = $apiSecret;
        $boor = Yii::$app->user->login($identity, 3600 * 24); //5小时
        if (!empty($boor)) {
            return $apiSecret;
        }
        return false;
    }

    /**
     * 注册账号
     * @param type $account     账号 手机号
     * @param type $password    密码
     * @return boolean
     */
    public function addAccount($account, $password, $authority = 2) {

        $existData = $this->find()->where(['account' => $account])->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['211', '账号已经存在']);
            return false;
        }

        $password = md5($password);
        $rote = 'admin';
        if ($authority == 3) {
            $rote = 'admin3';
        }
        $data = [
            'account' => $account, //账号
            'password' => $password, //密码  md5
            'username' => $account, //名称
            'authority' => $authority,
            'role' => $rote, //角色
            'type' => 1, //
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if (!empty($boor)) {
                return true;
            } else {
                $this->addError('mesg', ['212', '注册失败']);
                return false;
            }
        }
        $this->addError('mesg', ['212', '注册数据失败']);
        return false;
    }

    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getAccountDataMessage($id) {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }

    /**
     * 修改密码
     * @param type $uid
     * @param type $oldPassword
     * @param type $newPassword
     * @return boolean
     */
    public function modifyAccountPassword($uid, $oldPassword, $newPassword) {
        if ($oldPassword == $newPassword) {
            $this->addError('mesg', ['212', '新旧密码不能相同']);
            return false;
        }

        $boor = $this->provingAccountIdPasswordExactness($uid, $oldPassword);
        if (!$boor) {
            $this->addError('mesg', ['212', '原密码错误']);
            return false;
        }
        $password = md5($newPassword);
        $boor = $this->updateAll(['password' => $password], ['id' => $uid]);

        if ($boor) {
            return true;
        } else {
            $this->addError('mesg', ['212', '修改失败']);
            return false;
        }
    }

    /**
     * 验证密码算法正确  md5
     * @return type
     */
    public function provingAccountIdPasswordExactness($uid, $password) {
        $data = $this->find()->where(['id' => $uid])->asArray()->one();
        $passwordOriginal = md5($password); //加密

        if (!empty($data['password']) && $data['password'] == $passwordOriginal) {
            return $data;
        }
        return false;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getUserMemberFormList($page = 1, $limit = 10, $fields = [], $account) {
        $where = [
            'and',
            ['=', 'type', 1]
        ];
        if (!empty($account))
            $where[] = ['=', 'account', $account];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

    /**
     * 修改数据
     * @param type $id
     * @param type $password
     * @param type $type
     * @return boolean
     */
    public function UpdateDataMessage($id, $password, $type) {
        $update = [];
        if (!empty($password)) {
            $update['password'] = md5($password);
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (empty($update)) {
            $this->addError('mesg', ['212', '修改数据不能为空']);
            return false;
        }
        $boor = $this->updateAll($update, ['id' => $id]);
        if (!empty($boor)) {
            return true;
        }
        $this->addError('mesg', ['212', '修改失败']);
        return false;
    }

}
