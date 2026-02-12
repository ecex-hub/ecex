<?php

/**
 * x操作日志.
 *
 */

namespace common\helpers;

use common\models\AdminLog;
use Yii;

class AdminLogHelper extends \yii\base\Event {

    /**
     * 数据库新增保存日志
     *
     * @param $event
     * @throws \Throwable
     */
    public static function create($event) {
        if ($event->sender->className() !== AdminLog::className()) {
            $desc = '';
            foreach ($event->sender->getAttributes() as $name => $value) {
                !is_string($value) && $value = print_r($value, true);
                $desc .= '(' . $name . ') = ' . $value . ';';
            }
            $class = $event->sender->className();
            $idDes = '';
            if (isset($event->sender->id)) {
                $idDes = 'id = ' . $event->sender->id;
            }
            if (!empty(Yii::$app->getUser()->getIdentity()->username)) {
                $description = '管理员 [ ' . Yii::$app->getUser()->getIdentity()->username . ' ] ' . " 添加了{{%$class%}}, {$idDes} 的记录: " . $desc;
                $route = Yii::$app->controller->id . '/' . Yii::$app->controller->action->id;
                $admin_id = Yii::$app->getUser()->getId();
                $admin_name = Yii::$app->getUser()->getIdentity()->username;
                $ip = empty($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['REMOTE_ADDR'] : $_SERVER['HTTP_X_REAL_IP'];
                AdminLog::addLog($admin_id, $route, $description, $ip, $admin_name);
            }
        }
    }

    /**
     * 数据库修改保存日志
     *
     * @param $event
     * @throws \Throwable
     */
    public static function update($event) {
        if (!empty($event->changedAttributes)) {
            $desc = '';
            $oldAttributes = $event->sender->oldAttributes;
            foreach ($event->changedAttributes as $name => $value) {
                if ($oldAttributes[$name] == $value) {
                    continue;
                }
                !is_string($value) && $value = print_r($value, true);
                $desc .= '(' . $name . ') = ' . $value . '修改为' . $event->sender->oldAttributes[$name] . ';';
            }
            $class = $event->sender->className();
            $idDes = '';
            if (isset($event->sender->id)) {
                $idDes = 'id = ' . $event->sender->id;
            }
            if (!isset(Yii::$app->getUser()->getIdentity()->username)) {
                return false;
            }
            $description = '管理员 [ ' . Yii::$app->getUser()->getIdentity()->username . ' ] ' . " 修改了{{%$class%}}, {$idDes} 的记录: " . $desc;
            $route = Yii::$app->controller->id . '/' . Yii::$app->controller->action->id;
            $admin_id = Yii::$app->getUser()->id;
            $admin_name = Yii::$app->getUser()->getIdentity()->username;
            $ip = empty($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['REMOTE_ADDR'] : $_SERVER['HTTP_X_REAL_IP'];
            AdminLog::addLog($admin_id, $route, $description, $ip, $admin_name);
        }
    }

    /**
     * 数据库删除保存日志
     *
     * @param $event
     * @throws \Throwable
     */
    public static function delete($event) {
        $desc = '';
        foreach ($event->sender->getAttributes() as $name => $value) {
            !is_string($value) && $value = print_r($value, true);
            $desc .= $event->sender->getAttributeLabel($name) . '(' . $name . ') => ' . $value . ';';
        }
        $class = $event->sender->className();
        $idDes = '';
        if (isset($event->sender->id)) {
            $idDes = 'id = ' . $event->sender->id;
        }
        $description = '管理员 [ ' . Yii::$app->getUser()->getIdentity()->username . ' ] ' . " 删除了 {{%$class%}}, {$idDes} 的记录: " . $desc;
        $route = Yii::$app->controller->id . '/' . Yii::$app->controller->action->id;
        $admin_id = Yii::$app->getUser()->id;
        $admin_name = Yii::$app->getUser()->getIdentity()->username;
        $ip = empty($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['REMOTE_ADDR'] : $_SERVER['HTTP_X_REAL_IP'];
        AdminLog::addLog($admin_id, $route, $description, $ip, $admin_name);
    }

}
