<?php

namespace common\models;

use common\components\FuncHelper;
use Yii;


class Tongji extends BaseModel
{

    protected $table = 't_tongji';


    protected $PDO_CONN = false;

    public static function tableName()
    {
        return '{{t_tongji}}';
    }

    public static function getDb()
    {
        return Yii::$app->get('db');
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //
            ['day', 'string'], //1-支付宝 2-微信 3-银行
            ['register_num', 'number'], //状态  1-福海支付 2-桥头支付
            ['real_num', 'number'], //1-支付宝 2-微信 3-银行
            ['buy_product_num', 'number'], //
            ['recharge_money', 'number'], //1-默认 2-确定
            ['buy_product_money', 'number'], // 1-启用 2-关闭
            ['withdraw_money', 'number'], //1-默认 2-确定
            ['recharge_num', 'number'], // 1-启用 2-关闭
            ['withdraw_num', 'number'], // 1-启用 2-关闭
        ];
    }
}