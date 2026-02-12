<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  提现配置
 */
class WithdrawalConfig extends BaseModel {

    protected $table = 't_withdrawal_config';

    public static function tableName() {
            return '{{t_withdrawal_config}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['withdrawalNo', 'number'], //编号
            ['withdrawalName', 'string'], //提现名称
            ['minMoney', 'number'], //最小金额
            ['maxMoney', 'number'], //最大金额
            ['appKey', 'string'], //appkey
            ['appSecret', 'string'], //Secret
            ['appPrivate', 'string'], //private
            ['remarks', 'string'], //备注
            ['configType', 'string'], //提现类型 。1银行卡
            ['sort', 'number'], //备注
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }
    
     public $ConfigType = [
        1 => '银行卡'
    ];

    /**
     * 增加提现配置
     * @param type $withdrawalNo
     * @param type $withdrawalName
     * @param type $minMoney
     * @param type $maxMoney
     * @param type $appKey
     * @param type $appSecret
     * @param type $appPrivate
     * @param type $remarks
     * @param type $sort
     * @param type $configType
     * @return boolean
     */
    public function addWithdrawalConfigData($withdrawalNo, $withdrawalName, $minMoney, $maxMoney, $appKey, $appSecret, $appPrivate, $remarks, $sort, $configType) {

        $data = [
            'withdrawalNo' => $withdrawalNo, //编号
            'withdrawalName' => $withdrawalName, //支付名称
            'minMoney' => $minMoney, //最小金额
            'maxMoney' => $maxMoney, //最大金额
            'appKey' => $appKey, //appkey
            'appSecret' => $appSecret, //Secret
            'appPrivate' => $appPrivate, //private
            'remarks' => $remarks, //备注
            'sort' => $sort,
            'configType' => $configType,
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
    public function getWithdrawalConfigList($page = 1, $limit = 10, $fields = []) {
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
    public function updatePayConfigData($id, $withdrawalNo, $withdrawalName, $minMoney, $maxMoney, $appKey, $appSecret, $appPrivate, $remarks, $sort, $type, $configType) {
        $update = [];
        if (!empty($withdrawalNo)) {
            $update['withdrawalNo'] = $withdrawalNo;
        }
        if (!empty($withdrawalName)) {
            $update['withdrawalName'] = $withdrawalName;
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
        if (!empty($configType)) {
            $update['configType'] = $configType;
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
    public function getClientWithdrawalConfigList($page = 1, $limit = 10, $money, $fields = []) {

        $rediskey = __METHOD__ . $page . $limit . $money;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            //return $redisData;
        }

        $where = [
            'and',
            ['=', 'type', 1],
            ['<=', 'minMoney', $money],
            ['>=', 'maxMoney', $money],
        ];
        self::$key = $fields;
        $data = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-sort'])->where($where)->all();

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 三方提现数据
     * @param type $orderId
     * @param type $uid
     * @param type $money
     * @param type $payConfigType
     * @param type $ip
     * @return boolean
     */
    public function getWithdrawalConfigUrl($orderId, $uid, $money, $ip) {
        $payData = $this->getClientWithdrawalConfigList(1, 10, $money);
        $url = '';
        $returnData = [];
        foreach ($payData as $key => $value) {
            $class = 'PayThoroughfare' . $value['withdrawalNo'];
            if (method_exists($this, $class)) {
                try {
                    $data = $this->$class($orderId, $money, $ip, $value, $uid);
                } catch (\Exception $e) {
                    //$boor = false;
                    Yii::info('payData--error-------' . $value['payNo'] . $e,
                            'request');
                }
                if (!empty($data['type'])) {
                    $returnData['type'] = true;
                    $returnData['withdrawalNo'] = $value['withdrawalNo'];
                    $returnData['message'] = $data['message'];
                    break;
                } else if (!empty($data)) {
                    $returnData['type'] = false;
                    $returnData['withdrawalNo'] = $value['withdrawalNo'];
                    $returnData['message'] = $data['message'];
                }
            }
        }
        if (!empty($returnData)) {

            return $returnData;
        }
        $returnData['type'] = false;
        $returnData['withdrawalNo'] = 0;
        $returnData['message'] = '暂无合适通道';
        return $returnData;
    }

    /**
     * 提现
     * @param type $orderId
     * @param type $totalMoney
     * @param type $payType
     * @param type $ip
     * @param type $PayConfigureData
     * @param type $UserID
     * @return boolean
     */
    public function PayThoroughfare1($orderId, $totalMoney, $ip, $WithdrawalConfigureData, $UserID = 1) {

        $data = [
            'type' => true,
            'message' => '错误信息'
        ];

        return $data;

//        $url = "https://client.brcashypay.com/prod-api/api/payIn";   //提交地址
//        $mch_id = $PayConfigureData['appKey']; //商户后台API管理获取
//        $Md5key = $PayConfigureData['appSecret'];  //
//        $payTypeData = ['1' => 140]; //
////        if (!isset($payTypeData[$payType])) {
////            return false;
////        }
//        $p_data = array(
//            'currency' => 'BRL', //货币代码
//            'payType' => 140, //支付类型 《支付类型-payType》
//            'amount' => (float) $totalMoney, //金额decimal(20,2)	10	金额 10-20000
//            'reusableStatus' => 'false', //重复支付	是	Boolean	false	（false=不允许 true=允许）目前只能是false
//            'mchOrderNo' => $orderId, //订单号
//            'expireTime' => 3600, //	Long	3600	过期时间（单位：秒）默认3600秒=1小时
//            'notifyUrl' => Yii::$app->params['notify'] . 'call-back/manage' . $PayConfigureData['passagewayTerrace'],
//            'nonceStr' => time() . rand(0, 100000), //随机数	是	String(32)	1628381288000	随机数
//            'remark' => $UserID, //remark	备注
//            'realName' => 'Jeck', //	用户姓名
//            'goodsBody' => 'apple', // 商品描述		商品描述
//            'email' => 'qwert@as.com', //邮箱			邮箱
//            'phone' => '+551234567' // 手机号
//        );
//        $sign = SignHelper::checkSign1($p_data, $Md5key);
//        $postString = json_encode($p_data);
//        $header = [
//            'Content-Type: application/json;charset=UTF-8',
//            'Content-Length: ' . strlen($postString),
//            'MerchantId: ' . $mch_id,
//            'Sign: ' . $sign,
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

}
