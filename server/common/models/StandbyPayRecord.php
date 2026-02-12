<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  新闻
 */
class StandbyPayRecord extends BaseModel {

    protected $table = 't_standby_pay_record';

    public static function tableName() {
        return '{{t_standby_pay_record}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['assetType', 'number'], //变化类型 。1增加 。2减少
            ['changeType', 'number'], //变化原因 。1充值 2提现。。。
            ['money', 'number'], //变化金额 string
            ['startMoney', 'number'], //开始金额
            ['endMoney', 'number'], //结束金额
            ['remarks', 'string'], //备注
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    // 资产变化类型
    const ASSET_TYPE_1 = 1; // 增加
    const ASSET_TYPE_2 = 2; // 扣除

    public $changeType = [
        1 => '余额充值',
        2 => '转帐收入',
        3 => '转帐支出',
        4 => "项目投资支出",
        5 => "管理增加",
        6 => '备付金购买福利',
        7 => '管理扣除',
        8 => '银行卡转账充值',
        9 => '三方充值'
    ];

    public function addStandbyPayRecord($uid, $assetType, $changeType, $money, $remarks = null) {

        //获取用户金币信息
        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (!empty($AccountInfoData)) {
            $endMoney = $AccountInfoData['standbyPay'];
            $startMoney = 0;
            if ($assetType == 1) {
                $startMoney = $endMoney - $money;
            } if ($assetType == 2) {
                $startMoney = $endMoney + $money;
                $money = -1 * $money;
            }

            $data = [
                'uid' => $uid, //用户id
                'assetType' => $assetType, //变化类型 。1增加 。2减少
                'changeType' => $changeType, //变化原因 。1充值 2提现。。。
                'money' => $money, //变化金额 string
                'startMoney' => $startMoney, //开始金额
                'endMoney' => $endMoney, //结束金额
                'remarks' => $remarks,
                'type' => 1, //状态  1为成功可使用   2为已使用
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
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
        } else {
            $this->addError('mesg', ['212', '用户信息异常']);
            return false;
        }
    }

    /**
     * 获取新闻列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientStandbyPayRecordList($page = 1, $limit = 10, $fields = [], $uid, $assetType) {

        $rediskey = __METHOD__ . $page . $limit . $uid . $assetType;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        //Yii::$app->redis->del('var1')

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'uid', $uid]
        ];

        if (!empty($assetType)) {
            $where[] = ['=', 'assetType', $assetType];
        }
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
