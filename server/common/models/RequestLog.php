<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  充值订单
 */
class RequestLog extends BaseModel
{

    protected $table = 't_request_log';

    public static function tableName()
    {
        return '{{t_request_log}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
//            ['id', 'number'], //标记id
//            ['uid', 'number'], //用户id
//            ['url', 'string'], //金额
//            ['method', 'string'], //金额
//            ['request', 'string'], //支付金额
//            ['response', 'string'], //支付金额
//            ['status_code', 'number'], //支付金额
//            ['itime', 'number'], //
//            ['utime', 'number'], //
        ];
    }
}