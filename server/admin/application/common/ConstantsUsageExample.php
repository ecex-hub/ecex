<?php

namespace app\common;

/**
 * Constants类使用示例
 * 展示如何在不同场景中使用常量
 */
class ConstantsUsageExample
{
    /**
     * 在控制器中使用常量示例
     */
    public function controllerExample()
    {
        // 获取账单类型名称
        $billTypeName = Constants::BILL_TYPE_MAP[Constants::BILL_TYPE_RECHARGE];
        
        // 获取金额类型名称
        $moneyTypeName = Constants::MONEY_TYPE_MAP[Constants::MONEY_TYPE_PAYBACK];
        
        // 获取账单单位名称
        $unitName = Constants::BILL_UNIT_MAP[Constants::BILL_UNIT_ADD];
        
        return [
            'bill_type' => $billTypeName,
            'money_type' => $moneyTypeName,
            'unit' => $unitName
        ];
    }
    
    /**
     * 在模型中使用常量示例
     */
    public function modelExample($billData)
    {
        // 验证账单类型是否有效
        if (!isset(Constants::BILL_TYPE_MAP[$billData['bill_type']])) {
            throw new \Exception('无效的账单类型');
        }
        
        // 验证金额类型是否有效
        if (!isset(Constants::MONEY_TYPE_MAP[$billData['money_type']])) {
            throw new \Exception('无效的金额类型');
        }
        
        return [
            'bill_type_name' => Constants::BILL_TYPE_MAP[$billData['bill_type']],
            'money_type_name' => Constants::MONEY_TYPE_MAP[$billData['money_type']],
            'is_valid' => true
        ];
    }
    
    /**
     * 在条件查询中使用常量示例
     */
    public function queryExample()
    {
        // 查询充值相关的账单
        $rechargeBills = Db::name('bill')
            ->where('bill_type', Constants::BILL_TYPE_RECHARGE)
            ->where('money_type', Constants::MONEY_TYPE_RECHARGE)
            ->select();
            
        // 查询回报钱包的所有操作
        $paybackBills = Db::name('bill')
            ->where('money_type', Constants::MONEY_TYPE_PAYBACK)
            ->select();
            
        return [
            'recharge_bills' => $rechargeBills,
            'payback_bills' => $paybackBills
        ];
    }
    
    /**
     * 获取所有选项列表示例
     */
    public function getOptionsExample()
    {
        return [
            'bill_types' => Constants::BILL_TYPE_MAP,
            'money_types' => Constants::MONEY_TYPE_MAP,
            'bill_units' => Constants::BILL_UNIT_MAP
        ];
    }
    
    /**
     * 在验证中使用常量示例
     */
    public function validationExample($input)
    {
        $errors = [];
        
        // 验证账单类型
        if (!array_key_exists($input['bill_type'], Constants::BILL_TYPE_MAP)) {
            $errors[] = '账单类型无效';
        }
        
        // 验证金额类型
        if (!array_key_exists($input['money_type'], Constants::MONEY_TYPE_MAP)) {
            $errors[] = '金额类型无效';
        }
        
        // 验证账单单位
        if (!array_key_exists($input['bill_unit'], Constants::BILL_UNIT_MAP)) {
            $errors[] = '账单单位无效';
        }
        
        return [
            'is_valid' => empty($errors),
            'errors' => $errors
        ];
    }
}