<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  充值订单
 */
class RechargeOrder extends BaseModel {

    protected $table = 't_recharge_order';

    public static function tableName() {
        return '{{t_recharge_order}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['money', 'number'], //金额
            ['payMoney', 'number'], //支付金额
            ['payTime', 'number'], //支付金额
            ['payConfigNo', 'number'], //支付平台编号
            ['payName', 'string'], //付款人姓名
            ['realName', 'string'], //收款人姓名
            ['bankCard', 'string'], //收款人卡号
            ['orderId', 'string'], //订单id
            ['ProjectID', 'number'], //项目id 。
            ['IncomeLevelID', 'number'], //收益id
            ['bankPayUrl', 'string'], //银行卡转账支付凭证
            ['orderType', 'number'], //订单类型 。 1投资 。 2冲余额 。3限时福利 。4备付金充值 。 
            ['payType', 'number'], //下单类型  1三方支付 。 2银行卡转账  3备付金
            ['payConfigType', 'number'], //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            ['type', 'number'], //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6取消 。7支付金额异常 8处理中
            ['buyRemarks', 'string'], //投资失败备注
            ['payRemarks', 'string'], //支付失败备注
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 创建充值钱包三方支付订单（仅创建订单与支付链接，不直接加余额）
     * @param int    $uid           用户ID
     * @param float  $money         充值金额
     * @param int    $payConfigType 支付类型：1支付宝 2微信 3银行卡
     * @param string $ip            用户IP
     * @return array|false          成功返回 ['orderId' => string, 'url' => string, 'payNo' => int]
     */
    public function addWalletOnlineRechargeOrder($uid, $money, $payConfigType, $ip) {
        $money = (float)$money;
        if ($money <= 0) {
            $this->addError('mesg', ['212', '充值金额必须大于0']);
            return false;
        }
        if ($money < 100) {
            $this->addError('mesg', ['212', '最低充值金额为100元']);
            return false;
        }

        $accountInfo = AccountInfo::getAccountDataMessage($uid);
        if (empty($accountInfo)) {
            $this->addError('mesg', ['212', '用户信息异常']);
            return false;
        }

        // 一小时内未支付订单数量限制（订单类型：2 冲余额，三方支付）
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'type', 3],
            ['=', 'payType', 1],
            ['=', 'orderType', 2],
            ['>', 'itime', time() - 3600],
        ];
        $countData = $this->find()
            ->where($where)
            ->select('payConfigNo,count(*) as count')
            ->groupBy('payConfigNo')
            ->asArray()
            ->all();
        foreach ($countData as $value) {
            if (!empty($value['payConfigNo']) && $value['count'] >= 10) {
                $this->addError('mesg', ['212', '未支付的订单太多了，稍后再试哦']);
                return false;
            }
        }

        $orderId = time() . $this->createRand(10) . '';

        $data = [
            'uid'          => $uid,
            'money'        => $money,
            'payMoney'     => 0,
            'payTime'      => 0,
            'orderId'      => $orderId,
            'ProjectID'    => 0,
            'IncomeLevelID'=> 0,
            'orderType'    => 2, // 订单类型：2 冲余额
            'payType'      => 1, // 三方支付
            'payConfigType'=> $payConfigType,
            'type'         => 1, // 申请中
            'itime'        => time(),
            'utime'        => time(),
        ];

        $this->attributes = $data;
        if (!$this->validate()) {
            $this->addError('mesg', ['211', '数据校验失败，请检查参数']);
            return false;
        }

        $inserted = $this->addData($data);
        if (empty($inserted)) {
            $this->addError('mesg', ['212', '充值订单创建失败，请稍后重试']);
            return false;
        }

        // 获取第三方支付链接（使用充值场景 payType = 2）
        $payConfigModel = new PayConfig();
        $urlData = $payConfigModel->getPayConfigUrl($orderId, $uid, $money, $payConfigType, $ip, null, $payType = 2);
        if (!empty($urlData['url'])) {
            $updated = $this->updateAll(
                ['type' => 3, 'payConfigNo' => $urlData['payNo']],
                ['orderId' => $orderId]
            );
            if (!empty($updated)) {
                return [
                    'orderId' => $orderId,
                    'url'     => $urlData['url'],
                    'payNo'   => $urlData['payNo'],
                ];
            }

            $this->addError('mesg', ['212', '支付状态异常，请稍后重试']);
            return false;
        }

        // 获取支付链接失败，更新订单状态
        $this->updateAll(['type' => 2, 'payRemarks' => '支付链接获取失败'], ['orderId' => $orderId]);
        $this->addError('mesg', ['212', '支付链接获取失败，请稍后重试或更换金额']);
        return false;
    }

    /**
     * @inheritdoc
     */
    public function getAccountInfo() {
        return $this->hasOne(AccountInfo::className(), ['uid' => 'uid'])->select(['uid', 'oneLevel', 'twoLevel', 'threeLevel']);
    }

    /**
     * 用户三方充值投资
     * @param type $uid
     * @param type $ProjectID
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderIncomeData($uid, $ProjectID, $IncomeLevelID, $payButtonId, $ip) {//payButtonId 。$payConfigType
        $ProjectData = ProjectData::getProjectDataMessage($ProjectID);
        if (empty($ProjectData)) {
            $this->addError('mesg', ['212', '项目id为空']);
            return false;
        }

        if ($ProjectData['projectType'] == 1) {
            //$this->addError('mesg', ['212', '一级项目不能购买']);
            //return false;
        }


        $IncomeLevel = IncomeLevel::getIncomeLevelDataMessage($IncomeLevelID);

        if (empty($IncomeLevel)) {
            $this->addError('mesg', ['212', '收益级别异常']);
            return false;
        }

        if ($IncomeLevel['grade'] <> 1 || $IncomeLevel['continuousType'] <> 1) {
            $this->addError('mesg', ['212', '该收益级别只允许复投']);
            return false;
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

        if ($AccountInfoData['vipGrade'] == 1) {//
            $this->addError('mesg', ['212', '未实名用户无法投资']);
            return false;
        }
        $payConfigNo = null;
        $payButtonData = PayButton::getPayButtonMessage($payButtonId);
        if (empty($payButtonData)) {
            $this->addError('mesg', ['212', '支付按钮已经关闭，请更换支付方式']);
            return false;
        } else {
            if (in_array($payButtonData['payConfigType'], [1, 2, 3])) {
                $payConfigType = $payButtonData['payConfigType'];
                $payConfigNo = $payButtonData['payNo'];
            } else {
                $this->addError('mesg', ['212', '支付按钮异常，请更换支付方式']);
                return false;
            }
        }

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'type', 3],
            ['>', 'itime', time() - 3600]
        ];

        $countData = $this->find()->where($where)->select('payConfigNo,count(*) as count')->groupBy('payConfigNo')->asArray()->all();

        foreach ($countData as $key => $value) {
            if (!empty($value['payConfigNo'])) {
                if ($value['count'] >= 10) {
                    $this->addError('mesg', ['212', '未支付的订单太多了，稍后再试哦']);
                    return false;
                }
            }
        }
//        if ($count >= 20) {
//            $this->addError('mesg', ['212', '今日未支付订单过多']);
//            return false;
//        }

        $orderId = time() . $this->createRand(10) . '';
        $money = $IncomeLevel['investMoney'];
        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            'ProjectID' => $ProjectData['id'], //项目id 。
            'IncomeLevelID' => $IncomeLevel['id'], //收益id
            'orderType' => 1, //订单类型 。 1投资 。 2冲余额
            'payType' => 1, //下单类型  1三方支付 。 2银行卡转账  3备付金
            'payConfigType' => $payConfigType, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败 
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    //获取支付链接
                    $model = new PayConfig();
                    $urlData = $model->getPayConfigUrl($orderId, $uid, $money, $payConfigType, $ip, $payConfigNo);
                    if (!empty($urlData['url'])) {
                        $boor = $this->updateAll(['type' => 3, 'payConfigNo' => $urlData['payNo']], ['orderId' => $orderId]);
                        if (!empty($boor)) {
                            $urlData['orderId'] = $orderId;
                            return $urlData;
                        } else {
                            $this->addError('mesg', ['212', '支付状态异常，请稍后重试']);
                            return false;
                        }
                    } else {
                        $this->updateAll(['type' => 2], ['orderId' => $orderId]);
                        $this->addError('mesg', ['212', '支付链接获取失败，请稍后重试或更换金额']);
                        return false;
                    }
                } else {
                    $this->addError('mesg', ['212', '支付订单下单失败，请稍后重试']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户银行卡转账投资
     * @param type $uid
     * @param type $ProjectID
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderBankData($uid, $ProjectID, $IncomeLevelID, $bankId, $money, $payName, $ip, $bankPayUrl) {//'bankId','money','payName'
        $ProjectData = ProjectData::getProjectDataMessage($ProjectID);
        if (empty($ProjectData)) {
            $this->addError('mesg', ['212', '项目id为空']);
            return false;
        }

        if ($ProjectData['projectType'] == 1) {
            //$this->addError('mesg', ['212', '一级项目不能购买']);
            //return false;
        }


        $IncomeLevel = IncomeLevel::getIncomeLevelDataMessage($IncomeLevelID);

        if (empty($IncomeLevel)) {
            $this->addError('mesg', ['212', '收益级别异常']);
            return false;
        }

        if ($IncomeLevel['grade'] <> 1 || $IncomeLevel['continuousType'] <> 1) {
            $this->addError('mesg', ['212', '该收益级别只允许复投']);
            return false;
        }
        if ($money <> $IncomeLevel['investMoney']) {
            $this->addError('mesg', ['212', '转账金额与投资金额不符']);
            return false;
        }

        //$bankId
        $model = new BankList();
        $bankIdData = $model->getClientBankMessage($bankId);
        if (empty($bankIdData)) {
            $this->addError('mesg', ['212', '收款银行卡已经关闭，请更换银行卡转账']);
            return false;
        } else {
            $realName = $bankIdData['realName'];
            $bankCard = $bankIdData['bankCard'];
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

        if ($AccountInfoData['vipGrade'] == 1) {//
            $this->addError('mesg', ['212', '未实名用户无法投资']);
            return false;
        }


        $orderId = time() . $this->createRand(10) . '';
        $money = $IncomeLevel['investMoney'];
        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            'payName' => $payName, //付款人姓名
            'realName' => $realName, //收款人姓名
            'bankCard' => $bankCard, //收款人卡号
            'ProjectID' => $ProjectData['id'], //项目id 。
            'IncomeLevelID' => $IncomeLevel['id'], //收益id
            'bankPayUrl' => $bankPayUrl,
            'orderType' => 1, //订单类型 。 1投资 。 2冲余额
            'payType' => 2, //下单类型  1三方支付 。 2银行卡转账   3备付金
            'payConfigType' => 5, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];

        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                return true;
//                $boor = $this->updateAll(['type' => 3, 'payConfigNo' => $urlData['payNo']], ['orderId' => $orderId]);
//                if (!empty($boor)) {
//                    $urlData['orderId'] = $orderId;
//                    return $urlData;
//                } else {
//                    $this->addError('mesg', ['212', '支付状态异常，请稍后重试']);
//                    return false;
//                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户备付金投资
     * @param type $uid
     * @param type $ProjectID
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderStandbyPayData($uid, $ProjectID, $IncomeLevelID, $ip) {
        $ProjectData = ProjectData::getProjectDataMessage($ProjectID);
        if (empty($ProjectData)) {
            $this->addError('mesg', ['212', '项目id为空']);
            return false;
        }

        if ($ProjectData['projectType'] == 1) {
            //$this->addError('mesg', ['212', '一级项目不能购买']);
            //return false;
        }


        $IncomeLevel = IncomeLevel::getIncomeLevelDataMessage($IncomeLevelID);

        if (empty($IncomeLevel)) {
            $this->addError('mesg', ['212', '收益级别异常']);
            return false;
        }

        if ($IncomeLevel['grade'] <> 1 || $IncomeLevel['continuousType'] <> 1) {
            $this->addError('mesg', ['212', '该收益级别只允许复投']);
            return false;
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

        if ($AccountInfoData['vipGrade'] == 1) {//
            $this->addError('mesg', ['212', '未实名用户无法投资']);
            return false;
        }


        $orderId = time() . $this->createRand(10) . '';
        $money = $IncomeLevel['investMoney'];
        //校验金额是否充足
        $model = new AccountInfo();
        $boor = $model->checkAccountGold($uid, $money, $type = 2);
        if (!$boor) {
            $this->addError('mesg', ['212', '备付金余额不足']);
            return false;
        }
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'orderType', 1],
            ['=', 'payType', 3],
            ['>', 'itime', time() - 60]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        if (!empty($existData)) {
//            $this->addError('mesg', ['212', '操作太快了，一分钟后再试试呢']);
//            return false;
        }
        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            //'payName' => $payName, //付款人姓名
            //'realName' => $realName, //收款人姓名
            //'bankCard' => $bankCard, //收款人卡号
            'ProjectID' => $ProjectData['id'], //项目id 。
            'IncomeLevelID' => $IncomeLevel['id'], //收益id
            //'bankPayUrl' => $bankPayUrl,
            'orderType' => 1, //订单类型 。 1投资 。 2冲余额
            'payType' => 3, //下单类型  1三方支付 。 2银行卡转账   3备付金
            'payConfigType' => 4, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];

        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                //扣余额
                $boor = $model->deductAccountGold($uid, $money, $type = 2);
                if ($boor) {
                    $boor = $this->updateAll(['type' => 4, 'payTime' => time()], ['orderId' => $orderId]);
                    //资产变化
                    $AssetChanges = new AssetChanges();
                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_2, AssetChanges::ASSET_TYPE_2, $changeType = 14, $money);
                    //备付金记录
                    $model = new StandbyPayRecord();
                    $model->addStandbyPayRecord($uid, StandbyPayRecord::ASSET_TYPE_2, $changeType = 4, $money);
                    //投资
                    $model = new BuyRecord();
                    $boor = $model->addBuyRecord($data['ProjectID'], $data['orderId'], $data['IncomeLevelID'], $data['uid']);
                    if ($boor) {
                        return true;
                    } else {
                        $error_mesg = $model->getErrors('mesg');
                        $this->updateAll(['type' => 5, 'buyRemarks' => $error_mesg[0][1]], ['orderId' => $data['orderId']]);
                        $this->addError('mesg', ['211', $error_mesg[0][1]]);
                        return false;
                    }
                } else {
                    $boor = $this->updateAll(['type' => 6, 'payRemarks' => '备付金扣除失败'], ['orderId' => $orderId]);
                    $this->addError('mesg', ['212', '备付金扣除失败']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户三方充值投资 限时福利
     * @param type $uid
     * @param type $ProjectID
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderLimitedWelfareData($uid, $limitedWelfareID, $payButtonId, $ip) {//payButtonId 。$payConfigType
        $ProjectData = LimitedWelfareData::getLimitedWelfareDataMessage($limitedWelfareID);
        if (empty($ProjectData)) {
            $this->addError('mesg', ['212', '项目id为空']);
            return false;
        }

        $model = new LimitedWelfareRecord();
        $existData = $model->userExistData($uid);
        if (!empty($existData)) {
//            $this->addError('mesg', ['212', '已经购买了,无法再次购买']);
//            return false;
        }
        //
        $where = [
            'and',
            ['>', 'itime', time() - 600],
            ['=', 'uid', $uid],
            ['=', 'type', 3],
            ['=', 'payType', 1],
            ['=', 'orderType', 3],
        ];
        $count = $this->find()->where($where)->count() ?? 0;
        if ($count > 0) {
//            $this->addError('mesg', ['212', '最近有提交过支付，请处理完成再来哦']);
//            return false;
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

        if ($AccountInfoData['vipGrade'] == 1) {//
            $this->addError('mesg', ['212', '未实名用户无法投资']);
            return false;
        }
        $payConfigNo = null;
        $payButtonData = PayButton::getPayButtonMessage($payButtonId);
        if (empty($payButtonData)) {
            $this->addError('mesg', ['212', '支付按钮已经关闭，请更换支付方式']);
            return false;
        } else {
            if (in_array($payButtonData['payConfigType'], [1, 2, 3])) {
                $payConfigType = $payButtonData['payConfigType'];
                $payConfigNo = $payButtonData['payNo'];
            } else {
                $this->addError('mesg', ['212', '支付按钮异常，请更换支付方式']);
                return false;
            }
        }

        $orderId = time() . $this->createRand(10) . '';
        $money = $ProjectData['investMoney'];
        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            'ProjectID' => $ProjectData['id'], //项目id 。
            //'IncomeLevelID' => $IncomeLevel['id'], //收益id
            'orderType' => 3, //订单类型 。 1投资 。 2冲余额  3限时福利
            'payType' => 1, //下单类型  1三方支付 。 2银行卡转账  3备付金
            'payConfigType' => $payConfigType, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    //获取支付链接
                    $model = new PayConfig();
                    $urlData = $model->getPayConfigUrl($orderId, $uid, $money, $payConfigType, $ip, $payConfigNo);
                    if (!empty($urlData['url'])) {
                        $boor = $this->updateAll(['type' => 3, 'payConfigNo' => $urlData['payNo']], ['orderId' => $orderId]);
                        if (!empty($boor)) {
                            $urlData['orderId'] = $orderId;
                            return $urlData;
                        } else {
                            $this->addError('mesg', ['212', '支付状态异常，请稍后重试']);
                            return false;
                        }
                    } else {
                        $this->updateAll(['type' => 2], ['orderId' => $orderId]);
                        $this->addError('mesg', ['212', '支付链接获取失败，请稍后重试或更换金额']);
                        return false;
                    }
                } else {
                    $this->addError('mesg', ['212', '支付订单下单失败，请稍后重试']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户银行卡转账投资 限时福利
     * @param type $uid
     * @param type $ProjectIDaddRechargeOrderLimitedWelfareData
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderBankLimitedWelfareData($uid, $ProjectID, $bankId, $money, $payName, $ip, $bankPayUrl) {//'bankId','money','payName'
        $ProjectData = LimitedWelfareData::getLimitedWelfareDataMessage($ProjectID);
        if (empty($ProjectData)) {
            $this->addError('mesg', ['212', '项目id为空']);
            return false;
        }


        if ($money <> $ProjectData['investMoney']) {
            $this->addError('mesg', ['212', '转账金额与投资金额不符']);
            return false;
        }
        $model = new LimitedWelfareRecord();
        $existData = $model->userExistData($uid);
        if (!empty($existData)) {
//            $this->addError('mesg', ['212', '已经购买了,无法再次购买']);
//            return false;
        }
        //
        $where = [
            'and',
            ['>', 'itime', time() - 600],
            ['=', 'uid', $uid],
            ['=', 'type', 1],
            ['=', 'payType', 2],
            ['=', 'orderType', 3],
        ];
        $count = $this->find()->where($where)->count() ?? 0;
        if ($count > 0) {
//            $this->addError('mesg', ['212', '最近有提交过支付，请处理完成再来哦']);
//            return false;
        }



        //$bankId
        $model = new BankList();
        $bankIdData = $model->getClientBankMessage($bankId);
        if (empty($bankIdData)) {
            $this->addError('mesg', ['212', '收款银行卡已经关闭，请更换银行卡转账']);
            return false;
        } else {
            $realName = $bankIdData['realName'];
            $bankCard = $bankIdData['bankCard'];
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

        if ($AccountInfoData['vipGrade'] == 1) {//
            $this->addError('mesg', ['212', '未实名用户无法投资']);
            return false;
        }


        $orderId = time() . $this->createRand(10) . '';
        $money = $ProjectData['investMoney'];
        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            'payName' => $payName, //付款人姓名
            'realName' => $realName, //收款人姓名
            'bankCard' => $bankCard, //收款人卡号
            'ProjectID' => $ProjectData['id'], //项目id 。
            //'IncomeLevelID' => $IncomeLevel['id'], //收益id
            'bankPayUrl' => $bankPayUrl,
            'orderType' => 3, //订单类型 。 1投资 。 2冲余额 3限时福利
            'payType' => 2, //下单类型  1三方支付 。 2银行卡转账   3备付金
            'payConfigType' => 5, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];

        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                return true;
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户备付金投资 限时福利
     * @param type $uid
     * @param type $ProjectID
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderStandbyPayLimitedWelfare($uid, $ProjectID, $ip) {
        $ProjectData = LimitedWelfareData::getLimitedWelfareDataMessage($ProjectID);
        if (empty($ProjectData)) {
            $this->addError('mesg', ['212', '项目id为空']);
            return false;
        }



        $model = new LimitedWelfareRecord();
        $existData = $model->userExistData($uid);
        if (!empty($existData)) {
//            $this->addError('mesg', ['212', '已经购买了,无法再次购买']);
//            return false;
        }
        //
        $where = [
            'and',
            ['>', 'itime', time() - 600],
            ['=', 'uid', $uid],
            ['=', 'type', 1],
            ['=', 'payType', 3],
            ['=', 'orderType', 3],
        ];
        $count = $this->find()->where($where)->count() ?? 0;
        if ($count > 0) {
//            $this->addError('mesg', ['212', '最近有提交过支付，请处理完成再来哦']);
//            return false;
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

        if ($AccountInfoData['vipGrade'] == 1) {//
            $this->addError('mesg', ['212', '未实名用户无法投资']);
            return false;
        }


        $orderId = time() . $this->createRand(10) . '';
        $money = $ProjectData['investMoney'];
        //校验金额是否充足
        $model = new AccountInfo();
        $boor = $model->checkAccountGold($uid, $money, $type = 2);
        if (!$boor) {
            $this->addError('mesg', ['212', '备付金余额不足']);
            return false;
        }


        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'orderType', 3],
            ['=', 'payType', 3],
            ['>', 'itime', time() - 60]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '操作太快了，一分钟后再试试呢']);
            return false;
        }

        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            //'payName' => $payName, //付款人姓名
            //'realName' => $realName, //收款人姓名
            //'bankCard' => $bankCard, //收款人卡号
            'ProjectID' => $ProjectData['id'], //项目id 。
            //'IncomeLevelID' => $IncomeLevel['id'], //收益id
            //'bankPayUrl' => $bankPayUrl,
            'orderType' => 3, ////订单类型 。 1投资 。 2冲余额 3限时福利
            'payType' => 3, //下单类型  1三方支付 。 2银行卡转账   3备付金
            'payConfigType' => 4, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];

        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                //扣余额
                $boor = $model->deductAccountGold($uid, $money, $type = 2);
                if ($boor) {
                    $boor = $this->updateAll(['type' => 4, 'payTime' => time()], ['orderId' => $orderId]);
                    //资产变化
                    $AssetChanges = new AssetChanges();
                    $AssetChanges->addAssetChangesData($uid, AssetChanges::MONEY_TYPE_2, AssetChanges::ASSET_TYPE_2, $changeType = 22, $money);
                    //备付金记录
                    $model = new StandbyPayRecord();
                    $model->addStandbyPayRecord($uid, StandbyPayRecord::ASSET_TYPE_2, $changeType = 6, $money);
                    //投资
                    $model = new LimitedWelfareRecord();
                    $boor = $model->buyLimitedWelfareRecord($data['uid'], $data['ProjectID'], $data['orderId']);

                    if ($boor) {
                        return true;
                    } else {
                        $error_mesg = $model->getErrors('mesg');
                        $this->updateAll(['type' => 5, 'buyRemarks' => $error_mesg[0][1]], ['orderId' => $data['orderId']]);
                        $this->addError('mesg', ['211', $error_mesg[0][1]]);
                        return false;
                    }
                } else {
                    $boor = $this->updateAll(['type' => 6, 'payRemarks' => '备付金扣除失败'], ['orderId' => $orderId]);
                    $this->addError('mesg', ['212', '备付金扣除失败']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户银行卡转账购买备付金
     * @param type $uid
     * @param type $ProjectID
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderBankDataStandbyPay($uid, $bankId, $money, $payName, $ip, $bankPayUrl) {//'bankId','money','payName'
        if ($money < 100) {
            $this->addError('mesg', ['212', '最低100起购']);
            return false;
        }

        //$bankId
        $model = new BankList();
        $bankIdData = $model->getClientBankMessage($bankId);
        if (empty($bankIdData)) {
            $this->addError('mesg', ['212', '收款银行卡已经关闭，请更换银行卡转账']);
            return false;
        } else {
            $realName = $bankIdData['realName'];
            $bankCard = $bankIdData['bankCard'];
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

//        if ($AccountInfoData['vipGrade'] == 1) {//
//            $this->addError('mesg', ['212', '未实名用户无法投资']);
//            return false;
//        }


        $orderId = time() . $this->createRand(10) . '';
        // $money = $IncomeLevel['investMoney'];
        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            'payName' => $payName, //付款人姓名
            'realName' => $realName, //收款人姓名
            'bankCard' => $bankCard, //收款人卡号
            'ProjectID' => '', //项目id 。
            'IncomeLevelID' => '', //收益id
            'bankPayUrl' => $bankPayUrl,
            'orderType' => 4, //订单类型 。 1投资 。 2冲余额
            'payType' => 2, //下单类型  1三方支付 。 2银行卡转账   3备付金
            'payConfigType' => 5, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];

        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                return true;
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 用户三方充值投资 备付金
     * @param type $uid
     * @param type $ProjectID
     * @param type $IncomeLevelID
     * @return boolean
     */
    public function addRechargeOrderPaymentStandbyPayData($uid, $money, $payButtonId, $ip) {//payButtonId 。$payConfigType
//        $ProjectData = LimitedWelfareData::getLimitedWelfareDataMessage($limitedWelfareID);
//        if (empty($ProjectData)) {
//            $this->addError('mesg', ['212', '项目id为空']);
//            return false;
//        }
        $money = intval($money);
        if ($money < 100 || $money > 20000) {
            $this->addError('mesg', ['212', '购买金额异常']);
            return false;
        }

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'type', 3],
            ['>', 'itime', time() - 3600]
        ];

        $countData = $this->find()->where($where)->select('payConfigNo,count(*) as count')->groupBy('payConfigNo')->asArray()->all();

        foreach ($countData as $key => $value) {
            if (!empty($value['payConfigNo'])) {
                if ($value['count'] >= 10) {
                    $this->addError('mesg', ['212', '未支付的订单太多了，稍后再试哦']);
                    return false;
                }
            }
        }

        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '用户id异常']);
            return false;
        }

//        if ($AccountInfoData['vipGrade'] == 1) {//
//            $this->addError('mesg', ['212', '未实名用户无法投资']);
//            return false;
//        }
        $payConfigNo = null;
        $payButtonData = PayButton::getPayButtonMessage($payButtonId);
        if (empty($payButtonData)) {
            $this->addError('mesg', ['212', '支付按钮已经关闭，请更换支付方式']);
            return false;
        } else {
            if (in_array($payButtonData['payConfigType'], [1, 2, 3])) {
                $payConfigType = $payButtonData['payConfigType'];
                $payConfigNo = $payButtonData['payNo'];
            } else {
                $this->addError('mesg', ['212', '支付按钮异常，请更换支付方式']);
                return false;
            }
        }

        $orderId = time() . $this->createRand(10) . '';
        //$money = $ProjectData['investMoney'];
        $data = [
            //'id'=>FuncHelper::uniqid12(),, //标记id
            'uid' => $uid, //用户id
            'money' => $money, //金额
            'payMoney' => 0,
            'payTime' => 0,
            //'payConfigNo', 'number'], //支付平台编号
            'orderId' => $orderId, //订单id
            //'ProjectID' => $ProjectData['id'], //项目id 。
            //'IncomeLevelID' => $IncomeLevel['id'], //收益id
            'orderType' => 4, //订单类型 。 1投资 。 2冲余额  3限时福利  4备付金充值
            'payType' => 1, //下单类型  1三方支付 。 2银行卡转账  3备付金
            'payConfigType' => $payConfigType, //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
            'type' => 1, //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6失败
            //['buyRemarks', 'string'], //投资失败备注
            //['payRemarks', 'string'], //支付失败备注
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    //获取支付链接
                    $model = new PayConfig();
                    $urlData = $model->getPayConfigUrl($orderId, $uid, $money, $payConfigType, $ip, $payConfigNo, $payType = 2);
                    if (!empty($urlData['url'])) {
                        $boor = $this->updateAll(['type' => 3, 'payConfigNo' => $urlData['payNo']], ['orderId' => $orderId]);
                        if (!empty($boor)) {
                            $urlData['orderId'] = $orderId;
                            return $urlData;
                        } else {
                            $this->addError('mesg', ['212', '支付状态异常，请稍后重试']);
                            return false;
                        }
                    } else {
                        $this->updateAll(['type' => 2], ['orderId' => $orderId]);
                        $this->addError('mesg', ['212', '支付链接获取失败，请稍后重试或更换金额']);
                        return false;
                    }
                } else {
                    $this->addError('mesg', ['212', '支付订单下单失败，请稍后重试']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 支付回掉
     * @param type $orderId
     * @param type $payMoney  'payType' => 2, //下单类型  1三方支付 。 2银行卡转账
     * @return boolean
     */
    public function FallBackRecharge($orderId, $payMoney = null) {

        $existData = $this->find()->where(['orderId' => $orderId, 'type' => 3, 'payType' => 1])->asArray()->one();
        if (empty($existData)) {//订单异常
            return true;
        }

        if (empty($payMoney)) {
            $payMoney = $existData['money'];
        }
        $minMoney = $existData['money'] - 2;
        $maxMoney = $existData['money'] + 2;

        if ($payMoney < $minMoney || $payMoney > $maxMoney) {//支付金额异常
            $this->updateAll(['type' => 7, 'payRemarks' => '支付金额异常'], ['id' => $existData['id']]);
            return true;
        }

        if ($existData['orderType'] == 1) {//投资增加
            $boor = $this->updateAll(['type' => 8, 'payTime' => time()], ['id' => $existData['id'], 'type' => 3]);
            if ($boor) {
                $model = new BuyRecord();
                $boor = $model->addBuyRecord($existData['ProjectID'], $existData['orderId'], $existData['IncomeLevelID'], $existData['uid']);
                if ($boor) {
                    $this->updateAll(['type' => 4, 'payTime' => time()], ['id' => $existData['id']]);
                    return true;
                } else {
                    $error_mesg = $model->getErrors('mesg');
                    $this->updateAll(['type' => 5, 'buyRemarks' => $error_mesg[0][1]], ['id' => $existData['id']]);
                    return true;
                }
            }
        } else if ($existData['orderType'] == 2) {//余额增加
        } else if ($existData['orderType'] == 3) {//限时福利
            $boor = $this->updateAll(['type' => 8, 'payTime' => time()], ['id' => $existData['id'], 'type' => 3]);
            if ($boor) {
                $model = new LimitedWelfareRecord();
                $model->buyLimitedWelfareRecord($existData['uid'], $existData['ProjectID'], $existData['orderId']);
                if ($boor) {
                    $this->updateAll(['type' => 4, 'payTime' => time()], ['id' => $existData['id']]);
                    return true;
                } else {
                    $error_mesg = $model->getErrors('mesg');
                    $this->updateAll(['type' => 5, 'buyRemarks' => $error_mesg[0][1]], ['id' => $existData['id']]);
                    return true;
                }
            }
        } else if ($existData['orderType'] == 4) {//备付金
            $boor = $this->updateAll(['type' => 8, 'payTime' => time()], ['id' => $existData['id'], 'type' => 3]);
            if ($boor) {
                $model = new AccountInfo();
                $model->addAccountGold($existData['uid'], $existData['money'], $type = 2);
                if ($boor) {

                    //资产变化
                    $AssetChanges = new AssetChanges();
                    $AssetChanges->addAssetChangesData($existData['uid'], AssetChanges::MONEY_TYPE_2, AssetChanges::ASSET_TYPE_1, $changeType = 1, $existData['money'], $remarks = '三方充值');
                    //备付金记录
                    $model = new StandbyPayRecord();
                    $model->addStandbyPayRecord($existData['uid'], StandbyPayRecord::ASSET_TYPE_1, $changeType = 9, $existData['money'], $remarks = '三方充值');

                    $this->updateAll(['type' => 4, 'payTime' => time()], ['id' => $existData['id']]);
                    return true;
                } else {
                    $error_mesg = $model->getErrors('mesg');
                    $this->updateAll(['type' => 5, 'buyRemarks' => '备付金增加失败'], ['id' => $existData['id']]);
                    return true;
                }
            }
        }
    }

    /**
     * 银行卡支付回掉
     * @param type $orderId  'payType' => 2, //下单类型  1三方支付 。 2银行卡转账
     * @param type $payMoney
     * @return boolean
     */
    public function BackBackRecharge($id, $type) {
        $existData = $this->find()->where(['id' => $id, 'type' => 1, 'payType' => 2])->asArray()->one();
        if (empty($existData)) {//订单异常
            $this->addError('mesg', ['211', '订单状态无法操作']);
            return false;
        }
        if ($type == 1) {
            if ($existData['orderType'] == 1) {//投资增加
                $boor = $this->updateAll(['type' => 4, 'payTime' => time()], ['id' => $existData['id'], 'type' => 1]);
                if ($boor) {

                    $model = new BuyRecord();
                    $boor = $model->addBuyRecord($existData['ProjectID'], $existData['orderId'], $existData['IncomeLevelID'], $existData['uid']);
                    if ($boor) {
                        return true;
                    } else {
                        $error_mesg = $model->getErrors('mesg');
                        $this->updateAll(['type' => 5, 'buyRemarks' => $error_mesg[0][1]], ['id' => $existData['id'], 'type' => 4]);
                        $this->addError('mesg', ['211', $error_mesg[0][1]]);
                        return false;
                    }
                } else {
                    $this->addError('mesg', ['211', '订单状态修改失败']);
                    return false;
                }
            } else if ($existData['orderType'] == 2) {//余额增加
            } else if ($existData['orderType'] == 3) {//限时福利
                $boor = $this->updateAll(['type' => 4, 'payTime' => time()], ['id' => $existData['id'], 'type' => 1]);
                if ($boor) {
                    $model = new LimitedWelfareRecord();
                    $boor = $model->buyLimitedWelfareRecord($existData['uid'], $existData['ProjectID'], $existData['orderId']);
                    if ($boor) {
                        return true;
                    } else {
                        $error_mesg = $model->getErrors('mesg');
                        $this->updateAll(['type' => 5, 'buyRemarks' => $error_mesg[0][1]], ['id' => $existData['id'], 'type' => 4]);
                        $this->addError('mesg', ['211', $error_mesg[0][1]]);
                        return false;
                    }
                }
            } else if ($existData['orderType'] == 4) {//备付金
                $boor = $this->updateAll(['type' => 4, 'payTime' => time()], ['id' => $existData['id'], 'type' => 1]);
                if ($boor) {
                    $model = new AccountInfo();
                    $model->addAccountGold($existData['uid'], $existData['money'], $type = 2);
                    if ($boor) {

                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($existData['uid'], AssetChanges::MONEY_TYPE_2, AssetChanges::ASSET_TYPE_1, $changeType = 1, $existData['money'], $remarks = '银行卡充值');
                        //备付金记录
                        $model = new StandbyPayRecord();
                        $model->addStandbyPayRecord($existData['uid'], StandbyPayRecord::ASSET_TYPE_1, $changeType = 8, $existData['money'], $remarks = '银行卡充值');
                        return true;
                    } else {
                        $error_mesg = $model->getErrors('mesg');
                        $this->updateAll(['type' => 5, 'buyRemarks' => $error_mesg[0][1]], ['id' => $existData['id'], 'type' => 4]);
                        $this->addError('mesg', ['211', $error_mesg[0][1]]);
                        return false;
                    }
                }
            }
        } else if ($type == 2) {//取消
            $boor = $this->updateAll(['type' => 6, 'payTime' => time()], ['id' => $existData['id'], 'type' => 1]);
            if ($boor) {
                return true;
            } else {
                $this->addError('mesg', ['211', '订单状态修改失败']);
                return false;
            }
        }
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getRechargeList($page = 1, $limit = 10, $fields = [], $type = null,
            $uid = null, $payConfigNo = null, $payConfigType = null, $orderId = null, $start_time = null, $end_time = null, $payType = null) {
        $where = [
            'and'
        ];
        if (!empty($type))
            $where[] = ['=', 'type', $type];
        if (!empty($uid))
            $where[] = ['=', 'uid', $uid];
        if (!empty($payConfigNo))
            $where[] = ['=', 'payConfigNo', $payConfigNo];
        if (!empty($payConfigType))
            $where[] = ['=', 'payConfigType', $payConfigType];
        if (!empty($orderId))
            $where[] = ['=', 'orderId', $orderId];
        if (!empty($start_time))
            $where[] = ['>', 'itime', $start_time];
        if (!empty($end_time))
            $where[] = ['<', 'itime', $end_time];
        if (!empty($payType))
            $where[] = ['in', 'payType', $payType];

        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
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
    public function getRechargeListStatistics($type = null,
            $uid = null, $payConfigNo = null, $payConfigType = null, $orderId = null, $start_time = null, $end_time = null) {

        $rediskey = __METHOD__ . $type . $uid . $payConfigNo . $payConfigType . $orderId . $start_time . $end_time;
        $redisData = self::getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'payType', 1]
        ];
        if (!empty($type))
            $where[] = ['=', 'type', $type];
        if (!empty($uid))
            $where[] = ['=', 'uid', $uid];
        if (!empty($payConfigNo))
            $where[] = ['=', 'payConfigNo', $payConfigNo];
        if (!empty($payConfigType))
            $where[] = ['=', 'payConfigType', $payConfigType];
        if (!empty($orderId))
            $where[] = ['=', 'orderId', $orderId];
        if (!empty($start_time)) {
            $where[] = ['>', 'itime', $start_time];
        } else {
            $where[] = ['>', 'itime', strtotime(date('Y-m-d'))];
        }

        if (!empty($end_time)) {
            $where[] = ['<', 'itime', $end_time];
        } else {
            $where[] = ['<', 'itime', strtotime(date('Y-m-d')) + 86400];
        }

//        if (!empty($payType))
//            $where[] = ['in', 'payType', $payType];
        //支付金额
        $data['pay_money'] = $this->find()->where(array_merge($where, [['=', 'type', 4]]))->sum('money') ?? 0;
        $data['pay_count'] = $this->find()->where(array_merge($where, [['=', 'type', 4]]))->count() ?? 0;

        //拉起金额
        $data['pay_all_money'] = $this->find()->where(array_merge($where, [['>=', 'type', 3]]))->sum('money') ?? 0;
        $data['pay_all_count'] = $this->find()->where(array_merge($where, [['>=', 'type', 3]]))->count() ?? 0;

        //$time = $this->redisTime;
        $time = 10;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取指定日期登录人数
     * @param type $date
     * @return type
     */
    static public function getRechargeOrderNumber($date) {
//         ['orderType', 'number'], //订单类型 。 1投资 。 2冲余额
//            ['payType', 'number'], //下单类型  1三方支付 。 2银行卡转账  3备付金
//            ['payConfigType', 'number'], //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
//            ['type', 'number'], //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6取消 。7支付金额异常


        $time = strtotime($date);
        $where1 = [
            'and',
            ['>', 'payTime', $time],
            ['<', 'payTime', $time + 86400],
            ['in', 'type', [4, 5]]
        ];
        $where2 = [
            'and',
            ['>', 'payTime', $time - 86400],
            ['<', 'payTime', $time],
            ['in', 'type', [4, 5]]
        ];
        $where3 = [
            'and',
            ['in', 'type', [4, 5]]
        ];
        //银行卡充值
        $data['recharge_day_bank'] = self::find()->where(array_merge($where1, [['=', 'payType', 2]]))->sum('money') ?? 0; //银行卡今日充值
        $data['recharge_yesterday_bank'] = self::find()->where(array_merge($where2, [['=', 'payType', 2]]))->sum('money') ?? 0; //银行卡昨日充值
        $data['recharge_all_bank'] = self::find()->where(array_merge($where3, [['=', 'payType', 2]]))->sum('money') ?? 0; //银行卡总充值
        //备付金投资
        $data['recharge_day_standby'] = self::find()->where(array_merge($where1, [['=', 'payType', 3]]))->sum('money') ?? 0; //今日充值
        $data['recharge_yesterday_standby'] = self::find()->where(array_merge($where2, [['=', 'payType', 3]]))->sum('money') ?? 0; //昨日充值
        $data['recharge_all_standby'] = self::find()->where(array_merge($where3, [['=', 'payType', 3]]))->sum('money') ?? 0; //总充值
        //三方在线充值
        $data['recharge_day_tripartite'] = self::find()->where(array_merge($where1, [['=', 'payType', 1]]))->sum('money') ?? 0; //今日充值
        $data['recharge_yesterday_tripartite'] = self::find()->where(array_merge($where2, [['=', 'payType', 1]]))->sum('money') ?? 0; //昨日充值
        $data['recharge_all_tripartite'] = self::find()->where(array_merge($where3, [['=', 'payType', 1]]))->sum('money') ?? 0; //总充值
        //总入金
        $data['recharge_day_income'] = self::find()->where($where1)->sum('money') ?? 0; //今日充值
        $data['recharge_yesterday_income'] = self::find()->where($where2)->sum('money') ?? 0; //昨日充值
        $data['recharge_all_income'] = self::find()->where($where3)->sum('money') ?? 0; //总充值
//
//        $where1 = $where;
//        $where2 = $where;
//        $where3 = $where;
//        $where4 = $where;
//        $data['recharge_day_money'] = self::find()->where($where)->sum('money') ?? 0; //今日充值
//        //三方代付金额
//        $where1[] = ['=', 'payType', 1];
//        $data['recharge_day_san_money'] = self::find()->where($where1)->sum('money') ?? 0; //三方代付金额
//        //银行卡转账充值金额
//        $where2[] = ['=', 'payType', 2];
//        $data['recharge_day_bank_money'] = self::find()->where($where2)->sum('money') ?? 0; //银行卡转账充值金额
//        //投资金额
//        $where3[] = ['=', 'orderType', 1];
//        $data['recharge_day_touzi_money'] = self::find()->where($where3)->sum('money') ?? 0; //投资金额
//        //余额购买金额
//        $where4[] = ['=', 'orderType', 2];
//        $data['recharge_day_balance_money'] = self::find()->where($where4)->sum('money') ?? 0; //余额购买金额
//        //总充值金额
//        $where = [
//            'and',
//            ['in', 'type', [4, 5]]
//        ];
//        $data['recharge_all_money'] = self::find()->where($where)->sum('money') ?? 0; //总充值金额
        return $data;
    }

    /**
     * 获取指定日期登录人数
     * @param type $date
     * @return type
     */
    static public function getRechargeOrderNumberAgent($date, $uid) {
//         ['orderType', 'number'], //订单类型 。 1投资 。 2冲余额
//            ['payType', 'number'], //下单类型  1三方支付 。 2银行卡转账  3备付金
//            ['payConfigType', 'number'], //支付类型 。1支付宝 2微信  3银行卡 4备付金 。5银行卡
//            ['type', 'number'], //订单状态 。 1申请中  2支付链接获取失败。 3支付中 。4成功 。5成功但是投资失败 。6取消 。7支付金额异常


        $time = strtotime($date);
        $where1 = [
            'and',
            ['>', 'payTime', $time],
            ['<', 'payTime', $time + 86400],
            ['in', 'type', [4, 5]],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $where2 = [
            'and',
            ['>', 'payTime', $time - 86400],
            ['<', 'payTime', $time],
            ['in', 'type', [4, 5]],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $where3 = [
            'and',
            ['in', 'type', [4, 5]],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
//        $where1Temp = array_merge($where3, [['=', 'payType', 2]]);
//        $where1Temp[] = [
//            'or',
//            ['=', 't_account_info.oneLevel', $uid],
//            ['=', 't_account_info.twoLevel', $uid],
//            ['=', 't_account_info.threeLevel', $uid],
//        ];
//        $data['recharge_all_income'] = self::find()->where($where1Temp)
//                        ->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0;
//        echo '<pre>';
//        //$data = self::find()->joinWith(['accountInfo'])->asArray()->all();
//        var_dump($data);
//        exit;
        //银行卡充值
        $data['recharge_day_bank'] = self::find()->where(array_merge($where1, [['=', 'payType', 2]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //银行卡今日充值
        $data['recharge_yesterday_bank'] = self::find()->where(array_merge($where2, [['=', 'payType', 2]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //银行卡昨日充值
        $data['recharge_all_bank'] = self::find()->where(array_merge($where3, [['=', 'payType', 2]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //银行卡总充值
        //备付金投资
        $data['recharge_day_standby'] = self::find()->where(array_merge($where1, [['=', 'payType', 3]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //今日充值
        $data['recharge_yesterday_standby'] = self::find()->where(array_merge($where2, [['=', 'payType', 3]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //昨日充值
        $data['recharge_all_standby'] = self::find()->where(array_merge($where3, [['=', 'payType', 3]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //总充值
        //三方在线充值
        $data['recharge_day_tripartite'] = self::find()->where(array_merge($where1, [['=', 'payType', 1]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //今日充值
        $data['recharge_yesterday_tripartite'] = self::find()->where(array_merge($where2, [['=', 'payType', 1]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //昨日充值
        $data['recharge_all_tripartite'] = self::find()->where(array_merge($where3, [['=', 'payType', 1]]))->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //总充值
        //总入金
        $data['recharge_day_income'] = self::find()->where($where1)->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //今日充值
        $data['recharge_yesterday_income'] = self::find()->where($where2)->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //昨日充值
        $data['recharge_all_income'] = self::find()->where($where3)->joinWith(['accountInfo'])->sum('t_recharge_order.money') ?? 0; //总充值
//
//        $where1 = $where;
//        $where2 = $where;
//        $where3 = $where;
//        $where4 = $where;
//        $data['recharge_day_money'] = self::find()->where($where)->sum('money') ?? 0; //今日充值
//        //三方代付金额
//        $where1[] = ['=', 'payType', 1];
//        $data['recharge_day_san_money'] = self::find()->where($where1)->sum('money') ?? 0; //三方代付金额
//        //银行卡转账充值金额
//        $where2[] = ['=', 'payType', 2];
//        $data['recharge_day_bank_money'] = self::find()->where($where2)->sum('money') ?? 0; //银行卡转账充值金额
//        //投资金额
//        $where3[] = ['=', 'orderType', 1];
//        $data['recharge_day_touzi_money'] = self::find()->where($where3)->sum('money') ?? 0; //投资金额
//        //余额购买金额
//        $where4[] = ['=', 'orderType', 2];
//        $data['recharge_day_balance_money'] = self::find()->where($where4)->sum('money') ?? 0; //余额购买金额
//        //总充值金额
//        $where = [
//            'and',
//            ['in', 'type', [4, 5]]
//        ];
//        $data['recharge_all_money'] = self::find()->where($where)->sum('money') ?? 0; //总充值金额
        return $data;
    }

}
