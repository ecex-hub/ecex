<?php

namespace common\models;

use common\helpers\EventHelper;
use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;

/**
 * ContactForm is the model behind the contact form.  后台账号登录白名单
 */
//class UserMemberForm extends  BaseModel implements IdentityInterface
class WhiteListMessage extends BaseModel {

    protected $table = 't_white_list_message';

    public static function tableName() {
        return '{{t_white_list_message}}';
    }

//    public static function getDb() {
//        return Yii::$app->get('TGTreasureDB');
//    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
                [['itime', 'utime'], 'required'], //必填项目
            ['_id', 'string'], //标记id
            ['accountID', 'string'], //账号id
            ['accountName', 'string'], //账号昵称
            ['whiteListIP', 'string'], //白名单ip
            ['type', 'number'], //状态  1为启动  2为关闭
            ['itime', 'number'], //加入时间
            ['utime', 'number'], //更新时间
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addWhiteListMessage($whiteListIP, $accountName) {
        $fireld = [];
        $accountData = UserMemberForm::getAccountDataOneAll($accountName, $fireld);
        if (empty($accountData)) {
            $this->addError('mesg', ['211', '登录账号不存在']);
            return false;
        }
        $where = ['accountID' => $accountData['_id'], 'whiteListIP' => $whiteListIP];
        $configureData = $this->find()->where($where)->asArray()->one();
        if (!empty($configureData)) {
            $this->addError('mesg', ['211', '白名单记录已经存在']);
            return false;
        }
        $data = [
            '_id' => FuncHelper::uniqid12(), //标记id
            'accountID' => $accountData['_id'], //账号id
            'accountName' => $accountData['account'], //账号昵称
            'whiteListIP' => $whiteListIP, //白名单ip
            'type' => 1, //状态  1为启动  2为关闭
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if (!empty($boor)) {
                return true;
            }
        }
        $this->addError('mesg', ['214', '数据添加失败']);
        return false;
    }

    /**
     * 列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @param type $whiteListIP
     * @param type $accountName
     * @return type
     */
    public function WhiteListMessageList($page = 1, $limit = 10, $fields = [], $whiteListIP = null, $accountName = null) {
        $where = [];
        if (!empty($whiteListIP)) {
            $where['whiteListIP'] = $whiteListIP;
        }

        if (!empty($accountName)) {
            $where['accountName'] = $accountName;
        }
        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);
        return $data;
    }

    /**
     * 修改白名单信息
     * @return type
     */
    public function updateWhiteListMessage($id, $blacklistType) {
        $updateData = [];
        if (!empty($blacklistType)) {
            $updateData['type'] = $blacklistType;
        }

        if (empty($updateData)) {
            $this->addError('mesg', ['210', '请填入修改信息']);
            return false;
        }
        $where = ['_id' => $id];
        $boor = $this->updateAll($updateData, $where);
        if ($boor) {
            return true;
        }
        $this->addError('mesg', ['211', '修改失败']);
        return false;
    }

    /**
     * 校验后台账号白名单信息
     * @param type $accountID
     * @return boolean
     */
    public static function checkAccountWhiteListIpMessage($accountID) {
//        $data['code'] = true; //临时关闭登录白名单限制
//        return $data;
        $blacklist_ip = empty($_SERVER['HTTP_X_REAL_IP']) ? '' : $_SERVER['HTTP_X_REAL_IP'];
        $data['code'] = false;
        if (empty($blacklist_ip)) {
            $blacklist_ip = $_SERVER['REMOTE_ADDR'];
            if (empty($blacklist_ip)) {
                $data['code'] = false;
            }
        }
        if (!empty($blacklist_ip)) {
            $data['ip'] = $blacklist_ip;
        } else {
            $data['ip'] = '127.0.0.1';
        }

        $where = [
            'and',
                ['accountID' => $accountID],
                ['whiteListIP' => $blacklist_ip],
                ['type' => 1]
        ];
        $exitsData = self::find()->where($where)->asArray()->one();
        if (!empty($exitsData)) {
            $data['code'] = true;
        }
        return $data;
    }

}
