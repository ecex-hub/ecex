<?php

namespace app\admin\model;

use think\Model;


class Bill extends Model
{


    // 表名
    protected $name = 'bill_record';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = false;

    // 定义时间戳字段名
    protected $createTime = false;
    protected $updateTime = false;
    protected $deleteTime = false;

    // 追加属性
    protected $append = [
        'itime_text',
        'utime_text'
    ];

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
    const BillTypeWithdrawal = 17;

    const BillTypeSys = 18;


    public function getItimeTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['itime']) ? $data['itime'] : '');
        return is_numeric($value) ? date("Y-m-d H:i:s", $value) : $value;
    }


    public function getUtimeTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['utime']) ? $data['utime'] : '');
        return is_numeric($value) ? date("Y-m-d H:i:s", $value) : $value;
    }

    protected function setItimeAttr($value)
    {
        return $value === '' ? null : ($value && !is_numeric($value) ? strtotime($value) : $value);
    }

    protected function setUtimeAttr($value)
    {
        return $value === '' ? null : ($value && !is_numeric($value) ? strtotime($value) : $value);
    }


    public function user()
    {
        return $this->belongsTo(
            'app\admin\model\Account', 'uid', 'uid', [], 'LEFT')
            ->field('uid,nickname,oneLevel')
            ->setEagerlyType(1);
    }
    public function admin()
    {
        return $this->belongsTo(
            'app\admin\model\Admin', 'ext_id', 'id', [], 'LEFT')
            ->field('id,nickname')
            ->setEagerlyType(0);
    }
}
