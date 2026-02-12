<?php

namespace common\models;


class UserRedPacketTotal extends BaseModel
{

    protected $table = 't_user_red_packet_total';

    public static function tableName()
    {
        return '{{t_user_red_packet_total}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标题
            ['money', 'number'], //
            ['type', 'number'], //
            ['num', 'number'], //
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }
}