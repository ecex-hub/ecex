<?php

namespace common\models;

use common\components\FuncHelper;
use common\helpers\RedisHelper;
use Yii;
use yii\db\Expression;
use yii\web\IdentityInterface;

class AccountInfo extends BaseModel implements IdentityInterface
{

    protected $table = 't_account_info';

    public static function tableName()
    {
        return '{{t_account_info}}';
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
            ['uid', 'number'], //用户id
            ['e_uid', 'string'], //用户别名
            ['account', 'string'], //账号
            ['password', 'string'], //密码  md5
            ['payPassword', 'string'], //支付密码  md5
            ['nickname', 'string'], //名称
            ['avatar', 'string'], //头像
            ['rechargeAllMoney', 'number'], //充值总金额
            ['withdrawalAllMoney', 'number'], //提现总金额
            ['accountIncome', 'number'], //总收入
            ['invite_code', 'string'], //邀请码
            ['is_real', 'number'], //真人认证

            //钱
            ['money', 'number'], //余额
            ['buy_product_money', 'number'], //购买产品总金额
            ['pay_back', 'number'], //回报基金
            ['allowance', 'number'], //津贴基金
            ['dream_fund', 'number'], //圆梦基金


            //上级
            ['path', 'string'], //用户路径
            ['oneLevel', 'number'], //一级上级
            ['twoLevel', 'number'], //二级上级
            ['threeLevel', 'number'], //三级上级
            ['oneIncome', 'number'], //一级总收益
            ['twoIncome', 'number'], //二级总收益
            ['threeIncome', 'number'], //三级总收益
            ['oneSharePeople', 'number'], //一级总人数
            ['twoSharePeople', 'number'], //二级总人数
            ['threeSharePeople', 'number'], //三级总人数
            //签到
            ['oneReward', 'number'], //累积奖励等级1剩余次数
            ['twoReward', 'number'], //累积奖励等级2剩余次数
            ['threeReward', 'number'], //累积奖励等级3剩余次数

            //身份证信息
            ['realName', 'string'], //姓名
            ['IDCard', 'string'], //身份证号
            ['IDFrontUrl', 'string'], //身份证正面 国徽
            ['IDOppositeUrl', 'string'], //身份证反面 人像

            ['qq', 'string'], //qq
            ['wechat', 'string'], //微信
            //状态
            ['RegisterIp', 'string'], //注册ip
            // 注意：login_ip 和 last_login_time 不在 rules 中定义，因为它们可能不存在于数据库表中
            // 这些字段只在登录时通过 updateAll 更新，不需要在 rules 中定义
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];


    public static function selectColumn()
    {
        return self::$key;
    }

    /**
     * {@inheritdoc}
     */
    public static function findIdentity($id)
    {
        return static::findOne(['uid' => $id]);
    }

    /**
     * {@inheritdoc}
     */
    public function getAuthKey()
    {
        return "";
    }

    /**
     * @inheritdoc
     * 用以标识 Yii::$app->user->id 的返回值
     */
    public function getId()
    {
        return $this->getPrimaryKey();
    }

    /**
     * {@inheritdoc}
     */
    public function validateAuthKey($authKey)
    {
        return "";
    }

    /**
     * {@inheritdoc} 验证登录
     */
    public static function findIdentityByAccessToken($token, $type = null)
    {
    }

    /**
     * 验证密码算法正确  md5
     * @return type
     */
    public static function provingAccountInfoPasswordExactness($account, $password)
    {
        $data = self::find()->where(['account' => $account])->one();
        $passwordOriginal = md5($password); //加密
        if (!empty($data['password']) && $data['password'] == $passwordOriginal) {
            return $data;
        }
        return false;
    }

    public function getAccountInfo($uid)
    {
        $data = self::find()->where([
            'uid' => $uid,
        ])->asArray()->one();
        return $data;
    }

    /**
     * 生成唯一的6位邀请码（数字和字母）
     * @return string
     */
    private function generateUniqueInviteCode()
    {
        $maxAttempts = 100; // 最大尝试次数，避免无限循环
        $attempts = 0;
        
        do {
            // 生成6位随机字符串（包含数字和大写字母）
            //$characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
            $characters = '0123456789';
            $inviteCode = '';
            for ($i = 0; $i < 6; $i++) {
                $inviteCode .= $characters[rand(0, strlen($characters) - 1)];
            }
            
            // 检查数据库中是否已存在
            $exists = $this->find()
                ->where(['invite_code' => $inviteCode])
                ->exists();
            
            $attempts++;
            
            // 如果尝试次数过多，抛出异常
            if ($attempts >= $maxAttempts) {
                throw new \Exception('生成唯一邀请码失败，请稍后重试');
            }
        } while ($exists);
        
        return $inviteCode;
    }


    /**
     * 用户登录
     * @param type $identity
     * @param type $loginType
     * @param type $cookie_name
     * @return type
     */
    public function login($identity, $sendIp)
    {
        $this->updateAll([
            'login_ip' => $sendIp,
            'last_login_time' => time(),
        ], ['uid' => $identity->uid]);
        $accessToken = RedisHelper::getTokenByUid($identity->uid);
        return $accessToken;
    }

    /**
     * 注册账号
     * @param type $account 账号 手机号
     * @param type $password 密码
     * @return boolean
     */
    public function RegisterAccount(
        $account, $password, $inviteCode, $sendIp = null, $nickname, $idCard, $payPassword = null)
    {
        // 验证账号格式（支持手机号或其他形式的账号）
        // 账号长度：3-50位，允许字母、数字、下划线
        if (strlen($account) < 3 || strlen($account) > 50) {
            $this->addError('mesg', ['211', '账号长度为3-50位']);
            return false;
        }
        if (!preg_match('/^[a-zA-Z0-9_]+$/', $account)) {
            $this->addError('mesg', ['211', '账号只能包含字母、数字和下划线']);
            return false;
        }
        $existData = $this->find()
            ->where(['account' => $account])
            ->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['211', '账号已经存在']);
            return false;
        }
        //ip限制
        //  $ipCount = $this->find()
        //      ->where(['RegisterIp' => $sendIp])
        //      ->count();
        //  if ($ipCount > 5) {
        //      $this->addError('mesg', ['211', '该ip最多注册5个账号']);
        //      return false;
        //  }
        if ($inviteCode && $inviteCode != "WK7958") {
            // 直接从 AccountInfo 表中验证邀请码（因为 t_invite 表不存在）
            $inviteUser = $this->find()
                ->where(['invite_code' => $inviteCode])
                ->asArray()
                ->one();
            if (empty($inviteUser)) {
                $this->addError('mesg', ['212', '邀请码错误，请联系客服']);
                return false;
            }
            $existLevelData = $this->getAccountInfo($inviteUser['uid']);
            if (empty($existLevelData)) {
                $this->addError('mesg', ['212', '邀请码对应用户异常']);
                return false;
            }
        }
        $avatarArr = [
            1 => '/uploads/1.png',
            2 => '/uploads/2.png',
            3 => '/uploads/3.png',
            4 => '/uploads/4.png',
        ];
        $randomKey = array_rand($avatarArr);
        $randomImage = $avatarArr[$randomKey];
        $password = md5($password);
        // 处理交易密码
        $payPasswordHash = null;
        if (!empty($payPassword)) {
            $payPasswordHash = md5($payPassword);
        }
        $data = [
            'account' => $account, //账号
            'password' => $password, //密码  md5
            'nickname' => !empty($nickname) ? $nickname : $account, //名称，如果为空则使用账号
            'avatar' => $randomImage, //头像
            'money' => 0, //余额
            'IDCard' => $idCard, //身份证号
            'oneIncome' => 0, //一级总收益
            'twoIncome' => 0, //二级总收益
            'threeIncome' => 0, //三级总收益
            'oneSharePeople' => 0, //一级总人数
            'twoSharePeople' => 0, //二级总人数
            'threeSharePeople' => 0, //三级总人数
            'investAllMoney' => 0, //投资总金额
            'RegisterIp' => $sendIp, //注册IP
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
            'invite_code' => $this->generateUniqueInviteCode(), //生成唯一的6位邀请码
            // 注意：login_ip 和 last_login_time 在登录时设置，不在注册时设置
        ];
        // 如果提供了交易密码，则添加到数据中
        if (!empty($payPasswordHash)) {
            $data['payPassword'] = $payPasswordHash; //支付密码 md5
        }
        if (isset($existLevelData)) {
            $data['oneLevel'] = $existLevelData['uid'];  //一级上级
            $data['twoLevel'] = $existLevelData['oneLevel']; //二级上级
            $data['threeLevel'] = $existLevelData['twoLevel']; //三级上级
            if ($existLevelData['path'] == '') {
                $data['path'] = $existLevelData['uid'] . ",";
            } else {
                $data['path'] = $existLevelData['path'] . $existLevelData['uid'] . ',';
            }
        }
        // 开始一个事务
        $transaction = Yii::$app->db->beginTransaction();
        try {
            // 直接尝试保存，不使用 insertData，以便获取详细错误信息
            $this->attributes = $data;
            if (!$this->validate()) {
                $errors = $this->getErrors();
                $errorMsg = '数据验证失败';
                if (!empty($errors)) {
                    $errorMessages = [];
                    foreach ($errors as $field => $fieldErrors) {
                        if (is_array($fieldErrors)) {
                            $errorMessages = array_merge($errorMessages, $fieldErrors);
                        } else {
                            $errorMessages[] = $fieldErrors;
                        }
                    }
                    if (!empty($errorMessages)) {
                        $errorMsg = implode('; ', $errorMessages);
                    }
                }
                throw new \Exception($errorMsg);
            }
            if (!$this->save(false)) {
                $errors = $this->getErrors();
                $errorMsg = '保存数据失败';
                if (!empty($errors)) {
                    $errorMessages = [];
                    foreach ($errors as $field => $fieldErrors) {
                        if (is_array($fieldErrors)) {
                            $errorMessages = array_merge($errorMessages, $fieldErrors);
                        } else {
                            $errorMessages[] = $fieldErrors;
                        }
                    }
                    if (!empty($errorMessages)) {
                        $errorMsg = implode('; ', $errorMessages);
                    }
                }
                throw new \Exception($errorMsg);
            }
            $uid = $this->uid;
            // 提交事务
            $transaction->commit();
            if (isset($existLevelData)) {
                //获取用户第一级别
                if ($existLevelData['uid']) {
                    $bool = $this->updateAll([
                        'oneSharePeople' => new Expression('oneSharePeople+' . 1)
                    ], ['uid' => $existLevelData['uid']]);
                }
                //获取用户第二级别。
                if ($existLevelData['oneLevel']) {
                    $bool = $this->updateAll([
                        'twoSharePeople' => new Expression('twoSharePeople+' . 1)
                    ], ['uid' => $existLevelData['oneLevel']]);
                }
                //获取用户第三级别。
                if ($existLevelData['twoLevel']) {
                    $bool = $this->updateAll([
                        'threeSharePeople' => new Expression('threeSharePeople+' . 1)
                    ], ['uid' => $existLevelData['twoLevel']]);
                }
            }
            return $uid;
        } catch (\Exception $e) {
            $transaction->rollBack();
            $errorMessage = $e->getMessage();
            FuncHelper::ErrLog('register', $data, $errorMessage);
            // 使用异常中的具体错误信息
            $this->addError('mesg', ['212', $errorMessage ?: '注册失败']);
            return false;
        }
    }


    //邀请好友
    public function makeInviteUser($uid, $inviteUid)
    {
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $bool = $this->updateAll([
                'pay_back' => new Expression('pay_back+' . 2),
                'oneSharePeople' => new Expression('oneSharePeople+' . 1)
            ], ['uid' => $inviteUid]);
            if (!$bool) {
                throw new \Exception('Failed to save bill record');
            }
            $billData = [
                'uid' => $inviteUid,
                'money' => 2,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeInvite,
                'ext_id' => $uid,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $transaction->commit();
        } catch (\Exception $e) {
            FuncHelper::ErrLog('register_invite', [
                'invite' => $inviteUid
            ], $e->getMessage());
            $transaction->rollBack();
        }

    }


    public static function getAccountDataMessage($id)
    {
        $data = self::find()->where(['uid' => $id])->asArray()->one();
        return $data;
    }


    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getAccountListDataMessage($id)
    {
        $where = [
            'and',
            ['in', 'uid', $id]
        ];
        $data = self::find()->where($where)->asArray()->all();
        return $data;
    }

    /**
     * 获取单条信息  按照账号
     * @param type $id
     * @return type
     */
    public static function getAccountDataMessageMoebile($account)
    {
        $data = self::find()->where(['account' => $account])->asArray()->one();
        return $data;
    }

    /**
     * 修改密码
     * @param type $uid
     * @param type $oldPassword
     * @param type $newPassword
     * @return boolean
     */
    public function modifyAccountPassword($user,
                                          $oldPassword, $newPassword, $qq, $wechat)
    {
        $uid = $user->uid;
        if ($oldPassword) {
            if ($user->password != md5($oldPassword)) {
                $this->addError('mesg', ['212', '原密码错误']);
                return false;
            }
            if ($oldPassword == $newPassword) {
                $this->addError('mesg', ['212', '新旧密码不能相同']);
                return false;
            }
            $password = md5($newPassword);
            $boor = $this->updateAll(['password' => $password], ['uid' => $uid]);
        } else {
            $data = [];
            if ($qq) {
                $data['qq'] = $qq;
            }
            if ($wechat) {
                $data['wechat'] = $wechat;
            }
            $boor = $this->updateAll($data, ['uid' => $uid]);
            //第一次
            if (empty($user['qq']) && empty($user['wechat']) && $boor) {
                $this->makeSocial($uid);
            }
        }
        if ($boor) {
            return true;
        } else {
            $this->addError('mesg', ['212', '修改失败']);
            return false;
        }
    }

    public function makeSocial($uid)
    {
        $money = 2;
        // 开始一个事务
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $boor = $this->updateAll([
                'pay_back' => new Expression('money+' . $money),
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('update to save user');
            }
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeBindSocial,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            // 提交事务
            $transaction->commit();
            return true;
        } catch (\Exception $e) {
            $transaction->rollBack();
            FuncHelper::ErrLog('social', [
                'uid' => $uid,
            ], $e->getMessage());
            $this->addError('mesg', ['212', '兑换失败']);
            return false;
        }
    }

    public function getTeamList($uid, $level, $page, $size, $keywords)
    {
        $fields = ['uid', 'account', 'nickname', 'itime', 'buy_product_money', 'path'];
        if ($level == 1) {
            $where = [
                'and',
                ['=', 'oneLevel', $uid],
            ];
            if ($keywords) {
                $where[] = [
                    'or',
                    ['like', 'account', $keywords],
                    ['like', 'nickname', $keywords],
                ];
            }
            $list = $this->listFind(['page' => $page, 'row' => $size])
                ->select($fields)
                ->where($where)
                ->orderBy("buy_product_money desc")
                ->orderBy("itime desc")
                ->asArray()->all();
        } else if ($level == 2) {
            $where = [
                'and',
                ['=', 'twoLevel', $uid],
            ];
            if ($keywords) {
                $where[] = [
                    'or',
                    ['like', 'account', $keywords],
                    ['like', 'nickname', $keywords],
                ];
            }
            $list = $this->listFind(['page' => $page, 'row' => $size])
                ->where($where)
                ->asArray()
                ->all();
        } else {
            $where = [
                'and',
                ['=', 'threeLevel', $uid],
            ];
            if ($keywords) {
                $where[] = [
                    'or',
                    ['like', 'account', $keywords],
                    ['like', 'nickname', $keywords],
                ];
            }
            $list = $this->listFind(['page' => $page, 'row' => $size])
                ->where($where)
                ->asArray()
                ->all();
        }
        return $list;
    }


    public function getTeamCount($uid, $level, $keywords)
    {
        $fields = ['uid', 'account', 'nickname', 'itime', 'buy_product_money'];
        if ($level == 1) {
            $where = [
                'and',
                ['=', 'oneLevel', $uid],
            ];
            if ($keywords) {
                $where[] = [
                    'or',
                    ['like', 'account', $keywords],
                    ['like', 'nickname', $keywords],
                ];
            }
            $list = $this->find()
                ->where($where)
                ->count();
        } else if ($level == 2) {
            $where = [
                'and',
                ['=', 'twoLevel', $uid],
            ];
            if ($keywords) {
                $where[] = [
                    'or',
                    ['like', 'account', $keywords],
                    ['like', 'nickname', $keywords],
                ];
            }
            $list = $this->find()
                ->where($where)
                ->count();
        } else {
            $where = [
                'and',
                ['=', 'threeLevel', $uid],
            ];
            if ($keywords) {
                $where[] = [
                    'or',
                    ['like', 'account', $keywords],
                    ['like', 'nickname', $keywords],
                ];
            }
            $list = $this->find()
                ->where($where)
                ->count();
        }
        return $list;
    }

    public function getTeamRegisterNum($uid, $path)
    {
        if ($path == "") {
            $path = $uid . "," . "%";
        } else {
            $path = $path . $uid . "," . "%";
        }
        $map = ['like', 'path', $path, false];
        $count = $this->find()
            ->where($map)->count();
        return $count;
    }


    public function getTeamBuyMoney($uid)
    {
        $a = $this->find()
            ->where(["oneLevel" => $uid])
            ->sum("buy_product_money");
        $b = $this->find()
            ->where(["twoLevel" => $uid])
            ->sum("buy_product_money");
        $c = $this->find()
            ->where(["threeLevel" => $uid])
            ->sum("buy_product_money");
        $money = bcadd($a, $b, $c);
        return $money;
    }

    /**
     * 修改支付密码
     * @param type $uid
     * @param type $oldPassword
     * @param type $newPassword
     * @return boolean
     */
    public function modifyAccountPayPassword($user, $oldPassword, $newPassword)
    {
        $password = md5($newPassword);
        if ($user->payPassword) {
            if ($user['payPassword'] != md5($oldPassword)) {
                $this->addError('mesg', ['212', '原始密码有误']);
                return false;
            }

            if ($oldPassword == $newPassword) {
                $this->addError('mesg', ['212', '不能和原密码相同']);
                return false;
            }
        }
        $boor = $this->updateAll(['payPassword' => $password], ['uid' => $user->uid]);
        if ($boor) {
            return true;
        } else {
            $this->addError('mesg', ['212', '修改失败']);
            return false;
        }
    }

    public function addInvitePayBack($uid, $userProductId, $money, $level)
    {
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeInvitePayBack,
                'ext_id' => $userProductId,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $accountData = [
                'pay_back' => new Expression('pay_back+' . $money)
            ];
            if ($level == 1) {
                $accountData['oneIncome'] = new Expression('oneIncome+' . $money);
            }
            if ($level == 2) {
                $accountData['twoIncome'] = new Expression('twoIncome+' . $money);
            }
            if ($level == 3) {
                $accountData['threeIncome'] = new Expression('threeIncome+' . $money);
            }
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll($accountData, ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('invite_pay_back', [
                'uid' => $uid,
                'money' => $money,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        return false;
    }


    /**
     * 增加用户充值提现总金额
     * @param type $uid
     * @param type $type
     * @return boolean
     */
    public function addAccountRechargeWithdrawalAllMoney($uid, $money, $type)
    {

        if ($type == 1) {
            $boor = $this->updateAll([
                'rechargeAllMoney' => new Expression('rechargeAllMoney+' . $money)],
                ['uid' => $uid]);
        } else if ($type == 2) {
            $boor = $this->updateAll([
                'withdrawalAllMoney' => new Expression('withdrawalAllMoney+' . $money)],
                ['uid' => $uid]);
        }

        if ($boor) {
            return true;
        }
        $this->addError('mesg', ['212', '增加失败']);
        return false;
    }


    /**
     * 更新用户身份证信息
     * @param type $uid
     * @param type $realName
     * @param type $IDCard
     * @param type $IDFrontUrl
     * @param type $IDOppositeUrl
     * @param type $IDHandUrl
     * @return boolean
     */
    public function updateAccountIDCard($user, $realName, $IDCard, $IDFrontUrl, $IDOppositeUrl)
    {
        $uid = $user->id;
        $IDCardType = FuncHelper::checkIDCard($IDCard);
        if (!$IDCardType) {
            $this->addError('mesg', ['212', '身份证号码格式不正确']);
            return false;
        }
        $where = [
            'and',
            ['=', 'IDCard', $IDCard],
            ['in', 'type', [1, 2]],
        ];
        $real = new Real();
        $existData = $real->find()
            ->where($where)
            ->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '该身份证已提交']);
            return false;
        }
        $where1 = [
            'and',
            ['=', 'uid', $uid],
            ['in', 'type', [1, 2]],
        ];
        $real = new Real();
        $existData = $real->find()
            ->where($where1)
            ->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '身份证已提交或者已通过审核']);
            return false;
        }
        $data = [
            'uid' => $uid,
            'realName' => $realName,
            'IDCard' => $IDCard,
            'IDFrontUrl' => $IDFrontUrl,
            'IDOppositeUrl' => $IDOppositeUrl,
            'type' => 1,
            'itime' => time(),
            'utime' => time()
        ];
        $boor = $real->insertData($data);
        if ($boor) {
            $this->updateAll(["is_real" => 1], ['uid' => $uid]);
            return true;
        }
        $this->addError('mesg', ['212', '修改失败']);
        return false;
    }


    /**
     * 获取指定日期注册人数
     * @param type $date
     * @return type
     */
    static public function getRegisterNumber($date)
    {
        $time = strtotime($date);
        //注册
        $where = [
            'and',
            ['>', 'itime', $time],
            ['<', 'itime', $time + 86400]
        ];
        $data['register_day_number'] = self::find()->where($where)->count() ?? 0;
        $where = [
            'and',
            ['>', 'itime', $time - 86400],
            ['<', 'itime', $time]
        ];
        $data['register_yesterday_number'] = self::find()->where($where)->count() ?? 0;
        $data['register_all_number'] = self::find()->count() ?? 0;
        //有效
        $where = [
            'and',
            ['>', 'itime', $time],
            ['<', 'itime', $time + 86400],
            ['>', 'vipGrade', 1]
        ];
        $data['register_day_effective'] = self::find()->where($where)->count() ?? 0;
        $where = [
            'and',
            ['>', 'itime', $time - 86400],
            ['<', 'itime', $time],
            ['>', 'vipGrade', 1]
        ];
        $data['register_yesterday_effective'] = self::find()->where($where)->count() ?? 0;
        $where = [
            'and',
            ['>', 'vipGrade', 1]
        ];
        $data['register_all_effective'] = self::find()->where($where)->count() ?? 0;
        //金钱
        $data['account_all_money'] = self::find()->where([])->sum('money') ?? 0; //
        $data['account_all_standbyPay'] = self::find()->where([])->sum('standbyPay') ?? 0; //
        $data['account_all_goldBrick'] = self::find()->where([])->sum('goldBrick') ?? 0; //
        return $data;
    }

    /**
     * 获取指定日期注册人数
     * @param type $date
     * @return type
     */
    static public function getRegisterNumberAgent($date, $uid)
    {
        $time = strtotime($date);
        //注册
        $where = [
            'and',
            ['>', 'itime', $time],
            ['<', 'itime', $time + 86400],
            [
                'or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $data['register_day_number'] = self::find()->where($where)->count() ?? 0;
        $where = [
            'and',
            ['>', 'itime', $time - 86400],
            ['<', 'itime', $time],
            [
                'or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $data['register_yesterday_number'] = self::find()->where($where)->count() ?? 0;
        $where = [
            'and',
            [
                'or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $data['register_all_number'] = self::find()->where($where)->count() ?? 0;
        //有效
        $where = [
            'and',
            ['>', 'itime', $time],
            ['<', 'itime', $time + 86400],
            ['>', 'vipGrade', 1],
            [
                'or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $data['register_day_effective'] = self::find()->where($where)->count() ?? 0;
        $where = [
            'and',
            ['>', 'itime', $time - 86400],
            ['<', 'itime', $time],
            ['>', 'vipGrade', 1],
            [
                'or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $data['register_yesterday_effective'] = self::find()->where($where)->count() ?? 0;
        $where = [
            'and',
            ['>', 'vipGrade', 1],
            [
                'or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $data['register_all_effective'] = self::find()->where($where)->count() ?? 0;
        //金钱
        $where = [
            'and',
            [
                'or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $data['account_all_money'] = self::find()->where($where)->sum('money') ?? 0; //
        $data['account_all_standbyPay'] = self::find()->where($where)->sum('standbyPay') ?? 0; //
        $data['account_all_goldBrick'] = self::find()->where($where)->sum('goldBrick') ?? 0; //
        return $data;
    }

    /**
     * 获取后台首页数据
     * @return type
     */
    public function getIndexDataList()
    {
        $date = date('Y-m-d');
        $rediskey = __METHOD__ . $date;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $returnData = [];
        //会员增加数量
        $data = self::getRegisterNumber($date);
        $returnData = array_merge($returnData, $data);

        //银行卡充值 。预付金投资 。在线三方充值 总入金
        $data = RechargeOrder::getRechargeOrderNumber($date);
        $returnData = array_merge($returnData, $data);

        //今日提现金额
        $data = WithdrawalOrder::getWithdrawalOrderNumber($date);
        $returnData = array_merge($returnData, $data);
        //////
        //登录人数
        $data = VipLoginInfo::getLoginNumber($date);
        $returnData = array_merge($returnData, $data);
        //签到次数
        $data = SignInRecord::getIndexDataSignInRecord($date);
        $returnData = array_merge($returnData, $data);

        //三方代付金额
        //银行卡转账充值金额
        //投资金额
        //余额购买金额
        //总充值金额
        //总提现金额
        //总人数
        //更新缓存
        $time = $this->redisTime;
        $time = 300;
        self::redisCacheOperation(md5($rediskey), $returnData, $time);

        return $returnData;
    }

    /**
     * 获取后台首页数据
     * @return type
     */
    public function getIndexDataListAgent($uid)
    {
        $date = date('Y-m-d');
        $rediskey = __METHOD__ . $date . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $returnData = [];
        //会员增加数量
        $data = self::getRegisterNumberAgent($date, $uid);
        $returnData = array_merge($returnData, $data);

        //银行卡充值 。预付金投资 。在线三方充值 总入金
        $data = RechargeOrder::getRechargeOrderNumberAgent($date, $uid);
        $returnData = array_merge($returnData, $data);

        //今日提现金额
        $data = WithdrawalOrder::getWithdrawalOrderNumberAgent($date, $uid);
        $returnData = array_merge($returnData, $data);

        //////
        //登录人数
        $data = VipLoginInfo::getLoginNumberAgent($date, $uid);
        $returnData = array_merge($returnData, $data);
        //签到次数
        $data = SignInRecord::getIndexDataSignInRecordAgent($date, $uid);
        $returnData = array_merge($returnData, $data);

        $model = new AgentTeamSql();
        //获取今天充值 。提现 。入金 。余额
        $time = strtotime($date);
        $startTime = $time;
        $endTime = $startTime + 86400;
        $type = 1;
        $data = $model->sqlOperateTeamListData($uid, $startTime, $endTime, $type);
        $returnData['recharge_day_tripartite'] = $returnData['recharge_day_income'] = $returnData['Withdrawal_day_money'] = $returnData['account_all_money'] = $returnData['account_all_standbyPay'] = $returnData['account_all_goldBrick'] = 0;
        if (!empty($data['recharge_tripartite']))
            $returnData['recharge_day_tripartite'] = $data['recharge_tripartite']; //充值

        if (!empty($data['recharge_income']))
            $returnData['recharge_day_income'] = $data['recharge_income']; //总入金
        if (!empty($data['Withdrawal_money']))
            $returnData['Withdrawal_day_money'] = $data['Withdrawal_money']; //提现
        if (!empty($data['account_all_money']))
            $returnData['account_all_money'] = $data['account_all_money']; //提现
        if (!empty($data['account_all_standbyPay']))
            $returnData['account_all_standbyPay'] = $data['account_all_standbyPay']; //提现
        if (!empty($data['account_all_goldBrick']))
            $returnData['account_all_goldBrick'] = $data['account_all_goldBrick']; //提现


        //获取昨天 充值 。提现 。入金
        $time = strtotime($date);
        $startTime = $time - 86400;
        $endTime = $startTime + 86400;
        $type = 2;
        $data = $model->sqlOperateTeamListData($uid, $startTime, $endTime, $type);
        $returnData['recharge_yesterday_tripartite'] = $returnData['recharge_yesterday_income'] = $returnData['Withdrawal_yesterday_money'] = 0;
        if (!empty($data['recharge_tripartite']))
            $returnData['recharge_yesterday_tripartite'] = $data['recharge_tripartite']; //昨日充值


        //
        if (!empty($data['recharge_income']))
            $returnData['recharge_yesterday_income'] = $data['recharge_income']; //总入金
        if (!empty($data['Withdrawal_money']))
            $returnData['Withdrawal_yesterday_money'] = $data['Withdrawal_money']; //提现


        //获取总 充值 。提现 。入金
        $time = strtotime($date);
        $startTime = 1672502400;
        $endTime = $time + 86400;
        $type = 2;
        $data = $model->sqlOperateTeamListData($uid, $startTime, $endTime, $type);

        $returnData['recharge_all_tripartite'] = $returnData['recharge_all_income'] = $returnData['Withdrawal_all_money'] = 0;
        if (!empty($data['recharge_tripartite']))
            $returnData['recharge_all_tripartite'] = $data['recharge_tripartite']; //总充值
        if (!empty($data['recharge_income']))
            $returnData['recharge_all_income'] = $data['recharge_income']; //总入金
        if (!empty($data['Withdrawal_money']))
            $returnData['Withdrawal_all_money'] = $data['Withdrawal_money']; //三方代付金额


        //银行卡转账充值金额
        //投资金额
        //余额购买金额
        //总充值金额
        //总提现金额
        //总人数
        //更新缓存
        $time = $this->redisTime;
        $time = 600;
        self::redisCacheOperation(md5($rediskey), $returnData, $time);

        return $returnData;
    }

    /**
     * 获取下级列表列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientHomePeopleNumber($uid)
    {
        // 定义缓存键
        $cacheKey = "client_home_people_number:uid={$uid}";

        // 尝试从 Redis 获取缓存数据
        $cachedData = Yii::$app->redis->get($cacheKey);
        if ($cachedData !== false) {
            // 如果缓存存在，直接返回缓存数据
            return json_decode($cachedData, true);
        }

        // 默认返回的数据
        $data = [
            'allRegister' => 0,
            'dayRegister' => 0
        ];

        // 获取 allRegister
        $fields = ['uid', 'oneSharePeople'];
        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        self::$key = $fields;
        $accountData = $this->find()->asArray()->where($where)->one();

        if (!empty($accountData['oneSharePeople'])) {
            $data['allRegister'] = $accountData['oneSharePeople'];
        }

        // 获取 dayRegister
        $where = [
            'and',
            ['=', 'oneLevel', $uid],
            ['>=', 'itime', strtotime(date('Y-m-d'))]
        ];
        $data['dayRegister'] = $this->listFind([])->where($where)->count() ?? 0;

        // 将查询结果存入 Redis，并设置缓存有效期为 5 分钟（300 秒）
        Yii::$app->redis->setex($cacheKey, 300, json_encode($data));

        return $data;
    }

    /**
     * 备付金转帐
     * @param type $uid
     * @param type $account 目标账号
     * @param type $money
     */
    public function BuyStandbyTransfer($uid, $account, $money)
    {

        $boor = $this->checkAccountGold($uid, $money, $type = 2);
        if (!$boor) {
            $this->addError('mesg', ['212', '余额不足']);
            return false;
        }

        //验证目标
        $AccountData = self::getAccountDataMessageMoebile($account);
        if (empty($AccountData)) {
            $this->addError('mesg', ['212', '账号不存在']);
            return false;
        }


        //验证目标
        $existData = self::getAccountDataMessage($uid);
        if (empty($existData)) {
            $this->addError('mesg', ['212', '账号不存在']);
            return false;
        }

        if ($existData['investAllMoney'] <= 0) {
            $this->addError('mesg', ['212', '未投资用户，暂无法开启转账']);
            return false;
        }


        $boor = $this->deductAccountGold($uid, $money, $type = 2);
        if (!$boor) {
            $this->addError('mesg', ['212', '余额不足']);
            return false;
        } else {
            //资产变化
            $AssetChanges = new AssetChanges();
            $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_2, AssetChanges::ASSET_TYPE_2, $changeType = 17, $money, $remarks = '目标id：' . $AccountData['uid']);
            //备付金记录
            $model = new StandbyPayRecord();
            $model->addStandbyPayRecord($uid, StandbyPayRecord::ASSET_TYPE_2, $changeType = 3, $money, $remarks = $AccountData['account']);
        }

        //增加备付金
        $boor = $this->addAccountGold($AccountData['uid'], $money, $type = 2);
        if ($boor) {
            //备付金记录
            $model = new StandbyPayRecord();
            $model->addStandbyPayRecord($AccountData['uid'], StandbyPayRecord::ASSET_TYPE_1, $changeType = 2, $money, $remarks = $existData['account']);
            //资产变化
            $AssetChanges = new AssetChanges();
            $AssetChanges->addAssetChangesData($AccountData['uid'], AssetChanges::MONEY_TYPE_2, AssetChanges::ASSET_TYPE_1, $changeType = 17, $money, $remarks = '发起id：' . $uid);

            return true;
        } else {
            $this->addError('mesg', ['212', '购买失败，联系客服']);
            return false;
        }
    }

    /**
     * 获取团队投资总额
     * @param type $uid
     * @return type
     */
    public static function getTeaminvestAllMoney($uid)
    {
        $rediskey = __METHOD__ . $uid;
        $redisData = self::getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['or',
                ['=', 'oneLevel', $uid],
                ['=', 'twoLevel', $uid],
                ['=', 'threeLevel', $uid],
            ]
        ];
        $teamMoney = self::find()->where($where)->sum('investAllMoney') ?? 0;

        //更新缓存
        $time = self::$redisStaticTime;
        self::redisCacheOperation(md5($rediskey), $teamMoney, $time);

        return $teamMoney;
    }

    public function payBackConvert($user, $money)
    {
        if ($money <= 0) {
            $this->addError('mesg', ['212', '兑换金额有误']);
            return false;
        }
        if (bccomp($money, $user->pay_back) > 0) {
            $this->addError('mesg', ['212', '最大金额不能超过回报钱包内余额']);
            return false;
        }
        $newMoney = bcsub($user->pay_back, $money);
        $uid = $user->uid;
        // 开始一个事务
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $boor = $this->updateAll([
                'money' => new Expression('money+' . $money),
                'pay_back' => $newMoney,
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('update to save user');
            }
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'sub',
                'bill_type' => BillRecord::BillTypePayBackConvert,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeOne,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypePayBackMoney,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            // 提交事务
            $transaction->commit();
            return true;
        } catch (\Exception $e) {
            $transaction->rollBack();
            FuncHelper::ErrLog('pay_back_convert', [
                'uid' => $uid,
                'money' => $money,
            ], $e->getMessage());
            $this->addError('mesg', ['212', '兑换失败']);
            return false;
        }
    }

    //邀请人数
    public function addInviteCountPayBack($inviteUid)
    {

        $userProduct = new  UserProduct();
        $count = $userProduct->getBuyCount($inviteUid);
        $money = 0;
        if ($count == 5) {
            $money = 88;
        } else if ($count == 10) {
            $money = 288;
        } else if ($count == 25) {
            $money = 888;
        } else if ($count == 50) {
            $money = 2088;
        } else if ($count == 100) {
            $money = 6888;
        }
        if (empty($money)) {
            return true;
        }
        $inviteM = new InviteRebate();
        $info = $inviteM->getBuyCount($inviteUid, $count);
        if ($info) {
            return true;
        }
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $inviteData = [
                'uid' => $inviteUid,
                'money' => $money,
                'num' => $count,
                'day' => date("Y-m-d"),
                'bill_unit' => 'add',
                'itime' => time(),
                'utime' => time(),
            ];
            $inviteM = new InviteRebate();
            if (!$inviteM->insertData($inviteData)) {
                throw new \Exception('Failed to save invite record');
            }
            //账单
            $billData = [
                'uid' => $inviteUid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeInviteCountPayBack,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            //用户
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'pay_back' => new Expression('pay_back+' . $money)
            ], ['uid' => $inviteUid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('invite_count_pay_back', [
                'uid' => $inviteUid,
                'money' => $money,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        return false;
    }


    public function addMoneyByDreamFund($uid, $dreamFund)
    {
        $month = Date("Y-m-01");
        $fundMonthModel = new UserFundMonth();
        $info = $fundMonthModel->getOne($uid, $month);
        if ($info) {
            return true;
        }
        $money = $dreamFund * (0.008);
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $monthData = [
                'uid' => $uid,
                'income' => $money,
                'day' => $month,
                'itime' => time(),
                'utime' => time(),
            ];
            $fundMonthModel = new UserFundMonth();
            if (!$fundMonthModel->insertData($monthData)) {
                throw new \Exception('Failed to fund month record');
            }
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeThree,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeFundMonth,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'allowance' => new Expression('allowance+' . $money)
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('dream_fund_month', [
                'uid' => $uid,
                'money' => $money,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        return false;
    }
}
