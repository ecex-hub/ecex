<?php

namespace common\models;

use Yii;

/**
 * 登录日志模型
 *
 * @property int $id
 * @property int $admin_id 管理员ID
 * @property string $username 用户名
 * @property string $ip 登录IP
 * @property int $result 登录结果：1成功 0失败
 * @property string $reason 失败原因
 * @property string $user_agent 浏览器信息
 * @property int $createtime 登录时间
 */
class LoginLog extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{t_login_log}}';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['admin_id', 'result', 'createtime'], 'integer'],
            [['username', 'ip'], 'string', 'max' => 50],
            [['reason'], 'string', 'max' => 255],
            [['user_agent'], 'string', 'max' => 500],
            [['username', 'ip', 'result'], 'required'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'admin_id' => '管理员ID',
            'username' => '用户名',
            'ip' => '登录IP',
            'result' => '登录结果',
            'reason' => '失败原因',
            'user_agent' => '浏览器信息',
            'createtime' => '登录时间',
        ];
    }

    /**
     * 记录登录日志
     * @param int $adminId 管理员ID
     * @param string $username 用户名
     * @param bool $success 是否成功
     * @param string $reason 失败原因
     * @return bool
     */
    public static function log($adminId, $username, $success, $reason = '')
    {
        $model = new self();
        $model->admin_id = $adminId;
        $model->username = $username;
        $model->ip = Yii::$app->request->getUserIP();
        $model->result = $success ? 1 : 0;
        $model->reason = $reason;
        $model->user_agent = Yii::$app->request->getUserAgent();
        $model->createtime = time();
        
        return $model->save();
    }
}