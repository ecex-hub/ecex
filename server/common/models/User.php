<?php

namespace common\models;

use phpDocumentor\Reflection\DocBlock\Tags\Var_;
use Yii;
use yii\base\Model;
use yii\db\Expression;
use common\helpers\HashidsHelper;
use common\helpers\RandName;

/**
 * ContactForm is the model behind the contact form.  用户相关信息
 */
class User extends \common\models\BaseModel {

    protected $table = 'user';

    public static function tableName() {
        return '{{user}}';
    }

    public static function getDb() {
        return Yii::$app->get('db');
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['uid', 'number'], //用户id
            ['account', 'string'], //账号
            ['power', 'number'], // 角色 7 用户
            ['password', 'string'], //密码
            ['rank', 'number'], //等级
            ['state', 'number'], //状态,1正常
            ['addtime', 'number'], //添加时间
            ['nickname', 'string'], //名称
            ['modifypwd', 'number'],
            ['morelogin', 'number'], //1多地登陆
            ['px', 'number'], //
            ['phone', 'string'], //手机号
            ['sms_time', 'number'], //
            ['sms_code', 'number'], //
            ['googlecode', 'number'], //
            ['acttime', 'number'], //
            ['playcount', 'number'], //
            ['birth', 'number'], //
            ['pic', 'number'], //
            ['recycle', 'number'], //
            ['people', 'number'], //推广人数
            ['extensionReward', 'number'], //推广奖励金额
            ['ip', 'string'], //注册ip
            ['device_type', 'number'], //
            ['mac', 'string'], //mac
            ['customAccount', 'string'], //自定义登陆账号
            ['accountType', 'number'], //账号类型   1为游客账号    2为正式账号
            ['photo', 'string'], //头像
            ['gender', 'number'], //性别 1男 2女
            ['city', 'string'], //城市 。上海
            ['followNumber', 'number'], //关注数
            ['fansNumber', 'number'], // 粉丝数
            ['weiBoNumber', 'number'], // 微博数
            ['receivedReward', 'number'], // 收到打赏
            ['sendOutReward', 'number'], // 送出打赏
            ['preservationLoginAccount', 'string'], //保存登陆账号
            ['preservationLoginPassword', 'string'], //保存登陆密码
            ['preservationPasswordPlaintext', 'string'], //保存登陆密码 明文
            ['mobile', 'string'], //手机号
            ['shareUid', 'number'], //分享上级id
        ];
    }

    //设备类型
    const DEVICE_TYPE_1 = 1; //安卓
    const DEVICE_TYPE_2 = 2; //ios
    const DEVICE_TYPE_3 = 3; //h5
    const DEVICE_TYPE_4 = 4; //h5书签
    const USER_POWER = 7; //7为 用户
    const ROBOR_POWER = 8; //8为 机器人用户

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * @inheritdoc
     */
    public function getUserMoney() {
        return $this->hasOne(UserMoney::className(), ['uid' => 'uid'])->select([]);
    }

    /**
     * register.
     * 注册一个用户
     * @param string $token token.
     * @param string $pwd 密码.
     * @param string $device_type 设备类型1安卓2ios.
     * @param string $mac 设备号.
     * @param string $system_version 系统版本.
     * @param string $phone_model 手机型号.
     * @param number $channelID 渠道号.
     * @return string
     */
    static public function register(
            $token,
            $pwd = '',
            $device_type = '',
            $mac = '',
            $system_version = '',
            $phone_model = '',
            $channelID = '',
            $uid = null,
            $ROBOR = false,
            $versions = ''
    ) {
        $ip = self::ip();
//        $MainchannelID = ChannelManage::mainChannel;
//        if (!empty($ip) && $ip <> '127.0.0.1' && $channelID <> $MainchannelID) {
//            $existData = $this->getIpRegisterData($ip);
//            if (!empty($existData)) {
//                $channelID = $MainchannelID;
//            }
//        }


        $TIMESTAMP = $_SERVER['REQUEST_TIME'];
        $photo = rand(1, 10);
        if (empty($uid)) {
            $name = RandName::RandUidName();
        } else {
            $name = '';
        }
        $power = 7;
        if ($ROBOR) {
            $power = self::ROBOR_POWER;
        }
        if (!empty($uid)) {
            Yii::$app->db->createCommand("INSERT INTO user (uid,account,power,password,rank,state,addtime,ip,device_type,mac,system_version,phone_model,channelID,originalChannelID,photo,nickname) "
                            . "VALUES('{$uid}','{$token}','{$power}','{$pwd}',1,1,{$TIMESTAMP},'{$ip}','{$device_type}','{$mac}','{$system_version}','{$phone_model}','{$channelID}','{$channelID}','{$photo}','{$name}')")
                    ->query();
        } else {
            Yii::$app->db->createCommand("INSERT INTO user (uid,account,power,password,rank,state,addtime,ip,device_type,mac,system_version,phone_model,channelID,originalChannelID,photo,nickname) "
                            . "VALUES(null,'{$token}','{$power}','{$pwd}',1,1,{$TIMESTAMP},'{$ip}','{$device_type}','{$mac}','{$system_version}','{$phone_model}','{$channelID}','{$channelID}','{$photo}','{$name}')")
                    ->query();
        }

        $userInfo = self::findOne(['account' => $token]);
        $uid = $userInfo->uid;
        //设置缓存
        Yii::$app->redis->hset('register', $token, $uid);
        if ($uid) {
            //获取佣金初始值
            $commission = TaskShare::getTaskInitial();
            Yii::$app->db->createCommand("INSERT INTO user_money (uid,money,commission) VALUES('{$uid}',0,'{$commission}')")->query(); //生成用户金额表
            //获取一个pin的记录
            //$userPin = UserPin::find()->select('id')->where(['uid' => 0])->limit(1)->orderBy('id')->asArray()->one();
            //$id = $userPin['id'];
            //Yii::$app->db->createCommand("UPDATE user_pin SET uid='{$uid}' WHERE id={$id}")->query(); //更新用户
            //UserPin::getUidPin($uid);
            Yii::$app->db->createCommand("INSERT INTO user_video_favorite_title (id,name,uid,type)VALUES(null,'','{$uid}',1)")->query();
            //
            Yii::$app->redis->hset('register', $token . 'state', 1);
            Yii::$app->redis->hset('register', $token . 'channelID', $channelID); //用户渠道
            $count = $userInfo->playcount; //用户的可播放次数
            $today = date('Y-m-d');
            $tomorrow = date('Y-m-d', strtotime("{$today} +1 days"));
            // Yii::$app->redis->hset('user_play_count_' . $today, $uid, $count);
            // Yii::$app->redis->hset('user_play_count_' . $tomorrow, $uid, $count);
            //注册扣量
            try {
                if ($power == self::USER_POWER) {
                    self::buckleQuantityRegisterDispose($uid, $channelID, $token, $device_type);
                    //获取用户最新渠道
                    $newChannelID = Yii::$app->redis->hget('register', $token . 'channelID');
                    //渠道注册计数统计
                    DayStatistics::addDayStatistics($today, $newChannelID, $device_type, 'register', 1, $versions);
                }
            } catch (\Exception $e) {
                Yii::info('buckleQuantityRegisterDispose' . $e, 'apiLog');
            }
        } else {
            Yii::info('添加用户失败 ' . $token, 'apiLog');
        }
        return $uid;
    }

    /**
     * 获取ip注册数
     * @param type $uid
     * @param type $page
     * @param type $limit
     * @return type
     */
    public function getIpRegisterData($ip) {
        $redisKey = __METHOD__ . $ip;
        $redisData = $this->getRedisCacheOperation(md5($redisKey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'ip' => $ip
        ];
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        //$time = Yii::$app->params['redisTime'];
        $time = 30;
        $this->redisCacheOperation(md5($redisKey), $data, $time);
        return $data;
    }

    /**
     * 返回当前ip
     * register.
     *
     * @return string
     */
    static public function ip() {
        $ip = isset($_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : $_SERVER['REMOTE_ADDR'];
        $ip = trim(strip_tags($ip));
        if (stripos($ip, ',') !== false) {
            $ip = explode(',', $ip)[1];
        }
        return $ip;
    }

    /**
     * bb 数据
     * @param type $page
     * @param type $row
     * @param type $uid
     * @param type $account
     * @return type
     */
    public function getUserInfoBBData(
            $page,
            $row,
            $uid,
            $account) {

        $where = ['and'];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }

        if (!empty($account)) {
            $where[] = ['=', 'account', $account];
        }
        $fields = [];
        self::$key = $fields;
        $data['data'] = $this->listFind(['row' => 1])->where($where)->all();
        return $data;
    }

    /**
     * getUserInfo.
     * 获取用户信息
     *
     * @param integer $page 页.
     * @param integer $row 行.
     * @param integer $uid uid.
     * @param string $account 账号.
     * @param string $nickname 昵称.
     * @param integer $channelID 渠道号.
     * @param integer $parent_id 上级id.
     * @param integer $device_type 设备类型1安卓2ios.
     * @param integer $start_time 开始时间.
     * @param integer $end_time 结束时间.
     * @param integer $originalChannelID 原渠道号.
     * @param array $channelIdMerge 管理员渠道.
     * @param array $fields 查询的字段.
     * @return mixed.
     */
    public function getUserInfo(
            $page,
            $row,
            $uid,
            $account,
            $nickname,
            $channelID,
            $parent_id,
            $device_type,
            $start_time,
            $end_time,
            $originalChannelID,
            $channelIdMerge,
            $fields = []
    ) {
        $ret = [];
        $row = is_numeric($row) ? $row : 20;
        $query = self::find()->orderBy('addtime DESC');
        if (!empty($fields) && is_array($fields)) {
            $query = $query->select($fields);
        }
        $query->joinWith(['userMoney']);
        if (!empty($uid)) {
            $query = $query->andWhere(["user.uid" => $uid]);
        }
        if (!empty($account)) {
            $query = $query->andWhere(['like', "account", $account]);
        }
        if (!empty($nickname)) {
            $query = $query->andWhere(['like', "nickname", $nickname]);
        }
        if (!empty($channelID)) {
            $query = $query->andWhere(["channelID" => $channelID]);
        }
        if (!empty($originalChannelID)) {
            $query = $query->andWhere(["originalChannelID" => $originalChannelID]);
        }
        if (!empty($parent_id)) {
            $query = $query->andWhere(["parent_id" => $parent_id]);
        }
        if (!empty($device_type)) {
            $query = $query->andWhere(["device_type" => $device_type]);
        }
        if (!empty($start_time)) {
            $query = $query->andWhere(['>=', 'addtime', $start_time]);
        }
        if (!empty($end_time)) {
            $query = $query->andWhere(['<=', 'addtime', $end_time]);
        }
        if (!empty($channelIdMerge) && is_array($channelIdMerge) && !in_array(1, $channelIdMerge)) {
            $query = $query->andWhere(['in', 'user.channelID', $channelIdMerge]);
        }
        //默认显示当天数据
        if (empty($query->where)) {
            //$query = $query->andWhere(['>=', 'addtime', strtotime(date('Y-m-d', time()))]);
            //$query = $query->andWhere(['<', 'addtime', strtotime(date('Y-m-d', time())) + 86400]);
        }
        $query = $query->andWhere(['in', 'power', [self::USER_POWER]]);
        $countQuery = clone $query;
        $query = $query->offset(($page - 1) * $row)->limit($row);
        $dataInfo = $query->asArray()->all();
        if (!empty($dataInfo)) {
            $uidArray = array_column($dataInfo, 'uid');
            $userMoney = UserMoney::getUserData($uidArray);
            $ret['count'] = $countQuery->count();
            $ret['page'] = ceil($ret['count'] / $row);
            $model = new WeiBoAuthentication();
            $weiBoTag = $model->getExistDataAccontTagMessage($uidArray, $tagType = 1);
            $teahouseTag = $model->getExistDataAccontTagMessage($uidArray, $tagType = 2);
            foreach ($dataInfo as $key => $value) {
                if (!empty($userMoney[$value['uid']])) {
                    $userMoneyInfo = $userMoney[$value['uid']];
                    $dataInfo[$key]['money'] = $userMoney[$value['uid']]['money'];
                    $dataInfo[$key]['vip_valid_time'] = !empty($userMoneyInfo['vip_valid_time']) ? date('Y-m-d H:i:s', $userMoney[$value['uid']]['vip_valid_time']) : 0;
                    $dataInfo[$key]['storey_valid_time'] = !empty($userMoneyInfo['storey_valid_time']) ? date('Y-m-d H:i:s', $userMoney[$value['uid']]['storey_valid_time']) : 0;
                    $dataInfo[$key]['cartoon_valid_time'] = !empty($userMoneyInfo['cartoon_valid_time']) ? date('Y-m-d H:i:s', $userMoney[$value['uid']]['cartoon_valid_time']) : 0;
                    $dataInfo[$key]['fiction_valid_time'] = !empty($userMoneyInfo['fiction_valid_time']) ? date('Y-m-d H:i:s', $userMoney[$value['uid']]['fiction_valid_time']) : 0;
                    $dataInfo[$key]['live_valid_time'] = !empty($userMoneyInfo['live_valid_time']) ? date('Y-m-d H:i:s', $userMoney[$value['uid']]['live_valid_time']) : 0;
                    $dataInfo[$key]['download_count'] = $userMoney[$value['uid']]['download_count'];
                    $dataInfo[$key]['community_time'] = !empty($userMoneyInfo['community_time']) ? date('Y-m-d H:i:s', $userMoney[$value['uid']]['community_time']) : 0;
                } else {
                    $dataInfo[$key]['money'] = 0;
                    $dataInfo[$key]['vip_valid_time'] = 0;
                    $dataInfo[$key]['storey_valid_time'] = 0;
                    $dataInfo[$key]['cartoon_valid_time'] = 0;
                    $dataInfo[$key]['fiction_valid_time'] = 0;
                    $dataInfo[$key]['live_valid_time'] = 0;
                    $dataInfo[$key]['download_count'] = 0;
                }
                $dataInfo[$key]['weiBoTag'] = $dataInfo[$key]['teahouseTag'] = [];
                if (!empty($weiBoTag[$value['uid']])) {
                    $dataInfo[$key]['weiBoTag'] = $weiBoTag[$value['uid']];
                }
                if (!empty($teahouseTag[$value['uid']])) {
                    $dataInfo[$key]['teahouseTag'] = $teahouseTag[$value['uid']];
                }
                $dataInfo[$key]['addtime'] = date('Y-m-d H:i:s', $value['addtime']);
                unset($dataInfo[$key]['userMoney']);
            }
            $ret['data'] = $dataInfo;
        }
        return $ret;
    }

    /**
     * getOneUserInfo.
     * 获取单个用户信息
     *
     * @param integer $uid 用户id.
     * @return mixed.
     */
    static public function getOneUserInfo($uid) {
        return self::find()->where(['uid' => $uid])->asArray()->one();
    }

    /**
     * userPlayHistory.
     * 用户播放历史记录
     *
     * @param integer $uid 用户id.
     * @return mixed.
     */
    static public function userPlayHistory($uid) {
        $history = unserialize(Yii::$app->redis->hget('play_history', $uid));
        if (empty($history)) {
            $history = unserialize('a:3:{s:10:"2021-07-16";a:2:{i:0;s:3:"124";i:1;s:3:"125";}s:10:"2021-07-17";a:2:{i:0;s:3:"125";i:1;s:3:"126";}s:10:"2021-07-19";a:2:{i:0;s:3:"122";i:1;s:3:"125";}}');
        }
        $px = function ($a, $b) {
            $a = intval(str_replace('-', '', $a));
            $b = intval(str_replace('-', '', $b));
            if ($a == $b) {
                return 0;
            }
            return $a < $b ? 1 : -1;
        };
        uksort($history, $px);
        $list = [];
        foreach ($history as $key => $val) {
            foreach ($val as $id) {
                $list[$id] = $key;
            }
        }
        $ret = [];
        $videoInfo = Video::find()->select(['vid', 'name', 'fanhao'])->where([
                    'in',
                    'vid',
                    array_keys($list)
                ])->asArray()->all();
        foreach ($videoInfo as $key => $value) {
            $videoInfo[$key]['watch_time'] = $list[$value['vid']];
        }
        $ret['data'] = $videoInfo;
        return $ret;
    }

    /**
     * getUserInstalledNumber.
     * 获取用户安装数
     *
     * @param integer $channelID 渠道号.
     * @param integer $start_time 开始时间.
     * @param integer $end_time 结束时间.
     * @param integer $device_type 设备类型1安卓2ios.
     *
     * @return mixed.
     */
    public static function getUserInstalledNumber(
            $channelID,
            $start_time,
            $end_time,
            $device_type = '',
            $channelIdMerge = []
    ) {
        $where = [
            'and',
            ['power' => self::USER_POWER],
        ];
        if (!empty($channelID)) {
            $where[] = ['=', 'channelID', $channelID];
        }
        if (!empty($start_time)) {
            $where[] = ['>=', 'addtime', $start_time];
        }
        if (!empty($end_time)) {
            $where[] = ['<', 'addtime', $end_time];
        }
        if (!empty($device_type)) {
            $where[] = ['=', 'device_type', $device_type];
        }
        if (!empty($channelIdMerge) && is_array($channelIdMerge) && !in_array('1', $channelIdMerge)) {
            $where[] = ['in', 'channelID', $channelIdMerge];
        }
        return self::find()->where($where)->count() ?? 0;
    }

    /**
     * getTimeData.
     * 获取时间段数据
     *
     * @param integer $channelID 渠道号.
     * @param integer $start_time 开始时间.
     * @param integer $end_time 结束时间.
     * @param array $fields 查询的字段.
     * @param array $channelIdMerge 管理员渠道
     *
     * @return mixed.
     */
    public static function getUserTimeData($channelID, $start_time, $end_time, $fields = [], $channelIdMerge = []) {
        $query = self::find()->where(['power' => self::USER_POWER]);
        if (!empty($fields) && is_array($fields)) {
            $query = $query->select($fields);
        }
        if (!empty($channelID)) {
            $query->andWhere(['=', 'channelID', $channelID]);
        }
        if (!empty($start_time)) {
            $query->andWhere(['>=', 'addtime', $start_time]);
        }
        if (!empty($end_time)) {
            $query->andWhere(['<=', 'addtime', $end_time]);
        }
        if (!empty($channelIdMerge) && is_array($channelIdMerge) && !in_array(1, $channelIdMerge)) {
            $where[] = ['in', 'channelID', $channelIdMerge];
        }
        return $query->asArray()->all();
    }

    /**
     * userSectionDataDispose.
     * 区间数据处理
     *
     * @param array $data 查找的数据.
     * @param array $dayFormat 时段格式.
     * @param array $initialData 初始数据.
     * @param integer $type 1当日 2昨日.
     *
     * @return mixed.
     */
    public static function userSectionDataDispose($data, $dayFormat, $initialData, $type) {
        foreach ($data as $key => $value) {
            foreach ($dayFormat as $k2 => $v2) {
                if ($value['addtime'] >= $v2['start_time'] && $value['addtime'] <= $v2['end_time']) {
                    if ($type == 1) {
                        $initialData[$k2]['day_installed'] += 1;
                        if ($value['device_type'] == self::DEVICE_TYPE_1) {
                            $initialData[$k2]['android_installed'] += 1;
                        }
                        if ($value['device_type'] == self::DEVICE_TYPE_2) {
                            $initialData[$k2]['ios_installed'] += 1;
                        }
                        if ($value['device_type'] == self::DEVICE_TYPE_3) {
                            $initialData[$k2]['h5_installed'] += 1;
                        }
                        if ($value['device_type'] == self::DEVICE_TYPE_4) {
                            $initialData[$k2]['h5_book_installed'] += 1;
                        }
                    } else {
                        $initialData[$k2]['yesterday_installed'] += 1;
                    }
                    break;
                }
            }
        }
        return $initialData;
    }

    /**
     * getChannelInstalled.
     * 获取多个渠道用户安装数
     *
     * @param array $channel_array 渠道集合.
     * @param integer $start_time 开始时间.
     * @param integer $end_time 结束时间.
     * @param integer $device_type 设备类型1安卓2ios.
     *
     * @return mixed.
     */
    public static function getChannelInstalled($channel_array, $start_time, $end_time, $device_type = '') {
        $where = [
            'and',
            ['power' => self::USER_POWER],
        ];
        if (!empty($channel_array)) {
            $where[] = ['in', 'channelID', $channel_array];
        }
        if (!empty($start_time)) {
            $where[] = ['>=', 'addtime', $start_time];
        }
        if (!empty($end_time)) {
            $where[] = ['<=', 'addtime', $end_time];
        }
        if (!empty($device_type)) {
            $where[] = ['=', 'device_type', $device_type];
        }
        $ret = [];
        $data = self::find()->select('channelID, count(uid) as installed')->where($where)->groupBy('channelID')->asArray()->all();
        foreach ($data as $key => $value) {
            $ret[$value['channelID']] = $value['installed'];
        }
        return $ret;
    }

    /**
     * clearUserInvite.
     * 清空邀请
     *
     * @param integer $uid 用户id.
     * @return mixed.
     */
    public function clearUserInvite($uid) {
        $model = self::findOne(['uid' => $uid]);
        if (empty($model)) {
            throw new \Exception('该uid不存在', 201);
        }
        $model->people = 0;
        if (!$model->save()) {
            throw new \Exception('失败', 202);
        }
        return true;
    }

    /**
     * deleteUser.
     * 删除用户
     *
     * @param integer $uid 用户id.
     * @return mixed.
     */
    public function deleteUser($uid) {
        $model = self::findOne(['uid' => $uid]);
        if (empty($model)) {
            throw new \Exception('该uid不存在', 201);
        }
        //
        if (!$model->delete()) {
            throw new \Exception('删除失败', 202);
        }
        $boor = Yii::$app->redis->hdel('register', $model->account);
        return true;
    }

    /**
     * buckleQuantityRegisterDispose.
     * 渠道注册扣量处理
     * @param number $uid uid.
     * @param number $channelID 渠道号.
     * @param string $uuid uuid.
     * @param number $device_type 设备类型1安卓2ios.
     * @return mixed.
     */
    public static function buckleQuantityRegisterDispose($uid, $channelID, $uuid, $device_type = 1) {
        $channelData = ChannelManage::getChannelData($channelID);
        if (empty($channelData)) {
            return false;
        }
        $mainChannel = ChannelManage::getMainChannel();
        if ($channelData['parent_id'] == '0') {
            //扣量到主渠道
            if ($mainChannel == $channelData['buckle_quantity_to_channel'] || empty($channelData['buckle_quantity_to_channel'])) {
                //根据设备获取扣量数
                if ($device_type == 1) {
                    $buckle_nums = $channelData['android_buckle_quantity'];
                    $redis_name = 'android';
                } else {
                    $buckle_nums = $channelData['ios_buckle_quantity'];
                    $redis_name = 'ios';
                }
                if (empty($buckle_nums)) {
                    $buckle_nums = $channelData['register_buckle_quantity'];
                    $redis_name = 'register';
                }
                //cpa渠道 分数处理
                if (stripos($buckle_nums, '/') !== false) {
                    $data = explode('/', $buckle_nums);
                    if (count($data) != 2 || !is_numeric($data[0]) || !is_numeric($data[1])) {
                        return false;
                    }
                    $divisor = $data[0];
                    $dividend = $data[1];
                    //随机位数扣
                    $divisor_array = Yii::$app->redis->get('channel_register' . $channelID . '_divisor_array');
                    $divisor_array = unserialize($divisor_array);
                    if (empty($divisor_array)) {
                        for ($i = 1; $i <= $dividend; $i++) {
                            $probability_array[] = $i;
                        }
                        $temp_array = array_rand($probability_array, $divisor);
                        foreach ($temp_array as $key => $value) {
                            $divisor_array[] = $probability_array[$value];
                        }
                        Yii::$app->redis->set('channel_register' . $channelID . '_divisor_array', serialize($divisor_array));
                    }
                    //
                    $nums = Yii::$app->redis->hget('channel_register' . $channelID, $redis_name . '_buckle_quantity');
                    if ($nums > $dividend || empty($nums)) {
                        $nums = 1;
                    } else {
                        $nums += 1;
                    }
                    Yii::$app->redis->hset('channel_register' . $channelID, $redis_name . '_buckle_quantity', $nums);
                    //扣量
                    if (in_array($nums, $divisor_array)) {
                        Yii::$app->redis->hset('register', $uuid . 'channelID', $mainChannel); //redis缓存丢失，重新设置
                        self::updateAll(['channelID' => $mainChannel], ['uid' => $uid]);
                    }
                    if ($nums == $dividend) {
                        Yii::$app->redis->set('channel_register' . $channelID . '_divisor_array', '');
                        //归零
                        Yii::$app->redis->hset('channel_register' . $channelID, $redis_name . '_buckle_quantity', 0);
                    }
                    return true;
                }
                //整数处理
                if ($buckle_nums > 0 && is_numeric($buckle_nums)) {
                    $nums = Yii::$app->redis->hget('channel_register' . $channelID, $redis_name . '_buckle_quantity');
                    if ($nums > $buckle_nums || empty($nums)) {
                        $nums = 1;
                    } else {
                        $nums += 1;
                    }
                    Yii::$app->redis->hset('channel_register' . $channelID, $redis_name . '_buckle_quantity', $nums);
                    //扣量
                    if ($nums == $buckle_nums) {
                        Yii::$app->redis->hset('register', $uuid . 'channelID', $mainChannel); //redis缓存丢失，重新设置
                        //归零
                        Yii::$app->redis->hset('channel_register' . $channelID, $redis_name . '_buckle_quantity', 0);
                        return self::updateAll(['channelID' => $mainChannel], ['uid' => $uid]);
                    }
                }
            }
        } else {//整数值, 双重扣量
            self::doubleBuckleQuantity($uid, $channelData, $uuid, $mainChannel);
        }
        return true;
    }

    /**
     * doubleBuckleQuantity.
     * 双重扣量
     *
     * @param number $uid uid.
     * @param array $channelData 当前渠道信息.
     * @param string $uuid uuid.
     * @param number $mainChannel 主渠道.
     * @return mixed.
     */
    public static function doubleBuckleQuantity($uid, $channelData, $uuid, $mainChannel) {
        $channelID = $channelData['channelID'];
        $parentInfo = ChannelManage::getParentChannelInfo($channelData['parent_id']);
        if (empty($parentInfo)) {
            return false;
        }
        if (stripos($parentInfo['register_buckle_quantity'], '/') !== false || stripos($channelData['register_buckle_quantity'], '/') !== false) {
            return false;
        }
        if ($parentInfo['register_buckle_quantity'] == 1 && $channelData['register_buckle_quantity'] > 0) {
            //全部扣量到主渠道
            if ($channelData['register_buckle_quantity'] > 0) {
                $nums = Yii::$app->redis->hget('channel_register' . $channelID, '_buckle_quantity');
                if ($nums > $channelData['register_buckle_quantity'] || empty($nums)) {
                    $nums = 1;
                } else {
                    $nums += 1;
                }
                Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', $nums);
                //扣量到渠道
                if ($nums == $channelData['register_buckle_quantity']) {
                    Yii::$app->redis->hset('register', $uuid . 'channelID', $mainChannel); //redis缓存丢失，重新设置
                    //归零
                    Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', 0);
                    return self::updateAll(['channelID' => $mainChannel], ['uid' => $uid]);
                }
            }
        }
        //双重扣量
        if ($parentInfo['register_buckle_quantity'] > 1 && $channelData['register_buckle_quantity'] > 0) {
            //扣量到渠道
            $buckle_quantity_channel = empty($channelData['buckle_quantity_to_channel']) ? $parentInfo['channelID'] : $mainChannel;

            //双重扣量计算实际扣量概率数 算法 1/((1 - 1/父渠道注册扣量数) * 1/子渠道扣量数) 四舍五入取整
            $channel_buckle_nums = round(1 / ((1 - 1 / $parentInfo['register_buckle_quantity']) * 1 / $channelData['register_buckle_quantity']));
            //如果子渠道扣量位数大于 父渠道扣量位数
            if ($channel_buckle_nums > $parentInfo['register_buckle_quantity']) {
                //计算主渠道扣量位数
                $main_buckle_nums = floor($channel_buckle_nums / $parentInfo['register_buckle_quantity']);
                for ($i = 1; $i <= $main_buckle_nums; $i++) {
                    $buckle_nums[] = $i * $parentInfo['register_buckle_quantity'];
                }
                if ($channel_buckle_nums > 0) {
                    $nums = Yii::$app->redis->hget('channel_register' . $channelID, '_buckle_quantity');
                    if ($nums > $channel_buckle_nums || empty($nums) || !is_numeric($nums)) {
                        $nums = 1;
                    } else {
                        $nums += 1;
                    }
                    Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', $nums);
                    //扣量到主渠道
                    if (in_array($nums, $buckle_nums) && $nums != $channel_buckle_nums) {
                        Yii::$app->redis->hset('register', $uuid . 'channelID', $mainChannel); //redis缓存丢失，重新设置
                        return self::updateAll(['channelID' => $mainChannel], ['uid' => $uid]);
                    }
                    //扣量到父渠道
                    if ($nums == $channel_buckle_nums) {
                        Yii::$app->redis->hset('register', $uuid . 'channelID',
                                $buckle_quantity_channel); //redis缓存丢失，重新设置
                        //归零
                        Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', 0);
                        return self::updateAll(['channelID' => $buckle_quantity_channel], ['uid' => $uid]);
                    }
                }
            } elseif ($parentInfo['register_buckle_quantity'] > $channel_buckle_nums) {
                //如果父渠道扣量位数大于 子渠道扣量位数
                //计算父渠道扣量位数
                $parent_buckle_nums = floor($parentInfo['register_buckle_quantity'] / $channel_buckle_nums);
                for ($i = 1; $i <= $parent_buckle_nums; $i++) {
                    $buckle_nums[] = $i * $channel_buckle_nums;
                }
                if ($parentInfo['register_buckle_quantity'] > 0) {
                    $nums = Yii::$app->redis->hget('channel_register' . $channelID, '_buckle_quantity');
                    if ($nums > $parentInfo['register_buckle_quantity'] || empty($nums) || !is_numeric($nums)) {
                        $nums = 1;
                    } else {
                        $nums += 1;
                    }
                    Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', $nums);
                    //扣量到主渠道
                    if ($nums == $parentInfo['register_buckle_quantity']) {
                        Yii::$app->redis->hset('register', $uuid . 'channelID', $mainChannel); //redis缓存丢失，重新设置
                        //归零
                        Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', 0);
                        return self::updateAll(['channelID' => $mainChannel], ['uid' => $uid]);
                    }
                    //扣量到父渠道
                    if (in_array($nums, $buckle_nums) && $nums != $parentInfo['register_buckle_quantity']) {
                        Yii::$app->redis->hset('register', $uuid . 'channelID',
                                $buckle_quantity_channel); //redis缓存丢失，重新设置
                        return self::updateAll(['channelID' => $buckle_quantity_channel], ['uid' => $uid]);
                    }
                }
            } else {
                //如果父渠道扣量位数等于 子渠道扣量位数  子渠道扣量位数延1位
                $channel_buckle_nums = $channel_buckle_nums + 1;
                $nums = Yii::$app->redis->hget('channel_register' . $channelID, '_buckle_quantity');
                if ($nums > $channel_buckle_nums || empty($nums)) {
                    $nums = 1;
                } else {
                    $nums += 1;
                }
                Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', $nums);
                //扣量到主渠道
                if ($nums == $parentInfo['register_buckle_quantity']) {
                    Yii::$app->redis->hset('register', $uuid . 'channelID', $mainChannel); //redis缓存丢失，重新设置
                    return self::updateAll(['channelID' => $mainChannel], ['uid' => $uid]);
                }
                //扣量到父渠道
                if ($nums == $channel_buckle_nums && $nums != $parentInfo['register_buckle_quantity']) {
                    Yii::$app->redis->hset('register', $uuid . 'channelID', $buckle_quantity_channel); //redis缓存丢失，重新设置
                    //归零
                    Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', 0);
                    return self::updateAll(['channelID' => $buckle_quantity_channel], ['uid' => $uid]);
                }
            }
        }
        //父渠道不扣量，子渠道直接扣到对应渠道
        if (empty($parentInfo['register_buckle_quantity']) && $channelData['register_buckle_quantity'] > 0) {
            //扣量到渠道
            $buckle_quantity_channel = empty($channelData['buckle_quantity_to_channel']) ? $channelData['parent_id'] : $mainChannel;
            if ($channelData['register_buckle_quantity'] > 0) {
                $nums = Yii::$app->redis->hget('channel_register' . $channelID, '_buckle_quantity');
                if ($nums > $channelData['register_buckle_quantity'] || empty($nums)) {
                    $nums = 1;
                } else {
                    $nums += 1;
                }
                Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', $nums);
                //扣量到渠道
                if ($nums == $channelData['register_buckle_quantity']) {
                    Yii::$app->redis->hset('register', $uuid . 'channelID', $buckle_quantity_channel); //redis缓存丢失，重新设置
                    //归零
                    Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', 0);
                    return self::updateAll(['channelID' => $buckle_quantity_channel], ['uid' => $uid]);
                }
            }
        }
        //父渠道设置了扣量，子渠道未设置 按父渠道扣量值 直接扣到主渠道
        if ($parentInfo['register_buckle_quantity'] > 0 && empty($channelData['register_buckle_quantity'])) {
            //扣量到渠道
            $nums = Yii::$app->redis->hget('channel_register' . $channelID, '_buckle_quantity');
            if ($nums > $parentInfo['register_buckle_quantity'] || empty($nums)) {
                $nums = 1;
            } else {
                $nums += 1;
            }
            Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', $nums);
            //扣量到渠道
            if ($nums == $parentInfo['register_buckle_quantity']) {
                Yii::$app->redis->hset('register', $uuid . 'channelID', $mainChannel); //redis缓存丢失，重新设置
                //归零
                Yii::$app->redis->hset('channel_register' . $channelID, '_buckle_quantity', 0);
                return self::updateAll(['channelID' => $mainChannel], ['uid' => $uid]);
            }
        }
    }

    /**
     * blackUser.
     * 拉黑用户
     *
     * @param integer $uid 用户id.
     * @param integer $status 1正常2封禁.
     * @return mixed.
     */
    public function blackUser($uid, $status = 2) {
        $model = self::findOne(['uid' => $uid]);
        if (empty($model)) {
            throw new \Exception('该uid不存在', 201);
        }
        if ($status == 1) {
            Yii::$app->redis->hset('register', $model->account . 'state', $status);
        } else {
            Yii::$app->redis->hset('register', $model->account . 'state', $status);
        }
        $model->state = $status;
        if (!$model->save()) {
            throw new \Exception('失败', 202);
        }
        return true;
    }

    /**
     * blackIpUser.
     * 根据ip拉黑用户
     *
     * @param string $ip ip.
     * @return mixed.
     */
    public function blackIpUser($ip) {
        if (!self::updateAll(['state' => 2], ['ip' => $ip])) {
            throw new \Exception('失败', 202);
        }
        return true;
    }

    /**
     * blackMacUser.
     * 根据mac拉黑用户
     *
     * @param string $ip ip.
     * @return mixed.
     */
    public function blackMacUser($mac) {
        if (!self::updateAll(['state' => 2], ['mac' => $mac])) {
            throw new \Exception('失败', 202);
        }
        return true;
    }

    /**
     * 重置密码.
     *
     * @param integer $uid 用户id.
     * @param string $new_password 新密码.
     * @return mixed.
     */
    public function resetPasswords($uid, $new_password) {
        $model = self::findOne(['uid' => $uid]);
        if (empty($model)) {
            throw new \Exception('该uid不存在', 201);
        }
        $model->password = password_hash($new_password, PASSWORD_BCRYPT);
        if (!$model->save()) {
            throw new \Exception('失败', 202);
        }
        return true;
    }

    /**
     * 重置登录.
     *
     * @param integer $uid 用户id.
     * @return mixed.
     */
    public function resetLogin($uid, $status = 2) {
        $model = self::findOne(['uid' => $uid]);
        if (empty($model)) {
            throw new \Exception('该uid不存在', 201);
        }

        $model->account = '';
        if (!$model->save()) {
            throw new \Exception('失败', 202);
        }
        Yii::$app->redis->hset('register', $model->account, '');
//        //重置登录状态
//        Yii::$app->redis->hset('login_status', $uid, $status);
        return true;
    }

    /**
     * 绑定账号
     * @param type $uid
     * @param type $account
     * @param type $password
     * @return boolean
     */
    public function bindAccountData($uid, $account, $password) {
        $accountExist = $this->find()->where(['customAccount' => $account])->asArray()->one();
        if (!empty($accountExist)) {
            $this->addError('mesg', ['240', '登陆账号已被使用']);
            return false;
        }

        $uidData = $this->find()->where(['uid' => $uid, 'power' => 7, 'accountType' => 1])->asArray()->one();
        if (empty($uidData)) {
            $this->addError('mesg', ['240', '账号异常无法绑定']);
            return false;
        }
        $password = password_hash($password, PASSWORD_BCRYPT);
        $boor = $this->updateAll(['password' => $password, 'customAccount' => $account, 'accountType' => 2],
                ['uid' => $uid]);
        if ($boor) {
            return true;
        } else {
            $this->addError('mesg', ['240', '账号异常无法绑定']);
            return false;
        }
    }

    /**
     * 登陆账号密码
     * @param type $account
     * @param type $password
     * @return boolean
     */
    public function checkAccountPassword($account, $password) {
        // $password = password_hash($password, PASSWORD_BCRYPT);

        $data = $this->find()->where(['customAccount' => $account, 'accountType' => 2])->asArray()->one();
        if (!empty($data['password'])) {
            $boor = password_verify($password, $data['password']);
            if ($boor) {
                return $data;
            } else {
                $this->addError('mesg', ['241', '账号密码错误']);
                return false;
            }
        } else {

            $password = md5($password);
            $data = $this->find()->where(['preservationLoginAccount' => $account, 'preservationLoginPassword' => $password])->asArray()->one();
            if (!empty($data)) {
                return $data;
            }
            $this->addError('mesg', ['240', '账号密码错误']);
            return false;
        }
    }

    /**
     * 增加用户推广人数
     * @param type $uid
     * @param type $number
     * @return type
     */
    static public function addUserPeopenNUmber($uid, $number) {
        $boor = self::updateAll(['people' => new Expression('people+' . $number)], ['uid' => $uid]);
        return $boor;
    }

    //修改用户分享属性 。并且修改渠道
    static public function updateUserShareUid($uid, $shareId) {
        $existData = User::getOneUserInfo($uid);
        if (!empty($existData['addtime']) && $existData['addtime'] > time() - 10) {
            if (empty($existData['shareUid'])) {//修改shareUid
                $update = ['shareUid' => $shareId];
                //获取跳转渠道
                $channelID = ChannelManage::shareChannel;
                $update['channelID'] = $channelID;
                $boor = self::updateAll($update, ['uid' => $uid]);
                //渠道注册计数统计
                if ($boor) {
                    $today = date('Y-m-d');
                    DayStatistics::addDayStatistics($today, $existData['channelID'], $GLOBALS['device_type'], 'register', -1, $GLOBALS['versions']);
                }
            }
        }
    }

    /**
     * 增加用户奖励金额
     * @param type $uid
     * @param type $number
     * @return type
     */
    static public function addUserExtensionReward($uid, $number) {
        $boor = self::updateAll(['extensionReward' => new Expression('extensionReward+' . $number)], ['uid' => $uid]);
        return $boor;
    }

    /**
     * 获取最多的奖励金额
     * @param type $uid
     * @param type $number
     * @return type
     */
    static public function getMaxExtensionReward() {


        $fields = ['uid', 'nickname', 'extensionReward'];
        $sort = '-extensionReward';
        self::$key = $fields;
        $data = self::listFind(['page' => 1, 'row' => 5, 'sort' => $sort])->where([])->all();
        return $data;
    }

    /**
     * 获取用户uid对应的pin
     * @param type $uid
     */
    public static function getUserUidPin($uid) {
        $existData = self::find()->where(['uid' => $uid])->asArray()->one();
        if (!empty($existData)) {
            if (!empty($existData['pin'])) {
                return $existData['pin'];
            } else {
                $hashids = HashidsHelper::instance(8);
                $pin = $hashids->encode($existData['uid']); //加密
                $update = [
                    'pin' => $pin
                ];
                self::updateAll($update, ['uid' => $uid]);
                return $pin;
            }
        }
        return null;
    }

    /**
     * 获取用户pin对应的uid
     * @param type $uid
     */
    public static function getUserPinUid($pin) {
        $existData = self::find()->where(['pin' => $pin])->asArray()->one();
        if (!empty($existData['uid'])) {
            return $existData['uid'];
        }
        return null;
    }

    /**
     * 获取用户pin对应的uid
     * @param type $channelID
     */
    public function getAppHomeConfig($uid, $versions = 2, $channelID = '') {
        //启动时间
        $startUpCountDown = 5;
        $startUpCountDown = SystemConfigure::getSystemConfigure('startUpCountDown');
        $startUpCountDown = !empty($startUpCountDown) ? $startUpCountDown : '5';
        $data = array();
        $data['startUpCountDown'] = $startUpCountDown;
        $data['app_name'] = '右手视频'; //视频名称
        $data['pay_url'] = ''; //支付h5页面地址 有的话就在个人中心显示入口

        $data['logo'] = 'https://img-encode1.oss-cn-chengdu.aliyuncs.com/2021/4/4cd5493e0e7163231622f3bc6be254b3a9455000.png'; //https://cdn.jsdelivr.net/gh/eric178178/gopay/static/images/playlogo.png';//app logo
        $data['ad'] = 'https://ff-123123.gz.bcebos.com/2021/7/7ec7caac995c8df3a36e07a3522d7af5c2da4374.jpg'; //'https://cdn.jsdelivr.net/gh/eric178178/gopay/static/images/ad1.jpg';//进入app的广告页
        //登录的
        $data['login_pic'] = 'https://img-encode1.oss-cn-chengdu.aliyuncs.com/2021/c/ce5de9ff6078d0c37b28fe0e7432fa23184d5ca0.jpg'; //'https://cdn.jsdelivr.net/gh/eric178178/gopay/static/images/login1.jpg';

        $data['video_ad'] = 'https://img-encode1.oss-cn-chengdu.aliyuncs.com/2021/2/29e59264f091fe3c46199af73c67c6c892b393b8.jpg';

        $USAUrl = SystemConfigure::getSystemConfigure('USAUrlHttps'); //app 图片地址
        if (empty($USAUrl))
            $USAUrl = Yii::$app->params['USAUrlHttps'];

        $USAUrlH5 = SystemConfigure::getSystemConfigure('USAUrlHttpsH5'); //h5 图片地址
        if (empty($USAUrlH5))
            $USAUrlH5 = Yii::$app->params['USAUrlHttps'];
        $ClientUploadUrl = SystemConfigure::getSystemConfigure('ClientUploadUrl'); //h5 图片地址
        if (empty($ClientUploadUrl)) {
            $ClientUploadUrl = Yii::$app->params['ClientUploadUrl'];
        }
        $data['img_cdn_h5'] = $USAUrlH5; //imgEncryptConf
        $data['img_cdn'] = $USAUrl; //imgEncryptConf
        //$data['img_cdn'] = Yii::$app->params['USAUrlHttps']; //imgEncryptConf
        $data['client_upload_cdn'] = $ClientUploadUrl; //imgEncryptConf
        $data['img_aes'] = array(
            'key' => Yii::$app->params['imgEncryptConf']['key'],
            'iv' => Yii::$app->params['imgEncryptConf']['iv']
        ); //图片的加密key

        $data['short_video_cache_num'] = 3;
        //user
//        $UserData = User::getOneUserInfo($uid);
        //分享地址
        $share_url = SystemConfigure::getSystemConfigure('update_url');
//        if (!empty($UserData['channelID'])) {
//            $share_url = $share_url . '?channel=' . $UserData['channelID'];
//        }
        //黑料地址
        $data['hl_url'] = SystemConfigure::getSystemConfigure('hl_url');
        //底部广告
        $model = new BottomPopup();
        $data['bottom'] = $model->getRandPopup();

        if (!empty($channelID)) {
            $share_url = $share_url . '?channel=' . $channelID;
        }

        //弹窗公告
        if (!empty($GLOBALS['device_type']) && $GLOBALS['device_type'] == 1) {
            $platform = 1;
        } else {
            $platform = 2;
        }
        $model = new PopupNotice();
        $fields = ['id', 'content', 'pic', 'noticeType', 'countDown'];
        $PopupNotice = $model->getClientList($fields, $platform);
        //弹窗公告
//        $model = new IndependentNotice();
//        $fields = ['id', 'content', 'pic', 'url', 'countDown'];
//        $PopupNotice = $model->getClientList($fields, null, $channelID);

        $data['PopupNotice'] = $PopupNotice;

        //大版本更新数据
        $data['Version'] = '3.0.0';
        $data['VersionApk'] = '1.0.1';
        $data['VersionIos'] = '1.0.1';
        $data['updateUrlapk'] = $share_url;
        $data['updateUrlios'] = $share_url;
        $data['updateMessage'] = "APP 新版本全新上线，\n请全网狼友优先保存账号凭证，\n以免账号丢失。\n下载地址：" . $share_url;

        //获取开屏广告
        $model = new OpenScreen();
        $OpenScreenData = $model->getClientList([], $channelID);
        if (!empty($OpenScreenData)) {
            $app_start_up = $OpenScreenData['pic'];
            $app_start_up_url = $OpenScreenData['url'];
        } else {
            $app_start_up = SystemConfigure::getSystemConfigure('app_start_up');
            $app_start_up_url = SystemConfigure::getSystemConfigure('app_start_up_url');
        }

        $data['suspensionUrl'] = '';
        $downloadH5Url = SystemConfigure::getSystemConfigure('downloadH5Url');
        if (!empty($downloadH5Url))
            $data['suspensionUrl'] = $downloadH5Url;
        $data['update_apk_url'] = SystemConfigure::getSystemConfigure('update_apk_url');
        // $app_start_up = SystemConfigure::getSystemConfigure('app_start_up');
        // $app_start_up_url = SystemConfigure::getSystemConfigure('app_start_up_url');
        $app_start_up_time = SystemConfigure::getSystemConfigure('app_start_up_time');

        if (!empty($app_start_up)) {
            $ad = $data['img_cdn'] . '/' . $app_start_up;
        }

        $data['ad'] = [
            'pic' => $ad,
            'type' => 1,
            'extra' => $app_start_up_url,
            'flag' => 'index_1',
            'time' => $app_start_up_time
        ];
        //是否开启游戏
        $data['is_open_game'] = ChannelManage::getIsOpenGame($channelID);
        //广告轮播间隔秒数
        $data['advertisement_interval'] = SystemConfigure::getSystemConfigure('advertisement_interval');
        if (empty($data['advertisement_interval']))
            $data['advertisement_interval'] = 3;
        //背景广告图
        $data['video_advertisement_pic'] = '';
        $data['video_advertisement_url'] = '';
        $data['video_advertisement_time'] = 0;
        $data['identity_pic'] = '';
        $data['share_pic'] = '';

        $model = new ImgAdvertisement();
        $existData = $model->getImgAdvertisementClinetList(1, $GLOBALS['channelID']);
        if (!empty($existData)) {
            $data['video_advertisement_pic'] = $existData['pic'];
            $data['video_advertisement_url'] = $existData['url'];
            $data['video_advertisement_time'] = $existData['countDown'];
            //
        }
        $existData = $model->getImgAdvertisementClinetList(2, $GLOBALS['channelID']);
        if (!empty($existData)) {
            $data['identity_pic'] = $existData['pic'];
        }
        $existData = $model->getImgAdvertisementClinetList(3, $GLOBALS['channelID']);
        if (!empty($existData)) {
            $data['share_pic'] = $existData['pic'];
        }

        return $data;
    }

    /**
     * timingDeleteUser.
     * 定时删除用户
     *
     * @param integer $time .
     * @return mixed.
     */
    public function timingDeleteUser($time) {
        $end_time = time();
        $data = self::find()->distinct()->select('a.uid')->alias('a')
                ->leftJoin('user_money AS b', 'a.uid = b.uid')
                ->leftJoin('user_login AS c', 'a.uid = c.uid')
                ->where(['not between', 'c.addtime', $time, $end_time])
                ->andwhere(['<=', 'b.vip_valid_time', $end_time])
                ->asArray()
                ->all();
        $dataInfo = self::find()->select('a.uid')->alias('a')
                ->leftJoin('user_money AS b', 'a.uid = b.uid')
                ->where(['<', 'a.addtime', $time - 3 * 86400])
                ->andwhere(['power' => self::USER_POWER])
                ->andwhere(['=', 'b.vip_valid_time', 0])
                ->andwhere(['=', 'b.score', 0])
                ->asArray()
                ->all();
        if (!empty($data) || !empty($dataInfo)) {
            $data_id_array = array_unique(array_column($data, 'uid'));
            $id_info = array_unique(array_column($dataInfo, 'uid'));
            $id_array = array_unique(array_merge_recursive($data_id_array, $id_info));
            $userInfo = self::find()->select('account')->where(['in', 'uid', $id_array])->asArray()->all();
            foreach ($userInfo as $key => $value) {
                Yii::$app->redis->hdel('register', $value['account'], $value['account'] . 'channelID', $value['account'] . 'state');
            }
            return User::deleteAll(['in', 'uid', $id_array]);
        }
        return true;
    }

    /**
     * 获取影片试看总次数
     * @param type $uid
     */
    public function getUserPlayCountNumber($uid) {
        $key = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($key));
        if ($redisData !== false) {
            return $redisData;
        }
        $data = SystemConfigure::getSystemConfigure('video_try_number');
        $data = $data ?? 0;
        //额外次数
        $userData = $this->find()->where(['uid' => $uid])->asArray()->one();
        if (!empty($userData['playcount'])) {
            $data = $data + $userData['playcount'];
        }

        //更新缓存
        $time = Yii::$app->params['redisTime'];
        $this->redisCacheOperation(md5($key), $data, $time);
        return $data;
    }

    /**
     * 获取vip等级
     * @param type $rank
     * @return string
     */
    public static function getVipName($rank) {
        $vipData = ['', '普通会员', '青铜', '白银', '黄金', '铂金'];
        if (!empty($vipData[$rank]))
            return $vipData[$rank];
        return '';
    }

    /**
     * 获取用户信息
     * @param type $uid
     * @return type
     */
    public function getUserMessage($uid) {
        //$vipData = ['', '普通会员', '青铜', '白银', '黄金', '铂金'];
        $user = $this->find()->where(['uid' => $uid])->asArray()->one();
        $userMoney = UserMoney::getUserMoneyOne($user['uid']);
        //头像
        if (!empty($user['pic'])) {
            $model = new UserPics();
            $data['pic'] = $model->getPicUrl($user['pic']);
        } else {
            $data['pic'] = '';
        }

        $data['customAccount'] = $user['customAccount'] ?? '';
        $data['birth'] = date('Y-m-d', $user['birth']);
        $data['phone'] = $user['account'];
        if (!$user['nickname']) {
            $data['nickname'] = $this->updateUidRandName($uid);
            //
            //$data['nickname'] = ''; //'网友 ' . UserPin::getUidPin($user['uid']);
        } else {
            $data['nickname'] = $user['nickname'];
        }
        $modelUserPics = new UserPics();
        $data['photo'] = $modelUserPics->getPicUrl($user['photo']) ?? ''; //头像
        $data['gender'] = $user['gender'] ?? 1; //性别 1男 2女
        $data['city'] = $user['city'] ?? '火星'; //城市 。上海
        $data['messageNumber'] = 0; //未读消息

        $data['uid'] = intval($user['uid']);
        //是否是vip
        $data['vip'] = 0;
        $data['vip_expire'] = 0;
        if (!empty($userMoney['vip_valid_time']) && $userMoney['vip_valid_time'] > time()) {
            $data['vip'] = 1;
            $data['vip_expire'] = $userMoney['vip_valid_time'];
        }
        //佣金剩余
        $data['commission'] = $userMoney['commission'];

        //是否是社区vip
        $data['communityVip'] = 0;
        if (!empty($userMoney['community_time']) && $userMoney['community_time'] > time()) {
            $data['communityVip'] = 1;
        }
        //游戏币
        $data['score'] = $userMoney['score'];
        //vip等级
        $data['rank'] = $user['rank'];
        $data['rank_name'] = '';
        if (!empty($user['rank'])) {
            $vipName = self::getVipName($user['rank']);
            if (!empty($vipName))
                $data['rank_name'] = $vipName;
        }
        //邀请人数
        $data['people'] = $user['people'];
        //试看次数
        $today = date('Y-m-d');
        $playcount = Yii::$app->redis->hget('user_play_count_' . $today, $user['uid']) ?? 0; //

        $video_try_type = SystemConfigure::getSystemConfigure('video_try_type');
        if ($video_try_type == 1) {
            //最大试看次数
            $data['playcountMax'] = $this->getUserPlayCountNumber($user['uid']) ?? 0;
            //一次性播放次数
            $disposablePlayNumber = $userMoney['disposablePlayNumber'];
            $data['playcountMax'] = intval($data['playcountMax'] + $disposablePlayNumber);
            $data['playcount'] = $data['playcountMax'] - $playcount;
            $data['playcount'] = intval($data['playcount']);
        } else {
            $data['playcountMax'] = $userMoney['disposablePlayNumber'];
            $data['playcount'] = $userMoney['disposablePlayNumber'];
        }


        // $data['playcount_now'] = 0;
        $data['money'] = $userMoney['money'] ?? 0;
        //$data['upload_num'] = mod_user::upgrade_num($user['rank'] + 1, $user['people']);
        //头部轮播
        //获取轮播广告
        $model = new Headbar();
        $fields = ['pic', 'url', 'type'];
        $HeadbarData = $model->getClientList($fields, 4);
        $data['headbar'] = $HeadbarData;
        //
        //判定茶贴发帖次数剩余
        $data['chick_post_number'] = '0';
        if (!empty($userMoney['chick_post_number'])) {
            $data['chick_post_number'] = $userMoney['chick_post_number'];
        }

        //获取客服链接
        $data['customer_service_url '] = SystemConfigure::getSystemConfigure('customer_service_url');
        //获取试看
        //$systemConfigure = RedisCache::get('user_play_count_' . $today, $GLOBALS['uid']);
        //$startUpCountDown = !empty($startUpCountDown) ? $startUpCountDown: '5';       
        //试看时长
        // $data['video_try_time'] = SystemConfigure::getSystemConfigure('video_try_time');
        //充值弹窗
        // $data['video_recharge_mask'] = SystemConfigure::getSystemConfigure('video_recharge_mask');
        //找回账号相关
        $data['on_line_service'] = SystemConfigure::getSystemConfigure('on_line_service');
        $data['download_url1'] = SystemConfigure::getSystemConfigure('download_url1');
        $data['download_url2'] = SystemConfigure::getSystemConfigure('download_url2');

        //获取用户信息
        $data['bindRemind'] = 1; //默认不弹
        if (!empty($user) && empty($user['customAccount'])) {
            if (!empty($userMoney['vip_valid_time'])) {//有过数据
                $data['bindRemind'] = 2; //默认不弹
            }
        }

        $existData = UserPinDetail::inspectUUIdExistence($uid);
        if (!empty($existData)) {
            $data['pinType'] = 1;
        } else {
            $data['pinType'] = 2;
        }

        return $data;
    }

    /**
     * 随机更新昵称
     * @param type $uid
     * @return type
     */
    public function updateUidRandName($uid) {
        $nickname = RandName::RandUidName();
        $boor = $this->setUpAccontMessage($uid, $nickname);
        if (!empty($boor)) {
            return $nickname;
        }
        return '';
    }

    /**
     * getMultiUserInfo.
     * 获取用户信息
     *
     * @param array $uid_array id集合.
     *
     * @return mixed.
     */
    public static function getMultiUserInfo($fields = [], $uid_array = []) {
        $ret = [];
        $data = self::find()->select($fields)->where(['in', 'uid', $uid_array])->asArray()->all();
        foreach ($data as $key => $value) {
            $ret[$value['uid']] = [
                'phone_model' => $value['phone_model'],
                'system_version' => $value['system_version'],
            ];
        }
        return $ret;
    }

    /**
     * 修改玩家茶馆基本信息
     * @param type $uid         用户id
     * @param type $nickname    用户昵称
     * @param type $photo       用户头像
     * @param type $gender      性别
     * @param type $city        城市
     * @return boolean
     */
    public function setUpAccontMessage($uid, $nickname = null, $photo = null, $gender = null, $city = null) {
        $update = [
        ];
        if (!empty($nickname))
            $update['nickname'] = $nickname;
        if (!empty($photo))
            $update['photo'] = $photo;
        if (!empty($gender))
            $update['gender'] = $gender;
        if (!empty($city))
            $update['city'] = $city;

        if (empty($update)) {
            $this->addError('mesg', ['240', '修改数据不能为空']);
            return false;
        }


        $boor = $this->updateAll($update, ['uid' => $uid]);
        if (!empty($boor)) {
            return true;
        }

        $this->addError('mesg', ['240', '修改失败']);
        return false;
    }

    /**
     * 获取用户信息 微博
     * @param type $uid
     */
    public function getUserListWeiBoData($uidList) {
        $uid = json_encode($uidList);
        $redisKey = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($redisKey));
        if ($redisData !== false) {
            return $redisData;
        }
        $fields = ['uid', 'photo', 'gender', 'city', 'nickname'];
        self::$key = $fields;
        $where = [
            'and',
            ['in', 'uid', $uidList],
        ];

        $dataTemp = $this->listFind(['row' => count($uidList)])->where($where)->all();
        $data = [];
        foreach ($dataTemp as $key => $value) {
            $data[$value['uid']] = $value;
        }
        //更新缓存
        $time = Yii::$app->params['redisTime'];
        $this->redisCacheOperation(md5($redisKey), $data, $time);
        return $data;
    }

    /**
     * 更新用户关注数以及粉丝数
     * @param type $uid         用户ID
     * @param type $number      增加数量
     * @param type $type        1为关注 。 2为粉丝
     * @param type $followType  1为增加 。2为取消
     * @return type
     */
//    static public function addUserFollowFansNUmber($uid, $number, $type, $followType) {
//        if ($type == 1) {//关注
//            if ($followType == 1) {//增加
//                return self::updateAll(['followNumber' => new Expression('followNumber+' . $number)], ['uid' => $uid]);
//            } else if ($followType == 2) {//减少
//                $where = [
//                    'and',
//                    ['=', 'uid', $uid],
//                    ['>=', 'followNumber', $number]
//                ];
//                return self::updateAll(['followNumber' => new Expression('followNumber-' . $number)], $where);
//            }
//        } elseif ($type == 2) {
//            if ($followType == 1) {//增加
//                return self::updateAll(['followNumber' => new Expression('fansNumber+' . $number)], ['uid' => $uid]);
//            } else if ($followType == 2) {//减少
//                $where = [
//                    'and',
//                    ['=', 'uid', $uid],
//                    ['>=', 'fansNumber', $number]
//                ];
//                return self::updateAll(['fansNumber' => new Expression('fansNumber-' . $number)], $where);
//            }
//        }
//        return false;
//    }

    /**
     * 更新用户关注数以及粉丝数
     * @param type $uid         用户ID
     * @param type $number      增加数量
     * @param type $type        1关注数 。 2粉丝数  3微博数 。4收到打赏  5送出打赏
     * @param type $followType  1为增加 。2为取消
     * @return type
     */
    static public function addUserFollowFansNUmber($uid, $number, $type, $followType) {
        $keyData = [1 => 'followNumber', 2 => 'fansNumber', 3 => 'weiBoNumber', 4 => 'receivedReward', 5 => 'sendOutReward'];
        if (empty($keyData[$type])) {
            return false;
        }
        if ($followType == 1) {
            $key = $keyData[$type];
            return self::updateAll(["$key" => new Expression("$key+" . $number)], ['uid' => $uid]);
        } elseif ($followType == 2) {
            $key = $keyData[$type];
            $where = [
                'and',
                ['=', 'uid', $uid],
                ['>=', $key, $number]
            ];
            return self::updateAll(["$key" => new Expression("$key-" . $number)], $where);
        }
        return false;
    }

    /**
     * 获取用户信息 微博
     * @param type $uid
     */
    public function getUserOneMessage($uid) {
        $redisKey = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($redisKey));
        if ($redisData !== false) {
            return $redisData;
        }
        $fields = [];

        $where = [
            'and',
            ['=', 'uid', $uid],
        ];
        self::$key = $fields;
        $data = $this->listFind([])->where($where)->one();

        //更新缓存
        $time = Yii::$app->params['redisTime'];
        $this->redisCacheOperation(md5($redisKey), $data, $time);
        return $data;
    }

    /**
     * 临时关闭消息缓存
     * @param type $uid
     * @param int $type $type = 2; //1关注 2茶馆 。3评论 。4打赏 。5点赞
     */
    public static function setUserMessageType($uid, $type) {
        //临时关闭缓存
        $userkey = 'messageRedisType_' . $uid;
        Yii::$app->redis->hset($userkey, $type, 2);
        $time = Yii::$app->params['redisTime'];
        Yii::$app->redis->expire($userkey, $time);
    }

    /**
     * 是否关闭缓存 。true 。未关闭 false 关闭
     * @param type $uid
     * @param type $type
     * @return boolean
     */
    public static function getUserMessageType($uid, $type) {
        $userkey = 'messageRedisType_' . $uid;
        $boor = Yii::$app->redis->hget($userkey, $type);
        if (!empty($boor)) {
            return false;
        }
        return true;
    }

    /**
     * 搜索昵称
     * @param type $name
     * @return type
     */
    public function getUserNameData($name) {
        $where = [
            'and',
            ['=', 'nickname', $name]
        ];
        return $this->find()->where($where)->asArray()->one();
    }

    /**
     * getOneUserInfo.
     * 获取单个用户信息
     *
     * @param integer $uid 用户id.
     * @return mixed.
     */
    public function getClientOneUserInfo($uid) {
        $redisKey = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($redisKey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $data = $this->find()->where(['uid' => $uid])->asArray()->one();

        //更新缓存
        $time = Yii::$app->params['redisTime'];
        $this->redisCacheOperation(md5($redisKey), $data, $time);
        return $data;
    }

    /**
     * 获取个人信息
     * @param type $uid
     * @return type
     */
    public function AccountMessage($uid) {
        $model = new User();
        $existData = $model->getUserOneMessage($uid);
        $modelUserPics = new UserPics();

        //信息拼装
        $data['followNumber'] = empty($existData['followNumber']) ? 0 : intval($existData['followNumber']);
        $data['fansNumber'] = empty($existData['fansNumber']) ? 0 : intval($existData['fansNumber']);
        $data['weiBoNumber'] = empty($existData['weiBoNumber']) ? 0 : intval($existData['weiBoNumber']);
        $data['receivedReward'] = empty($existData['receivedReward']) ? 0 : intval($existData['receivedReward']);
        $data['sendOutReward'] = empty($existData['sendOutReward']) ? 0 : intval($existData['sendOutReward']);
        $data['gender'] = empty($existData['gender']) ? 1 : intval($existData['gender']);
        $data['city'] = empty($existData['city']) ? '火星' : $existData['city'];
        if (!empty($existData['nickname'])) {
            $data['nickname'] = $existData['nickname'];
        } else {
            $data['nickname'] = $model->updateUidRandName($uid); //'网友 ' . UserPin::getUidPin($existData['uid']);
        }


        //$data['nickname'] = empty($existData['nickname']) ? '' : $existData['nickname'];
//        if (!$user['nickname']) {
//            $data['nickname'] = '网友 ' . UserPin::getUidPin($user['uid']);
//        } else {
//            $data['nickname'] = $user['nickname'];
//        }

        $data['photo'] = $modelUserPics->getPicUrl($existData['photo']) ?? '';
        $data['uid'] = empty($existData['uid']) ? 0 : intval($existData['uid']);

        $data['messageNumber'] = 0; //未读消息
        //是否关注
        $data['followType'] = 2;
        $followType = WeiBoFollow::getUserFollowData($GLOBALS['uid'], $uid);
        if (!empty($followType)) {
            $data['followType'] = intval($followType);
        }
        //认证标签
        $model = new WeiBoAuthentication();
        $fields = ['id', 'tagid'];
        $data['authenticationData'] = $model->getClientList($uid, $fields);
        $data['money'] = 0;
        $model = new UserMoney();
        $MoneyData = $model->getUserMoneyOne($uid);
        if (!empty($MoneyData['money'])) {
            $data['money'] = $MoneyData['money'];
        }
        return $data;
    }

    /**
     * updateUserChannel.
     * 更改用户渠道
     *
     * @param integer $uid 用户id.
     * @return mixed.
     */
    public function updateUserChannel($uid, $channelID) {
        $model = self::findOne(['uid' => $uid]);
        if (empty($model)) {
            throw new \Exception('该uid不存在', 201);
        }
        $uuid = $model->account;
        //
        $model->channelID = $channelID;
        if (!$model->save()) {
            throw new \Exception('修改失败', 202);
        }
        Yii::$app->redis->hset('register', $uuid . 'channelID', $channelID);
        return true;
    }

//    
//            ['preservationLoginAccount', 'string'], //保存登陆账号
//            ['preservationLoginPassword', 'string'], //保存登陆密码
//            ['preservationPasswordPlaintext', 'string'], //保存登陆密码 明文

    /**
     * 绑定账号
     * @param type $uid
     * @param type $account
     * @param type $password
     * @return boolean
     */
    public function getUserPreservationLoginAccount($uid) {
        $redisKey = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($redisKey));
        if ($redisData !== false) {
            return $redisData;
        }
        $accountExist = $this->find()->where(['uid' => $uid])->asArray()->one();
        if (!empty($accountExist['preservationLoginAccount'])) {
            $data['Account'] = $accountExist['preservationLoginAccount'];
            $data['Password'] = $accountExist['preservationPasswordPlaintext'];
            //        //更新缓存
            $time = Yii::$app->params['redisTime'];
            $this->redisCacheOperation(md5($redisKey), $data, $time);
            return $data;
        }
        if (empty($accountExist)) {
            $this->addError('mesg', ['240', '账号异常无法绑定']);
            return false;
        }
        $preservationLoginAccount = $this->getRandString($count = 8);
        $preservationPasswordPlaintext = $this->getRandString($count = 8);
        $preservationLoginPassword = md5($preservationPasswordPlaintext);
        $update = [
            'preservationLoginAccount' => $preservationLoginAccount,
            'preservationLoginPassword' => $preservationLoginPassword,
            'preservationPasswordPlaintext' => $preservationPasswordPlaintext,
        ];
        $boor = $this->updateAll($update, ['uid' => $uid]);
        if ($boor) {
            $data['Account'] = $update['preservationLoginAccount'];
            $data['Password'] = $update['preservationPasswordPlaintext'];
            //更新缓存
            $time = Yii::$app->params['redisTime'];
            $this->redisCacheOperation(md5($redisKey), $data, $time);
            return $data;
        } else {
            $this->addError('mesg', ['240', '账号密码获取失败']);
            return false;
        }
    }

    /**
     * 生成随机字符串
     * @param type $count
     * @return type
     */
    public function getRandString($count = 8) {

        $strs = "abcdefghijklmnopqrstuvwxyz1234567890";
        $name = substr(str_shuffle($strs), mt_rand(0, strlen($strs) - $count - 1), $count);
        return $name;
    }

    /**
     * getTimeData.
     * 获取时间段数据
     *
     * @param integer $channelID 渠道.
     * @param integer $start_time 开始时间.
     * @param integer $end_time 结束时间.
     * @param integer $device_type 设备类型1安卓2ios.
     * @param integer $is_bind 是否绑定1是2否
     * @return mixed.
     */
    public static function getTimeData($channelID, $start_time, $end_time, $is_bind = '', $device_type = '') {
        $where = [
            'and',
            ['power' => self::USER_POWER],
        ];
        if (!empty($channelID)) {
            $where[] = ['=', 'channelID', $channelID];
        }
        if (!empty($device_type)) {
            $where[] = ['=', 'device_type', $device_type];
        }
        $ret['total_register'] = self::find()->where($where)->count('uid') ?? 0; //注册
        if (!empty($start_time)) {
            $where[] = ['>=', 'addtime', $start_time];
        }
        if (!empty($end_time)) {
            $where[] = ['<=', 'addtime', $end_time];
        }
        $ret['today_register'] = self::find()->where($where)->count('uid') ?? 0; //当日注册
        if ($is_bind == 1) {
            $where[] = ['!=', 'customAccount', null];
        }
        $ret['total_bind'] = self::find()->where($where)->count('uid') ?? 0; //绑定
        $ret['today_bind'] = self::find()->where($where)->count('uid') ?? 0; //当日绑定
        return $ret;
    }

    /**
     * 更新绑定手机号
     * @param type $uid
     * @param type $mobile
     * @return boolean
     */
    public function updateUserMobile($uid, $mobile) {

        $mobileData = $this->find()->where(['mobile' => $mobile])->asArray()->one();
        if (!empty($mobileData)) {
            return false;
        }

        $existData = $this->find()->where(['uid' => $uid])->asArray()->one();
        if (empty($existData)) {
            return false;
        }
        if (!empty($existData['mobile'])) {
            return false;
        }

        $boor = $this->updateAll(['mobile' => $mobile], ['uid' => $uid]);
        if ($boor) {
            return true;
        }
        return false;
    }

    /**
     * 验证码绑定手机
     * @param type $uid
     * @param type $mobile
     * @param type $code
     * @return boolean
     */
    public function updateUserMobileSms($uid, $mobile, $code) {

        $UserData = $this->find()->where(['uid' => $uid])->asArray()->one();
        if (!empty($UserData['mobile'])) {
            $this->addError('mesg', ['241', '无需重复绑定']);
            return false;
        }
        //验证手机验证码是否正确
        $model = new SendSMSLog();
        $boor = $model->checkPhoneCode($mobile, $code);
        if (!$boor) {
            $this->addError('mesg', ['241', '验证码错误']);
            return false;
        }

        $boor = $this->updateUserMobile($uid, $mobile);
        if (!empty($boor)) {
            return true;
        }
        $this->addError('mesg', ['241', '绑定失败']);
        return false;
    }
    
    
    
    /**
     * 获取渠道充值数据
     * @param type $channelID
     * @param type $start_time
     * @param type $end_time
     * @return type
     */
    public function getUserRetainedStatisticsData($channelID, $start_time, $end_time) {

        $where = [
            'and',
            ['>=', 'addtime', $start_time],
            ['<=', 'addtime', $end_time]
        ];
        if ($channelID <> 1) {
            $where[] = ['=', 'channelID', $channelID];
        }

        return $this->find()->where($where)->count() ?? 0;
    }

}
