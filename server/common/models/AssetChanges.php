<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  资产变化
 */
class AssetChanges extends BaseModel {

    protected $table = 't_asset_changes';

    public static function tableName() {
        return '{{t_asset_changes}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['moneyType', 'number'], //资产类型 。1余额 。 2备付金 。3金砖币
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

    // 资产变化类型
    const ASSET_TYPE_1 = 1; // 增加
    const ASSET_TYPE_2 = 2; // 扣除
    // 货币类型
    const MONEY_TYPE_1 = 1; // 余额
    const MONEY_TYPE_2 = 2; // 备付金
    const MONEY_TYPE_3 = 3; // 金砖币
    const MONEY_TYPE_4 = 4; // 分红股
    const MONEY_TYPE_5 = 5; // 原始股

    public $changeType = [
        1 => '充值',
        2 => '提现',
        3 => '邀请返佣',
        4 => "vip返佣",
        5 => '投资项目',
        6 => '项目释放结算',
        7 => '提现退回加手续费',
        8 => '管理员添加',
        9 => '余额转备付金',
        10 => '备付金转入',
        11 => '分红股分红',
        12 => '原始股买入扣除',
        13 => '原始股卖出增加',
        14 => '备付金投资',
        15 => '国家垫资撤资',
        16 => '投资赠送金砖币',
        17 => '备付金转帐',
        18 => '金砖币买入',
        19 => '金砖币卖出',
        20 => '限时福利手动释放',
        21 => '限时福利自动释放',
        22 => '备付金购买福利',
        23 => '购买福利赠送金砖币',
        24 => '提现扣除手续费',
        25 => '管理员扣除',
        26 => '金砖币回购扣除',
        27 => '金砖币回购余额增加',
        28 => '投资返利',
        29 => '外贸分润池分红',
        30 => '投资返利下级贡献',
        31 => '释放经费',
        32 => '领取津贴',
        33 => '投资亿万补贴',
    ];
    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addAssetChangesData($uid, $moneyType, $assetType, $changeType, $money, $remarks = null) {

        //获取用户金币信息
        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (!empty($AccountInfoData)) {
            $endMoney = 0;
            if ($moneyType == 1) {
                $endMoney = $AccountInfoData['money'];
            } else if ($moneyType == 2) {
                $endMoney = $AccountInfoData['standbyPay'];
            } else if ($moneyType == 3) {
                $endMoney = $AccountInfoData['goldBrick'];
            } else if ($moneyType == 4) {
                $endMoney = $AccountInfoData['bonusShare'];
            } else if ($moneyType == 5) {
                $endMoney = $AccountInfoData['initialShare'];
            }
            $startMoney = 0;
            if ($assetType == 1) {
                $startMoney = $endMoney - $money;
            } if ($assetType == 2) {
                $startMoney = $endMoney + $money;
                $money = -1 * $money;
            }

            $data = [
                'uid' => $uid, //用户id
                'moneyType' => $moneyType, //资产类型 。1余额 。 2备付金 。3金砖币
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
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getAssetChangesList($page = 1, $limit = 10, $fields = [], $uid = null, $moneyType = null, $changeType = null, $start_time = null, $end_time = null) {
        $where = [
            'and'
        ];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }
        if (!empty($moneyType)) {
            $where[] = ['=', 'moneyType', $moneyType];
        }
        if (!empty($changeType)) {
            $where[] = ['=', 'changeType', $changeType];
        }
        if (!empty($start_time)) {
            $where[] = ['>', 'start_time', $start_time];
        }
        if (!empty($end_time)) {
            $where[] = ['<', 'end_time', $end_time];
        }
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-id'])->where($where)->all();
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
    public function getClientAssetChangesList($page = 1, $limit = 10, $fields = [], $uid) {

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

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientAssetChangesMoneyRecordList($page = 1, $limit = 10, $fields = [], $uid, $assetType) {

        $rediskey = __METHOD__ . $page . $limit . $uid . $assetType;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'moneyType', 1]
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

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientAssetChangesMoneyInvestRebateAccount($page = 1, $limit = 10, $fields = [], $uid,$changeType=29) {

        $rediskey = __METHOD__ . $page . $limit . $uid;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'changeType', $changeType]
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
