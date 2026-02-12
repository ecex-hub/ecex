<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  限时福利项目
 */
class LimitedWelfareRecord extends BaseModel {

    protected $table = 't_limited_welfare_record';

    public static function tableName() {
        return '{{t_limited_welfare_record}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['title', 'string'], //标题
            ['investMoney', 'number'], //金额
            ['rewardMoney1', 'number'], //奖励金额1
            ['rewardMoney2', 'number'], //奖励金额2
            ['rewardMoney3', 'number'], //奖励金额3
            ['rewardMoney4', 'number'], //奖励金额4
            ['rewardMoney5', 'number'], //奖励金额5
            ['rewardMoney6', 'number'], //奖励金额6
            ['rewardMoney7', 'number'], //奖励金额7
            ['maxRewardMoney', 'number'], //满期奖励金额
            ['limitedWelfare', 'number'], //项目id
            ['cycle', 'number'], //周期
            ['startTime', 'number'], //开始时间
            ['type', 'number'], //1锁定中 2自动释放 。3手动释放 。4手动释放 。加钱失败
            ['RechargeOrderId', 'string'], //充值订单id
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 用户下单记录
     * @param type $title
     * @param type $investMoney
     * @param type $coverUrl
     * @param type $sort
     * @param type $type
     * @return boolean
     */
    public function buyLimitedWelfareRecord($uid, $limitedWelfareID, $RechargeOrderId) {

        $ProjectData = LimitedWelfareData::getLimitedWelfareDataMessage($limitedWelfareID);
        if (empty($ProjectData)) {
            $this->addError('mesg', ['212', '项目id为空']);
            return false;
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

        $existData = $this->userExistData($uid);
        if (!empty($existData)) {
//            $this->addError('mesg', ['212', '已经购买了,无法再次购买']);
//            return false;
        }

//        $maxRewardMoney = $ProjectData['rewardMoney1'] + $ProjectData['rewardMoney2'] + $ProjectData['rewardMoney3'] + $ProjectData['rewardMoney4'] +
//                $ProjectData['rewardMoney5'] + $ProjectData['rewardMoney6'] + $ProjectData['rewardMoney7'];

        $maxRewardMoney = $ProjectData['maxRewardMoney'];
        $cycle = $ProjectData['cycle'];

        $data = [
            'uid' => $uid, //用户id
            'title' => $ProjectData['title'], //标题
            'investMoney' => $ProjectData['investMoney'], //金额
            'rewardMoney1' => $ProjectData['rewardMoney1'], //奖励金额1
            'rewardMoney2' => $ProjectData['rewardMoney2'], //奖励金额1
            'rewardMoney3' => $ProjectData['rewardMoney3'], //奖励金额1
            'rewardMoney4' => $ProjectData['rewardMoney4'], //奖励金额1
            'rewardMoney5' => $ProjectData['rewardMoney5'], //奖励金额1
            'rewardMoney6' => $ProjectData['rewardMoney6'], //奖励金额1
            'rewardMoney7' => $ProjectData['rewardMoney7'], //奖励金额1
            'maxRewardMoney' => $maxRewardMoney, //满期奖励最大金额
            'limitedWelfare' => $ProjectData['id'], //项目id
            'cycle' => $ProjectData['cycle'],
            'startTime' => time() + 86400, //开始时间
            'type' => 1, //1锁定中 2自动释放 。3手动释放
            'RechargeOrderId' => $RechargeOrderId, //充值订单id
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    //赠送等额金砖币
                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($uid, $ProjectData['investMoney'], 3);
                    if ($boor) {//资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_3, AssetChanges::ASSET_TYPE_1, $changeType = 23, $ProjectData['investMoney']);
                        //金砖币记录
                        $model = new GoldBrickRecord();
                        $model->addGoldBrickRecord($uid, GoldBrickRecord::ASSET_TYPE_1, $changeType = 4, $ProjectData['investMoney']);
                        //记录金砖币总额
                        GiveBrick::addGiveBrickData($ProjectData['investMoney']);
                    }


                    return true;
                } else {
                    $this->addError('mesg', ['212', '添加失败']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户购买记录
     * @param type $uid
     * @return type
     */
    public function userExistData($uid) {
       // return false;
        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        return $this->find()->where($where)->asArray()->one();
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getLimitedWelfareRecordList($page = 1, $limit = 10, $fields = [], $uid, $type, $investMoney) {
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

    /**
     * 获取购买详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientLimitedWelfareRecord($page, $limit, $uid, $fields = []) {

        $rediskey = __METHOD__ . $page . $limit . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'uid', $uid],
        ];

        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 用户手动释放
     * @param type $uid
     * @return type
     */
    public function handMovementRelease($uid) {
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'type', 1],
            ['<', 'startTime', time() - 86400]
        ];
        $data = $this->find()->where($where)->asArray()->one();

        if (!empty($data)) {
            $timeDay = intval((time() - $data['startTime']) / 86400);
            if ($timeDay < 1) {
                $this->addError('mesg', ['211', '暂时无法释放']);
                return false;
            }
            if ($timeDay > 6) {
                $timeDay = 6;
            }

            $money = 0;
            for ($i = 1; $i <= $timeDay; $i++) {//算该结算多少钱
                if (!empty($data['rewardMoney' . $i])) {
                    $money = $money + $data['rewardMoney' . $i];
                };
            }
            if ($money > 0) {//释放给钱
                $boor = $this->updateAll(['type' => 3, 'utime' => time()], ['id' => $data['id'], 'type' => 1]);
                if ($boor) {
                    //增加余额
                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($data['uid'], $money, $type = 1);
                    if ($boor) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 20, $money);
                        return true;
                    } else {
                        $boor = $this->updateAll(['type' => 4, 'utime' => time()], ['id' => $data['id']]);
                        $this->addError('mesg', ['212', '释放完成余额结算失败，联系客服']);
                        return false;
                    }
                }
            }
        } else {
            $this->addError('mesg', ['211', '无释放条件']);
            return false;
        }
    }

}
