<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  签到奖励奖品
 */
class SignInReward extends BaseModel
{

    protected $table = 't_sign_in_reward';

    public static function tableName()
    {
        return '{{t_sign_in_reward}}';
    }

    const signInTypeByContinuous = 1;


    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['continuousDay', 'number'], //连续天数
            ['signInType', 'number'], //签到类型 。1为连续签到奖励 。 2为累积天数奖励
            ['rewardType', 'number'], //奖励类型 。1余额 。2备付金 。3金砖币 。4实物
            ['rewardNumber', 'number'], //奖励数量
            ['rewardName', 'string'], //奖励名字
            ['picUrl', 'string'], //图片
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public $defaultType = 1; //默认奖励类型
    public $defaultNumber = 0; ///默认奖励数量
    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    public function addSignInReward($continuousDay, $signInType, $rewardType, $rewardNumber, $rewardName, $picUrl)
    {

        if ($signInType == 1) {
            if (empty($continuousDay) || empty($rewardType) || empty($rewardNumber)) {
                $this->addError('mesg', ['212', '检查输入数据']);
                return false;
            }
        } else {
            if (empty($continuousDay) || empty($rewardType) || empty($rewardNumber) || empty($picUrl)) {
                $this->addError('mesg', ['212', '检查输入数据']);
                return false;
            }
        }

        //验证重复
        $where = [
            'and',
            ['=', 'continuousDay', $continuousDay],
            ['=', 'signInType', $signInType]
        ];
        $existData = $this->find()->where($where)->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '该签到类型天数奖励已经添加了']);
            return false;
        }
        $data = [
            'continuousDay' => $continuousDay, //连续天数
            'signInType' => $signInType, //签到类型 。1为连续签到奖励 。 2为累积天数奖励
            'rewardType' => $rewardType, //奖励类型 。1余额 。2备付金 。3金砖币 。4实物
            'rewardNumber' => $rewardNumber, //奖励数量
            'rewardName' => $rewardName, //奖励名字
            'picUrl' => $picUrl, //图片
            'type' => 1, //状态  1为启用   2为关闭
            'itime' => time(), //
            'utime' => time(), //
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
    public function getSignInRewardList($page = 1, $limit = 10, $fields = [], $signInType = null)
    {
        $where = [
            'and'
        ];
        if (!empty($signInType)) {
            $where[] = ['=', 'signInType', $signInType];
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
    public function updateSignInData($id, $type, $rewardType, $rewardNumber, $rewardName, $picUrl)
    {
        $update = [];
        if (!empty($rewardType)) {
            $update['rewardType'] = $rewardType;
        }
        if (!empty($rewardNumber)) {
            $update['rewardNumber'] = $rewardNumber;
        }
        if (!empty($rewardName)) {
            $update['rewardName'] = $rewardName;
        }
        if (!empty($picUrl)) {
            $update['picUrl'] = $picUrl;
        }
        if (!empty($type)) {
            $update['type'] = $type;
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
     * 获取连续签到奖励
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getSignReward($signInType)
    {
        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'signInType', $signInType],
            // ['=', 'continuousDay', $continuousDay],
        ];
        $data = $this->listFind([])->where($where)->one();
        return $data;
    }

    /**
     * 获取累积奖励列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientSignInList($signInType = 2, $fields = [])
    {
        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'signInType', $signInType]
        ];
        $fields = ['id', 'continuousDay', 'rewardType', 'rewardNumber', 'picUrl', 'rewardName'];
        self::$key = $fields;
        $data = $this->listFind(['page' => 1, 'row' => 3, 'sort' => 'continuousDay'])->where($where)->all();
        return $data;
    }

    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getSignInDataMessage($id)
    {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }

}
