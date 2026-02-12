<?php

namespace common\service;

use common\components\FuncHelper;
use common\models\AccountInfo;
use common\models\BillRecord;
use common\models\Pay;
use common\models\Sys;
use common\models\RequestLog;
use yii\db\Expression;

class AlinService
{
    const secret_key = "wli11yqfnzkccfjex9ouv6dit7rhrhzl";
    const mchId = "250189614";
    const payOrderUrl = "https://aliviptue.meisuobudamiya.net/Pay_Index.html";

    public function generateSign($data, $key)
    {
        // 1. 移除值为空的参数
        foreach ($data as $paramKey => $paramValue) {
            if ($paramValue === "") {
                unset($data[$paramKey]);
            }
        }

        // 2. 按照参数名 ASCII 码从小到大排序
        ksort($data);

        // 3. 拼接成字符串 stringA
        $stringA = "";
        foreach ($data as $paramKey => $paramValue) {
            $stringA .= $paramKey . "=" . $paramValue . "&";
        }

        // 4. 拼接 key 生成 stringSignTemp
        $stringSignTemp = $stringA . "key=" . $key;

        // 5. 对 stringSignTemp 进行 MD5 运算并转为大写
        $signValue = strtoupper(md5($stringSignTemp));

        return $signValue;
    }

    function sendFormUrlEncodedRequest($url, $data)
    {
        // 初始化 cURL
        $ch = curl_init();

        // 将数据编码为 x-www-form-urlencoded 格式
        $postData = http_build_query($data);

        // 设置 cURL 选项
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/x-www-form-urlencoded',
            'Content-Length: ' . strlen($postData)
        ]);

        // 执行请求并获取响应
        $response = curl_exec($ch);

        // 检查是否发生错误
        if (curl_errno($ch)) {
            curl_close($ch);
            return [-1, curl_error($ch)];
        }

        // 关闭 cURL
        curl_close($ch);

        return [0, $response];
    }

    public function payOrder($data)
    {
        $notify = \Yii::$app->params['base_url']."/callback/alin";
        $returnUrl = \Yii::$app->params['return_url'];
        try {
            $requestData = [
                'pay_memberid' => self::mchId,
                'pay_orderid' => $data['otn'],
                'pay_applydate' => date("Y-m-d H:i:s"),
                'pay_bankcode' => $data['pay_bankcode'],
                'pay_callbackurl' => $returnUrl,
                'pay_notifyurl' => $notify,
                'pay_amount' => $data['amount'],
                'pay_productname' => '商品',
                'pay_md5sign' => $this->generateSign([
                    'pay_memberid' => self::mchId,
                    'pay_orderid' => $data['otn'],
                    'pay_applydate' => date("Y-m-d H:i:s"),
                    'pay_bankcode' => $data['pay_bankcode'],
                    'pay_callbackurl' => $returnUrl,
                    'pay_notifyurl' => $notify,
                    'pay_amount' => $data['amount'],
                ], self::secret_key)
            ];
            list($code, $msg) = $response = $this->sendFormUrlEncodedRequest(self::payOrderUrl, $requestData);
            $payModel = new Pay();
            $payModel->updateAll([
                'request' => json_encode($requestData),
                'response' => json_encode($msg),
            ], ['id' => $data['pay_id']]);
            if ($code) {
                throw new \Exception($msg);
            }
            $ret = json_decode($msg,true);
            if (isset($ret['status']) && $ret['status'] == "error") {
                throw new \Exception($ret['msg']);
            }
            $returnData = [
                "payUrl" => $ret['data']
            ];
            return [$code, $returnData];
        } catch (\Exception $e) {
            FuncHelper::ErrLog('pay', [
                'data' => $data,
            ], $e->getMessage());
            return [-1, '支付失败'];
        }
    }

    public function callback($data)
    {
        $params = $data;
        unset($params['sign']);
        $sign = $this->generateSign($params, self::secret_key);
        if (!isset($data['sign'])) {
            return false;
        }
        if ($sign != $data['sign']) {
            return false;
        }
        $otn = $data['orderid'];
        try {
            $transaction = \Yii::$app->db->beginTransaction();
            $payModel = new Pay();
            $payInfo = $payModel->getInfo($otn);
            if (empty($payInfo)) {
                throw new \Exception('订单不存在');
            }
            if ($payInfo['type'] != 1) {
                return true;
            }
            $uid = $payInfo['uid'];
            $money = $payInfo['money'];
            $sys=new Sys();
            $boor = $sys->updateAll([
                'buy_money' => new Expression('buy_money+' . $money)
            ], ['id' => $payInfo['sys_id']]);
            if (empty($boor)) {
                throw new \Exception('Failed to save sys fail');
            }
            //账单
            $billData = [
                'uid' => $uid,
                'money' => $money,
                'money_type' => BillRecord::MoneyTypeOne,
                'bill_unit' => 'add',
                'bill_type' => BillRecord::BillTypeBuyRecharge,
                'itime' => time(),
                'utime' => time(),
            ];
            $billRecord = new BillRecord();
            if (!$billRecord->insertData($billData)) {
                throw new \Exception('Failed to save bill record');
            }
            //支付账单
            $boor = $payModel->updateAll([
                'type' => 2,
                'callback' => json_encode($data),
                'paytime'=>time(),
            ], ['id' => $payInfo['id']]);
            if (empty($boor)) {
                throw new \Exception('Failed to save bill record');
            }
            //用户
            $accountInfo = new AccountInfo();
            $boor = $accountInfo->updateAll([
                'money' => new Expression('money+' . $money)
            ], ['uid' => $uid]);
            if (empty($boor)) {
                throw new \Exception('Failed to update user fail');
            }
            // 提交事务
            $transaction->commit();
            return true;
        } catch (\Exception $e) {
            $transaction->rollBack();
            FuncHelper::ErrLog('pay_callback_alin', [
            ], $e->getMessage());
            return false;
        }
    }
}