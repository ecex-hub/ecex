<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;
use yii\db\Expression;

/**
 * ContactForm is the model behind the contact form.  福利投资返利账号信息
 */
class WelfareRebateAccount extends BaseModel {

    protected $table = 't_welfare_rebate_account';

    public static function tableName() {
        return '{{t_welfare_rebate_account}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //
            ['investMoney', 'number'], //投资总金额 。已注入金额
            ['generateProfit', 'number'], //发展经费 。个人投资总金额 / 投入总金额 * 50000000  时间大于结束就结算
            ['distributeType', 'number'], //下发状态 。1未下发 。2已经下发
            //['allowanceProfit', 'number'], //津贴 。个人投资总金额 / 投入总金额 * 50000000 * vip 比例 时间大于结束就结算
            ['allowanceTime', 'number'], //津贴下发时间 。超过30天就下发余额
            ['countType', 'number'], //1累积中 。 2已经计算
            ['type', 'number'], //1累积中 。 2处理中
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public $RebateProportionData = [
        3 => 1,
        4 => 1.2,
        5 => 1.4,
        6 => 1.6,
        7 => 1.8,
        8 => 2.0,
        9 => 2.5,
        10 => 3,
        11 => 4,
        12 => 5,
    ];

    /**
     * 增加用户分润信息
     * @param type $uid
     * @param type $RechargeOrderId
     * @param type $buyMoney
     * @return boolean
     */
    public function addWelfareRebateAccount($uid, $buyMoney) {
        //增加总奖池
        $MaxMoney = WelfareRebateMoney::getWelfareRebateMoney();
//        if ($MaxMoney >= 50000000) {
//            $this->addError('mesg', ['212', '分润总金额满了']);
//            return false;
//        }
        //投入总金额
        WelfareRebateMoney::AddWelfareRebateMoney($buyMoney);

        $existData = $this->find()->where(['uid' => $uid])->asArray()->one();
        if (empty($existData)) {
            $generateProfit = $buyMoney * 0.018;
            $data = [
                'uid' => $uid, //
                'investMoney' => $buyMoney, //投资总金额 。已注入金额
                'generateProfit' => 0, //发展经费 。个人投资总金额 / 投入总金额 * 50000000  时间大于结束就结算
                'distributeType' => 1, //下发状态 。1未下发 。2已经下发
                //'allowanceProfit' => 0, //津贴 。个人投资总金额 / 投入总金额 * 50000000 * vip 比例 时间大于结束就结算
                'allowanceTime' => 0, //津贴下发时间 。超过30天就下发余额
                'countType' => 1, //1累积中 。 2已经计算
                'type' => 1, //1累积中 。 2处理中
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
            ];

            $this->attributes = $data;
            if ($this->validate()) {
                $boor = $this->addData($data);
                if ($boor) {
                    return true;
                } else {
                    $this->addError('mesg', ['212', '添加失败']);
                    return false;
                }
            }
            $this->addError('mesg', ['211', '数据异常，检查数据']);
            return false;
        } else {
            // $generateProfit = $buyMoney * 0.018;
            $boor = $this->updateAll(['investMoney' => new Expression('investMoney+' . $buyMoney)],
                    ['uid' => $uid]);
            if ($boor) {
                return true;
            } else {
                $this->addError('mesg', ['211', '累积异常']);
                return false;
            }
        }
    }

    public function getMaxDate() {
        return strtotime('2024-01-11');
    }

    /**
     * 统一释放经费
     */
    public function unifycomputeWelfareRebateAccount() {

        $time = $this->getMaxDate();
        $time = $time + 86400;
        if (time() > $time) {
            $row = 1000;
            $data = [];
            for ($i = 1; $i < 5; $i++) {
                self::$key = $fields;
                $existdata = $this->listFind(['page' => $i, 'row' => $row, 'sort' => '-itime'])->where([])->all();
                if (!empty($existdata)) {
                    $data = array_merge($data, $existdata);
                } else {
                    break;
                }
            }
            foreach ($data as $key => $value) {
                var_dump($value['uid']);
                $boor = $this->receiveWelfareRebateAccount($value['uid']);
                var_dump($boor);
            }
        } else {
            echo '还没到时间 。活动结束 24小时才能统一计算';
        }
    }

    /**
     * 计算经费收益
     * @param type $uid
     */
    public function computeWelfareRebateAccount($uid) {
        $time = $this->getMaxDate();
        if (time() > $time) {//活动结束了才能计算收益
            $MaxMoney = WelfareRebateMoney::getWelfareRebateMoney();
            $existData = $this->find()->where(['uid' => $uid])->asArray()->one();
            if (!empty($existData)) {
                $bi = $existData['investMoney'] / $MaxMoney;
                $allMOney = 50000000;
                $generateProfit = $this->changeDecimalReserve($allMOney * $bi);
                $this->updateAll(['generateProfit' => $generateProfit, 'countType' => 2], ['uid' => $uid]);
            }
        }
    }

    /**
     * 释放经费
     * @param type $uid
     * @return boolean
     */
    public function receiveWelfareRebateAccount($uid) {
        $time = $this->getMaxDate();
        if (time() > $time) {
            $existData = $this->find()->where(['uid' => $uid, 'distributeType' => 1])->asArray()->one();
            if (empty($existData)) {
                $this->addError('mesg', ['211', '暂无可释放经费']);
                return false;
            }
            if ($existData['countType'] == 1) {
                $this->computeWelfareRebateAccount($uid);
                $existData = $this->find()->where(['uid' => $uid, 'distributeType' => 1, 'countType' => 2])->asArray()->one();
                if (empty($existData)) {
                    $this->addError('mesg', ['211', '暂无可释放经费']);
                    return false;
                }
            }
            $boor = $this->updateAll(['type' => 2], ['id' => $existData['id'], 'type' => 1]);
            if ($boor) {
                //释放经费 
                $model = new AccountInfo();
                $boor = $model->addAccountGold($uid, $existData['generateProfit'], 1);
                if ($boor) {//资产变化
                    $this->updateAll(['type' => 1, 'distributeType' => 2], ['id' => $existData['id']]);
                    $AssetChanges = new AssetChanges();
                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 31, $existData['generateProfit']);
                    return true;
                } else {
                    $this->updateAll(['type' => 1], ['id' => $existData['id']]);
                    $this->addError('mesg', ['211', '领取失败']);
                    return false;
                }
            } else {
                $this->addError('mesg', ['211', '已经在处理中了']);
                return false;
            }
        } else {
            $this->addError('mesg', ['211', '暂未到领取时间']);
            return false;
        }
    }

    /**
     * 计算津贴收益
     * @param type $uid
     * @return int
     */
    public function getAllowanceAccountMoney($uid) {
        $existData = $this->find()->where(['uid' => $uid])->asArray()->one();
        if (empty($existData)) {
            return 0;
        }
        if ($existData['countType'] == 1) {
            $this->computeWelfareRebateAccount($uid);
            $existData = $this->find()->where(['uid' => $uid, 'countType' => 2])->asArray()->one();
            if (empty($existData)) {
                return 0;
            }
        }
        if (!empty($existData['generateProfit'])) {
            $RebateProportionData = $this->RebateProportionData;
            $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
            $RebateProportio = 1;
            if (!empty($AccountInfoData['vipGrade'])) {
                $vipGrade = $AccountInfoData['vipGrade'];
                if (!empty($RebateProportionData[$vipGrade])) {
                    $RebateProportio = $RebateProportionData[$vipGrade];
                }
            }
            return $existData['generateProfit'] * $RebateProportio;
        } else {
            return 0;
        }
    }

    /**
     * 领取津贴
     * @param type $uid
     */
    public function receiveWelfareRebateAllowanceAccount($uid) {

        $time = $this->getMaxDate();
        $startDay = date('d', $time);
        $Day = date('d');
        $time = $time + 28 * 86400;
        if (time() > $time) {
            if ($startDay == $Day) {
                //获取津贴金额
                $allowanceProfit = $this->getAllowanceAccountMoney($uid);
                if ($allowanceProfit > 0) {
                    $existData = $this->find()->where(['uid' => $uid])->asArray()->one();
                    if (!empty($existData)) {
                        if ($existData['allowanceTime'] < time() - 27 * 86400) {
                            $boor = $this->updateAll(['type' => 2], ['id' => $existData['id'], 'type' => 1]);
                            if ($boor) {
                                $existData = $this->find()->where(['uid' => $uid])->asArray()->one();

                                $allowanceTime = strtotime(date('Y-m-d'));
                                //赠送分润余额 
                                $model = new AccountInfo();
                                $boor = $model->addAccountGold($uid, $allowanceProfit, 1);
                                if ($boor) {
                                    $this->updateAll(['type' => 1, 'allowanceTime' => $allowanceTime], ['id' => $existData['id']]);
                                    $AssetChanges = new AssetChanges();
                                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 32, $allowanceProfit);

                                    return true;
                                } else {
                                    $this->addError('mesg', ['211', '津贴下发异常']);
                                    return false;
                                }
                            } else {
                                $this->addError('mesg', ['211', '已经处理中了']);
                                return false;
                            }
                        } else {
                            $this->addError('mesg', ['211', '暂未到领取时间哦']);
                            return false;
                        }
                    } else {
                        $this->addError('mesg', ['211', '暂无可领取数据']);
                        return false;
                    }
                } else {
                    $this->addError('mesg', ['211', '暂无可领取津贴']);
                    return false;
                }
            } else {
                $this->addError('mesg', ['211', '暂未到领取时间']);
                return false;
            }
        } else {
            $this->addError('mesg', ['211', '暂未到领取时间呢']);
            return false;
        }
    }

    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientWelfareRebateAccountMessage($uid) {
        $rediskey = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            // return $redisData;
        }
        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        $fields = [];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
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
    public function getWelfareRebateAccountList($page = 1, $limit = 10, $fields = [], $uid) {
        $where = [
            'and'
        ];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

}
