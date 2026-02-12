<?php

namespace console\controllers;

use common\models\RechargeOrder;
use common\models\UserProduct;
use yii\console\Controller;
use Yii;
use yii\db\Expression;

class ProductController extends Controller
{
    //用户第二天补贴
    //每分钟。
    public function actionTwoDay()
    {
        try {
            //每日统计收益数据
            $model = new \common\models\UserProduct();
            $yesterday = date('Y-m-d', strtotime('-1 day'));
            $where = [
                'and',
                ['=', 'two_day_type', 0],
                ['=', 'register_date', $yesterday],
            ];
            $list = $model->find()
                ->where($where)
                ->each(20);
            foreach ($list as $item) {
                $model->makeProductTwoDayExec($item);
            }
        } catch (\Exception $e) {
            Yii::info('product_two_day-------' . $e->getMessage(), 'request');
        }
    }

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
                ['=', 'type', 1],
                ['<', 'itime', $time],
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
            ->andWhere(['<>', 'up.register_date', $date]) // 不等于 null
            ->andWhere(['tupi.id' => null]) // 目标表中不存在记录
            ->andWhere(['up.type' => 1]);
//                ->createCommand()->getRawSql();
        foreach ($query->each(10) as $item) {
            $model = new \common\models\UserProduct();
            $model->makeProductDayExec($item);
        };
    }
}