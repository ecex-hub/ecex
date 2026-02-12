<?php

namespace common\models;


use common\components\FuncHelper;
use yii\db\Expression;
use yii;

class UserSignIn extends BaseModel
{

    protected $table = 't_user_sign_in';

    public static function tableName()
    {
        return '{{t_user_sign_in}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标题
            ['day', 'string'], //日期
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public function getCount($uid)
    {
        $where = [
            'and',
            ['=', 'uid', $uid]
        ];
        $count = $this->find()->where($where)->count();
        return intval($count);
    }


    public function addSignInRecord($user)
    {
        $uid = $user['uid'];
        $dateDay = date("Y-m-d");
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'day', $dateDay],
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '已经签到了']);
            return false;
        }
        $transaction = Yii::$app->db->beginTransaction();
        try {
            //记录签到日志
            $userSignInData = [
                'uid' => $uid,
                'day' => date("Y-m-d"),
                'itime' => time(),
                'utime' => time(),
            ];
            $userSignInM = new UserSignIn();
            if (!$userSignInM->insertData($userSignInData)) {
                throw new \Exception('Failed to save user sign in ');
            }
            $money = 2;
            if ($dateDay == "2025-01-28" ||
                $dateDay == "2025-01-29" ||
                $dateDay == "2025-01-30"
            ) {
                $money = 4;
            }
            //账单
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeTwo,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeSign,
                'ext_id' => $userSignInM->id,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            //用户信息
            $account = new AccountInfo();
            $bool = $account->updateAll([
                'pay_back' => new Expression('pay_back+' . $money),
            ], ['uid' => $uid]);
            if (!$bool) {
                throw new \Exception('Failed to save bill record');
            }
            $transaction->commit();
            //发送红包
            // 计算连续签到天数。
//            $num = $this->getConsecutiveSignInDays($uid, date("Y-m-d", $user->itime));
//            if ($num % 15 == 0) {
//                //判断红包是否已发红包。
//                $redPacket = new UserRedPacket();
//                $redCount = $redPacket->find()
//                    ->where(["uid" => $uid])
//                    ->andWhere(["day" => $dateDay])->count();
//                if ($redCount < 2) {
//                    //开始给用户发红包
//                    $money = $this->generateRedEnvelopeAmount();
//                    $redPacketData = [
//                        'uid' => $uid,
//                        'day' => $dateDay,
//                        'money' => $money,
//                        'type' => 1,
//                        'itime' => time(),
//                        'utime' => time()
//                    ];
//                    $redPacket->insertData($redPacketData);
//                }
//            }
            return true;
        } catch (\Exception $e) {
            FuncHelper::ErrLog('red', [
                'uid' => $uid,
                'day' => $dateDay,
            ], $e->getMessage());
            $transaction->rollBack();
        }
        $this->addError('mesg', ['212', '签到成功但是奖励下发异常，联系客服']);
        return false;

    }


    public function signList($uid)
    {
        $firstDateOfMonth = date('Y-m-01');
        $signInDays = $this->find()
            ->select('day')
            ->where(["uid" => $uid])
            ->andWhere([">=", "day", $firstDateOfMonth])
            ->orderBy("day desc")
            ->limit(31)->column();
        return $signInDays;
    }


    function generateRedEnvelopeAmount($minAmount = 10.00, $maxAmount = 20.00)
    {
        // 初始化红包金额数组
        $amounts = [];

        // 生成所有可能的金额，保留两位小数
        for ($i = $minAmount * 100; $i <= $maxAmount * 100; $i++) {
            $amounts[] = $i / 100;
        }

        // 随机选择一个红包金额
        $totalAmounts = count($amounts);
        $randomIndex = rand(0, $totalAmounts - 1);
        $selectedAmount = $amounts[$randomIndex];

        // 返回随机选中的红包金额，保留两位小数
        return number_format($selectedAmount, 2);
    }


    function getConsecutiveSignInDays($uid, $registerDate)
    {
        $firstDateOfMonth = date('Y-m-01');
        if ($registerDate < $firstDateOfMonth) {
            $registerDate = $firstDateOfMonth;
        }
        $days = $this->find()->select(['day'])
            ->where(['uid' => $uid])
            ->andWhere([">=", "day", $registerDate])
            ->orderBy("day desc")
            ->limit(31)
            ->column();
        $continuousDay = 0;
        $nowDate = Date("Y-m-d");
        $yesterday = date('Y-m-d', strtotime('-1 day'));
        $lastDay = null;
        foreach ($days as $index => $date) {
            if ($index == 0) {
                if ($date == $nowDate || $date == $yesterday) {
                    $continuousDay++;
                    $lastDay = date('Y-m-d', strtotime('-1 day', strtotime($date)));
                    continue;
                }
                break;
            }
            //下一次循环
            if ($lastDay != $date) {
                break;
            }
            $continuousDay++;
            $lastDay = date('Y-m-d', strtotime('-1 day', strtotime($date)));
        }
        return $continuousDay;
    }
}