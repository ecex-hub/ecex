<?php

namespace common\models;


use common\components\FuncHelper;
use yii\db\Expression;
use yii;

class UserProduct extends BaseModel
{

    protected $table = 't_user_product';

    public static function tableName()
    {
        return '{{t_user_product}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标记id
            ['product_id', 'number'], //产品ID
            ['product_type', 'number'], //产品ID
            ['name', 'string'], //标题
            ['price', 'number'], //产品价格
            ['day_income', 'number'], //每日收益
            ['allowance', 'number'], //产品补助
            ['day', 'number'], //产品天数

            ['num', 'number'], //数量
            ['total_price', 'number'], //总价
            ['total_income', 'number'], //总收益
            ['end_time', 'number'], //到期时间

            ['month', 'number'], //月
            ['month_income', 'number'], //每月补助
            ['next_time', 'number'], //下一次发放时间
            ['send_num', 'number'], //发放数量

            ['itime', 'number'], //
            ['utime', 'number'], //
            ['type', 'number'], //状态 1-默认 2-已完成
            ['income_price', 'number'], //收益价格
            ['register_date', 'string'], //注册时间
            ['oneLevel', 'number'], //上级uid
            ['total_pay_back', 'number'], //获取收益

        ];
    }

    public function getBuyCount($inviteUid)
    {
        $date = date("Y-m-d");
        $where = [
            'and',
            ['=', 'oneLevel', $inviteUid],
            ['=', 'register_date', $date],
        ];
        $count = $this->find()
            ->select(['uid'])
            ->where($where)
            ->groupBy("uid")
            ->count();
        return $count;
    }

    public function getInfo($id, $uid)
    {

        $where = [
            'and',
            ['=', 'id', $id],
            ['=', 'uid', $uid],
        ];
        $data = $this->find()
            ->select(['id', 'name', 'price', 'day_income', 'allowance', 'day',
                'num', 'total_price', 'end_time', 'type', 'income_price'])
            ->where($where)->one();
        return $data;
    }

    //最终补贴
    public function makeProductEndExec($userProduct)
    {
        $id = $userProduct['id'];
        $uid = $userProduct['uid'];
        $money = $userProduct['allowance'];
        $transaction = \Yii::$app->db->beginTransaction();
        try {
            //账单
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeThree,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeProductEnd,
                'ext_id' => $id,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            // 用户结束
            $boor = $this->updateAll([
                'type' => 2,
            ], ['id' => $id]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user product fail');
            }
            //用户
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'allowance' => new Expression('allowance+' . $money)
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
            $this->makeProductDayExec($userProduct);
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('product_end', $userProduct, $e->getMessage());
            return [-1, '添加失败'];
        }
        return true;
    }

    //每日收益
    public function makeProductDayExec($userProduct)
    {
        $id = $userProduct['id'];
        $uid = $userProduct['uid'];
        $money = $userProduct['total_price'] * $userProduct['day_income'] / 100;
        $income = new UserProductIncome();
        //用户已领取当天
        $hasId = $income->getReceiveByDay($uid, $userProduct['id']);
        if ($hasId) {
            return true;
        }
        //总领取天数
        $count = $income->getReceiveCount($uid, $userProduct['id']);
        if ($count >= $userProduct['day']) {
            return true;
        }
        $transaction = \Yii::$app->db->beginTransaction();
        try {
            //账单
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeProductIncome,
                'ext_id' => $id,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            //每日账单
            $userProductIncome = [
                'uid' => $uid,
                'user_product_id' => $userProduct['id'],
                'product_id' => $userProduct['product_id'],
                'income' => $money,
                'day' => date("Y-m-d"),
                'itime' => time(),
                'utime' => time(),
            ];
            $income = new UserProductIncome();
            $boor = $income->insertData($userProductIncome);
            if (empty($boor)) {
                throw new \Exception('Failed to save user product income');
            }
            //用户产品
            $userProductModel = new UserProduct();
            $boor = $userProductModel->updateAll([
                'total_pay_back' => new Expression('total_pay_back+' . $money)
            ], ['id' => $userProduct['id']]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user product fail');
            }
            //用户
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'pay_back' => new Expression('pay_back+' . $money)
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
            return true;
        } catch (\Exception $e) {
            $transaction->rollBack();
            FuncHelper::ErrLog('product_day', $userProduct, $e->getMessage());
            return false;
        }
    }


    public function productMonth($userProduct)
    {
        //产品发放完毕
        if ($userProduct->send_num >= $userProduct->month) {
            return true;
        }
        $uid = $userProduct->uid;
        $money = $userProduct->month_income * $userProduct->num;
        $accountM = new AccountInfo();
        $user = $accountM->find()->where(["uid" => $uid])->one();
        if (empty($user)) {
            return true;
        }
        $transaction = Yii::$app->db->beginTransaction();
        try {
            //领取奖励
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeThree,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeBuyProductAllowance,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $data = [
                'next_time' => new Expression('next_time+' . (86400 * 30)),
                'send_num' => new Expression('send_num+' . 1)
            ];
            //如果发放次数足够。
            if ($userProduct->send_num + 1 == $userProduct->month) {
                $data['type'] = 2;
            }
            //更新用户表
            $userProductM = new UserProduct();
            $boor = $userProductM->updateAll($data, ["id" => $userProduct->id]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user product');
            }
            if ($money) {
                $accountInfo = new AccountInfo();
                $boor = $accountInfo->updateAll([
                    'allowance' => new Expression('allowance+' . $money)
                ], ['uid' => $uid]);
                if (empty($boor)) {
                    throw new \Exception('Failed to update user fail');
                }
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('user_product_month', [
                'uid' => $uid,
                'money' => $money,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        return false;
    }
}