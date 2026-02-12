<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  收益级别
 */
class IncomeLevel extends BaseModel {

    protected $table = 't_income_level';

    public static function tableName() {
        return '{{t_income_level}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['investMoney', 'number'], //投资金额
            ['principal', 'number'], //算息本金
            ['grade', 'number'], //等级
            ['continuousType', 'number'], //复投状态 。1自动 2手动选择        
            ['continuousLevel', 'number'], //手动选择 等级 。默认1 。 可自己选择
            ['cycleOld', 'number'], //周期 。老的
            ['cycle', 'number'], //周期 。天
            ['dayInterest', 'number'], //日息 。                            当前周期
            ['interestIncome', 'number'], //到期收益 。 算息本金*7*日息        当前周期
            ['subsidy', 'number'], //补贴比例 。                             当前周期
            ['subsidyMoney', 'number'], //补贴金额 。 到期收益*补贴比例 。      当前周期
            ['realReturn', 'number'], //实际收益 。 到期收益 + 补贴金额。       当前周期       
            ['totalRevenue', 'number'], //结束释放可提收益                    总收益  
            ['type', 'number'], //1
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getIncomeLevelDataMessage($id) {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }

    /**
     * 获取下级手动复投状态
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientIncomeLevelMessage($money, $cycle, $grade) {
        $rediskey = __METHOD__ . $money . $cycle . $grade;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $fields = [];
        $where = [
            'and',
            ['=', 'investMoney', $money],
            ['=', 'cycleOld', $cycle],
            ['=', 'grade', $grade],
            ['=', 'continuousType', 2]
        ];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 自动复投下级收益
     * @param type $money
     * @param type $cycle
     * @param type $grade
     * @return type
     */
    public function getClientIncomeLevelAutomessage($money, $cycle, $grade) {
        $rediskey = __METHOD__ . $money . $cycle . $grade;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'investMoney', $money],
            ['=', 'cycle', $cycle],
            ['=', 'grade', $grade],
            ['=', 'continuousType', 1],
        ];
        $fields = [];

        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientIncomeLevelList($page = 1, $limit = 10, $fields = [], $investMoney) {

        $rediskey = __METHOD__ . $page . $limit . $investMoney;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'grade', 1]
        ];

        if (!empty($investMoney)) {
            $where[] = ['=', 'investMoney', $investMoney];
        }

        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'id'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 释放收益 选择周期列表
     * @param type $money
     * @param type $cycle
     * @param type $grade
     * @return type
     */
    public function getClientReleaseIncomeLevelmessage($page, $limit, $money, $LevelId = null) {
        $rediskey = __METHOD__ . $page . $limit . $money . $LevelId;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'investMoney', $money],
            ['=', 'grade', 1],
            ['=', 'continuousType', 1],
        ];
        $fields = [];
        if (!empty($LevelId)) {
            $where[] = ['=', 'id', $LevelId];
        }

        self::$key = $fields;

        //$data = $this->find()->where($where)->asArray()->orderBy('cycle')->all();
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'cycle'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 携息进阶 选择周期列表
     * @param type $money
     * @param type $cycle
     * @param type $grade
     * @return type
     */
    public function getClientPromotedIncomeLevelmessage($page, $limit, $money, $grade, $LevelId = null) {
        $rediskey = __METHOD__ . $page . $limit . $money .$grade. $LevelId;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'investMoney', $money],
            ['=', 'grade', $grade],
            ['=', 'continuousType', 1],
        ];
        $fields = [];
        if (!empty($LevelId)) {
            $where[] = ['=', 'id', $LevelId];
        }

        self::$key = $fields;

        //$data = $this->find()->where($where)->asArray()->orderBy('cycle')->all();
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'cycle'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 携息进阶 选择周期列表 优选
     * @param type $money
     * @param type $cycle
     * @param type $grade
     * @return type
     */
    public function getClientAutoPromotedIncomeLevelmessage($page, $limit, $money, $grade, $cycle, $LevelId = null) {
        $rediskey = __METHOD__ . $page . $limit . $money . $LevelId . $grade . $cycle;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'investMoney', $money],
            ['=', 'cycleOld', $cycle],
            ['=', 'grade', $grade],
            ['=', 'continuousType', 2],
        ];

        $fields = [];
        if (!empty($LevelId)) {
            $where[] = ['=', 'id', $LevelId];
        }

        self::$key = $fields;

        //$data = $this->find()->where($where)->asArray()->orderBy('cycle')->all();
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'cycle'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

}
