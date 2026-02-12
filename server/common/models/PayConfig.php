<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;
use common\helpers\SignHelper;
use common\helpers\HttpHelper;

/**
 * ContactForm is the model behind the contact form.  支付配置
 */
class PayConfig extends BaseModel {

    protected $table = 't_pay_config';

    public static function tableName() {
        return '{{t_pay_config}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['payNo', 'number'], //编号
            ['payname', 'string'], //支付名称
            ['minMoney', 'number'], //最小金额
            ['maxMoney', 'number'], //最大金额
            ['appKey', 'string'], //appkey
            ['appSecret', 'string'], //Secret
            ['appPrivate', 'string'], //private
            ['remarks', 'string'], //备注
            ['payConfigType', 'number'], //支付类型 。1支付宝 2微信  3银行卡
            ['payType', 'number'], //支付启用类型 。1投资 。 2备付金充值 。3混合
            ['sort', 'number'], //备注
            ['agent_code', 'string'], //支付编码
            ['payUrl', 'string'], //下单地址
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];
    public $payConfigType = [
        1 => '支付宝',
        2 => '微信',
        3 => '银行卡',
        4 => '备付金',
        5 => '银行卡转帐'
    ];

    public static function selectColumn() {
        return self::$key;
    }

    public function addPayConfigData($payNo, $payname, $minMoney, $maxMoney, $appKey, $appSecret, $appPrivate, $remarks,
            $sort, $payConfigType, $agent_code, $payUrl, $payType) {

        $data = [
            'payNo' => $payNo, //编号
            'payname' => $payname, //支付名称
            'minMoney' => $minMoney, //最小金额
            'maxMoney' => $maxMoney, //最大金额
            'appKey' => $appKey, //appkey
            'appSecret' => $appSecret, //Secret
            'appPrivate' => $appPrivate, //private
            'remarks' => $remarks, //备注
            'sort' => $sort,
            'payConfigType' => $payConfigType,
            'payType' => $payType,
            'agent_code' => $agent_code, //支付编码
            'payUrl' => $payUrl, //下单地址
            'type' => 1, //状态  1为成功可使用   2为已使用
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    return true;
                } else {
                    $this->addError('mesg', ['212', '添加失败']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getPayConfigList($page = 1, $limit = 10, $fields = []) {
        $where = [
            'and'
        ];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

    /**
     * 修改数据
     * @param type $id
     * @param type $title
     * @param type $author
     * @param type $coverUrl
     * @param type $content
     * @param type $type
     * @return boolean
     */
    public function updatePayConfigData($id, $payNo, $payname, $minMoney, $maxMoney, $appKey, $appSecret,
            $appPrivate, $remarks, $sort, $type, $payConfigType, $agent_code, $payUrl, $payType) {
        $update = [];
        if (!empty($payNo)) {
            $update['payNo'] = $payNo;
        }
        if (!empty($payname)) {
            $update['payname'] = $payname;
        }
        if (!empty($minMoney)) {
            $update['minMoney'] = $minMoney;
        }
        if (!empty($maxMoney)) {
            $update['maxMoney'] = $maxMoney;
        }
        if (!empty($appKey)) {
            $update['appKey'] = $appKey;
        }
        if (!empty($appSecret)) {
            $update['appSecret'] = $appSecret;
        }
        if (!empty($appPrivate)) {
            $update['appPrivate'] = $appPrivate;
        }
        if (!empty($remarks)) {
            $update['remarks'] = $remarks;
        }
        if (!empty($sort)) {
            $update['sort'] = $sort;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (!empty($payConfigType)) {
            $update['payConfigType'] = $payConfigType;
        }
        if (!empty($agent_code)) {
            $update['agent_code'] = $agent_code;
        }
        if (!empty($payUrl)) {
            $update['payUrl'] = $payUrl;
        }
        if (!empty($payType)) {
            $update['payType'] = $payType;
        }

        if (empty($update)) {
            $this->addError('mesg', ['211', '修改数据不能为空']);
            return false;
        }

        $boor = $this->updateAll($update, ['id' => $id]);
        if ($boor) {
            return true;
        }
        $this->addError('mesg', ['211', '修改失败']);
        return false;
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientPayConfigList($page = 1, $limit = 10, $money, $payConfigType, $fields = [], $payConfigNo = null, $payType = 1) {

        $rediskey = __METHOD__ . $page . $limit . $money . $payConfigType . $payType;
        // 兼容：部分环境未实现 Redis 缓存方法，这里做安全降级
        $redisData = method_exists($this, 'getRedisCacheOperation')
            ? $this->getRedisCacheOperation(md5($rediskey))
            : null;
        if (!empty($redisData)) {
            //return $redisData;
        }

        $where = [
            'and',
            ['=', 'type', 1],
            ['<=', 'minMoney', $money],
            ['>=', 'maxMoney', $money],
            ['=', 'payConfigType', $payConfigType],
            ['or',
                ['=', 'payType', $payType],
                ['=', 'payType', 3]
            ]
        ];

        if (!empty($payConfigNo)) {
            $where[] = ['=', 'payNo', $payConfigNo];
        }
        self::$key = $fields;
        $data = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-sort'])->where($where)->all();

        //更新缓存（如未实现 Redis 方法则自动忽略）
        if (property_exists($this, 'redisTime')) {
            $time = $this->redisTime;
        } else {
            $time = 300;
        }
        if (method_exists(self::class, 'redisCacheOperation')) {
            self::redisCacheOperation(md5($rediskey), $data, $time);
        }

        return $data;
    }

    /**
     * 获取支付url
     * @param type $orderId
     * @param type $uid
     * @param type $money
     * @param type $payConfigType
     * @param type $ip
     * @return boolean
     */
    public function getPayConfigUrl($orderId, $uid, $money, $payConfigType, $ip, $payConfigNo = null, $payType = 1) {
        $fields = [];
        $payData = $this->getClientPayConfigList(1, 10, $money, $payConfigType, $fields, $payConfigNo, $payType);
        $url = '';
        $returnData = [];

        foreach ($payData as $key => $value) {
            $class = 'PayThoroughfare' . $value['payNo'];

            if (method_exists($this, $class)) {
                //try {
                $url = $this->$class($orderId, $money, $payConfigType, $ip, $value, $uid);
//                } catch (\Exception $e) {
//                    $url = '';
//                    Yii::info('payData--error-------' . $value['payNo'] . $e,
//                            'request');
//                }
                if (!empty($url)) {
                    $returnData['url'] = $url;
                    $returnData['payNo'] = $value['payNo'];
                    break;
                }
            }
        }
        if (!empty($returnData)) {
            return $returnData;
        }
        return false;
    }

    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getPassagewayTerraceIDMessage($payNo) {
        $data = self::find()->where(['payNo' => $payNo])->asArray()->one();
        return $data;
    }

    /**
     * 充值
     * @param type $orderId
     * @param type $totalMoney
     * @param type $payType
     * @param type $ip
     * @param type $PayConfigureData
     * @param type $UserID
     * @return boolean
     */
    public function PayThoroughfare1($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {
        // return 'http://www.baidu.com';
        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');
        $app_id = $PayConfigureData['appKey'];
        $appSecret = $PayConfigureData['appSecret'];
        $agent_code = 'O822';
        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];
        $url = "http://openapi.shangdubook.com/Api/Pay/unionOrderChange";
        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        $post_data = [
            'app_id' => $app_id,
            'agent_code' => $agent_code,
            'out_uid' => $UserID,
            'out_trade_no' => $orderId,
            'amount' => $totalMoney,
            'currency' => 2,
            'timestamp' => time(),
            'callback_url' => $notify . '/call-back/manage' . $PayConfigureData['payNo'],
            'create_ip' => $ip, //'171.216.219.102', //SignHelper::get_client_ip_simple(),
                // 'is_auto_change' => 0
        ];
//    ];
        $post_data['sign'] = SignHelper::checkSignNew1($post_data, $appSecret);
        //echo '<pre>';
        $rs = HttpHelper::httpPostDataNew1($url, $post_data);

        $rs_arr = json_decode($rs, true);
        if (!empty($rs_arr['data']['pay_url'])) {

            return $rs_arr['data']['pay_url'];
        }
        return false;

//        ];
//        $res = HttpHelper::httpPostJsonData1($url, $p_data, 5, $header);
//        $res = json_decode($res, true);
//        if (!empty($res['code']) && $res['code'] == '200') {
//            if ($PayConfigureData['returnType'] == 1) {
//                return $res['data']['payUrl'];
//            } else {
//                return $res['data']['payCode'];
//            }
//        }
//        Yii::info('payData--error-------1res' . json_encode($res), 'request');
//        return false;
    }

    /**
     * 2号平台回调
     * @param mixed $data
     */
    public function CallBack1($data) {
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['out_trade_no']) && !empty($data['status'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(1);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew1($data, $payConfigureData['appSecret']);
                if ($checkSign == $sign && $data['status'] == 3) {//签名
                    return $data['out_trade_no'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare2($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {
        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];
        if ($payConfigType == 1) {
            $agent_code = '888';
        } else if ($payConfigType == 2) {
            $agent_code = '999';
        } else {
            return false;
        }

        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];
        $url = "http://acrossthesea.champion999.one/api/newOrder";
        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];




        $post_data = [
            'merchantId' => $app_id, //    商户号:商户后台查看
            'orderId' => $orderId, //       商户订单号:订单长度10-50位;可传字母或数字;应确保订单号唯一性
            'orderAmount' => $totalMoney, //   订单金额:单位元,可为整数,也可最多保留2位小数
            'channelType' => $agent_code, //   通道编号:商户后台查看
            'notifyUrl' => $notify . '/call-back/manage' . $PayConfigureData['payNo'], //    异步通知地址:订单成功后会通知此地址
                //sign          签名:见公共签名规则
        ];
//    ];
        $post_data['sign'] = SignHelper::checkSignNew2($post_data, $appSecret);

        $rs = HttpHelper::httpPostDataNew1($url, $post_data);

        $rs_arr = json_decode($rs, true);
        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['data']['payUrl'])) {

            return $rs_arr['data']['payUrl'];
        }
        return false;
    }

    /**
     * 2号平台回调
     * @param mixed $data
     */
    public function CallBack2($data) {
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['orderId']) && !empty($data['merchantId'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(2);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew2($data, $payConfigureData['appSecret']);
                if ($checkSign == $sign) {//签名
                    return $data['orderId'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare3($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];
        if ($payConfigType == 1) {
            $agent_code = '888';
        } else if ($payConfigType == 2) {
            $agent_code = '999';
        } else {
            return false;
        }

        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];
        $url = "http://acrossthesea.champion999.one/api/newOrder";
        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];



        // $url = "http://acrossthesea.champion999.one/api/newOrder";

        $post_data = [
            'merchantId' => $app_id, //    商户号:商户后台查看
            'orderId' => $orderId, //       商户订单号:订单长度10-50位;可传字母或数字;应确保订单号唯一性
            'orderAmount' => $totalMoney, //   订单金额:单位元,可为整数,也可最多保留2位小数
            'channelType' => $agent_code, //   通道编号:商户后台查看
            'notifyUrl' => $notify . '/call-back/manage' . $PayConfigureData['payNo'], //    异步通知地址:订单成功后会通知此地址
                //sign          签名:见公共签名规则
        ];
//    ];
        //  $model = new SignHelper();
        $post_data['sign'] = SignHelper::checkSignNew2($post_data, $appSecret);

        $rs = HttpHelper::httpPostDataNew1($url, $post_data);
        //Yii::info('payData--error-------1res' . $rs, 'request');

        $rs_arr = json_decode($rs, true);
        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['data']['payUrl'])) {

            return $rs_arr['data']['payUrl'];
        }
        return false;
    }

    /**
     * 3号平台回调
     * @param mixed $data
     */
    public function CallBack3($data) {
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['orderId']) && !empty($data['merchantId'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(2);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew2($data, $payConfigureData['appSecret']);
                if ($checkSign == $sign) {//签名
                    return $data['orderId'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare4($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];

        if ($payConfigType == 1) {
            $agent_code = '905';
        } else if ($payConfigType == 2) {
            $agent_code = '905';
        } else if ($payConfigType == 3) {
            $agent_code = '905';
        } else {
            return false;
        }

        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "https://ssfpay.caishengpay.com/api/payment/pay";
        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];
        //扫码
        $post_data = array(
            "pay_memberid" => $app_id,
            "pay_orderid" => $orderId,
            "pay_amount" => $totalMoney,
            "pay_applydate" => date("Y-m-d H:i:s"),
            "pay_bankcode" => $agent_code,
            "pay_notifyurl" => $notify . '/call-back/manage' . $PayConfigureData['payNo'],
            "pay_callbackurl" => "http://www.baidu.com",
            "pay_orderip" => $ip,
        );

        $sign = SignHelper::checkSignNew4($post_data, $appSecret);

        $post_data["pay_md5sign"] = $sign;
        $post_data['pay_attach'] = $UserID;
        $post_data['pay_productname'] = '购买商品';
        $post_data['type'] = "json"; //json  或  html


        $rs = HttpHelper::httpPostDataNew4($url, $post_data);
        $rs_arr = json_decode($rs, true);
        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['data']['pay_url'])) {

            return $rs_arr['data']['pay_url'];
        }
        return false;
    }

    /**
     * 4号平台回调
     * @param mixed $data
     */
    public function CallBack4($data) {
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['orderid']) && !empty($data['returncode'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(4);
                if (empty($payConfigureData)) {
                    return false;
                }
                $returnArray = array(// 返回字段
                    "memberid" => $data["memberid"], // 商户ID
                    "orderid" => $data["orderid"], // 订单号
                    "amount" => $data["amount"], // 交易金额
                    "true_amount" => $data["true_amount"], //实付金额
                    "datetime" => $data["datetime"], // 交易时间
                    "transaction_id" => $data["transaction_id"], // 支付流水号
                    "returncode" => $data["returncode"],
                );

                $checkSign = SignHelper::checknotifySignNew4($returnArray, $payConfigureData['appSecret']);
                if ($checkSign == $sign && $data["returncode"] == "00") {//签名
                    return $data['orderid'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare5($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];

        if ($payConfigType == 1) {
            $agent_code = '824';
        } else if ($payConfigType == 2) {
            $agent_code = '824';
        } else if ($payConfigType == 3) {
            $agent_code = '824';
        } else {
            return false;
        }


        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "http://18.162.218.146:9098/gateway/pay";
        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        //扫码
        $post_data = array(
            'sign_type' => 'MD5',
            'format' => "JSON",
            'charset' => 'utf-8',
            'mch_code' => $app_id,
            'out_trade_no' => $orderId,
            'method' => $agent_code,
            'amount' => $totalMoney,
            'notify_url' => $notify . '/call-back/manage' . $PayConfigureData['payNo'],
        );
        $sign = SignHelper::checkSignNew5($post_data, $appSecret);

        $post_data["sign"] = $sign;

        $rs = HttpHelper::httpPostDataNew5($url, $post_data);
        $rs_arr = json_decode($rs, true);

        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['pay_url'])) {

            return $rs_arr['pay_url'];
        }
        return false;
    }

    /**
     * 5号平台回调
     * @param mixed $data
     */
    public function CallBack5($data) {
        if (!empty($data)) {
            $sign = $data['plat_sign'];
            unset($data['plat_sign']);
            if (!empty($data['out_trade_no']) && !empty($data['status'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(5);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew5($data, $payConfigureData['appSecret']);
                if ($checkSign == $sign && $data["status"] == "SUCCESS") {//签名
                    return $data['out_trade_no'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare6($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];
        $appPrivate = $PayConfigureData['appPrivate'];
        if ($payConfigType == 1) {
            $agent_code = '8003';
        } else if ($payConfigType == 2) {
            $agent_code = '8003';
        } else if ($payConfigType == 3) {
            $agent_code = '8003';
        } else {
            return false;
        }
        // $agent_code = '8016';
        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "http://hbwz.xyz:56700/api/pay/create_order";

        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        //扫码
        $post_data = array(
            'mchId' => $app_id,
            // 'appId' => $appPrivate,
            'productId' => $agent_code,
            'mchOrderNo' => $orderId,
            'amount' => $totalMoney * 100,
            'currency' => 'cny',
            'notifyUrl' => $notify . '/call-back/manage' . $PayConfigureData['payNo'],
            'subject' => '商品1',
            'body' => "商品描述",
            'reqTime' => date('YmdHis'),
            'version' => "1.0"
        );
        $sign = SignHelper::checkSignNew4($post_data, $appSecret);

        $post_data["sign"] = $sign;

        $rs = HttpHelper::httpPostDataNew4($url, $post_data);
        $rs_arr = json_decode($rs, true);

        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['payUrl'])) {

            return $rs_arr['payUrl'];
        }
        return false;
    }

    /**
     * 6号平台回调
     * @param mixed $data
     */
    public function CallBack6($data) { //income  分
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['mchOrderNo']) && !empty($data['status'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(6);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew4($data, $payConfigureData['appSecret']);
                if ($checkSign == $sign && in_array($data["status"], [2, 3])) {//签名
                    return $data['mchOrderNo'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare7($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];
        $appPrivate = $PayConfigureData['appPrivate'];
        if ($payConfigType == 1) {
            $agent_code = '8003';
        } else if ($payConfigType == 2) {
            $agent_code = '8003';
        } else if ($payConfigType == 3) {
            $agent_code = '8003';
        } else {
            return false;
        }
        // $agent_code = '8016';
        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "http://hbwz.xyz:56700/api/pay/create_order";

        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        //扫码
        $post_data = array(
            'mchId' => $app_id,
            // 'appId' => $appPrivate,
            'productId' => $agent_code,
            'mchOrderNo' => $orderId,
            'amount' => $totalMoney * 100,
            'currency' => 'cny',
            'notifyUrl' => $notify . '/call-back/manage' . $PayConfigureData['payNo'],
            'subject' => '商品1',
            'body' => "商品描述",
            'reqTime' => date('YmdHis'),
            'version' => "1.0"
        );
        $sign = SignHelper::checkSignNew4($post_data, $appSecret);

        $post_data["sign"] = $sign;

        $rs = HttpHelper::httpPostDataNew4($url, $post_data);
        $rs_arr = json_decode($rs, true);

        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['payUrl'])) {

            return $rs_arr['payUrl'];
        }
        return false;
    }

    /**
     * 6号平台回调
     * @param mixed $data
     */
    public function CallBack7($data) { //income  分
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['mchOrderNo']) && !empty($data['status'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(7);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew4($data, $payConfigureData['appSecret']);
                if ($checkSign == $sign && in_array($data["status"], [2, 3])) {//签名
                    return $data['mchOrderNo'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare8($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];
        // $appPrivate = $PayConfigureData['appPrivate'];
        if ($payConfigType == 1) {
            $agent_code = '1';
        } else if ($payConfigType == 2) {
            $agent_code = '1';
        } else if ($payConfigType == 3) {
            $agent_code = '1';
        } else {
            return false;
        }
        // $agent_code = '8016';
        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "https://api.huojian68.com/v1/payment";

        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        //扫码
        $post_data = array(
            'app_id' => $app_id,
            'amount' => $totalMoney,
            'order_no' => $orderId,
            'ts' => time(),
            'typ_id' => $agent_code,
            'notify' => $notify . '/call-back/manage' . $PayConfigureData['payNo'],
        );
        $sign = SignHelper::checkSignNew5($post_data, $appSecret);

        $post_data["sign"] = $sign;

        $rs = HttpHelper::httpPostDataNew1($url, $post_data);
        $rs_arr = json_decode($rs, true);

        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['payload'])) {

            return $rs_arr['payload'];
        }
        return false;
    }

    /**
     * 8号平台回调
     * @param mixed $data
     */
    public function CallBack8($data) { //income  分
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['order_no']) && !empty($data['status'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(8);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew5($data, $payConfigureData['appSecret']);

                if ($checkSign == $sign && in_array($data["status"], [2])) {//签名
                    return $data['order_no'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare9($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];
        // $appPrivate = $PayConfigureData['appPrivate'];
        if ($payConfigType == 1) {
            $agent_code = '32';
        } else if ($payConfigType == 2) {
            $agent_code = '32';
        } else if ($payConfigType == 3) {
            $agent_code = '32';
        } else {
            return false;
        }
        // $agent_code = '8016';
        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "https://open.wmpay.cn/intf/wapwpay.html";

        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        //扫码
        $post_data = array(
            'customerid' => $app_id,
            'sdcustomno' => $orderId,
            'orderAmount' => $totalMoney * 100,
            'cardno' => $agent_code,
            'noticeurl' => $notify . '/call-back/manage' . $PayConfigureData['payNo'],
            'backurl' => 'http://ww.baidu.com',
        );
        echo '<pre>';
        $sign = SignHelper::checkSignNew9($post_data, $appSecret);

        $post_data["Sign"] = $sign;
        $post_data["mark"] = '1';

        $rs = HttpHelper::httpPostDataNew1($url, $post_data);
        $rs_arr = json_decode($rs, true);

        var_dump($post_data);
        var_dump($rs);
        var_dump($rs_arr);
        exit;
        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['payload'])) {

            return $rs_arr['payload'];
        }
        return false;
    }

    public function PayThoroughfare10($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey'];

        $appSecret = $PayConfigureData['appSecret'];
        // $appPrivate = $PayConfigureData['appPrivate'];
        if ($payConfigType == 1) {
            $agent_code = '10032';
        } else if ($payConfigType == 2) {
            $agent_code = '10032';
        } else if ($payConfigType == 3) {
            $agent_code = '10032';
        } else {
            return false;
        }
        // $agent_code = '8016';
        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "https://pay.rende.one/api/v1";

        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        //扫码
        $post_data = array(
            'api_key' => $app_id,
            'action' => 'order',
            'timestamp' => time(),
            'data' => [
                'gate_id' => $agent_code,
                'order_number' => $orderId,
                'amount' => $totalMoney,
                'notify_url' => $notify . '/call-back/manage' . $PayConfigureData['payNo']
            ],
        );
        $sign = SignHelper::checkSignNew10($post_data['api_key'], $appSecret, $post_data['action'], $post_data['timestamp']);

        $post_data["sign"] = $sign;

        $rs = HttpHelper::httpPostDataNew5($url, $post_data);
//        echo '<pre>';
//        var_dump($post_data);
//        var_dump($rs);
        $rs_arr = json_decode($rs, true);
//        var_dump($rs_arr);
//        Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['data']['url'])) {

            return $rs_arr['data']['url'];
        }
        return false;
    }

    /**
     * 10号平台回调
     * @param mixed $data
     */
    public function CallBack10($data) { //income  分
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['data']['order_number']) && !empty($data['data']['status'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                //amount
                $payConfigureData = self::getPassagewayTerraceIDMessage(10);
                if (empty($payConfigureData)) {
                    return false;
                }
                //$checkSign = SignHelper::checkSignNew5($data, $payConfigureData['appSecret']);
                $checkSign = SignHelper::checkSignNew10($payConfigureData['appKey'], $payConfigureData['appSecret'], 'callback', $data['data']['timestamp']);

                if ($checkSign == $sign && in_array($data['data']['status'], [2])) {//签名
                    return $data['data']['order_number'];
                }
            }
        }
        return false;
    }

    public function PayThoroughfare11($orderId, $totalMoney, $payConfigType, $ip, $PayConfigureData, $UserID = 1) {

        $totalMoney = intval($totalMoney);
        $notify = SystemConfigure::getSystemConfigure('callback_url');

        $app_id = $PayConfigureData['appKey']; //448

        $appSecret = $PayConfigureData['appSecret']; //GHIYWPPFDJ0G8YKKVHFN861PHD86UB4SALP7KIL5YSV7Z4GY7QRDJ2S1X44XZFHLY1VNRJDUENF4AQV9WMUOLILVDSD6BSDJVBEUCSVCEBNBCUMRRCPXGEZHCA5MKSK
        $appPrivate = $PayConfigureData['appPrivate'];//29141500ac724953a9a2d55b47e2b98e
        if ($payConfigType == 1) {
            $agent_code = '8021';
        } else if ($payConfigType == 2) {
            $agent_code = '8004';
        } else if ($payConfigType == 3) {
            $agent_code = '8021';
        } else {
            return false;
        }
        // $agent_code = '8016';
        if (!empty($PayConfigureData['agent_code']))
            $agent_code = $PayConfigureData['agent_code'];

        $url = "http://lheng.xyz:56700/api/pay/create_order";

        if (!empty($PayConfigureData['payUrl']))
            $url = $PayConfigureData['payUrl'];

        //扫码
        $amount = $totalMoney * 1 * 100; //元转换为分
        $post_data = array(
            "mchId" => $app_id, //商户ID
            "appId" => $appPrivate, //商户应用ID
            "productId" => $agent_code, //支付产品ID
            "mchOrderNo" =>$orderId, // 商户订单号
            "currency" => 'cny', //币种
            "amount" => $amount . "", // 支付金额
            "clientIp" => $ip, //客户端IP
            "device" => 'ios10.3.1', //客户端设备
            "returnUrl" => 'http://www.baidu.com', //支付结果前端跳转URL
            "notifyUrl" => $notify . '/call-back/manage' . $PayConfigureData['payNo'], //支付结果后台回调URL
            "subject" => '网络购物', //商品主题
            "body" => '网络购物', //商品描述信息
//            "param1" => '', //扩展参数1
//            "param2" => '', //扩展参数2
//            "extra" => '', //附加参数
            "reqTime" => date("YmdHis"), //请求时间, 格式yyyyMMddHHmmss
            "version" => '1.0'  //版本号, 固定参数1.0
        );
//        echo '<pre>';
//        var_dump($post_data);
        
        
         $sign = SignHelper::checkSignNew11($post_data, $appSecret);
      //   var_dump($sign);
        $post_data["sign"] = $sign;

        $rs = HttpHelper::httpPostDataNew4($url, $post_data);
       // var_dump($rs);
        $rs_arr = json_decode($rs, true);

        //Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
        if (!empty($rs_arr['payUrl'])) {

            return $rs_arr['payUrl'];
        }
        return false;
        
        
        
//        $sign = paramArraySign($paramArray, $mchKey);  //签名
//        $paramArray["sign"] = $sign;
//
//        $paramsStr = http_build_query($paramArray); //请求参数str
//        $response = httpPost($url, $paramsStr);
//
//        ////////
//        $sign = SignHelper::checkSignNew10($post_data['api_key'], $appSecret, $post_data['action'], $post_data['timestamp']);
//
//        $post_data["sign"] = $sign;
//
//        $rs = HttpHelper::httpPostDataNew5($url, $post_data);
////        echo '<pre>';
////        var_dump($post_data);
////        var_dump($rs);
//        $rs_arr = json_decode($rs, true);
////        var_dump($rs_arr);
////        Yii::info('payData--error-------1res' . json_encode($rs_arr), 'request');
//        if (!empty($rs_arr['data']['url'])) {
//
//            return $rs_arr['data']['url'];
//        }
//        return false;
    }
    
    
        /**
     * 10号平台回调
     * @param mixed $data
     */
    public function CallBack11($data) { //income  分
        if (!empty($data)) {
            $sign = $data['sign'];
            unset($data['sign']);
            if (!empty($data['mchOrderNo']) && !empty($data['status'])) {
//                $orderIdData = RechargeOrder::getOrderIdData($data['merchantOrderId']);
//                if (empty($orderIdData)) {
//                    return false;
//                }
                $payConfigureData = self::getPassagewayTerraceIDMessage(11);
                if (empty($payConfigureData)) {
                    return false;
                }
                $checkSign = SignHelper::checkSignNew11($data, $payConfigureData['appSecret']);
                if ($checkSign == $sign && in_array($data["status"], [2, 3])) {//签名
                    return $data['mchOrderNo'];
                }
            }
        }
        return false;
    }

}
