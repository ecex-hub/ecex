<?php

namespace common\models;


/**
 * ContactForm is the model behind the contact form.  项目内容
 */
class Real extends BaseModel
{

    protected $table = 't_real';

    public static function tableName()
    {
        return '{{t_real}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['uid', 'number'], //标记id
            ['realName', 'string'], //标题
            ['IDCard', 'string'], //产品价格
            ['IDFrontUrl', 'string'], //每日收益
            ['IDOppositeUrl', 'string'], //产品补助
            ['type', 'number'], //状态  1-创建 2-通过 3-拒绝
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }
}