<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  投资返利记录
 */
class InvestRebateRecord extends BaseModel {

    protected $table = 't_invest_rebate_record';

    public static function tableName() {
        return '{{t_invest_rebate_record}}';
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
        1 => 3,
        2 => 4,
        3 => 5,
        4 => 7,
        5 => 10,
    ];

    /**
     * 投资 增加返利记录
     * @param type $uid
     * @param type $RechargeOrderId
     * @param type $buyMoney
     * @return boolean
     */
    public function addInvestRebateRecordData($uid, $RechargeOrderId, $buyMoney) {
//        if (!in_array($uid, [6,18890])) {
//            $this->addError('mesg', ['212', '不允许哦']);
//            return false;
//        }
        //增加总奖池
        $MaxMoney = InvestInjectMoney::getInvestInjectMoney();
        if ($MaxMoney >= 50000000) {
            $this->addError('mesg', ['212', '分润总金额满了']);
            return false;
        }

        $model = new InvestRebateAccount();
        $maxTime = $model->getMaxDate();
        $minTime = $maxTime - 7 * 86400;
        if (time() < $minTime || time() > $maxTime) {
            $this->addError('mesg', ['212', '暂时未到时间哦']);
            return false;
        }



        $count = $this->find()->where(['uid' => $uid])->count() ?? 0;

        $count = $count + 1;
        $RebateProportionData = $this->RebateProportionData;
        $RebateProportion = 3;
        if (!empty($RebateProportionData[$count])) {
            $RebateProportion = $RebateProportionData[$count];
        } elseif ($count > 5) {
            $RebateProportion = $RebateProportionData[5];
        }
        $RebateMney = $buyMoney * ($RebateProportion / 100);
        $data = [
            'uid' => $uid, //
            'bid' => '', //投资id
            'RechargeOrderId' => $RechargeOrderId, //充值订单id
            'buyMoney' => $buyMoney, //购买金额
            'RebateProportion' => $RebateProportion, //返利比例
            'RebateMney' => $RebateMney, //返利金额
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

                //累计分润金额
                $model = new InvestRebateAccount();
                $model->addInvestRebateAccount($uid, $buyMoney);

                return true;
            } else {
                Yii::info('addInvestRebateRecordData-error---------' . json_encode($data), 'request');
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
    public function receiveInvestRebateRecordData($id, $uid) {
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
                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 28, $existData['RebateMney']);

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
    public function getClientInvestRebateRecord($uid, $page = 1, $limit = 10, $fields = []) {

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
    public function getInvestRebateList($page = 1, $limit = 10, $fields = [], $uid, $type) {
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
