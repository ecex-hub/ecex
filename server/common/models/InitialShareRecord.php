<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  原始股买入卖出
 */
class InitialShareRecord extends BaseModel {

    protected $table = 't_initial_share_record';

    public static function tableName() {
        return '{{t_initial_share_record}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['orderId', 'number'], //orderId
            ['initialShareNumber', 'number'], //原始股数量
            ['price', 'number'], //操作时单价
            ['valueMoney', 'number'], //对应余额
            ['shareType', 'number'], //申请类型 。1买入 。2卖出
            ['type', 'number'], //状态  1为申请 。2成功 。3失败 。4异常失败
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 原始股买入
     * @param type $uid
     * @param type $bonusShareNumber
     * @return boolean
     */
    public function purchaseInitialShareRecord($uid, $initialShareNumber) {
        if ($initialShareNumber <= 0) {
            $this->addError('mesg', ['212', '操作数量异常']);
            return false;
        }
        //获取原始股单价
        $initial_share_price = SystemConfigure::getSystemConfigure('initial_share_price');
        if (empty($initial_share_price)) {
            $this->addError('mesg', ['212', '原始股操作尚未启动，请稍后']);
            return false;
        }
        $money = $initialShareNumber * $initial_share_price;
        $model = new AccountInfo();
        $boor = $model->checkAccountGold($uid, $money, $type = 1);
        if (!$boor) {
            $this->addError('mesg', ['212', '余额不足']);
            return false;
        }

        $orderId = time() . $this->createRand(9) . '';
        $data = [
            'uid' => $uid, //用户id
            'orderId' => $orderId,
            'initialShareNumber' => $initialShareNumber, //原始股数量
            'price' => $initial_share_price, //操作时单价
            'valueMoney' => $money, //对应余额
            'shareType' => 1, //申请类型 。1买入 。2卖出
            'type' => 1, //状态  1为申请 。2成功 。3失败  4异常失败
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                //扣钱  余额
                $boor = $model->deductAccountGold($uid, $money, $type = 1);
                if (!empty($boor)) {
                    //资产变化
                    $AssetChanges = new AssetChanges();
                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_2, $changeType = 12, $money);

                    //操作增加 原始股
                    $boor = $model->addAccountGold($uid, $initialShareNumber, $type = 5);
                    if ($boor) {
                        $this->updateAll(['type' => 2], ['orderId' => $orderId]);
                        return true;
                    } else {
                        $this->updateAll(['type' => 4], ['orderId' => $orderId]);
                        $this->addError('mesg', ['212', '买入失败，订单异常']);
                        return false;
                    }
                } else {
                    $this->updateAll(['type' => 3], ['orderId' => $orderId]);
                    $this->addError('mesg', ['212', '买入失败，余额不足']);
                    return false;
                }
            }
            $this->addError('mesg', ['212', '添加失败']);
            return false;
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 原始股卖出
     * @param type $uid
     * @param type $bonusShareNumber
     * @return boolean
     */
    public function salesInitialShareRecord($uid, $initialShareNumber) {
        if ($initialShareNumber <= 0) {
            $this->addError('mesg', ['212', '操作数量异常']);
            return false;
        }
        //获取原始股单价
        $initial_share_price = SystemConfigure::getSystemConfigure('initial_share_price');
        if (empty($initial_share_price)) {
            $this->addError('mesg', ['212', '原始股操作尚未启动，请稍后']);
            return false;
        }
        $money = $initialShareNumber * $initial_share_price;
        $model = new AccountInfo();
        $boor = $model->checkAccountGold($uid, $initialShareNumber, $type = 5);
        if (!$boor) {
            $this->addError('mesg', ['212', '原始股不足']);
            return false;
        }

        $orderId = time() . $this->createRand(9) . '';
        $data = [
            'uid' => $uid, //用户id
            'orderId' => $orderId,
            'initialShareNumber' => $initialShareNumber, //原始股数量
            'price' => $initial_share_price, //操作时单价
            'valueMoney' => $money, //对应余额
            'shareType' => 2, //申请类型 。1买入 。2卖出
            'type' => 1, //状态  1为申请 。2成功 。3失败  4异常失败
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                //扣钱 原始股
                $boor = $model->deductAccountGold($uid, $initialShareNumber, $type = 5);
                if (!empty($boor)) {

                    //操作增加 余额
                    $boor = $model->addAccountGold($uid, $money, $type = 1);
                    if ($boor) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 13, $money);

                        $this->updateAll(['type' => 2], ['orderId' => $orderId]);
                        return true;
                    } else {
                        $this->updateAll(['type' => 4], ['orderId' => $orderId]);
                        $this->addError('mesg', ['212', '卖出失败，订单异常']);
                        return false;
                    }
                } else {
                    $this->updateAll(['type' => 3], ['orderId' => $orderId]);
                    $this->addError('mesg', ['212', '卖出失败，余额不足']);
                    return false;
                }
            }
            $this->addError('mesg', ['212', '添加失败']);
            return false;
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
    public function getInitialShareList($page = 1, $limit = 10, $fields = [], $uid, $type, $shareType) {
        $where = [
            'and'
        ];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }
        if (!empty($type)) {
            $where[] = ['=', 'type', $type];
        }
        if (!empty($shareType)) {
            $where[] = ['=', 'shareType', $shareType];
        }
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

    /**
     * 获取客服端列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientInitialShareList($page = 1, $limit = 10, $fields = [], $uid) {

        $rediskey = __METHOD__ . $page . $limit . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
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

}
