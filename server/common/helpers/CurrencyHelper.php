<?php

/**
 * x消息发送.
 *
 */

namespace common\helpers;

use Yii;

/**
 * Currency Helper
 */
class CurrencyHelper extends BaseHelper {

    // 货币类型
    const CURRENCY_TYPE_1 = 1; //
    const CURRENCY_TYPE_3 = 3; // 游戏币
    // 货币变化来源类型
    const CURRENCY_FORM_TYPE_1 = 1; // 充值.
    const CURRENCY_FORM_TYPE_2 = 2; // GM
    const CURRENCY_FORM_TYPE_3 = 3; // 兑换扣除
    const CURRENCY_FORM_TYPE_4 = 4; // 兑换退回
    const CURRENCY_FORM_TYPE_5 = 5; // 充值按钮赠送.
    const CURRENCY_FORM_TYPE_6 = 6; // 开元.
    // 资产变化类型
    const CHANGE_TYPE_1 = 1; // 增加
    const CHANGE_TYPE_2 = 2; // 扣除

    public static $currency_type = [self::CURRENCY_TYPE_1 => '金币', self::CURRENCY_TYPE_3 => '游戏币'];
    /**
     * construct.
     *
     * @return void.
     */
    public function __construct() {
        
    }

}
