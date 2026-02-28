<?php

namespace app\common;

/**
 * 通用常量定义类
 * 存放项目中多个地方都需要使用的常量
 */
class Constants
{
    // ==================== 金额类型常量 ====================
    /** 充值余额 */
    const MONEY_TYPE_RECHARGE = 1;
    
    /** 回报钱包 */
    const MONEY_TYPE_PAYBACK = 2;
    
    /** 补助钱包 */
    const MONEY_TYPE_ALLOWANCE = 3;
    
    /** 国众基金 */
    const MONEY_TYPE_FUND = 4;
    
    /** 金额类型映射数组 */
    const MONEY_TYPE_MAP = [
        self::MONEY_TYPE_RECHARGE => '充值余额',
        self::MONEY_TYPE_PAYBACK => '回报钱包',
        self::MONEY_TYPE_ALLOWANCE => '补助钱包',
        self::MONEY_TYPE_FUND => '国众基金'
    ];
    
    // ==================== 账单单位常量 ====================
    /** 扣减 */
    const BILL_UNIT_SUB = 'sub';
    
    /** 添加 */
    const BILL_UNIT_ADD = 'add';
    
    /** 账单单位映射数组 */
    const BILL_UNIT_MAP = [
        self::BILL_UNIT_SUB => '扣减',
        self::BILL_UNIT_ADD => '添加'
    ];
    
    // ==================== 账单类型常量 ====================
    /** 充值 */
    const BILL_TYPE_RECHARGE = 1;
    
    /** 购买产品 */
    const BILL_TYPE_BUY_PRODUCT = 2;
    
    /** 回报钱包转出 */
    const BILL_TYPE_PAYBACK_CONVERT = 3;
    
    /** 转入充值钱包 */
    const BILL_TYPE_TRANSFER_RECHARGE = 4;
    
    /** 产品每日收益 */
    const BILL_TYPE_PRODUCT_INCOME = 5;
    
    /** 提现 */
    const BILL_TYPE_WITHDRAWAL = 6;
    
    /** 用户打卡 */
    const BILL_TYPE_SIGN = 7;
    
    /** 下级用户购买产品返利 */
    const BILL_TYPE_INVITE_PAYBACK = 8;
    
    /** 每日购买成员数 */
    const BILL_TYPE_INVITE_COUNT_PAYBACK = 9;
    
    /** 邀请好友成功 */
    const BILL_TYPE_INVITE = 10;
    
    /** 绑定社交账号 */
    const BILL_TYPE_BIND_SOCIAL = 11;
    
    /** 产品到期补助 */
    const BILL_TYPE_PRODUCT_END = 12;
    
    /** 内需补助金 */
    const BILL_TYPE_PRODUCT_TWO_DAY = 13;
    
    /** 完成实名认证 */
    const BILL_TYPE_REGISTER = 14;
    
    /** 邀请用户完成实名认证 */
    const BILL_TYPE_INVITE_AUTH = 15;
    
    /** 每月分红 */
    const BILL_TYPE_FUND_MONTH = 16;
    
    /** 提现驳回 */
    const BILL_TYPE_FUND_WITHDRAWAL = 17;
    
    /** 系统操作 */
    const BILL_TYPE_SYS = 18;
    
    /** 领取红包 */
    const BILL_TYPE_RED_PACKET = 19;
    
    /** 每月补助 */
    const BILL_TYPE_BUY_PRODUCT_ALLOWANCE = 20;
    
    /** 账单类型映射数组 */
    const BILL_TYPE_MAP = [
        self::BILL_TYPE_RECHARGE => "充值",
        self::BILL_TYPE_BUY_PRODUCT => "购买产品",
        self::BILL_TYPE_PAYBACK_CONVERT => '回报钱包转出',
        self::BILL_TYPE_TRANSFER_RECHARGE => "转入充值钱包",
        self::BILL_TYPE_PRODUCT_INCOME => '产品每日收益',
        self::BILL_TYPE_WITHDRAWAL => "提现",
        self::BILL_TYPE_SIGN => "用户打卡",
        self::BILL_TYPE_INVITE_PAYBACK => "下级用户购买产品返利",
        self::BILL_TYPE_INVITE_COUNT_PAYBACK => "每日购买成员数",
        self::BILL_TYPE_INVITE => '邀请好友成功',
        self::BILL_TYPE_BIND_SOCIAL => '绑定社交账号',
        self::BILL_TYPE_PRODUCT_END => '产品到期补助',
        self::BILL_TYPE_PRODUCT_TWO_DAY => "内需补助金",
        self::BILL_TYPE_REGISTER => '完成实名认证',
        self::BILL_TYPE_INVITE_AUTH => '邀请用户完成实名认证',
        self::BILL_TYPE_FUND_MONTH => '每月分红',
        self::BILL_TYPE_FUND_WITHDRAWAL => '提现驳回',
        self::BILL_TYPE_SYS => '系统操作',
        self::BILL_TYPE_RED_PACKET => '领取红包',
        self::BILL_TYPE_BUY_PRODUCT_ALLOWANCE => "每月补助"
    ];
}