<?php

namespace common\models;

use common\components\FuncHelper;
use Yii;


class City extends BaseModel
{

    protected $table = 't_city';


    protected $PDO_CONN = false;

    public static function tableName()
    {
        return '{{t_city}}';
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
            ['parent_id', 'string'],
            ['name', 'number'], //
            ['type', 'string'], //
        ];
    }

    public function getList()
    {

        $where = [
            'and',
            ['=', 'type', 1],
        ];
        $fields = ['id', 'name'];
        $list = $this->find()
            ->select($fields)
            ->orderBy('id asc')
            ->asArray()
            ->where($where)->all();
        foreach ($list as &$item) {
            $where = [
                'and',
                ['=', 'type', 2],
                ['=', 'parent_id', $item['id']],
            ];
            $list1 = $this->find()
                ->select($fields)
                ->orderBy('id asc')
                ->asArray()
                ->where($where)->all();
            foreach ($list1 as &$value) {
                $where = [
                    'and',
                    ['=', 'type', 3],
                    ['=', 'parent_id', $value['id']],
                ];
                $list2 = $this->find()
                    ->select($fields)
                    ->orderBy('id asc')
                    ->asArray()
                    ->where($where)->all();
                $value['sub'] = $list2;
            }
            $item['sub'] = $list1;
        }
        return $list;
    }


    public function getInfo($cityId)
    {

        $where = [
            'and',
            ['=', 'id', $cityId],
        ];
        $list = $this->find()
            ->asArray()
            ->where($where)->one();
        return $list;
    }
}