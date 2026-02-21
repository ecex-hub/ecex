<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  短信发送
 */
class SendSMSLog extends BaseModel
{

    protected $table = 't_send_sms_log';

    public static function tableName()
    {
        return '{{t_send_sms_log}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['_id', 'string'], //标记id
            ['phone', 'string'], //手机号
            ['smsCode', 'number'], //验证码
            ['sendIp', 'string'], //发送ip
            ['sendAgentID', 'number'], //发送账号id
            ['type', 'number'], //状态  1为成功可使用   2为已使用
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    public function userIDSendSMSReocrd($phone, $sendIp, $sendAgentID = null)
    {
        //10分钟10条
        //手机号 ip  账号id
        if (!empty($sendAgentID)) {
            $where = [
                'and',
                [
                    'or',
                    ['=', 'phone', $phone],
                    ['=', 'sendIp', $sendIp],
                    ['=', 'sendAgentID', $sendAgentID],
                ],
                ['>', 'itime', time() - 600]
            ];
        } else {
            $where = [
                'and',
                [
                    'or',
                    ['=', 'phone', $phone],
                    ['=', 'sendIp', $sendIp]
                ],
                ['>', 'itime', time() - 600]
            ];
        }


        $count = $this->find()->where($where)->count() ?? 0;
        if ($count > 10) {
            $this->addError('mesg', ['210', '发送太频繁了']);
            return false;
        }
        //生成验证码
        $smsCode = $this->makeRandNumberCode();

        $data = [
            '_id' => FuncHelper::uniqid12(), //标记id
            'phone' => $phone, //手机号
            'smsCode' => intval($smsCode), //验证码
            'sendIp' => $sendIp, //发送ip
            'sendAgentID' => $sendAgentID, //发送账号id
            'type' => 1, //状态  1为成功可使用   2为已使用
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->insert($data);
            if ($boor) {
                //准备发送短信
                $model = new SendSMS();
                //$boor = $model->SMSSend($phone, $smsCode);
                $boor = true;
                if (!empty($boor)) {
                    return true;
                } else {
                    $this->addError('mesg', ['212', '验证码发送失败']);
                    return false;
                }
            }
        }
        $this->addError('mesg', ['211', '验证码生成失败']);
        return false;
    }

    /**
     * 生成随机验证码
     * @param type $length
     * @return int
     */
    public function makeRandNumberCode($length = 6)
    {
        // 密码字符集，可任意添加你需要的字符
        $chars = array(1, 2, 3, 4, 5, 6, 7, 8, 9);
        // 在 $chars 中随机取 $length 个数组元素键名
        $keys = array_rand($chars, $length);
        $password = '';
        for ($i = 0; $i < $length; $i++) {
            // 将 $length 个数组元素连接成字符串
            $password .= $chars[$keys[$i]];
        }
        return $password;
    }

    /**
     * 验证验证码是否正确  并失效验证码
     * @param type $phone
     * @param type $code
     * @return boolean
     */
    public function checkPhoneCode($phone, $code)
    {
        $where = [
            'and',
            ['=', 'phone', $phone],
            ['=', 'smsCode', $code],
            ['=', 'type', 1],
            ['>', 'itime', time() - 300]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        if (!empty($existData)) {
            $this->updateAll(['type' => 2], ['_id' => $existData['_id']]);
            return true;
        }
        return false;
    }

}
