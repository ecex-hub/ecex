<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;
use yii\db\Expression;

/**
 * ContactForm is the model behind the contact form.  提现订单
 */
class WithdrawalOrder extends BaseModel
{

    protected $table = 't_withdrawal';

    public static function tableName()
    {
        return '{{t_withdrawal}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['otn', 'string'], //订单号
            ['money', 'number'], //金额
            ['card_id', 'number'], //订单id
            ['type', 'number'], //订单状态 1-申请中2-通过 3-拒绝
            ['ip', 'string'], //ip
            ['itime', 'number'], //
            ['utime', 'number'], //
            ['pay_time', 'number'], //代付时间
            ['realName', 'string'], //姓名
            ['bankName', 'string'], //银行名字
            ['bankCard', 'string'], //银行卡号
            ['alipay_card', 'string'], //支付宝账号
            ['pay_type', 'number'], //1-银行卡 2-支付宝
        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }


    /**
     * H5 钱包简单提现接口
     * 使用回报钱包（pay_back）为提现来源，根据前端传入的账户信息创建提现记录
     *
     * @param \common\models\AccountInfo $user
     * @param float $money
     * @param string $accountType  alipay / bank
     * @param string $accountNumber 支付宝账号或银行卡号
     * @param string $ip
     * @return bool
     */
    public function addClientWithdrawal($user, $money, $accountType, $accountNumber, $ip)
    {
        $uid = $user->uid;
        $money = (float)$money;

        if ($money < 100) {
            $this->addError('mesg', ['212', '提现最低额度100']);
            return false;
        }

        // 使用回报钱包作为提现来源
        if (bccomp($money, $user['pay_back']) > 0) {
            $this->addError('mesg', ['212', '可提现金额不足']);
            return false;
        }
        $endPayBack = bcsub($user['pay_back'], $money);

        // 每天限制一次提现
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['>', 'itime', strtotime(date('Y-m-d 00:00:00'))],
            ['in', 'type', [1, 2]]
        ];
        $existData = $this->find()->where($where)
            ->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '每天只允许提现一次哦']);
            return false;
        }

        // 账户类型映射
        $payType = 1; // 1-银行卡 2-支付宝
        $bankName = '';
        $bankCard = '';
        $alipayCard = '';
        if (strtolower($accountType) === 'alipay') {
            $payType = 2;
            $alipayCard = $accountNumber;
        } else {
            $payType = 1;
            $bankCard = $accountNumber;
        }

        $transaction = Yii::$app->db->beginTransaction();
        try {
            // 账单记录（回报钱包扣减）
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'sub',
                'bill_type' => BillRecord::BillTypWithdrawal,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }

            // 提现记录
            $data = [
                'uid' => $uid,
                'money' => $money,
                'card_id' => 0,
                'type' => 1, // 1-申请中 2-通过 3-拒绝
                'ip' => $ip,
                'otn' => FuncHelper::generateOrderNumber(),
                'paytime' => 0,
                'itime' => time(),
                'utime' => time(),
                'bankName' => $bankName,
                'bankCard' => $bankCard,
                'alipay_card' => $alipayCard,
                'realName' => $user->realName ?? '',
                'pay_type' => $payType,
            ];
            if (!$this->insertData($data)) {
                throw new \Exception('Failed to save withdrawal record');
            }

            // 更新用户回报钱包
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'pay_back' => $endPayBack
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }

            $transaction->commit();

            // 发送站内通知
            $notice = new Notice();
            $noticeData = [
                'uid' => $uid,
                'title' => '提现发起通知',
                'content' => "您发起的提现{$money}金额请求已提交成功，审核将在1-3工作日完成，请耐心等待",
                'msg_type' => Notice::IsWithdrawal,
                'itime' => time(),
                'utime' => time(),
            ];
            $notice->insertData($noticeData);

            return true;
        } catch (\Exception $e) {
            $transaction->rollBack();
            FuncHelper::ErrLog('withdrawal_client', [
                'uid' => $uid,
                'money' => $money,
            ], $e->getMessage());
            $this->addError('mesg', ['211', '提现失败，请稍后重试']);
            return false;
        }
    }

    /**
     * 用户提现
     * @return boolean
     */
    public function addWithdrawalOrderData($user, $money, $cardId, $ip, $payPassword)
    {
        $uid = $user->uid;
        if ($money < 100) {
            $this->addError('mesg', ['212', '提现最低额度100']);
            return false;
        }
        if (bccomp($money, $user['pay_back']) > 0) {
            $this->addError('mesg', ['212', '提现金额不足']);
            return false;
        }
        $endPayBack = bcsub($user['pay_back'], $money);
        $model = new BindBankCard();
        $BankCardData = $model->getInfo($uid, $cardId);
        if (empty($BankCardData)) {
            $this->addError('mesg', ['212', '银行卡信息异常']);
            return false;
        }
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['>', 'itime', strtotime(date('Y-m-d 00:00:00'))],
            ['in', 'type', [1, 2]]
        ];
        $existData = $this->find()->where($where)
            ->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '每天只允许提现一次哦']);
            return false;
        }
        if (empty($user['payPassword'])) {
            $this->addError('mesg', ['212', '未设置支付密码']);
            return false;
        }
        //校验支付密码
        if (md5($payPassword) != $user['payPassword']) {
            $this->addError('mesg', ['212', '支付密码错误']);
            return false;
        }
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'sub',
                'bill_type' => BillRecord::BillTypWithdrawal,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            $data = [
                'uid' => $uid,
                'money' => $money, //金额
                'card_id' => $cardId,
                'type' => 1, //1-默认 2-通过 3-拒绝
                'ip' => $ip,
                'otn' => FuncHelper::generateOrderNumber(),
                'paytime' => 0,
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
                'bankName' => $BankCardData['bankName'], //银行名字
                'bankCard' => $BankCardData['bankCard'], //银行卡号
                'alipay_card' => $BankCardData['alipay_card'],//支付宝
                'realName' => $BankCardData['realName'], //姓名
                'pay_type' => $BankCardData['pay_type'],
            ];
            if (!$this->insertData($data)) {
                throw new \Exception('Failed to save withdrawal record');
            }
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'pay_back' => $endPayBack
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            $transaction->commit();

            //发送消息
            $notice = new Notice();
            $data = [
                'uid' => $uid,
                'title' => '提现发起通知',
                'content' => "您发起的提现{$money}金额请求已提交成功，审核将在1-3工作日完成，请耐心等待",
                'msg_type' => Notice::IsWithdrawal,
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
            ];
            $notice->insertData($data);
            return true;
        } catch (\Exception $e) {
            // 如果有任何错误发生，回滚事务
            $transaction->rollBack();
            FuncHelper::ErrLog('withdrawal', [
                'uid' => $uid,
                'money' => $money,
            ], $e->getMessage());
            $this->addError('mesg', ['211', '数据异常，检查数据']);
            return false;
        }

    }


    /**
     * 确认或取消订单
     * @param type $id
     * @param int $type
     * @return boolean
     */
    public function confirmWithdrawalOrderorderId($orderId, $type)
    {
        $existData = $this->find()->where(['orderId' => $orderId])->asArray()->one();
        if (!empty($existData) && $existData['type'] == 3) {
            if ($type == 1) {//确认代付
                $model = new WithdrawalConfig();
                $data = $model->getWithdrawalConfigUrl($existData['orderId'], $existData['uid'], $existData['money'], $existData['ip']);
                if ($data['type']) {//成功
                    $boor = $this->updateAll(['type' => 5, 'withdrawalConfigNo' => $data['withdrawalNo']], ['id' => $existData['id'], 'type' => 3]);
                    return true;
                } else {
                    $this->addError('mesg', ['211', '代付失败： 通道号：' . $data['withdrawalNo'] . ',原因：' . $data['message']]);
                    return false;
                }
            } else if ($type == 2) {//取消代付
                $boor = $this->updateAll(['type' => 8, 'withdrawalRemarks' => "管理员取消代付"], ['id' => $existData['id'], 'type' => 3]);
                if ($boor) {//还钱
                    $model = new AccountInfo();
                    $boor = $model->addAccountGold($existData['uid'], $existData['money'], $type = 1);
                    if (!empty($boor)) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($existData['uid'], AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 7, $existData['money']);
                    }
                    return true;
                }
            }
        }
        $this->addError('mesg', ['211', '订单状态异常，无法操作']);
        return false;
    }

    /**
     * 确认或取消订单
     * @param type $id
     * @param int $type
     * @return boolean
     */
    public function confirmWithdrawalOrder($id, $type, $remarks)
    {
        $existData = $this->find()->where(['id' => $id])->asArray()->one();
        if (!empty($existData) && $existData['type'] == 3) {
            if ($type == 1) {//确认代付
                $model = new WithdrawalConfig();
                $data = $model->getWithdrawalConfigUrl($existData['orderId'], $existData['uid'], $existData['money'], $existData['ip']);
                if ($data['type']) {//成功
                    $boor = $this->updateAll(['type' => 5, 'withdrawalConfigNo' => $data['withdrawalNo']], ['id' => $id, 'type' => 3]);
                    return true;
                } else {
                    $this->addError('mesg', ['211', '代付失败： 通道号：' . $data['withdrawalNo'] . ',原因：' . $data['message']]);
                    return false;
                }
            } else if ($type == 2) {//取消代付
                $boor = $this->updateAll(['type' => 8, 'withdrawalRemarks' => $remarks], ['id' => $id, 'type' => 3]);//$remarks 管理员取消代付
                if ($boor) {//还钱
                    $model = new AccountInfo();
                    $money = $existData['deductMoney'] + $existData['money'];
                    $boor = $model->addAccountGold($existData['uid'], $money, $type = 1);
                    if (!empty($boor)) {
                        //资产变化
                        $AssetChanges = new AssetChanges();
                        $AssetChanges->addAssetChangesData($existData['uid'], AssetChanges::MONEY_TYPE_1, AssetChanges::ASSET_TYPE_1, $changeType = 7, $money, $remarks);
                    }
                    return true;
                }
            } else if ($type == 3) {//手动打款
                $boor = $this->updateAll(['type' => 6, 'withdrawalRemarks' => "手动打款"], ['id' => $id, 'type' => 3]);
                if (!empty($boor)) {
                    if ($existData['withdrawalType'] == 1) {
                        $model = new AccountInfo();
                        $model->addAccountRechargeWithdrawalAllMoney($existData['uid'], $existData['money'], $type = 2);
                    } else {
                        $model = new CountryAdvanceMoney();
                        $model->successOrderId($existData['orderId'], 1);
                    }
                    return true;
                }
                $this->addError('mesg', ['211', '订单状态修改失败']);
                return false;
            }
        }
        $this->addError('mesg', ['211', '订单状态异常，无法操作']);
        return false;
    }

    /**
     * 代付回掉
     * @param type $orderId
     * @param type $payMoney
     * @return boolean
     */
    public function FallBackWithdrawal($orderId, $payMoney = null)
    {
        $existData = $this->find()->where(['orderId' => $orderId, 'type' => 5])->asArray()->one();
        if (empty($existData)) {//订单异常
            return true;
        }

        if (empty($payMoney)) {
            $payMoney = $existData['money'];
        }
        $payRemarks = '';
        if ($payMoney <> $existData['money']) {//支付金额异常
            $payRemarks = '代付下发金额异常' . $payMoney;
        }

        $boor = $this->updateAll(['type' => 6, 'paytime' => time(), 'withdrawalRemarks' => $payRemarks], ['id' => $existData['id']]);
        if (!empty($boor)) {
            if ($existData['withdrawalType'] == 1) {
                $model = new AccountInfo();
                $model->addAccountRechargeWithdrawalAllMoney($existData['uid'], $existData['money'], $type = 2);
            } else {
                $model = new CountryAdvanceMoney();
                $model->successOrderId($existData['orderId'], 1);
            }

            return true;
        }

        return false;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getkWithdrawalList($page = 1, $limit = 10, $fields = [], $type = null, $uid = null, $start_time = null, $end_time = null)
    {
        $where = [
            'and'
        ];
        if (!empty($type)) {
            $where[] = [
                '=', 'type', $type
            ];
        }
        if (!empty($uid)) {
            $where[] = [
                '=', 'uid', $uid
            ];
        }
        if (!empty($start_time)) {
            $where[] = [
                '>', 'itime', $start_time
            ];
        }
        if (!empty($end_time)) {
            $where[] = [
                '<', 'itime', $end_time
            ];
        }
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

    /**
     * 获取指定日期提现金额
     * @param type $date
     * @return type
     */
    static public function getWithdrawalOrderNumber($date)
    {
        $time = strtotime($date);
        $where = [
            'and',
            ['>', 'payTime', $time],
            ['<', 'payTime', $time + 86400],
            ['=', 'type', 6]
        ];
        $data['Withdrawal_day_money'] = self::find()->where($where)->sum('money') ?? 0; //今日金额
        //
        $where = [
            'and',
            ['>', 'payTime', $time - 86400],
            ['<', 'payTime', $time],
            ['=', 'type', 6]
        ];
        $data['Withdrawal_yesterday_money'] = self::find()->where($where)->sum('money') ?? 0; //今日金额
        //总金额
        $where = [
            'and',
            ['=', 'type', 6]
        ];
        $data['Withdrawal_all_money'] = self::find()->where($where)->sum('money') ?? 0; //总金额
        return $data;
    }


    /**
     * 获取指定日期提现金额
     * @param type $date
     * @return type
     */
    static public function getWithdrawalOrderNumberAgent($date, $uid)
    {
        $time = strtotime($date);
        $where = [
            'and',
            ['>', 'payTime', $time],
            ['<', 'payTime', $time + 86400],
            ['=', 'type', 6],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $data['Withdrawal_day_money'] = self::find()->where($where)->joinWith(['accountInfo'])->sum('t_withdrawal_order.money') ?? 0; //今日金额
        //
        $where = [
            'and',
            ['>', 'payTime', $time - 86400],
            ['<', 'payTime', $time],
            ['=', 'type', 6],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $data['Withdrawal_yesterday_money'] = self::find()->where($where)->joinWith(['accountInfo'])->sum('t_withdrawal_order.money') ?? 0; //今日金额
        //总金额
        $where = [
            'and',
            ['=', 'type', 6],
            [
                'or',
                ['=', 't_account_info.oneLevel', $uid],
                ['=', 't_account_info.twoLevel', $uid],
                ['=', 't_account_info.threeLevel', $uid],
            ]
        ];
        $data['Withdrawal_all_money'] = self::find()->where($where)->joinWith(['accountInfo'])->sum('t_withdrawal_order.money') ?? 0; //总金额
        return $data;
    }


    public function getClientWithdrawalList($page = 1, $limit = 10, $uid)
    {
        $fields = ['id', 'money', 'itime', 'type', 'pay_type'];
        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        $list = $this
            ->listFind(['page' => $page, 'row' => $limit])
            ->select($fields)
            ->where($where)
            ->orderBy("itime desc")
            ->asArray()
            ->all();
        foreach ($list as &$item) {
            $item['create_time'] = date("Y-m-d H:i:s", $item['itime']);
        }
        $data['list'] = $list;
        $data['count'] = $this->listFind([])->where($where)->count();
        return $data;
    }

}
