<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  领奖
 */
class ReceivePrize extends BaseModel {

    protected $table = 't_receive_prize';

    public static function tableName() {
        return '{{t_receive_prize}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标题
            ['rewardID', 'number'], //奖品id
            ['rewardName', 'string'], //奖品昵称
            ['name', 'string'], //姓名
            ['phone', 'string'], //电话
            ['address', 'string'], //地址
            ['type', 'number'], //状态  1为申请了   2为发货了
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addReceivePrizeData($uid, $rewardID, $name, $phone, $address) {
        $rewardData = SignInReward::getSignInDataMessage($rewardID);
        if (empty($rewardData) || $rewardData['signInType'] <> 2) {
            $this->addError('mesg', ['212', '奖品信息异常']);
            return false;
        }

        $existData = $this->find()->where(['uid' => $uid, 'rewardID' => $rewardID])->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '已经领取了']);
            return false;
        }
        $AccountInfoData = AccountInfo::getAccountDataMessage($uid);
        if (empty($AccountInfoData)) {
            $this->addError('mesg', ['212', '无领取权限']);
            return false;
        }



        $type = 2;
        if ($rewardData['continuousDay'] == 3 && $AccountInfoData['oneReward'] > 0) {
            $type = 1;
        }
        if ($rewardData['continuousDay'] == 45 && $AccountInfoData['twoReward'] > 0) {
            $type = 1;
        }
        if ($rewardData['continuousDay'] == 90 && $AccountInfoData['threeReward'] > 0) {
            $type = 1;
        }

        if ($type == 2) {
            $this->addError('mesg', ['212', '无领取权限']);
            return false;
        }

        if ($AccountInfoData['investAllMoney'] <= 0) {
            $this->addError('mesg', ['212', '暂未进行过投资，无法领取']);
            return false;
        }

        if ($rewardData['continuousDay'] == 45) {
            //1798
            $existDataRecord = BuyRecord::getClientUidinvestAllMoneyMessage($uid, 1798);
            if (empty($existDataRecord)) {
                $this->addError('mesg', ['212', '需进行1798额度投资才能领取']);
                return false;
            }
        }

        if ($rewardData['continuousDay'] == 90) {
            //5798
            $existDataRecord = BuyRecord::getClientUidinvestAllMoneyMessage($uid, 5798);
            if (empty($existDataRecord)) {
                $this->addError('mesg', ['212', '需进行5798额度投资才能领取']);
                return false;
            }
        }


        $data = [
            'uid' => $uid, //标题
            'rewardID' => $rewardData['id'], //奖品id
            'rewardName' => $rewardData['rewardName'], //奖品昵称
            'name' => $name, //姓名
            'phone' => $phone, //电话
            'address' => $address, //地址
            'type' => 1, //状态  1为申请了   2为发货了
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                return true;
            } else {
                $this->addError('mesg', ['212', '添加失败']);
                return false;
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
    public function getReceivePrizeList($page = 1, $limit = 10, $fields = [], $uid, $type) {
        $where = [
            'and'
        ];
        if (!empty($uid)) {
            $where[] = ['=', 'uid', $uid];
        }
        if (!empty($type)) {
            $where[] = ['=', 'type', $type];
        }
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
    public function updateReceivePrizeData($id, $type) {
        $update = [];
        if (!empty($type)) {
            $update['type'] = $type;
            $update['utime'] = time();
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

}
