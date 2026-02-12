<?php

namespace common\models;


use common\components\FuncHelper;
use common\service\AlinService;
use common\service\DashengService;
use common\service\FuhaiService;
use common\service\PTZhongwaiService;
use common\service\QiaotouService;
use common\service\SihaiService;
use common\service\YunsifangService;
use yii\db\Expression;
use yii;

class Pay extends BaseModel
{

    protected $table = 't_pay';

    public static function tableName()
    {
        return '{{t_pay}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标记id
            ['otn', 'string'], //订单
            ['money', 'number'], //金额
            ['pay_type', 'number'], //支付渠道
            ['sys_id', 'number'], //支付ID
            ['type', 'number'], //状态  1-创建 2-通过 3-拒绝
            ['request', 'string'], //状态  1-创建 2-通过 3-拒绝
            ['response', 'string'], //状态  1-创建 2-通过 3-拒绝
            ['itime', 'number'], //
            ['utime', 'number'], //
            ['paytime', 'number'], //
            ['callback', 'string'], //

        ];
    }
    //$payMchArr = [
    //1 => '福海支付',
    //2 => '桥头支付',
    //3 => 'alin支付',
    //4 => '四海支付',
    //5 => '四海-云四方',
    //6 => '大圣支付',
    //7 => 'PT中外支付',
    //];
    //$payTypeArr = [
    //1 => '支付宝',
    //2 => '微信',
    //3 => '银行卡',
    //4 => '云闪付',
    //];
    //https://github.com/zoujingli/WeChatDeveloper
    //https://pay.yansongda.cn/docs/v2/alipay/pay.html#%E8%AE%A2%E5%8D%95%E9%85%8D%E7%BD%AE%E5%8F%82%E6%95%B0-1
    public function addPay($user, $sysId, $money, $ip)
    {
        $sys = new Sys();
        $payInfo = $sys->getInfo($sysId);
        if (empty($payInfo)) {
            return [-1, '渠道不存在'];
        }
        if ($money < $payInfo->min_price) {
            return [-1, '最小支付价格' . $payInfo->min_price];
        }
        if ($money > $payInfo->max_price) {
            return [-1, '最大支付价格' . $payInfo->max_price];
        }
        if (!is_int($money)) {
            return [-1, '必须是整数'];
        }
        $uid = $user->uid;
        $uuid = FuncHelper::uuid();
        $payId = 0;
        try {
            $data = [
                'uid' => $uid,
                'otn' => $uuid,
                'money' => $money,
                'pay_type' => $payInfo->pay_type,
                'sys_id' => $sysId,
                'itime' => time(),
                'utime' => time(),
            ];
            if (!$this->insertData($data)) {
                throw new \Exception('Failed to save bill record');
            }
            $payId = $this->id;
            // 提交事务
        } catch (\Exception $e) {
            FuncHelper::ErrLog('pay', [
                'uid' => $uid,
                'pay_id' => $payId,
                'money' => $money,
            ], $e->getMessage());
            return [-1, '添加失败'];
        }
        if ($payInfo->pay_mch == 1) {
            $data = [
                'pay_id' => $payId,
                "otn" => $uuid,
                "amount" => $money,
            ];
            if ($payInfo->pay_type == 1) {
                $data['product_code'] = 126;
            } else if ($payInfo->pay_type == 2) {
                $data['product_code'] = 132;
            } else if ($payInfo->pay_type == 3) {
                $data['product_code'] = 118;
            } else if ($payInfo->pay_type == 4) {
                $data['product_code'] = 128;
            }
            list($code, $msg) = (new FuhaiService())->payOrder($data);
            if ($code) {
                return [-1, '失败'];
            }
            return [0, $msg];
        } else if ($payInfo->pay_mch == 2) {
            $data = [
                'pay_id' => $payId,
                "otn" => $uuid,
                "amount" => $money,
            ];
            //支付宝
            if ($payInfo->pay_type == 1) {
                $data['product_id'] = 8020;
            } else if ($payInfo->pay_type == 2) {
                $data['product_id'] = 8017;
            }
            list($code, $msg) = (new QiaotouService())->payOrder($data);
            if ($code) {
                return [-1, '失败'];
            }
            return [0, $msg];
        } else if ($payInfo->pay_mch == 3) {
            $data = [
                'pay_id' => $payId,
                "otn" => $uuid,
                "amount" => $money,
            ];
            if ($payInfo->pay_type == 1) {
                $data['pay_bankcode'] = 3;
            } else if ($payInfo->pay_type == 2) {
                $data['pay_bankcode'] = 2;
            } else if ($payInfo->pay_type == 4) {
                $data['pay_bankcode'] = 10;
            }
            list($code, $msg) = (new AlinService())->payOrder($data);
            if ($code) {
                return [-1, '失败'];
            }
            return [0, $msg];
        } else if ($payInfo->pay_mch == 4) {
            $data = [
                'pay_id' => $payId,
                "otn" => $uuid,
                "amount" => $money,
                'clientIp' => $ip,
            ];
            if ($payInfo->pay_type == 3) {
                $data['product_id'] = 8025;
            }
            list($code, $msg) = (new SihaiService())->payOrder($data);
            if ($code) {
                return [-1, '失败'];
            }
            return [0, $msg];
        } else if ($payInfo->pay_mch == 5) {
            $data = [
                'pay_id' => $payId,
                "otn" => $uuid,
                "amount" => $money,
                'product_id' => 8036,
                'clientIp' => $ip,
            ];
            list($code, $msg) = (new YunsifangService())->payOrder($data);
            if ($code) {
                return [-1, '失败'];
            }
            return [0, $msg];
        } else if ($payInfo->pay_mch == 6) {
            $data = [
                'pay_id' => $payId,
                "otn" => $uuid,
                "amount" => $money,
            ];
            //大圣
            if ($payInfo->pay_type == 1) {
                $data['product_id'] = 8008;
            }
            if ($payInfo->pay_type == 2) {
                $data['product_id'] = 8001;
            }
            list($code, $msg) = (new DashengService())->payOrder($data);
            if ($code) {
                return [-1, '失败'];
            }
            return [0, $msg];
        } else if ($payInfo->pay_mch == 7) {
 
            $data = [
                'pay_id' => $payId,
                "otn" => $uuid,
                "amount" => $money,
                'clientIp' => $ip,
            ];
            if ($payInfo->pay_type == 1) {
                $data['product_id'] = 333;
            }
            if ($payInfo->pay_type == 2) {
                $data['product_id'] = 123;
            }
            list($code, $msg) = (new PTZhongwaiService())->payOrder($data);
            if ($code) {
                return [-1, '失败'];
            }
            return [0, $msg];
        }
        return [-1, '操作失败'];
    }

    public function alipayConf()
    {
        $config = [
            // 沙箱模式
            'debug' => false,
            // 签名类型 ( RSA|RSA2 )
            'sign_type' => 'RSA2',
            // 应用ID
            'appid' => '2021000122667306',
            // 应用私钥内容 ( 需1行填写，特别注意：这里的应用私钥通常由支付宝密钥管理工具生成 )
            'private_key' => 'MIIEowIBAAKCAQEAn...',
            // 公钥模式，支付宝公钥内容 ( 需1行填写，特别注意：这里不是应用公钥而是支付宝公钥，通常是上传应用公钥换取支付宝公钥，在网页可以复制 )
            'public_key' => 'MIIEowIBAAKCAQEAn',
            // 证书模式，应用公钥证书路径 ( 新版资金类接口转 app_cert_sn，如文件 appCertPublicKey.crt )
            'app_cert_path' => __DIR__ . '/alipay/appPublicCert.crt', // 'app_cert' => '证书内容',
            // 证书模式，支付宝根证书路径 ( 新版资金类接口转 alipay_root_cert_sn，如文件 alipayRootCert.crt )
            'alipay_root_path' => __DIR__ . '/alipay/alipayRootCert.crt', // 'root_cert' => '证书内容',
            // 证书模式，支付宝公钥证书路径 ( 未填写 public_key 时启用此参数，如文件 alipayPublicCert.crt )
            'alipay_cert_path' => __DIR__ . '/alipay/alipayPublicCert.crt', // 'public_key' => '证书内容'
            // 支付成功通知地址
            'notify_url' => '',
            // 网页支付回跳地址
            'return_url' => '',
        ];
        return $config;
    }


    public function getInfo($otn)
    {

        $where = [
            'and',
            ['=', 'otn', $otn],
        ];
        $list = $this->find()
            ->where($where)
            ->asArray()
            ->one();
        return $list;
    }

}