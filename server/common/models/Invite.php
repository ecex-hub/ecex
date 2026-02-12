<?php

namespace common\models;


/**
 * ContactForm is the model behind the contact form.  投资返利记录
 */
class Invite extends BaseModel
{

    protected $table = 't_invite';

    public static function tableName()
    {
        return '{{t_invite}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['uid', 'number'], //标记id
            ['invite_code', 'string'], //
        ];
    }
}