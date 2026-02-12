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
 * ContactForm is the model behind the contact form.  投资返利账号信息
 */
class InvestRebateAccount extends BaseModel {

    protected $table = 't_invest_rebate_account';

    public static function tableName() {
        return '{{t_invest_rebate_account}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //
            ['investMoney', 'number'], //投资总金额 。已注入金额
            ['generateProfit', 'number'], //investMoney * 0.018  已产生利润
            ['distributeTime', 'number'], //下发时间 。超过30天就下发余额
            ['type', 'number'], //1累积中 。 2处理中
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 增加用户分润信息
     * @param type $uid
     * @param type $RechargeOrderId
     * @param type $buyMoney
     * @return boolean
     */
    public function addInvestRebateAccount($uid, $buyMoney) {
        //增加总奖池
        $MaxMoney = InvestInjectMoney::getInvestInjectMoney();
        if ($MaxMoney >= 50000000) {
            $this->addError('mesg', ['212', '分润总金额满了']);
            return false;
        }
        //投入总金额
        InvestInjectMoney::AddInvestInjectMoney($buyMoney);

        $existData = $this->find()->where(['uid' => $uid])->asArray()->one();
        if (empty($existData)) {
            $generateProfit = $buyMoney * 0.018;
            $data = [
                'uid' => $uid, //
                'investMoney' => $buyMoney, //投资总金额 。已注入金额
                'generateProfit' => $generateProfit, //investMoney * 0.018  已产生利润
                'distributeTime' => 0, //下发时间 。超过30天就下发余额
                'type' => 1,
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
            $generateProfit = $buyMoney * 0.018;
            $boor = $this->updateAll(['investMoney' => new Expression('investMoney+' . $buyMoney), 'generateProfit' => new Expression('generateProfit+' . $generateProfit)],
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
        return strtotime('2023-12-18');
    }

    /**
     * 领取分润池
     * @param type $uid
     * @return boolean
     */
    public function receiveInvestRebateAccount($uid) {
        $time = $this->getMaxDate();
        if (time() > $time) {
            $existData = $this->find()->where(['uid' => $uid])->asArray()->one();
            if (!empty($existData['generateProfit'])) {
                if ($existData['distributeTime'] < (time() - 30 * 86400)) {
                    if ($existData['distributeTime'] < $time) {//第一次
                        //  $distributeTime = $time;
                        $distributeTime = time();
                    } else {
                        $distributeTime = $existData['distributeTime'] + 30 * 86400;
                    }
                    $boor = $this->updateAll(['type' => 2], ['id' => $existData['id'], 'type' => 1]);
                    if ($boor) {
                        //赠送分润余额 
                        $model = new AccountInfo();
                        $boor = $model->addAccountGold($uid, $existData['generateProfit'], 1);
                        if ($boor) {//资产变化
                            $this->updateAll(['type' => 1, 'distributeTime' => $distributeTime], ['id' => $existData['id']]);
                            $AssetChanges = new AssetChanges();
                            $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 29, $existData['generateProfit']);

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
                    $this->addError('mesg', ['211', '暂未到下次领取时间']);
                    return false;
                }
            } else {
                $this->addError('mesg', ['211', '暂无可领取奖励']);
                return false;
            }
        } else {
            $this->addError('mesg', ['211', '暂未到领取时间']);
            return false;
        }
    }

    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientInvestRebateAccountMessage($uid) {
        $rediskey = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
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
    public function getInvestRebateAccountList($page = 1, $limit = 10, $fields = [], $uid) {
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
