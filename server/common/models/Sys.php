<?php

namespace common\models;

use common\components\FuncHelper;
use Yii;


class Sys extends BaseModel
{

    protected $table = 't_sys';


    protected $PDO_CONN = false;

    public static function tableName()
    {
        return '{{t_sys}}';
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
            ['name', 'string'], //1-支付宝 2-微信 3-银行
            ['pay_mch', 'number'], //状态  1-福海支付 2-桥头支付
            ['pay_type', 'number'], //1-支付宝 2-微信 3-银行
            ['status', 'number'], //
            ['sort', 'number'], //1-默认 2-确定
            ['type', 'number'], // 1-启用 2-关闭
            ['min_price', 'number'], //1-默认 2-确定
            ['max_price', 'number'], // 1-启用 2-关闭
        ];
    }

    public function getList()
    {
        $fields = ["id", 'name', 'pay_type', 'min_price', 'max_price'];
        $where = [
            'and',
            ['=', 'status', 1],
            ['=', 'type', 1]
        ];
        $list = $this->find()
            ->select($fields)
            ->orderBy('sort desc')
            ->where($where)
            ->asArray()
            ->all();
        $payTypeArr = [
            1 => '支付宝',
            2 => '微信',
            3 => '银联',
            4 => '云闪付'
        ];
        foreach ($list as &$item) {
            $item['pay_type_name'] = $payTypeArr[$item['pay_type']] ?? "";
        }
        return $list;
    }


    public function getInfo($id)
    {

        $where = [
            'and',
            ['=', 'id', $id],
            ['=', 'type', 1]
        ];
        $list = $this->find()
            ->where($where)->one();
        return $list;
    }

}