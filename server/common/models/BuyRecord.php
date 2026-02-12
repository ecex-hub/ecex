<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  购买记录
 */
class BuyRecord extends BaseModel
{

    protected $table = 't_buy_record';

    public static function tableName()
    {
        return '{{t_buy_record}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['projectId', 'number'], //项目id
            ['projectOneId', 'number'], //项目一级id
            ['buyName', 'string'], //项目名字
            ['buyMoney', 'number'], //购买金额
            ['buyTime', 'number'], //下单时间
            ['RechargeOrderId', 'string'], //充值订单id
            ['principal', 'number'], //算息本金
            ['cycleOld', 'number'], //周期 。老的
            ['grade', 'number'], //等级
            ['cycle', 'number'], //周期 。天  当前锁定周期
            ['dayNumber', 'number'], //累计天数
            ['endTime', 'number'], //结束日期
            ['countCycle', 'number'], //总锁定天数 。 复投时增加
            ['dayInterest', 'number'], //每日利息 。日息    1
            ['interestIncome', 'number'], //到期收益 。 算息本金*日期*日息  1
            ['subsidy', 'number'], //补贴比例 。    1
            ['subsidyMoney', 'number'], //补贴金额 。 到期收益*补贴比例 。  1
            ['realReturn', 'number'], //实际收益 。 到期收益 + 补贴金额。   1
            ['totalRevenue', 'number'], //释放可提收益    总收益     复投时增加 me_totalRevenue
            ['continuousLevel', 'number'], //优选选择等级 。默认0 。 可自己选择 。123 。
            ['autoIncomeLevelID', 'number'], //释放选择重新开始等级id  new-- 手动携息进阶 。选择等级id
            ['autoLevel', 'number'], //自动复投  1自动复投 。 2直接释放 。3手动选择复投 me_autoLevel 。new--3手动携息进阶
            ['type', 'number'], //状态  1为结算锁定中    2为复投结束，可以释放得到收益  3自动复投没有了 等手动复投  4没得复投下级别了 等释放 。  5已经释放 关闭
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
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getBuyRecordList($page = 1, $limit = 10, $fields = [], $uid, $projectId,
                                     $projectOneId, $buyMoney, $RechargeOrderId, $type, $cycle, $start_time, $end_time)
    {
        $where = [
            'and'
        ];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }
        if (!empty($projectId)) {
            $where[] = ['=', 'projectId', $projectId];
        }
        if (!empty($projectOneId)) {
            $where[] = ['=', 'projectId', $projectOneId];
        }
        if (!empty($cycle)) {
            $where[] = ['=', 'cycle', $cycle];
        }
        if (!empty($buyMoney)) {
            $where[] = ['=', 'buyMoney', $buyMoney];
        }
        if (!empty($RechargeOrderId)) {
            $where[] = ['=', 'RechargeOrderId', $RechargeOrderId];
        }
        if (!empty($type)) {
            $where[] = ['=', 'type', $type];
        }
        if (!empty($start_time)) {
            $where[] = ['>', 'endTime', $start_time];
        }
        if (!empty($end_time)) {
            $where[] = ['<', 'endTime', $end_time + 86400];
        }

        $fields = ['id', 'uid', 'projectId', 'projectOneId', 'buyName', 'buyMoney', 'RechargeOrderId',
            'principal', 'grade', 'cycle', 'countCycle', 'totalRevenue', 'autoLevel', 'type', 'itime', 'endtime'];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientBuyRecordList($uid, $page = 1, $limit = 10, $fields = [], $type, $buyMoney)
    {

        $rediskey = __METHOD__ . $page . $limit . $uid . $type . $buyMoney;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            // return $redisData;
        }

        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        if ($type == 1) {
            $startTime = strtotime(date('Y-m-d')) - 86400;
            $endTime = $startTime + 3 * 86400;
            $where[] = [
                '>', 'endtime', $startTime
            ];
            $where[] = [
                '<', 'endtime', $endTime
            ];
        }
        if (!empty($buyMoney)) {
            $where[] = [
                '=', 'buyMoney', $buyMoney
            ];
        }
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientBuyRecordMessage($id, $fields = [])
    {
        $rediskey = __METHOD__ . $id;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            //return $redisData;
        }
        $where = [
            'and',
            ['=', 'id', $id]
        ];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getBuyRecordMessage($id, $uid = null, $fields = [])
    {

        $where = [
            'and',
            ['=', 'id', $id]
        ];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();

        return $data;
    }

    /**
     * 手动释放
     * @param type $uid
     * @param type $RecordID
     * @param type $LevelId
     */
    public function SelectReleaseAccount($uid, $RecordID, $LevelId)
    {
        $update = [
            'autoLevel' => 2,
            'autoIncomeLevelID' => $LevelId
        ];

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'id', $RecordID],
            ['=', 'autoLevel', 1]
        ];

        $boor = $this->updateAll($update, $where);
        return $boor;
    }

    /**
     * 选择携息
     * @param type $uid
     * @param type $RecordID
     * @param type $LevelId
     */
    public function SelectPromotedAccount($uid, $RecordID, $LevelId)
    {
        $update = [
            'autoLevel' => 3,
            'autoIncomeLevelID' => $LevelId
        ];

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'id', $RecordID],
            ['=', 'autoLevel', 1]
        ];

        $boor = $this->updateAll($update, $where);
        return $boor;
    }

    /**
     * 最大投资金额
     * @param type $uid
     * @return type
     */
    public static function getClientMaxMessage($uid)
    {

        $where = [
            'and',
            ['=', 'uid', $uid],
        ];
        $fields = [];
        self::$key = $fields;
        return self::find()->where($where)->asArray()->orderBy('buyMoney desc')->one();
    }

    /**
     * 投资金额
     * @param type $uid
     * @return type
     */
    public static function getClientUidinvestAllMoneyMessage($uid, $investAllMoney)
    {

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'buyMoney', $investAllMoney]
        ];
        $fields = [];
        self::$key = $fields;
        return self::find()->where($where)->asArray()->one();
    }

    ////////////

    /**
     * 修改数据
     * @param type $id
     * @param type $title
     * @param type $author
     * @param type $coverUrl
     * @param type $content
     * @param type $type
     * @return boolean
     */
    public function updateNewsData($id, $title, $author, $coverUrl, $content, $type)
    {
        $update = [];
        if (!empty($title)) {
            $update['title'] = $title;
        }
        if (!empty($author)) {
            $update['author'] = $author;
        }
        if (!empty($coverUrl)) {
            $update['coverUrl'] = $coverUrl;
        }
        if (!empty($content)) {
            $update['content'] = $content;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }

        if (empty($update)) {
            $this->addError('mesg', ['211', '修改数据不能为空']);
            return false;
        }

        $boor = $this->updateAll($update, ['id' => $id]);
        if ($boor) {
            return true;
        }
        $this->addError('mesg', ['211', '修改失败']);
        return false;
    }

    /**
     * 获取新闻详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientNewsMessage($id, $fields = [])
    {
        $rediskey = __METHOD__ . $id;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'id', $id]
        ];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

}
