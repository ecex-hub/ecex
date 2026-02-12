<?php

namespace common\models;

use Yii;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;

/**
 * AdminLog model
 *
 */
class AdminLog extends \common\models\BaseModel
{

    protected $table = 't_admin_log';

    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return '{{t_admin_log}}';
    }

    /**
     * {@inheritdoc}
     */
    public static function getDb()
    {
        return Yii::$app->get('db');
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [
            'timestamp' => [
                'class' => TimestampBehavior::className(),
                'attributes' => [
                    ActiveRecord::EVENT_BEFORE_INSERT => ['itime', 'utime'],
                    ActiveRecord::EVENT_BEFORE_UPDATE => ['utime']
                ]
            ]
        ];
    }

    private static $key = [];

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['description', 'ip', 'admin_name'], 'string'],
            [['itime', 'utime'], 'integer'],
            [['route'], 'string', 'max' => 255]
        ];
    }

    /**
     * @inheritdoc
     * //记录到系统操作日志
     *
     * @param string $admin_id 管理员id.
     * @param string $route 操作路由.
     * @param string $description 操作详情.
     * @param string $ip 操作ip.
     * @param string $admin_name 管理员名称.
     *
     * @return bool
     */
    public static function addLog($admin_id, $route, $description, $ip, $admin_name)
    {
        $adminLog = new AdminLog();
        $adminLog->admin_id = $admin_id;
        $adminLog->route = $route;
        $adminLog->description = $description;
        $adminLog->ip = $ip;
        $adminLog->admin_name = $admin_name;
        if (!$adminLog->validate()) {
            return 1;
            // throw new \Exception($adminLog->getFirstError(), 70002);
        }
        if (!$adminLog->save()) {
            return 2;
        }
    }

    /**
     * 删除系统日志 不计入系统日志
     *
     * @return bool
     */
    public function afterDelete()
    {
        return false;
    }

    /**
     * AdminLogInfo.
     * 操作日志
     *
     * @param string $sort 排序类型.
     * @param integer $page 当前页数.
     * @param integer $row 每页行数.
     * @param integer $admin_id 管理员编号.
     * @param integer $startTime 开始时间.
     * @param integer $endTime 结束时间.
     * @param string $admin_name 管理员名称.
     *
     * @return array.
     * @throws \Exception
     */
    public function adminLogList(
        $sort,
        $page = 1,
        $row = 10,
        $admin_id = 0,
        $description = '',
        $ip = '',
        $startTime = 0,
        $endTime = 0,
        $admin_name = ''
    )
    {
        $query = AdminLog::find()->orderBy('itime DESC');
        if (!empty($admin_id)) {
            $query = $query->andWhere(['admin_id' => $admin_id]);
        }
        if (!empty($description)) {
            $query = $query->andWhere(['like', 'description', $description]);
        }
        if (!empty($ip)) {
            $query = $query->andWhere(['ip' => $ip]);
        }
        if (!empty($startTime) && is_numeric($startTime)) {
            $query = $query->andWhere([">=", 'itime', $startTime]);
        }
        if (!empty($endTime) && is_numeric($endTime)) {
            $query = $query->andWhere(["<=", 'itime', $endTime]);
        }
        if (!empty($admin_name)) {
            $query = $query->andWhere(['like', 'admin_name', $admin_name]);
        }
        if (!empty($sort)) {
            if (strpos($sort, "-") === 0) {
                $sort = str_replace("-", '', $sort) . " DESC";
            } else {
                $sort = str_replace("-", '', $sort) . " ASC";
            }
            $query = $query->orderBy($sort);
        }
        $countQuery = clone $query;
        $query = $query->offset(($page - 1) * $row)->limit($row);
        $dataInfo = $query->asArray()->all();
        $ret = [];
        if (!empty($dataInfo)) {
            $ret['count'] = $countQuery->count();
            $ret['page'] = ceil($ret['count'] / $row);
//            foreach ($dataInfo as $k => $v) {
//            }
            $ret['data'] = $dataInfo;
        }
        return $ret;
    }

    /**
     * Monitoring.
     * 检测域名状态
     *
     * @return mixed.
     * @throws \Exception
     */
    public function Monitoring()
    {
        $url = Yii::$app->params['backendUrl'];
        $cmd = 'systemctl restart php74-php-fpm';
        $exec = "curl  connect-timeout 5 -I $url 2>/dev/null";
        $res = shell_exec($exec);
        echo "\r\n" . $res . '啥也没有';
        if (stripos($res, '502 Bad Gateway') !== false) {
            echo "\r\n出现502 并重启php-fpm" . date('Y-m-d H:i:s');
            $ss = shell_exec($cmd);
            //重启nginx
            $cmd = 'systemctl restart nginx';
            $ss = shell_exec($cmd);
            echo "\r\n" . $ss;
            exit();
        } elseif ($res == '') {
            echo "\r\n程序返回是空 并重启nginx" . date('Y-m-d H:i:s');
            $cmd = 'systemctl restart nginx';
            $ss = shell_exec($cmd);
            echo "\r\n" . $ss;
            exit();
        } else {
            echo "\r\n程序正常";
        }
    }

    /**
     * AdminLogInfo.
     * 操作日志
     *
     *
     * @return array.
     * @throws \Exception
     */
    public function getAdminLog()
    {
        $ret = [];
        $data = UserMemberForm::find()->where(['authority' => 5])->asArray()->all();
        foreach ($data as $key => $value) {
            $a = self::find()->where(['admin_id' => $value['_id']])->andWhere(['route' => 'login-administration/index'])
                ->orderBy('itime DESC')->limit(1)->asArray()->one();
            if (!empty($a)) {
                $ret[$value['username']][] = $a;
            }
            $b = self::find()->where(['admin_id' => $value['_id']])->andWhere(['route' => 'logout/logout'])
                ->orderBy('itime DESC')->limit(1)->asArray()->one();
            if (!empty($b)) {
                $ret[$value['username']][] = $b;
            }
        }

        require dirname(dirname(dirname(__FILE__))) . '/vendor/PHPExcel/PHPExcel.php';
        $objectPHPExcel = new \PHPExcel();
        $objectPHPExcel->setActiveSheetIndex(0);
        $fields = ['admin_name' => '昵称', 'description' => '描述'];
        $n = 65;
        //设置表头
        foreach ($fields as $key => $value) {
            $objectPHPExcel->getActiveSheet()->setCellValue(chr($n) . 1, $value);
            $n++;
        }
//        foreach ($temp as $key => $value) {
//            if (!is_numeric($value)) {
//                $data[] = unserialize($value);
//            }
//        }
        //设置行值
        $i = 1;
        foreach ($ret as $key => $value) {
            $n = 65;
            foreach ($value as $k => $v) {
                if (!empty($v)) {
                    $i = $i + 1;
                    $objectPHPExcel->getActiveSheet()->setCellValue(chr($n) . $i, $v['admin_name']);
                    $objectPHPExcel->getActiveSheet()->setCellValue(chr($n + 1) . $i, $v['description']);
//                    $n = $n + 2;
                }
            }
        }
        $objWriter = \PHPExcel_IOFactory::createWriter($objectPHPExcel, 'Excel5');
        $title = 'log列表-' . date("Y年m月j日") . '.xls';
        //创建文件夹
        $dir = dirname(dirname(dirname(__FILE__))) . '/frontend/web/temp_uploads/';
        if (!file_exists($dir)) {
            mkdir($dir, 0777, true);
        }
        $objWriter->save($dir . $title);
        $ret['data'] = Yii::$app->params['backendUrl'] . 'temp_uploads/' . $title;
        print_r($ret);
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getAdminLogList($page = 1, $limit = 10, $fields = [])
    {
        $where = [
            'and'
        ];
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

}
