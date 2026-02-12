<?php

namespace common\models;

use common\models\BaseModel;
use Yii;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;
use yii\db\Expression;

/**
 * ContactForm is the model behind the contact form.  项目内容
 */
class Product extends BaseModel
{

    protected $table = 't_product';

    public static function tableName()
    {
        return '{{t_product}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['name', 'string'], //标题
            ['image', 'string'], //标题
            ['price', 'number'], //产品价格
            ['remark', 'string'], //产品说明
            ['is_hot', 'number'], //1-热门
            ['sort', 'number'], //排序
            ['type', 'number'], //状态  1为启用   2为关闭
            ['limit_num', 'number'], //限制数量
            ['itime', 'number'], //
            ['utime', 'number'], //

            ['day', 'number'], //产品天数
            ['day_income', 'number'], //每日收益
            ['allowance', 'number'], //产品补助

            ['month', 'number'], //月
            ['month_income', 'number'], //每月补助


        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getList($page = 1, $limit = 10, $isHot = 0)
    {
        $where = [];
        if ($isHot > 0) {
            $where = [
                '=', 'is_hot', $isHot,
            ];
        }
        $data = $this->listFind(['page' => $page, 'row' => $limit])
            ->select([
                'id', 'name', 'image', 'price',
                'product_type', 'day', 'day_income', 'allowance', 'month', 'month_income'
            ])
            ->orderBy("sort asc")
            ->where(['type' => 1])
            ->andwhere($where)
            ->asArray()
            ->all();
        foreach ($data as &$row) {
            $row['image'] = FuncHelper::getCdnUrl($row['image']);
            $row['price'] = intval($row['price']);
        }
        return $data;
    }

    public function getInfo($id)
    {

        $where = [
            '=', 'id', $id
        ];
        $data = $this->find()
            ->where($where)->one();
        if ($data) {
            $data['image'] = FuncHelper::getCdnUrl($data['image']);
            $data['price'] = intval($data['price']);
        }
        return $data;
    }


    public function buyProduct($id, $num, $user)
    {
        $uid = $user->uid;
        $product = $this->getInfo($id);
        if (empty($product)) {
            return [-1, '产品不存在'];
        }
        $num=intval($num);
          $key = "buy_product". $uid;
          // 获取 Redis 组件
          $redis = Yii::$app->redis;
          $redisInfo = $redis->get($key);
          if ($redisInfo) {
              return [-1, '你购买的太频繁了，请稍候'];
          }
          $redis->set($key, 1, 'EX', 3, 'NX'); // 原子操作
        $totalPrice = $product['price'] * $num;
        if ($totalPrice > $user['money']) {
            return [-1, '余额不足'];
        }
        //产品购买限制
        $countNum = (new UserProduct())->find()
            ->where([
                'uid' => $uid,
                'product_id'=>$id,
                ])->sum("num");
        if ($countNum >= $product['limit_num']) {
            return [-1, '已超过产品购买限制'];
        }
        if ($num <= 0) {
            return [-1, '数量有误'];
        }
        $canBuyNum = max(0, $product['limit_num'] - $countNum);
        if ($num > $canBuyNum || $num <= 0) {
            return [-1, '可购买数量:' . $canBuyNum];
        }
        // 开始一个事务
        $transaction = Yii::$app->db->beginTransaction();
        $userProductId = 0;
        if ($product['product_type'] == 1) {
            $totalIncome = $product['day_income'] / 100 * $totalPrice * $product['day'];
            $endTime = time() + (86400 * $product['day']);
            $next_time = 0;
        } else {
            $totalIncome = $product['month'] * $num * $product['month_income'];
            $endTime = 0;
            $next_time = time() + (86400 * 30);
        }
        try {
            // 定义要插入的数据
            $data = [
                'uid' => $uid,
                'product_id' => $product['id'],
                'name' => $product['name'],
                'price' => $product['price'],
                'total_price' => $totalPrice,
                'total_income' => $totalIncome,
                'day' => $product['day'],
                'day_income' => $product['day_income'],
                'allowance' => $product['allowance'],
                'product_type' => $product['product_type'],
                'month' => $product['month'],
                'month_income' => $product['month_income'],
                'next_time' => $next_time,
                'num' => $num,
                'oneLevel' => $user->oneLevel,
                'end_time' => $endTime,
                'type' => 1,
                'register_date' => date('Y-m-d'),
                'itime' => time(),
                'utime' => time(),
            ];
            $userProduct = new UserProduct();
            if (!$userProduct->insertData($data)) {
                throw new \Exception('Failed to save user product');
            }
            $userProductId = $userProduct->id;
            $billData = [
                'uid' => $user->uid,
                'money' => $totalPrice,
                'money_type' => BillRecord::MoneyTypeOne,
                'bill_unit' => 'sub',
                'bill_type' => BillRecord::BillTypeBuyProduct,
                'ext_id' => $userProductId,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            //
            $accountInfo = new AccountInfo();
            $money = bcsub($user['money'], $totalPrice);
            $boor = $accountInfo->updateAll([
                'money' => $money,
                'buy_product_money' => new Expression('buy_product_money+' . $totalPrice),
            ], ['uid' => $user->uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('product', [
                'uid' => $user->uid,
                'product_id' => $id,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        //购买产品获取返现
        $account = new AccountInfo();
        if ($user->oneLevel) {
            $payBack = bcmul($totalPrice, 0.11);
            $account->addInvitePayBack($user->oneLevel, $userProductId, $payBack, 1);
            //每日下一级的用户中，购买了任意产品的人数，达到一定条件，额外再给一份奖励，奖励放回报钱包，不同人数对应不同奖励
            //$account->addInviteCountPayBack($user->oneLevel);
        }
        if ($user->twoLevel) {
            $payBack = bcmul($totalPrice, 0.08);
            $account->addInvitePayBack($user->twoLevel, $userProductId, $payBack, 2);
        }
        if ($user->threeLevel) {
            $payBack = bcmul($totalPrice, 0.05);
            $account->addInvitePayBack($user->threeLevel, $userProductId, $payBack, 3);
        }
   
        //发放补助
        $this->makeProductTwoDayExec($uid, $userProductId);
    
        //记录用户第一次购买成功
        try {
            $accountM = new AccountInfo();
            $userInfo = $accountM->find()->where(["uid" => $uid])->one();
            if ($userInfo) {
                $now = time();
                Yii::$app->db->createCommand()->upsert(
                    't_user_first_buy', // 表名
                    [
                        'uid' => $uid,
                        'money' => $userInfo->dream_fund,
                        'next_reward_time' => ($now + (86400 * 30)),
                        'itime' => $now,
                        'utime' => time(),
                    ], false
                )->execute();
            }
        } catch (\Exception $e) {
            FuncHelper::ErrLog('user_first_buy', [
                'uid' => $user->uid,
            ], $e->getMessage());
        }

        return [0, 'ok'];
    }

    public function makeProductTwoDayExec($uid, $id)
    {
        $count = (new UserProduct())->find()->where(['uid' => $uid])
            ->count();
        if ($count > 1) {
            return true;
        }
        $transaction = \Yii::$app->db->beginTransaction();
        try {
            //账单
            $billData = [
                'uid' => $uid,
                'money' => 20000,
                'money_type' => BillRecord::MoneyTypeThree,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeProductTwoDay,
                'ext_id' => $id,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            //用户
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'allowance' => new Expression('allowance+' . 20000)
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('product_two_day', [
                'uid' => $uid,
                'user_product_id' => $id,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        return false;
    }

    public function getUserList($uid, $page = 1, $limit = 10, $type = 1)
    {


        $where = [
            'and',
            ['=', 'uid', $uid],
        ];
        if ($type) {
            $where[] = ['=', 'type', $type];
        }
        $product = new UserProduct();
        $list = $product->listFind(['page' => $page, 'row' => $limit])
            ->select(['id', 'name', 'total_price', 'itime', 'type', 'total_income'])
            ->where($where)
            ->orderBy('id desc')
            ->asArray()
            ->all();
        foreach ($list as &$value) {
            $value['create_time'] = date("Y-m-d H:i:s", $value['itime']);
        }
        $count = $product->find()
            ->where($where)
            ->count();
        $data = [
            'list' => $list,
            'count' => $count
        ];
        return $data;
    }


    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getProjectDataMessage($id)
    {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }


    /**
     * 获取指定id列表
     * @param type $id
     * @return type
     */
    public static function getProjectDataListMessage($id)
    {
        $where = [
            'and',
            ['in', 'id', $id]
        ];
        $temp = self::find()->where($where)->asArray()->all();
        $data = [];
        foreach ($temp as $key => $value) {
            $data[$value['id']] = $value['title'];
        }
        return $data;
    }


}
