<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  分红股提现
 */
class BonusShareRecord extends BaseModel {

    protected $table = 't_bonus_share_record';

    public static function tableName() {
        return '{{t_bonus_share_record}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['orderId', 'number'], //orderId
            ['bonusShareNumber', 'number'], //分行股数量
            ['bonusShareMoney', 'number'], //分行股金额
            ['bonusShareTax', 'number'], //分行股税收
            ['bonusShareObtain', 'number'], //分行股下发金额
            ['type', 'number'], //状态  1为申请 。2平台审核 。3财政部审核 。4税务局审核 。5财务部拨款 。6打款 。 7失败
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public $BonusShareRecordType = [
        1 => '申请中',
        2 => '平台审核',
        3 => '财政部审核',
        4 => '税务局审核',
        5 => '财务部拨款',
        6 => '打款成功',
        7 => '失败'
    ];

    /**
     * 分红股分红
     * @param type $uid
     * @param type $bonusShareNumber
     * @return boolean
     */
    public function addBonusShareRecord($uid, $bonusShareNumber) {

        if ($bonusShareNumber <= 0) {
            $this->addError('mesg', ['212', '操作数量异常']);
            return false;
        }

        $model = new AccountInfo();
        $boor = $model->checkAccountGold($uid, $bonusShareNumber, $type = 4);
        if (!$boor) {
            $this->addError('mesg', ['212', '分红股不足']);
            return false;
        }
        $bonusShareMoney = $bonusShareNumber * 3;
        $bonusShareTax = $bonusShareMoney * 0.2;
        $bonusShareObtain = $bonusShareMoney - $bonusShareTax;
        $orderId = time() . $this->createRand(9) . '';
        $data = [
            'uid' => $uid, //用户id
            'orderId' => $orderId,
            'bonusShareNumber' => $bonusShareNumber, //分行股数量
            'bonusShareMoney' => $bonusShareMoney, //分行股金额
            'bonusShareTax' => $bonusShareTax, //分行股税收
            'bonusShareObtain' => $bonusShareObtain, //分行股下发金额
            'type' => 1, //状态  1为申请 。2平台审核 。3财政部审核 。4税务局审核 。5财务部拨款 。6打款 。 7失败
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    //扣钱
                    $boor = $model->deductAccountGold($uid, $bonusShareNumber, $type = 4);
                    if (!empty($boor)) {
                        $this->updateAll(['type' => 2], ['orderId' => $orderId]);
                        return true;
                    } else {
                        $this->updateAll(['type' => 7], ['orderId' => $orderId]);
                        $this->addError('mesg', ['212', '分红股扣除失败']);
                        return false;
                    }
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
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getBonusShareList($page = 1, $limit = 10, $fields = [], $uid, $type) {
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
     * 修改数据
     * @param type $id
     * @param type $title
     * @param type $author
     * @param type $coverUrl
     * @param type $content
     * @param type $type
     * @return boolean
     */
    public function updateBonusShareData($id, $type) {
        $update = [];
        if (!empty($type)) {
            $update['type'] = $type;
        }

        if (empty($update)) {
            $this->addError('mesg', ['211', '修改数据不能为空']);
            return false;
        }
        $where = [
            'and',
            ['=', 'id', $id],
            ['in', 'type', [2, 3, 4, 5]]
        ];
        $boor = $this->updateAll($update, $where);
        if ($boor) {
            if ($type == 6) {//打钱
                $data = $this->find()->where(['id' => $id, 'type' => 6])->asArray()->one();
                if (!empty($data)) {
                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($data['uid'], $data['bonusShareObtain'], $type = 1);
                    if (!empty($boor)) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($data['uid'], AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 11, $data['bonusShareObtain']);
                    }
                    return true;
                }
                $this->addError('mesg', ['211', '打款失败，订单异常']);
                return false;
            }
            return true;
        }
        $this->addError('mesg', ['211', '修改失败']);
        return false;
    }

    /**
     * 获取客服端列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientBonusShareList($page = 1, $limit = 10, $fields = [], $uid) {

        $rediskey = __METHOD__ . $page . $limit . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['<>', 'type', 7]
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
