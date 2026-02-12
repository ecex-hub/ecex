<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\db\Expression;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  投资注入总金额
 */
class InvestInjectMoney extends BaseModel {

    protected $table = 't_invest_inject_money';

    public static function tableName() {
        return '{{t_invest_inject_money}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
//            ['id', 'number'], //标记id
//            ['uid', 'number'], //
//            ['bid', 'number'], //投资id
//            ['RechargeOrderId', 'string'], //充值订单id
//            ['buyMoney', 'number'], //购买金额
//            ['RebateProportion', 'number'], //返利比例
//            ['RebateMney', 'number'], //返利金额
//            ['rebateNo', 'number'], //单数排序
//            ['type', 'number'], //状态  1为申请 。2成功 3余额增加失败  4处理中
//            ['receiveTime', 'number'], //领取时间
//            ['itime', 'number'], //
//            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 增加 投资注入总金额
     * @param type $buyMoney
     * @return boolean
     */
    public static function AddInvestInjectMoney($buyMoney) {
        $where = [
            'and'
        ];
        $boor = self::updateAll(['money' => new Expression('money+' . $buyMoney)], $where);
        return $boor;
    }

    /**
     * 获取注入总金额
     * @return int
     */
    public static function getInvestInjectMoney() {
        $where = [
            'and'
        ];
        $existData = self::find()->where($where)->asArray()->one();
        if (!empty($existData['money'])) {
            return $existData['money'];
        } else {
            return 0;
        }
    }

    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientInvestInjectMoneyMessage() {
        $rediskey = __METHOD__;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and'
        ];
        $fields = [];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

}
