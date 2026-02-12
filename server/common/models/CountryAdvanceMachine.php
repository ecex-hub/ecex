<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  国家垫资 投资等级信息
 */
class CountryAdvanceMachine extends BaseModel {

    protected $table = 't_country_advance_machine';

    public static function tableName() {
        return '{{t_country_advance_machine}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['price', 'number'], //投资总金额
            ['userPrice', 'number'], //用户投资金额
            ['countryPrice', 'number'], //国家垫资总额
            ['quarterBonus', 'number'], //季度分红金额
            ['type', 'number'], //是否启用
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 获取新闻详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientCountryAdvanceMachine($id, $fields = []) {
        $rediskey = __METHOD__ . $id;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
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

}
