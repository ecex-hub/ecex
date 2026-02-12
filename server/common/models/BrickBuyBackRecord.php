<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  金砖币回收记录
 */
class BrickBuyBackRecord extends BaseModel {

    protected $table = 't_brick_buy_back_record';

    public static function tableName() {
        return '{{t_brick_buy_back_record}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //uid
            ['title', 'string'], //标题
            ['projectID', 'number'], //回收项目id
            ['buyBackNumber', 'number'], //回收数量
            ['projectPrice', 'number'], //项目单价
            ['proportion', 'number'], //回收加成比例
            ['proportionMoney', 'number'], //加成价格
            ['goldBrick', 'number'], //金砖币余额
            ['money', 'number'], //总价格
            ['orderId', 'string'], //订单id
            ['type', 'number'], //状态  1为申请中   2为完成  3金砖币扣除失败 。4 余额增加失败
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    //vip等级对应
    public static $vipGradeProportion = [
        3 => 3,
        4 => 4,
        5 => 5,
        6 => 6,
        7 => 7,
        8 => 8,
        9 => 10,
        10 => 12,
        11 => 15,
        12 => 10];
    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addBrickBuyBackRecord($uid, $projectID) {

        $accountData = AccountInfo::getAccountDataMessage($uid);
        if (empty($accountData)) {
            $this->addError('mesg', ['212', '用户信息异常']);
            return false;
        }

//        $vipGradeProportion = self::$vipGradeProportion;
//        $proportion = 0; //加成比例
//        if (!empty($vipGradeProportion[$accountData['vipGrade']])) {
//            $proportion = $vipGradeProportion[$accountData['vipGrade']];
//        }
        //
        $projectIDData = BrickBuyBackProject::getBrickBuyBackProjectDataMessage($projectID);
        if (empty($projectIDData)) {
            $this->addError('mesg', ['212', '回购项目异常']);
            return false;
        }

        if ($projectIDData['type'] <> 1) {
            $this->addError('mesg', ['212', '回购项目已经关闭']);
            return false;
        }

        if (time() < $projectIDData['startTime'] || time() > $projectIDData['endTime']) {
            $this->addError('mesg', ['212', '回购项目已经过期']);
            return false;
        }

        $existData = $this->find()->where(['uid' => $uid, 'projectID' => $projectIDData['id']])->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '已经回购了']);
            return false;
        }
        $vipGrade = $accountData['vipGrade'];
        if ($vipGrade > 2) {
            $vipGrade = $vipGrade - 2;
        } else {
            $this->addError('mesg', ['212', '暂无回购权限']);
            return false;
        }
        if (!empty($projectIDData['vipProportion' . $vipGrade])) {
            $proportion = $projectIDData['vipProportion' . $vipGrade];
        } else {
            $proportion = 0;
        }

        //$proportion

        $buyBackNumber = $accountData['goldBrick'] * ($proportion / 100);
        $buyBackNumber = intval($buyBackNumber);
        if ($buyBackNumber <= 0) {
            $this->addError('mesg', ['212', 'vip等级不足，暂时无法回购']);
            return false;
        }

        $projectPrice = $projectIDData['price']; //项目单价

        $money = $buyBackNumber * $projectPrice; //总价格
        //校验金币余额
        $model = new AccountInfo();
        $boor = $model->checkAccountGold($uid, $buyBackNumber, $type = 3);
        if (!$boor) {
            $this->addError('mesg', ['212', '金砖币余额不足']);
            return false;
        }
        $orderId = time() . $this->createRand(10) . '';
        $data = [
            'uid' => $uid, //uid
            'title' => $projectIDData['title'], //标题
            'projectID' => $projectIDData['id'], //回收项目id
            'buyBackNumber' => $buyBackNumber, //回收数量
            'projectPrice' => $projectPrice, //项目单价
            'proportion' => $proportion, //回收加成比例
            'proportionMoney' => 0, //加成价格
            'money' => $money, //总价格
            'goldBrick' => $accountData['goldBrick'],
            'orderId' => $orderId,
            'type' => 1, //状态  1为申请中   2为完成  3失败
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                //扣钱
                $model = new AccountInfo();
                $boor = $model->deductAccountGold($uid, $buyBackNumber, $type = 3);
                if ($boor) {
                    //资产变化
                    $AssetChanges = new AssetChanges();
                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_3, AssetChanges::ASSET_TYPE_2, $changeType = 26, $buyBackNumber);
                    //金砖币记录
                    $model = new GoldBrickRecord();
                    $model->addGoldBrickRecord($uid, GoldBrickRecord::ASSET_TYPE_2, $changeType = 5, $buyBackNumber);
                    //加余额
                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($uid, $money, $type = 1);
                    if ($boor) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 27, $money);
                        $this->updateAll(['type' => 2], ['orderId' => $orderId, 'type' => 1]);
                        return true;
                    } else {
                        $this->updateAll(['type' => 4], ['orderId' => $orderId, 'type' => 1]);
                        $this->addError('mesg', ['212', '余额增加失败']);
                        return false;
                    }
                } else {
                    $this->updateAll(['type' => 3], ['orderId' => $orderId, 'type' => 1]);
                    $this->addError('mesg', ['212', '金砖币扣除失败']);
                    return false;
                }
            } else {
                $this->addError('mesg', ['212', '添加失败']);
                return false;
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getBrickBuyBackRecordList($page = 1, $limit = 10, $fields = [], $uid, $type) {
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
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientBrickBuyBackRecordList($page = 1, $limit = 10, $fields = [], $uid) {

        $rediskey = __METHOD__ . $page . $limit . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'uid', $uid]
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
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientBrickBuyBackRecordMessage($id, $fields = []) {
        $rediskey = __METHOD__ . $id;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'type', 1],
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
     * 获取用户指定项目购买记录
     * @param type $uid
     * @param type $idList
     * @return type
     */
    public function getClientBrickBuyBackRecordMessageExistData($uid, $idList) {
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['in', 'projectID', $idList],
            ['>', 'type', 1]
        ];
        $data = $this->find()->where($where)->asArray()->all();
        $existData = [];
        foreach ($data as $key => $value) {
            $existData[$value['projectID']] = $value;
        }
        return $existData;
    }

}
