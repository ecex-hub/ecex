<?php

namespace console\controllers;

use common\models\RechargeOrder;
use common\models\UserProduct;
use yii\console\Controller;
use Yii;
use yii\db\Expression;

class ProductController extends Controller
{

    // 比如产品有效期1天。
    // 今天凌晨00:00:00购买，每天凌晨1点更新每日补助。
    // 计算产品结束，触发一次产品每日补助。

    //产品结束补助
    //每分钟
    public function actionEnd()
    {
        try {
            //每日统计收益数据
            $model = new \common\models\UserProduct();
            $time = time();
            $where = [
                'and',
                ['=', 'product_type', 1],
                ['=', 'type', 1],
                ['<', 'end_time', $time],
            ];
            $list = $model->find()
                ->where($where)
                ->each(20);
            foreach ($list as $item) {
                $model->makeProductEndExec($item);
            }
        } catch (\Exception $e) {
            Yii::info('product_end-------' . $e->getMessage(), 'request');
        }
    }

    //产品每天补贴
    //每天一次
    public function actionDay()
    {

        //每日统计收益数据
        $date = date("Y-m-d");
        $query = UserProduct::find()
            ->alias('up')
            ->select(['up.*'])
            ->leftJoin(
                't_user_product_income AS tupi',
                "tupi.uid = up.uid AND tupi.user_product_id = up.id AND tupi.day=:date",
                [':date' => $date]
            )
            ->andWhere(['up.product_type' => 1])
            ->andWhere(['<>', 'up.register_date', $date]) // 不等于 null
            ->andWhere(['tupi.id' => null]) // 目标表中不存在记录
            ->andWhere(['up.type' => 1]);
//            ->createCommand()->getRawSql();
        foreach ($query->each(10) as $item) {
            $model = new \common\models\UserProduct();
            $model->makeProductDayExec($item);
        };
    }

    //购买产品按月补助
    //每分钟运行一次。
    public function actionMonth()
    {
        $now = time();
        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'product_type', 2],
            ["<", 'next_time', $now]
        ];
        $query = UserProduct::find()
            ->where($where);
//            ->createCommand()->getRawSql();
        foreach ($query->each(10) as $userProduct) {
            $model = new \common\models\UserProduct();
            $model->productMonth($userProduct);
        }
    }

}