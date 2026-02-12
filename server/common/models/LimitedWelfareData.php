<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  限时福利项目
 */
class LimitedWelfareData extends BaseModel {

    protected $table = 't_limited_welfare_data';

    public static function tableName() {
        return '{{t_limited_welfare_data}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['investMoney', 'number'], //金额
            ['rewardMoney1', 'number'], //奖励金额1
            ['rewardMoney2', 'number'], //奖励金额2
            ['rewardMoney3', 'number'], //奖励金额3
            ['rewardMoney4', 'number'], //奖励金额4
            ['rewardMoney5', 'number'], //奖励金额5
            ['rewardMoney6', 'number'], //奖励金额6
            ['rewardMoney7', 'number'], //奖励金额7
            ['maxRewardMoney', 'number'], //总额
            ['cycle', 'number'], //周期
            ['coverUrl', 'string'], //封面
            ['sort', 'number'], //排序
            ['type', 'number'], //状态  1为启用   2为关闭
            ['frontType', 'number'], //前段是否可点击 。 1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addLimitedWelfareData($title, $investMoney, $coverUrl, $sort, $type,
            $rewardMoney1, $rewardMoney2, $rewardMoney3, $rewardMoney4, $rewardMoney5, $rewardMoney6, $rewardMoney7,$frontType,$maxRewardMoney,$cycle
    ) {

        $data = [
            'title' => $title, //标题
            'investMoney' => $investMoney, //金额
            'rewardMoney1' => $rewardMoney1, //奖励金额1
            'rewardMoney2' => $rewardMoney2, //奖励金额1
            'rewardMoney3' => $rewardMoney3, //奖励金额1
            'rewardMoney4' => $rewardMoney4, //奖励金额1
            'rewardMoney5' => $rewardMoney5, //奖励金额1
            'rewardMoney6' => $rewardMoney6, //奖励金额1
            'rewardMoney7' => $rewardMoney7, //奖励金额1
            'maxRewardMoney'=>$maxRewardMoney,//
            'cycle'=>$cycle,
            'frontType'=>$frontType,
            'coverUrl' => $coverUrl, //封面
            'sort' => $sort, //排序
            'type' => $type, //状态  1为启用   2为关闭
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    return true;
                } else {
                    $this->addError('mesg', ['212', '添加失败']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getLimitedWelfareDataList($page = 1, $limit = 10, $fields = []) {
        $where = [
            'and'
        ];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

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
    public function updateLimitedWelfareData($id, $title, $investMoney, $coverUrl, $sort, $type,
            $rewardMoney1, $rewardMoney2, $rewardMoney3, $rewardMoney4, $rewardMoney5, $rewardMoney6, $rewardMoney7,$frontType,$maxRewardMoney,$cycle) {
        $update = [];
        if (!empty($title)) {
            $update['title'] = $title;
        }
        if (!empty($investMoney)) {
            $update['investMoney'] = $investMoney;
        }
        if (!empty($coverUrl)) {
            $update['coverUrl'] = $coverUrl;
        }
        if (!empty($sort)) {
            $update['sort'] = $sort;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (!empty($rewardMoney1)) {
            $update['rewardMoney1'] = $rewardMoney1;
        }
        if (!empty($rewardMoney2)) {
            $update['rewardMoney2'] = $rewardMoney2;
        }
        if (!empty($rewardMoney3)) {
            $update['rewardMoney3'] = $rewardMoney3;
        }
        if (!empty($rewardMoney4)) {
            $update['rewardMoney4'] = $rewardMoney4;
        }
        if (!empty($rewardMoney5)) {
            $update['rewardMoney5'] = $rewardMoney5;
        }
        if (!empty($rewardMoney6)) {
            $update['rewardMoney6'] = $rewardMoney6;
        }
        if (!empty($rewardMoney7)) {
            $update['rewardMoney7'] = $rewardMoney7;
        }
        if (!empty($maxRewardMoney)) {
            $update['maxRewardMoney'] = $maxRewardMoney;
        }
        if (!empty($frontType)) {
            $update['frontType'] = $frontType;
        }
        if (!empty($cycle)) {
            $update['cycle'] = $cycle;
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
     * 获取新闻列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientLimitedWelfareList($page = 1, $limit = 10, $fields = []) {
        // 缓存键：可以根据具体情况自定义
        $redisKey = __METHOD__ . ":page={$page}:limit={$limit}:fields=" . md5(implode(',', $fields));

        // 尝试从 Redis 获取缓存数据
        $cachedData = Yii::$app->redis->get($redisKey);
        if ($cachedData !== false) {
            // 如果缓存存在，直接返回缓存数据
            return json_decode($cachedData, true);
        }

        // 如果没有缓存，查询数据库
        $where = [
            'and',
            ['=', 'type', 1]
        ];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit])
        ->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        // 将查询结果存入 Redis，设置缓存过期时间（例如 5 分钟）
        Yii::$app->redis->setex($redisKey, 300, json_encode($data));

        return $data;
    }


    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientLimitedWelfareMessage($id, $fields = []) {
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
        //$fields = [];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getLimitedWelfareDataMessage($id) {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }

}
