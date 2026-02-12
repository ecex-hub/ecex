<?php

namespace common\models;

use Yii;
use common\models\BaseModel;

/**
 * ContactForm is the model behind the contact form.  存储过程操作
 */
//class UserMemberForm extends  BaseModel implements IdentityInterface
class AgentTeamSql extends BaseModel
{

    protected $table = 't_agent_team_profit';

    /**
     * pdo 实例
     * @var type
     */
    protected $PDO_CONN = false;

    public static function tableName()
    {
        return '{{t_agent_team_profit}}';
    }

    public static function getDb()
    {
        return Yii::$app->get('db');
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['itime', 'utime'], 'required'], //必填项目
            ['_id', 'string'], //唯一标识id
        ];
    }

    private static $key = [];

    public function __construct($config = array())
    {
        parent::__construct($config);
        $this->connectDB();
    }

    /**
     * 实例化sql server pdo
     */
    private function connectDB()
    {
        $this->PDO_CONN = new \PDO(Yii::$app->db->dsn, Yii::$app->db->username, Yii::$app->db->password);
    }

    public static function selectColumn()
    {
        return self::$key;
    }

    /**
     * 获取团队充值 。提现数据
     * @param type $UserID
     * @param type $startTime
     * @param type $endTime
     * @return boolean
     */
    public function sqlOperateTeamListData($uid, $startTime, $endTime, $type)
    {//TeamListData
        $dbh = $this->PDO_CONN;
        if ($dbh === false) {//如果连接失败执行
            $this->addError('mesg', ['211', '数据链接异常']);
            return false;
        }
        $procName = "TeamListData";
        $stmt = $dbh->prepare("call $procName(?,?,?,?)");
        $stmt->bindParam(1, $uid);
        $stmt->bindParam(2, $startTime);
        $stmt->bindParam(3, $endTime);
        $stmt->bindParam(4, $type);
        $res = $stmt->execute();

        //获取第一个结果集.
        $rowset = $stmt->fetch();
        return $rowset;
//        if (!empty($rowset['returnData'])) {
//            return $rowset['returnData'];
//        }
//        return 0;
    }

}
