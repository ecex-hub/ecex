<?php

namespace common\models;


use common\components\FuncHelper;
use yii\db\Expression;

class UserProductIncome extends BaseModel
{

    protected $table = 't_user_product_income';

    public static function tableName()
    {
        return '{{t_user_product_income}}';
    }


    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标记id
            ['product_id', 'number'], //产品ID
            ['user_product_id', 'number'], //用户产品ID
            ['income', 'number'], //收益
            ['day', 'string'], //产品天数
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public function getReceiveCount($uid, $userProductId)
    {
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'user_product_id', $userProductId],
        ];
        $count = $this->find()
            ->where($where)
            ->count();
        return $count;
    }

    public function getReceiveByDay($uid, $userProductId)
    {
        $date = date("Y-m-d");
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'user_product_id', $userProductId],
            ['=', 'day', $date],
        ];
        $info = $this->find()
            ->select(['id'])
            ->where($where)
            ->asArray()
            ->one();
        return $info;
    }

}