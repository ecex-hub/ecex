<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\helpers\SignatureHelper;

/**
 * ContactForm is the model behind the contact form.  短信发送
 */
class SendSMS extends BaseModel {

    protected $table = 't_send_sms';

    public static function tableName() {
        return '{{t_send_sms}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
                ['_id', 'string'], //标记id
            ['phone', 'string'], //手机号
            ['smsCode', 'number'], //验证码
            ['sendIp', 'number'], //发送ip
            ['sendAgentID', 'number'], //发送账号id
            ['type', 'number'], //状态  1为成功可使用   2为已使用
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    // *** 需用户填写部分 ***
    // fixme 必填：是否启用https
    private $security = false;
    // fixme 必填: 请参阅 https://ak-console.aliyun.com/ 取得您的AK信息
    private $accessKeyId = "";
    private $accessKeySecret = "";
    private $SignName = '添微科技';
    private $TemplateCode = 'SMS_217840103';
    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function SMSSend($phone, $code) {

        $security = $this->security;

        // 优先从环境变量读取，否则使用属性值
        $accessKeyId = getenv('ALIYUN_SMS_ACCESS_KEY_ID') ?: $this->accessKeyId;
        $accessKeySecret = getenv('ALIYUN_SMS_ACCESS_KEY_SECRET') ?: $this->accessKeySecret;

        // fixme 必填: 短信接收号码
        $params["PhoneNumbers"] = $phone;

        // fixme 必填: 短信签名，应严格按"签名名称"填写，请参考: https://dysms.console.aliyun.com/dysms.htm#/develop/sign
        $params["SignName"] = $this->SignName;

        // fixme 必填: 短信模板Code，应严格按"模板CODE"填写, 请参考: https://dysms.console.aliyun.com/dysms.htm#/develop/template
        $params["TemplateCode"] = $this->TemplateCode;

        $code = intval($code);
        // fixme 可选: 设置模板参数, 假如模板中存在变量需要替换则为必填项
        $params['TemplateParam'] = Array(
            "code" => $code
        );

        // fixme 可选: 设置发送短信流水号
        // $params['OutId'] = "12345";
        // fixme 可选: 上行短信扩展码, 扩展码字段控制在7位或以下，无特殊需求用户请忽略此字段
        // $params['SmsUpExtendCode'] = "1234567";
        // *** 需用户填写部分结束, 以下代码若无必要无需更改 ***
        if (!empty($params["TemplateParam"]) && is_array($params["TemplateParam"])) {
            $params["TemplateParam"] = json_encode($params["TemplateParam"], JSON_UNESCAPED_UNICODE);
        }

        // 初始化SignatureHelper实例用于设置参数，签名以及发送请求
        $helper = new SignatureHelper();
        try {
            // 此处可能会抛出异常，注意catch
            $content = $helper->request(
                    $accessKeyId, $accessKeySecret, "dysmsapi.aliyuncs.com", array_merge($params, array(
                "RegionId" => "cn-hangzhou",
                "Action" => "SendSms",
                "Version" => "2017-05-25",
                    )), $security
            ); 
            if (!empty($content->Code) && $content->Code == 'OK') {
                return true;
            }
        } catch (\Exception $e) {
            //  $this->returnJsonError($e->getMessage(), [], $e->getCode());
        }

        return true;
    }

}
