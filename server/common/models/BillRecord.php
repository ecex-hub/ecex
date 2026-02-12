<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  银行卡绑定信息
 */
class BillRecord extends BaseModel
{

    protected $table = 't_bill_record';

    public static function tableName()
    {
        return '{{t_bill_record}}';
    }

    //1余额, 2 回报钱包, 3补助钱包, 4圆梦基金
    const MoneyTypeOne = 1;
    const MoneyTypeTwo = 2;
    const MoneyTypeThree = 3;
    const MoneyTypeFour = 4;


//    充值钱包	充值获得	-	充值后展示，+
    const BillTypeBuyRecharge = 1;
//    充值钱包	购买产品	-	购买产品消耗，-
    const BillTypeBuyProduct = 2;
//    充值钱包	回报钱包转换	-	回报钱包转入，+
    const BillTypePayBackConvert = 3;//回报钱包转出
//    回报钱包	转换到充值钱包	-	转出到充值钱包，-
    const BillTypePayBackMoney = 4;//金额转入
//    回报钱包	产品收益	每日1.3%等等	每日产生的收益，+
    const BillTypeProductIncome = 5;//金额转入
//    回报钱包	提现
    const BillTypWithdrawal = 6;//金额转入

//    回报钱包	累计签到	每次3-8元随机	累计签到奖励获得，+
    const BillTypeSign = 7;//这个是后台操作
//    回报钱包	邀请返利	-	下级购买产品返利，+
    const BillTypeInvitePayBack = 8;//金额转入
//    回报钱包	邀请认购补贴	-	邀请认购人数奖励，+
    const BillTypeInviteCountPayBack = 9;//金额转入
//    回报钱包	邀请好友	每个2元	邀请成功1人，+
    const BillTypeInvite = 10;//金额转入
//    回报钱包	绑定社交账号	2元	绑定社交账号，+
    const BillTypeBindSocial = 11;//金额转入
//    补助钱包	产品到期补助	-	持有产品到期，+
    const BillTypeProductEnd = 12;//金额转入
//    补助钱包	产品购买补助	2000一次性	购买产品第二天获得，+
    const BillTypeProductTwoDay = 13;//金额转入
//    圆梦基金	注册	20000	自己注册并且实名认证的奖励，+
    const BillTypeRegister = 14;//金额转入
//    圆梦基金	邀请奖励	每个10000	邀请的人完成实名认证，+
    const BillTypeInviteAuth = 15;//金额转入
    //补助钱包 每个月产生1.5%的分红到补助钱包
    const BillTypeFundMonth = 16;
    //提现返还
    const BillTypeFundWithdrawal = 17;
    const BillTypeSys = 18;
    const BillTypeRedPacket = 19;
    //购买产品每月补助
    const BillTypeBuyProductAllowance = 20;

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['money', 'number'], //金额
            ['money_type', 'number'], //1余额, 2 回报钱包, 3补助钱包, 4圆梦基金
            ['bill_unit', 'string'], //类型 sub-扣钱 add-价钱
            ['bill_type', 'number'], //类型 1-购买产品
            ['ext_id', 'number'], //扩张ID
            ['ext_content', 'string'], //扩张ID
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public function getList($uid, $page, $size)
    {
        $where = [
            'and',
            ['=', 'uid', $uid],
        ];
        $list = $this->listFind(['page' => $page, 'row' => $size])
            ->where($where)
            ->orderBy("id desc")
            ->asArray()
            ->all();
        $billTypeArr = [
            1 => "充值",
            2 => "认购补助",
            3 => '回报钱包转出',
            4 => "转入充值钱包",
            5 => '产品每日收益',
            6 => "提现",
            7 => "用户打卡",
            8 => "下级用户认购返利",
            9 => "每日购买成员数",
            10 => '邀请好友成功',
            11 => '绑定社交账号',
            12 => '产品到期补助',
            13 => "内需补助金",
            14 => '完成实名认证',
            15 => '邀请用户完成实名认证',
            16 => '每月分红',
            17 => '提现驳回',
            18 => '系统操作',
            19 => '领取红包',
            20 => '每月补助',
        ];
        foreach ($list as &$item) {
            $item['create_time'] = date("Y-m-d H:i:s", $item['itime']);
            $item['bill_name'] = $billTypeArr[$item['bill_type']] ?? "";
            if ($item['bill_type'] == 18) {
                $item['bill_name'] = $item['ext_content'];
            }
        }
        $count = $this->find()
            ->where($where)
            ->count();
        $data = [
            'list' => $list,
            'count' => $count,
        ];
        return $data;
    }
}