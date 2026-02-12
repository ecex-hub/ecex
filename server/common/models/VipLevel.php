<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  vip返利等级
 */
class VipLevel extends BaseModel {

    protected $table = 't_vip_level';

    public static function tableName() {
        return '{{t_vip_level}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['vipGrade', 'number'], //vip
            ['vipName', 'number'], //vip 名字
            ['oneReturn', 'number'], //1
            ['twoReturn', 'number'], //2
            ['threeReturn', 'number'], //3
            ['type', 'number'], //1
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }


}
