<?php

namespace common\models;

use think\process\Utils;
use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  签到记录
 */
class SignInRecord extends BaseModel
{

    protected $table = 't_sign_in_record';

    public static function tableName()
    {
        return '{{t_sign_in_record}}';
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['dateDay', 'string'], //签到日期
            ['continuousDay', 'number'], //当前连续天数
            ['rewardType', 'number'], //奖励类型 。1余额 。2备付金 。3金砖币 。//4实物
            ['rewardNumber', 'number'], //奖励数量
            ['type', 'number'], //状态  1为申请下发 2下发成功 3为下发异常
            ['signInType', 'number'], //签到类型: 1为连续签到奖励, 2为累积天数奖励
            ['is_pay', 'number'], //1-已支付
            ['itime', 'number'], //
            ['utime', 'number'], //
            ['img', 'string']
        ];
    }

    public function hasSign($uid)
    {
        $dateDay = date("Y-m-d", time());
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'dateDay', $dateDay],
            ['=', 'signInType', 2],
            ['=', 'type', 2]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        return (bool)$existData;
    }

    /**
     * 用户签到
     * @param type $uid
     * @return boolean
     */
    public function addSignInRecord($uid)
    {
        //不准补签

        if (!empty($existData)) {
            $this->addError('mesg', ['212', '已经签到了']);
            return false;
        }
        $yesterDay = date("Y-m-d", time() - 86400);
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'dateDay', $yesterDay],
            ['=', 'signInType', 1]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        $continuousDay = 0;
        if (!empty($existData)) {
            $continuousDay = $existData['continuousDay'];
        }
        $continuousDay = $continuousDay + 1;
        $model = new SignInReward();
        $rewardData = $model->getSignReward(SignInReward::signInTypeByContinuous);
        $data = [
            'uid' => $uid, //用户id
            'dateDay' => $dateDay, //签到日期
            'continuousDay' => $continuousDay, //当前连续天数
            'type' => 3, //1为申请下发 2下发成功 3为下发异常
            'is_pay' => 0,
            'itime' => time(), //
            'utime' => time(), //
            'rewardType' => 0,
            'rewardNumber' => 0,
            'signInType' => 1,
        ];
        if ($rewardData) {
            $data['rewardType'] = $rewardData['rewardType']; //奖励类型 。1余额 。2备付金 。3金砖币 。4实物
            $data['rewardNumber'] = $rewardData['rewardNumber']; //奖励数量状态
        }
        $this->attributes = $data;
        $boor = $this->insert($data);
        if (empty($boor)) {
            $this->addError('mesg', ['212', '添加失败']);
            return false;
        }
        if (empty($rewardData)) {
            return true;
        }
        //下发奖励
        $model = new AccountInfo();
        $boor = $model->addAccountGold($uid, $rewardData['rewardNumber'], $rewardData['rewardType']);
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'dateDay', $dateDay]
        ];
        if ($boor) {
            $this->updateAll(['type' => 2], $where);
            return true;
        }
        $this->addError('mesg', ['212', '签到成功但是奖励下发异常，联系客服']);
        return false;

    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getSignInRecordList($uid, $time = null, $page = 1, $limit = 100, $fields = [])
    {
        if (empty($time)) {
            $time = time();
        }
        $timedata = $this->getMonthStart($time);
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'signInType', 1],
            ['>', 'itime', $timedata['start']],
            ['<', 'itime', $timedata['end']]
        ];
        self::$key = $fields;
        $data = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'itime'])->where($where)->all();
        return $data;
    }

    /**
     * 获取指定时间月开始 结束时间
     * @param type $time
     * @return type
     */
    public function getMonthStart($time)
    {
        $t = date('t', strtotime($time));
        // 获取当前日期的年份和月份
        $year = date('Y', $time);
        $month = date('m', $time);

        // 获取当前月份的开始时间戳
        $startOfMonth = strtotime("{$year}-{$month}-01");
        $endOfMonth = $startOfMonth + 86400 * $t;

        $data['start'] = $startOfMonth;
        $data['end'] = $endOfMonth;
        return $data;
    }

    /**
     * 获取连续签到天数
     * @param type $uid
     * @return int
     */
    public function getContinuousType($uid)
    {
        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        $existdata = $this->find()->orderBy('id desc')->where($where)->asArray()->one();

        $continuousDay = 0;
        // 获取昨天的 Unix 时间戳
        $yesterdayStart = strtotime(date('Y-m-d', time() - 86400));
        if (!empty($existdata['continuousDay']) && $existdata['itime'] > $yesterdayStart) {
            $continuousDay = $existdata['continuousDay'];
        }
        $data['continuousDay'] = $continuousDay; //连续签到天数
        //获取累积签到奖励
        $accountData = AccountInfo::getAccountDataMessage($uid);
        $total = [1, 1, 1];
        if (!empty($accountData)) {
            if ($accountData['oneReward'] > 0)
                $total[0] = 2;
            if ($accountData['twoReward'] > 0)
                $total[1] = 2;
            if ($accountData['threeReward'] > 0)
                $total[2] = 2;
        }
        $data['total'] = $total;
        $model = new SignInReward();
        $data['totalReward'] = $model->getClientSignInList();
        return $data;
    }


    /**
     * 获取连续签到天数
     * @param type $uid
     * @return int
     */
    public function getContinuousDay($uid)
    {
        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        $existdata = $this->find()->orderBy('id desc')->where($where)->asArray()->one();
        $continuousDay = 0;
        // 获取昨天的 Unix 时间戳
        $yesterdayStart = strtotime(date('Y-m-d', time() - 86400));
        if (!empty($existdata['continuousDay']) && $existdata['itime'] > $yesterdayStart) {
            $continuousDay = $existdata['continuousDay'];
        }
        return $continuousDay;
    }


    /**
     * 签到数据
     * @param type $date
     * @return type
     */
    public static function getIndexDataSignInRecord($date)
    {
        $rediskey = __METHOD__ . $date;
        $redisData = self::getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $returnData = [];

        $time = strtotime($date);
        $where = [
            'and',
            ['>', 'itime', $time],
            ['<', 'itime', $time + 86400],
            ['=', 'type', 2]
        ];
        $data['SignIn_day_number'] = self::find()->where($where)->count() ?? 0; //今日金额
        //
        $where = [
            'and',
            ['>', 'itime', $time - 86400],
            ['<', 'itime', $time],
            ['=', 'type', 2]
        ];
        $data['SignIn_yesterday_number'] = self::find()->where($where)->count() ?? 0; //今日金额
        //总次数
        $where = [
            'and',
            ['=', 'type', 2]
        ];
        $data['SignIn_all_number'] = self::find()->where($where)->count() ?? 0; //总金额
        //$time = $this->redisTime;
        $time = 3600;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }


    /**
     * 签到数据
     * @param type $date
     * @return type
     */
    public static function getIndexDataSignInRecordAgent($date, $uid)
    {
        $rediskey = __METHOD__ . $date;
        $redisData = self::getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            // return $redisData;
        }
        $returnData = [];

        $time = strtotime($date);
        $where = [
            'and',
            ['>', 't_sign_in_record.itime', $time],
            ['<', 't_sign_in_record.itime', $time + 86400],
            ['=', 'type', 2],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $data['SignIn_day_number'] = self::find()->where($where)->joinWith(['accountInfo'])->count() ?? 0; //今日金额
        //
        $where = [
            'and',
            ['>', 't_sign_in_record.itime', $time - 86400],
            ['<', 't_sign_in_record.itime', $time],
            ['=', 'type', 2],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $data['SignIn_yesterday_number'] = self::find()->where($where)->joinWith(['accountInfo'])->count() ?? 0; //今日金额
        //总次数
        $where = [
            'and',
            ['=', 'type', 2],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $data['SignIn_all_number'] = self::find()->where($where)->joinWith(['accountInfo'])->count() ?? 0; //总金额
        //$time = $this->redisTime;
        $time = 3600;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    public function getSignInRecordFundList($uid, $page = 1, $limit = 10, $fields = [])
    {
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'signInType', 2],
        ];
        self::$key = $fields;
        $list = $this->listFind(['page' => $page, 'row' => $limit])
            ->orderBy("id desc")
            ->where($where)->asArray()->all();

        $totalCount = $this->find()->where($where)->count();
        $count = count($list);
        // 计算起始编号
        // 计算起始编号（从最大值开始递减）
        $startNumber = max(1, ($totalCount - (($page - 1) * $limit + $count) + 1));
        foreach ($list as $index => &$item) {
            $item['sequence'] = $startNumber + ($count - $index - 1); // 添加从1开始的序号
            $item['create_time'] = date("Y-m-d H:i:s", $item['itime']);
            $item["img"] = FuncHelper::getCdnUrl($item['img']);
        }
        return $list;
    }


    public function getSignInRecordFundCount($uid)
    {
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'signInType', 2],
            ['=', 'type', 2],
        ];
        $count = $this->find()->where($where)->count();
        return $count;
    }

    public function addSignInFundRecord($uid, $img)
    {
        //不准补签
        $dateDay = date("Y-m-d", time());
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'dateDay', $dateDay],
            ['=', 'signInType', 2]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '已经签到了']);
            return false;
        }
        $yesterDay = date("Y-m-d", time() - 86400);
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'dateDay', $yesterDay],
            ['=', 'signInType', 2]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        $continuousDay = 0;
        if (!empty($existData)) {
            $continuousDay = $existData['continuousDay'];
        }
        $continuousDay = $continuousDay + 1;
        $data = [
            'uid' => $uid, //用户id
            'dateDay' => $dateDay, //签到日期
            'continuousDay' => $continuousDay, //当前连续天数
            'type' => 1, //1为申请下发 2下发成功 3为下发异常
            'itime' => time(), //
            'utime' => time(), //
            'rewardType' => 0,
            'rewardNumber' => 0,
            'signInType' => 2,
            'img' => $img,
        ];
        $this->attributes = $data;
        $boor = $this->insertData($data);
        if (empty($boor)) {
            $this->addError('mesg', ['212', '添加失败']);
            return false;
        }
        return true;
    }
}
