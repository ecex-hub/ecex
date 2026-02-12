<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  投资返金砖币活动
 */
class WelfareRebateRecord extends BaseModel {

    protected $table = 't_welfare_rebate_record';

    public static function tableName() {
        return '{{t_welfare_rebate_record}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //
            ['bid', 'number'], //投资id
            ['RechargeOrderId', 'string'], //充值订单id
            ['buyMoney', 'number'], //购买金额
            ['RebateProportion', 'number'], //返利比例
            ['RebateMney', 'number'], //返利金额
            ['BrickProportion', 'number'], //金砖币返利比例WelfareActivity
            ['BrickMney', 'number'], //金砖币返利金额
            ['rebateNo', 'number'], //单数排序
            ['type', 'number'], //状态  1为申请 。2成功 3余额增加失败  4处理中
            ['receiveTime', 'number'], //领取时间
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public $RebateProportionData = [
        1 => ['money' => 2, 'selfBrick' => 5, 'superior' => 5],
        2 => ['money' => 3, 'selfBrick' => 5, 'superior' => 5],
        3 => ['money' => 4, 'selfBrick' => 5, 'superior' => 5],
        4 => ['money' => 5, 'selfBrick' => 10, 'superior' => 5],
        5 => ['money' => 6, 'selfBrick' => 10, 'superior' => 5],
        6 => ['money' => 7, 'selfBrick' => 15, 'superior' => 5],
        7 => ['money' => 8, 'selfBrick' => 15, 'superior' => 5],
        8 => ['money' => 9, 'selfBrick' => 20, 'superior' => 5],
    ];

    /**
     * 投资 增加返利记录
     * @param type $uid
     * @param type $RechargeOrderId
     * @param type $buyMoney
     * @return boolean
     */
    public function addWelfareRebateRecordData($uid, $RechargeOrderId, $buyMoney) {
//        if (!in_array($uid, [6, 18890,176938])) {
//            $this->addError('mesg', ['212', '不允许哦']);
//            return false;
//        }
        //增加总奖池
//        $MaxMoney = InvestInjectMoney::getInvestInjectMoney();
//        if ($MaxMoney >= 50000000) {
//            $this->addError('mesg', ['212', '分润总金额满了']);
//            return false;
//        }

        $model = new WelfareRebateAccount();
        $maxTime = $model->getMaxDate();
        $minTime = $maxTime - 19 * 86400;
        if (time() < $minTime || time() > $maxTime) {
            $this->addError('mesg', ['212', '暂时未到时间哦']);
            return false;
        }



        $count = $this->find()->where(['uid' => $uid])->count() ?? 0;

        $count = $count + 1;
        $RebateProportionData = $this->RebateProportionData;
        $RebateProportion = 3;
        $selfBrick = 5;
        $superior = 5;
        if (!empty($RebateProportionData[$count])) {
            $RebateProportion = $RebateProportionData[$count]['money'];
            $selfBrick = $RebateProportionData[$count]['selfBrick'];
            $superior = $RebateProportionData[$count]['superior'];
        } elseif ($count > 8) {
            $RebateProportion = $RebateProportionData[8]['money'];
            $selfBrick = $RebateProportionData[8]['selfBrick'];
            $superior = $RebateProportionData[8]['superior'];
        }
        $RebateMney = $buyMoney * ($RebateProportion / 100);

        $BrickMney = $buyMoney * ($selfBrick / 100);
        $data = [
            'uid' => $uid, //
            'bid' => '', //投资id
            'RechargeOrderId' => $RechargeOrderId, //充值订单id
            'buyMoney' => $buyMoney, //购买金额
            'RebateProportion' => $RebateProportion, //返利比例
            'RebateMney' => $RebateMney, //返利金额
            'BrickProportion' => $selfBrick, //金砖币返利比例
            'BrickMney' => $BrickMney, //金砖币返利金额
            'rebateNo' => $count,
            'receiveTime' => 0,
            'type' => 1, //状态  
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                //增加上级金砖币
                $existData = AccountInfo::getAccountDataMessage($uid);
                if (!empty($existData['oneLevel'])) {

                    $money = $buyMoney * ($superior / 100);
                    $oneLevel = $existData['oneLevel'];
                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($oneLevel, $money, $type = 3);
                    if ($boor) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($oneLevel, AssetChanges::MONEY_TYPE_3, AssetChanges::ASSET_TYPE_1, $changeType = 30, $money);
                        //金砖币记录
                        $model = new GoldBrickRecord();
                        $model->addGoldBrickRecord($oneLevel, GoldBrickRecord::ASSET_TYPE_1, $changeType = 6, $money);
                    }
                }
                //累计分润金额
                $model = new WelfareRebateAccount();
                $model->addWelfareRebateAccount($uid, $buyMoney);

                return true;
            } else {
                Yii::info('addWelfareRebateRecordData-error---------' . json_encode($data), 'request');
                $this->addError('mesg', ['212', '添加失败']);
                return false;
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户领取
     * @param type $id
     * @param type $uid
     * @return boolean
     */
    public function receiveWelfareRebateRecordData($id, $uid) {
        $existData = $this->find()->where(['id' => $id, 'uid' => $uid, 'type' => 1])->asArray()->one();
        if (empty($existData)) {
            $this->addError('mesg', ['211', '领取订单异常']);
            return false;
        } else {
            $boor = $this->updateAll(['type' => 4], ['id' => $id, 'type' => 1]);
            if ($boor) {
                //赠送一定比例余额 
                $model = new AccountInfo();
                $boor = $model->addAccountGold($uid, $existData['RebateMney'], 1);
                if ($boor) {//资产变化
                    $AssetChanges = new AssetChanges();
                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 33, $existData['RebateMney']);

                    //BrickMney增加金砖币

                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($uid, $existData['BrickMney'], $type = 3);
                    if ($boor) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_3, AssetChanges::ASSET_TYPE_1, $changeType = 33, $existData['BrickMney']);
                        //金砖币记录
                        $model = new GoldBrickRecord();
                        $model->addGoldBrickRecord($uid, GoldBrickRecord::ASSET_TYPE_1, $changeType = 7, $existData['BrickMney']);
                    }

                    $this->updateAll(['type' => 2, 'receiveTime' => time()], ['id' => $id]);

                    return true;
                } else {
                    $this->updateAll(['type' => 3], ['id' => $id]);
                    $this->addError('mesg', ['212', '余额增加失败']);
                    return false;
                }
            } else {
                $this->addError('mesg', ['211', '订单暂时无法领取，稍后再试']);
                return false;
            }
        }
    }

    /**
     * 获取记录
     * @param type $uid
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientWelfareRebateRecord($uid, $page = 1, $limit = 10, $fields = []) {

        $rediskey = __METHOD__ . $uid . $page . $limit;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            //return $redisData;
        }

        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getWelfareRebateList($page = 1, $limit = 10, $fields = [], $uid, $type) {
        $where = [
            'and'
        ];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }
        if (!empty($type)) {
            $where[] = ['=', 'type', $type];
        }
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

}
