<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;
use yii\db\Expression;

/**
 * ContactForm is the model behind the contact form.  赠送金砖币
 */
class GiveBrick extends BaseModel {

    protected $table = 't_give_brick';

    public static function tableName() {
        return '{{t_give_brick}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['brickNumber', 'number'], //数量
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public static function addGiveBrickData($number) {
        $boor = self::updateAll(['brickNumber' => new Expression('brickNumber+' . $number)], ['id' => 1]);
    }

    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientGiveBrickData() {
        $rediskey = __METHOD__;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
           // return $redisData;
        }
        $where = [
            'and',
            ['=', 'id', 1]
        ];
        $fields = [];
        self::$key = $fields;
        $existData = $this->find()->where($where)->asArray()->one();
        $data = 0;
        if (!empty($existData['brickNumber'])) {
            $data = $existData['brickNumber'];
        }
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

}
