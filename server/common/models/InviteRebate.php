<?php

namespace common\models;


/**
 * ContactForm is the model behind the contact form.  投资返利记录
 */
class InviteRebate extends BaseModel
{

    protected $table = 't_invite_rebate';

    public static function tableName()
    {
        return '{{t_invite_rebate}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //
            ['money', 'number'], //投资id
            ['num', 'number'], //充值订单id
            ['day', 'string'], //
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public function getBuyCount($inviteUid, $num)
    {
        $date = date("Y-m-d");
        $where = [
            'and',
            ['=', 'uid', $inviteUid],
            ['=', 'day', $date],
            ['=', 'num', $num],
        ];
        $info = $this->find()
            ->where($where)
            ->select(['uid'])
            ->one();
        return $info;
    }
}