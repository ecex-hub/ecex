<?php

namespace common\service;

use common\components\FuncHelper;
use common\models\AccountInfo;
use common\models\BillRecord;
use common\models\Pay;
use common\models\Sys;
use common\models\RequestLog;
use yii\db\Expression;

class QiaotouService
{
    const secret_key = "D6XZAKLEVDGBQXBFUZAH8BAEVFL4O0CXDMIFLU0KLOQRTNMRBVOZPIH83UJQJJEIIQPN8FNJFBUDSCVU8WWLOPQGVZUCZZ1MQZTALV4XBFFGEARGNIH62CARHY6RSFSF";
    const mchId = "10459";
    const payOrderUrl = "http://pay.qtpal.click/api/pay/create_order";

    public function generateSign($data, $key)
    {
        // 1. 移除值为空的参数和 sign 参数
        foreach ($data as $paramKey => $paramValue) {
            if ($paramValue === "" || $paramKey === "sign") {
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
        // 去除最后一个 &
        $stringA = rtrim($stringA, "&");

        // 4. 拼接 key 生成 stringSignTemp
        $stringSignTemp = $stringA . "&key=" . $key;

        // 5. 对 stringSignTemp 进行 MD5 运算并转为大写
        $signValue = strtoupper(md5($stringSignTemp));
        return $signValue;
    }

    public function sendPostRequest($url, $data)
    {
        // 初始化 cURL
        $ch = curl_init();
        // 将数据转换为 URL 编码的查询字符串格式
        $postData = http_build_query($data);
        // 设置 cURL 选项
        curl_setopt($ch, CURLOPT_URL, $url); // 请求的 URL
        curl_setopt($ch, CURLOPT_POST, true); // 使用 POST 方法
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postData); // POST 数据
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // 返回响应结果，而不是直接输出

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
        $data['amount']=$data['amount']*100;
        $notify = \Yii::$app->params['base_url']."/callback/qiaotou";
        $returnUrl = \Yii::$app->params['return_url'];
        try {
            $requestData = [
                'mchId' => self::mchId,
                'productId' => $data['product_id'],
                'mchOrderNo' => $data['otn'],
                'amount' => $data['amount'],
                'notifyUrl' => $notify,
                'returnUrl'=>$returnUrl,
                'sign' => $this->generateSign([
                    'mchId' => self::mchId,
                    'productId' => $data['product_id'],
                    'mchOrderNo' => $data['otn'],
                    'amount' => $data['amount'],
                    'notifyUrl' => $notify,
                    'returnUrl'=>$returnUrl,
                ], self::secret_key)
            ];
            list($code, $msg) = $response = $this->sendPostRequest(self::payOrderUrl, $requestData);
            $payModel = new Pay();
            $payModel->updateAll([
                'request' => json_encode($requestData),
                'response' => json_encode($msg),
            ], ['id' => $data['pay_id']]);
            if ($code) {
                throw new \Exception($msg);
            }
            $ret = json_decode($msg,true);
            if ($ret['retCode'] != "SUCCESS") {
                throw new \Exception($ret['errDes']);
            }
            return [$code, [
                "payUrl" => $ret['payParams']['payUrl']
            ]];
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
        $otn = $data['mchOrderNo'];
        try {
            $transaction = \Yii::$app->db->beginTransaction();
            $payModel = new Pay();
            $payInfo = $payModel->getInfo($otn);
            if (empty($payInfo)) {
                throw new \Exception('订单不存在');
            }
            if ($payInfo['type'] != 1) {
                throw new \Exception('订单已支付');
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
            FuncHelper::ErrLog('pay_callback_fuhai', [
            ], $e->getMessage());
            return false;
        }
    }
}