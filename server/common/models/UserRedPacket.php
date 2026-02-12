<?php

namespace common\models;


class UserRedPacket extends BaseModel
{

    protected $table = 't_user_red_packet';

    public static function tableName()
    {
        return '{{t_user_red_packet}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标题
            ['day', 'string'], //日期
            ['money', 'number'], //
            ['type', 'number'], //
            ['itime', 'number'], //
            ['utime', 'number'], //
            ['is_receive', 'number'], //
        ];
    }
}