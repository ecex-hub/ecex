<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  金砖币
 */
class GoldBrickTrend extends BaseModel {

    protected $table = 't_gold_brick_trend';

    public static function tableName() {
        return '{{t_gold_brick_trend}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['dateTime', 'string'], //日期 。2023-10-10
            ['dayDate', 'string'], //日期 。天
            ['price', 'number'], //价格
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public $standard = 50; //
    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addGoldBrickTrend() {
        //验证重复
        $existData = $this->find()->orderBy('id desc')->asArray()->one();

        $dateTime = date('Y-m-d');
        if (!empty($existData['dateTime']) && $existData['dateTime'] == $dateTime) {
            $this->addError('mesg', ['212', '已经添加了']);
            return false;
        }
        $dayDate = date('d');
        $price = SystemConfigure::getSystemConfigure('gold_brick_price');
        if (!empty($price)) {
            $data = [
                'dateTime' => $dateTime, //日期 。2023-10-10
                'dayDate' => $dayDate, //日期 。天
                'price' => $price, //价格
                'type' => 1, //状态  1为成功可使用   2为已使用
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
        $this->addError('mesg', ['211', '价格获取失败']);
        return false;
    }

    /**
     * 获取最新价格详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientGoldBrickPriceMessage() {
        $rediskey = __METHOD__;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'type', 1]
        ];
        $fields = [];
        self::$key = $fields;
        $data = $this->find()->where($where)->orderBy('id desc')->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        $time = 10;
        $price = 0;
        if (!empty($data['price']))
            $price = $data['price'];
        self::redisCacheOperation(md5($rediskey), $price, $time);

        return $price;
    }

    /**
     * 客服端折线图数据
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientGoldBrickList() {

        $rediskey = __METHOD__;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
           // return $redisData;
        }
        $day = date('d');
        $date1 = date('Y-m');
        $date = strtotime($date1. '-0');// 
        $where = [
            'and',
            ['>=', 'itime', $date]
        ];
        $fields = [];
        self::$key = $fields;
        $data = $this->listFind(['page' => 1, 'row' => 40, 'sort' => 'id'])->where($where)->all();
        $temp = [];
        foreach ($data as $key => $value) {
            $dayDate = intval($value['dayDate']);
            $temp[$dayDate] = $value;
        }
        $dayData = [];
        $goldData = [];
        for ($i = 1; $i <= $day; $i++) {
            $dayData[] = $i;
            if (!empty($temp[$i])) {
                $goldData[] = $temp[$i]['price'];
            } else {
                $goldData[] = 0;
            }
        }

        $returnData['dayData'] = $dayData;
        $returnData['goldData'] = $goldData;
        $returnData['date1'] = $date1;
        $returnData['date'] = $date;
        $returnData['day'] = $day;
        $returnData['temp'] = $temp;
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $returnData, $time);

        return $returnData;
    }

    ///////////

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getNewsList($page = 1, $limit = 10, $fields = []) {
        $where = [
            'and'
        ];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'grade'])->where($where)->all();
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
    public function updateNewsData($id, $title, $author, $coverUrl, $content, $type) {
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

        if (empty($type)) {
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
    public function getClientNewsMessage($id, $fields = []) {
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
