<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  金砖币回收项目
 */
class BrickBuyBackProject extends BaseModel {

    protected $table = 't_brick_buy_back_project';

    public static function tableName() {
        return '{{t_brick_buy_back_project}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['buyBackNumber', 'number'], //回收数量
            ['vipProportion1', 'number'], //vip回收比例
            ['vipProportion2', 'number'], //vip回收比例
            ['vipProportion3', 'number'], //vip回收比例
            ['vipProportion4', 'number'], //vip回收比例
            ['vipProportion5', 'number'], //vip回收比例
            ['vipProportion6', 'number'], //vip回收比例
            ['vipProportion7', 'number'], //vip回收比例
            ['vipProportion8', 'number'], //vip回收比例
            ['vipProportion9', 'number'], //vip回收比例
            ['vipProportion10', 'number'], //vip回收比例
            ['price', 'number'], //单价
            ['startTime', 'number'], //开始时间
            ['endTime', 'number'], //结束时间
            ['type', 'number'], //状态  1为启用   2为关闭
            ['sort', 'number'], //
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addBrickBuyBackProjectData($title, $buyBackNumber, $price, $startTime, $endTime, $type, $sort,
            $vipProportion1, $vipProportion2, $vipProportion3, $vipProportion4, $vipProportion5,
            $vipProportion6, $vipProportion7, $vipProportion8, $vipProportion9, $vipProportion10) {

        $data = [
            'title' => $title, //标题
            'buyBackNumber' => $buyBackNumber, //回收数量
            'vipProportion1' => $vipProportion1,
            'vipProportion2' => $vipProportion2,
            'vipProportion3' => $vipProportion3,
            'vipProportion4' => $vipProportion4,
            'vipProportion5' => $vipProportion5,
            'vipProportion6' => $vipProportion6,
            'vipProportion7' => $vipProportion7,
            'vipProportion8' => $vipProportion8,
            'vipProportion9' => $vipProportion9,
            'vipProportion10' => $vipProportion10,
            'price' => $price, //单价
            'startTime' => $startTime, //开始时间
            'endTime' => $endTime, //结束时间
            'type' => $type, //状态  1为启用   2为关闭
            'sort' => $sort, //排序
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
    public function getBrickBuyBackProjectList($page = 1, $limit = 10, $fields = []) {
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
    public function updateBrickBuyBackProjectData($id, $title, $buyBackNumber, $price, $startTime, $endTime, $type, $sort,
            $vipProportion1, $vipProportion2, $vipProportion3, $vipProportion4, $vipProportion5,
            $vipProportion6, $vipProportion7, $vipProportion8, $vipProportion9, $vipProportion10) {
        $update = [];
        if (!empty($title)) {
            $update['title'] = $title;
        }
        if (!empty($buyBackNumber)) {
            $update['buyBackNumber'] = $buyBackNumber;
        }
        if (!empty($price)) {
            $update['price'] = $price;
        }
        if (!empty($startTime)) {
            $update['startTime'] = $startTime;
        }
        if (!empty($endTime)) {
            $update['endTime'] = $endTime;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (!empty($sort)) {
            $update['sort'] = $sort;
        }
        if (!empty($vipProportion1)) {
            $update['vipProportion1'] = $vipProportion1;
        }
        if (!empty($vipProportion2)) {
            $update['vipProportion2'] = $vipProportion2;
        }
        if (!empty($vipProportion3)) {
            $update['vipProportion3'] = $vipProportion3;
        }
        if (!empty($vipProportion4)) {
            $update['vipProportion4'] = $vipProportion4;
        }
        if (!empty($vipProportion5)) {
            $update['vipProportion5'] = $vipProportion5;
        }
        if (!empty($vipProportion6)) {
            $update['vipProportion6'] = $vipProportion6;
        }
        if (!empty($vipProportion7)) {
            $update['vipProportion7'] = $vipProportion7;
        }
        if (!empty($vipProportion8)) {
            $update['vipProportion8'] = $vipProportion8;
        }
        if (!empty($vipProportion9)) {
            $update['vipProportion9'] = $vipProportion9;
        }
        if (!empty($vipProportion10)) {
            $update['vipProportion10'] = $vipProportion10;
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
    public function getClientBrickBuyBackProjectList($page = 1, $limit = 10, $fields = []) {

        $rediskey = __METHOD__ . $page . $limit;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            //return $redisData;
        }

        $where = [
            'and',
            ['=', 'type', 1],
//            ['<', 'startTime', time()],
//            ['>', 'endTime', time()]
        ];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-sort'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取新闻详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientBrickBuyBackProjectMessage($id, $fields = []) {
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
        $fields = [];
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
    public static function getBrickBuyBackProjectDataMessage($id) {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }

}
