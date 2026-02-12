<?php
/**
 * x消息发送.
 *
 */
namespace common\helpers;

use Yii;

/**
 * Event Helper
 */
class EventHelper extends BaseHelper
{
    // 消息队列主KEY
    const EVENT_KEY = 'event_message';// 充值通知
    const EVENT_SYS_HORN_UPDATES = 'sys_horn_updates'; // 跑马灯通知
    const EVENT_DELETE_GOLD = 'delete_gold'; //扣除金币通知
    
    // 消息格式
    const FORMAT_XML = 'xml';
    const FORMAT_JSON = 'json';
    const FORMAT_STR =  'str';
    
    // 消息动作
    const TYPE_NAME_RECHARGE_MC = 'recharge_mc'; // 开通月卡
    const TYPE_NAME_NEW_MAIL = 'new_mail'; // 邮件通知
    const TYPE_NAME_HORN_SYS_LIST = 'horn_sys_list'; // 跑马灯通知

    // 消息类型
    const TYPE_0 = 0; // 充值
    const TYPE_1 = 1; // 税收
    const TYPE_2 = 2; // SVIP通知
    const TYPE_3 = 3; // 游戏公告
    const TYPE_4 = 4; // 游戏开关,状态变更
    const TYPE_5 = 5; // 道具配置变动
    const TYPE_6 = 6; // 发放道具通知
    const TYPE_7 = 7; // 封禁用户
    const TYPE_8 = 8; // 发放福卡
    const TYPE_9 = 9; // 配置五福期数通知
    const TYPE_10 = 10; // 牛币充值通知
    const TYPE_11 = 11; // 爆浆
    
    protected $redis =  null;
    
    /**
     * construct.
     *
     * @return void.
     */
    public function __construct()
    {

    }
    
    /**
     * x同步发送消息到消息队列.
     *
     * @param array  $message    消息数据.
     * @param string $typeFormat 消息格式.
     *
     * @return mixed.
     */
    public function sendMsg($message, $typeFormat = self::FORMAT_JSON)
    {
        $ret = false;
        $data = $this->formatMessage($message, $typeFormat);
        if (!empty($data)) {
            $ret = Yii::$app->redis->lpush(self::EVENT_KEY, $data);
        }
        return $ret;
    }
    
    /**
     * x发送消息到消息队列.
     *
     * @param string $key 消息key.
     * @param array  $message    消息数据.
     * @param string $typeFormat 消息格式.
     *
     * @return mixed.
     */
    public function sendMessage($key, $message, $typeFormat = self::FORMAT_JSON)
    {
        $ret = false;
        $data = $this->formatMessage($message, $typeFormat);
        if (!empty($data)) {
            $ret = Yii::$app->redis->publish($key, $data);
        }
        return $ret;
    }
    
    /**
     * x发送的消息格式处理.
     *
     * @param array  $message    消息数据.
     * @param string $typeFormat 消息格式.
     *
     * @return mixed.
     */
    protected function formatMessage($message, $typeFormat = self::FORMAT_JSON)
    {
        $ret = '';
        if (in_array($typeFormat, [self::FORMAT_XML, self::FORMAT_JSON, self::FORMAT_STR])) {
            if ($typeFormat == self::FORMAT_XML) {
                $ret = $this->generateXMLByArr($message);
            } elseif ($typeFormat == self::FORMAT_JSON) {
                $ret = $this->generateJSONByArr($message);
            } else {
                $ret = $this->generateQueryStrByArr($message);
            }
        }
        return $ret;
    }

    /**
     * x生成xml格式的函数.
     *
     * @param array $data 入参.
     *
     * @return mixed.
     */
    protected function generateXMLByArr($data)
    {
        $xmlData = "<xml>";
        foreach ($data as $k => $v) {
            if (is_array($v)) {
                $xmlData .= "<" . $k . ">";
                foreach ($v as $key => $value) {
                    $xmlData .= "<" . $key . ">" . $value . "</" . $key . ">";
                }
                $xmlData .= "</" . $k . ">";
            }
            $xmlData .= "<" . $k . ">" . $v . "</" . $k . ">";
        }
        $xmlData .= "</xml>";
        
        return $xmlData;
    }
    
    /**
     * x生成json格式的函数.
     *
     * @param array $data 入参.
     *
     * @return mixed.
     */
    protected function generateJSONByArr($data)
    {
        return json_encode($data);
    }
    
    /**
     * x生成query_str格式的函数.
     *
     * @param array $data 入参.
     *
     * @return mixed.
     */
    protected function generateQueryStrByArr($data)
    {
        return http_build_query($data);
    }
}
