<?php

namespace common\models;


/**
 * ContactForm is the model behind the contact form.  项目内容
 */
class Province extends BaseModel
{

    protected $table = 't_province';

    public static function tableName()
    {
        return '{{t_province}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['name', 'string'], //标题
            ['value', 'number'], //产品价格
        ];
    }
}