<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  国家垫资信息
 */
class CountryAdvanceMoney extends BaseModel {

    protected $table = 't_country_advance_money';

    public static function tableName() {
        return '{{t_country_advance_money}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['machineId', 'number'], //投资金额id
            ['investMoney', 'number'], //投资金额
            ['countryAllPrice', 'number'], //国家垫资总额
            ['countryPrice', 'number'], //剩余国家垫资金额
            ['revertCountryPrice', 'number'], //已经归还国家垫资
            ['quarterBonusMoney', 'number'], //季度分红总额 。 撤资返回投资金额 。 加季度分红总额
            ['bonusTimes', 'number'], //项目分红次数 。4 3 2 1
            ['isDivestment', 'number'], //是否撤资 。1未撤资 。2可以撤资  3申请撤资,待审核 。4平台审核  5财政部审核  6税务部审核  7财政部拨款  8打款   9已完成  10取消  11处理中  12 失败
            ['divestmentTime', 'number'], //撤资时间
            ['divestmentTypeTime3', 'number'], //撤资时间3
            ['divestmentTypeTime4', 'number'], //撤资时间3
            ['divestmentTypeTime5', 'number'], //撤资时间3
            ['divestmentTypeTime6', 'number'], //撤资时间3
            ['divestmentTypeTime7', 'number'], //撤资时间3
            ['divestmentTypeTime8', 'number'], //撤资时间3
            ['divestmentTypeTime9', 'number'], //撤资时间3
            ['createTime', 'number'], //买入时间
            ['itime', 'number'], //
            ['utime', 'number'], //
            ////
            ['realName', 'string'], //姓名
            ['bankName', 'string'], //银行名字
            ['bankCard', 'string'], //银行卡号
            ['subBranchName', 'string'], //支行名字
            ['orderId', 'string'], //订单号
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 获取客服端信息
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientCountryAdvanceMoneyMessage($uid) {

        $rediskey = __METHOD__ . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'uid', $uid]
        ];

        $data = $this->find()->select('sum(investMoney) as investMoney,sum(countryAllPrice) as countryAllPrice,sum(countryPrice) as countryPrice,sum(revertCountryPrice) as revertCountryPrice,sum(investMoney+quarterBonusMoney) as quarterBonusMoney')
                        ->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 
     * @param type $uid
     * @param type $machineId       投资id
     * @param type $bonusTimes      用户分红季度
     * @return boolean
     */
    public function addCountryAdvanceMoney($uid, $machineId, $bonusTimes, $createTime) {
        $model = new CountryAdvanceMachine();
        $machineData = $model->getClientCountryAdvanceMachine($machineId);

        $data = [
            'uid' => $uid, //用户id
            'machineId' => $machineId, //投资金额id
            'investMoney' => $machineData['userPrice'], //投资金额
            'countryAllPrice' => $machineData['countryPrice'], //国家垫资总额
            'countryPrice' => $machineData['countryPrice'], //剩余国家垫资金额
            'revertCountryPrice' => 0, //已经归还国家垫资
            'quarterBonusMoney' => 0, //季度分红总额 。 撤资返回投资金额 。 加季度分红总额
            'bonusTimes' => 4, //项目分红次数 。4 3 2 1
            'isDivestment' => 1, //是否撤资 。1未撤资 。2可以撤资  3申请撤资 。4已经撤资 。
            'createTime' => strtotime($createTime), //买入时间
            'itime' => strtotime($createTime),
            'utime' => strtotime($createTime),
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
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
     * 获取单条详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientCountryAdvanceMoneyOneMessage($id, $uid, $fields = []) {
        $rediskey = __METHOD__ . $id . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            // return $redisData;
        }
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'id', $id]
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
     * 撤资
     * @param type $uid
     * @param type $id
     */
    public function accountDivestment($uid, $id, $realName, $bankName, $bankCard, $subBranchName) {


        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'id', $id],
            ['=', 'isDivestment', 2]
        ];
        $data = $this->find()->where($where)->asArray()->one();
        if (!empty($data)) {
            $update = [
                'isDivestment' => 3,
                'realName' => $realName,
                'bankName' => $bankName,
                'bankCard' => $bankCard,
                'subBranchName' => $subBranchName,
                'divestmentTime' => time()
            ];
            $boor = $this->updateAll($update, $where);
            if ($boor) {
                return true;
            } else {
                $this->addError('mesg', ['211', '暂时无法撤资']);
                return false;
            }
        } else {
            $this->addError('mesg', ['211', '暂时无法撤资']);
            return false;
        }
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getCountryAdvanceMoneyList($page = 1, $limit = 10, $fields = [], $isDivestment, $uid) {
        $where = [
            'and'
        ];
        if (!empty($isDivestment))
            $where[] = ['=', 'isDivestment', $isDivestment];
        if (!empty($uid))
            $where[] = ['=', 'uid', $uid];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

    public function AdminExamineData($id, $type) {
        if (in_array($type, [4, 5, 6, 7, 8, 9])) {//确认 。4平台审核  5财政部审核  6税务部审核  7财政部拨款  8打款   9
            if ($type <> 9) {
                $where = [
                    'and',
                    ['=', 'id', $id],
                    ['in', 'isDivestment', [3, 4, 5, 6, 7, 8]]
                ];
                $boor = $this->updateAll(['isDivestment' => $type, 'divestmentTypeTime' . $type => time(), 'utime' => time()], $where); //锁定
                if (!empty($boor)) {
                    return true;
                } else {
                    $this->addError('mesg', ['211', '修改失败']);
                    return false;
                }
            } else {//打钱
                $where = [
                    'and',
                    ['=', 'id', $id],
                    ['in', 'isDivestment', [3, 4, 5, 6, 7, 8]]
                ];
                $boor = $this->updateAll(['isDivestment' => 11, 'divestmentTypeTime' . $type => time(), 'utime' => time()], $where); //锁定
                if ($boor) {
                    $existData = $this->find()->where(['id' => $id])->asArray()->one();
                    if (!empty($existData)) {
                        $money = $existData['investMoney'] + $existData['quarterBonusMoney'];
                        $ip = '127.0.0.1';
                        $model = new WithdrawalOrder();
                        $orderId = $model->addWithdrawalOrderDataCountryMoney($existData['uid'], $money, $existData['realName'], $existData['bankName'],
                                $existData['bankCard'], $existData['subBranchName'], 1, $ip);
                        if ($orderId) {
                            $boor = $this->updateAll(['orderId' => $orderId], ['id' => $id]);
                            return $boor;
                        }
                    }
                    $boor = $this->updateAll(['type' => 8], ['id' => $id]); //回退状态
                    $this->addError('mesg', ['211', '代付拉取失败，回退状态']);
                    return false;
                } else {
                    $this->addError('mesg', ['211', '状态异常，无法代付打款']);
                    return false;
                }
            }

            $data = $this->find()->where($where)->asArray()->one();
            if ($data) {
                $boor = $this->updateAll(['isDivestment' => 6, 'utime' => time()], $where); //锁定
                if ($boor) {
                    //加钱
                    $uid = $data['uid'];
                    $money = $data['investMoney'] + $data['quarterBonusMoney'];
                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($uid, $money, 1);
                    if (!empty($boor)) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 15, $money);
                        $boor = $this->updateAll(['isDivestment' => 4, 'utime' => time()], ['id' => $uid, 'isDivestment' => 6]); //锁定
                        return true;
                    } else {
                        $this->addError('mesg', ['211', '余额增加失败']);
                        return false;
                    }
                }
            } else {
                $this->addError('mesg', ['211', '数据异常']);
                return false;
            }
        } else {
            $where = [
                'and',
                ['=', 'id', $id],
                ['in', 'isDivestment', [4, 5, 6, 7, 8]]
            ];
            $boor = $this->updateAll(['isDivestment' => 10], $where);
            if ($boor) {
                return true;
            } else {
                $this->addError('mesg', ['211', '取消失败']);
                return false;
            }
        }
    }

    /**
     * 回调
     * @param type $orderId
     * @param type $type
     */
    public function successOrderId($orderId, $type) {
        if ($type == 1) {
            $this->updateAll(['type' => 9], ['orderId' => $orderId, 'type' => 11]);
        } else {
            $this->updateAll(['type' => 8], ['orderId' => $orderId, 'type' => 11]);
        }
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientCountryAdvanceMoneyList($page = 1, $limit = 10, $fields = [], $uid, $type) {

        $rediskey = __METHOD__ . $page . $limit . $uid . $type;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            // return $redisData;
        }

        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        if ($type == 1) {//可以撤资
            $where[] = ['=', 'isDivestment', 2];
        } else if ($type == 2) {
            $where[] = ['<>', 'isDivestment', 2];
        } else if ($type == 3) {
            $where[] = ['>', 'isDivestment', 2];
        }

        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => 'createTime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

}
