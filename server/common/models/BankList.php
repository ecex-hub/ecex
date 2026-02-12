<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  银行列表 。还没写
 */
class BankList extends BaseModel {

    protected $table = 't_bank_list';

    public static function tableName() {
        return '{{t_bank_list}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['realName', 'string'], //姓名
            ['bankName', 'string'], //银行名字
            ['bankCard', 'string'], //银行卡号
            ['belong', 'string'], //归属管理员
            ['sort', 'number'], //排序
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addBankList($realName, $bankName, $bankCard, $sort) {

        $bankCardBoor = $this->validateBankCardNumber($bankCard);
        if (!$bankCardBoor) {
            $this->addError('mesg', ['212', '请输入有效的银行卡号']);
            return false;
        }

        $existData = $this->find()->where(['bankCard' => $bankCard])->asArray()->one();
        if (!empty($existData)) {
            $this->addError('mesg', ['212', '该银行卡已经记录了']);
            return false;
        }


        $data = [
            'realName' => $realName, //姓名
            'bankName' => $bankName, //银行名字
            'bankCard' => $bankCard, //银行卡号
            'belong' => '', //归属管理员
            'sort' => $sort,
            'type' => 2, //状态  1为启用   2为关闭
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                if (!empty($boor)) {
                    return true;
                } else {
                    $this->addError('mesg', ['212', '添加失败']);
                    return false;
                }
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
    public function getBankList($page = 1, $limit = 10, $fields = []) {
        $where = [
            'and'
        ];

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
    public function updateBankData($id, $sort, $type, $realName, $bankName, $bankCard) {
        $update = [];
        if (!empty($sort)) {
            $update['sort'] = $sort;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (!empty($realName)) {
            $update['realName'] = $realName;
        }
        if (!empty($bankName)) {
            $update['bankName'] = $bankName;
        }
        if (!empty($bankCard)) {
            $update['bankCard'] = $bankCard;
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
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientBankList($page = 1, $limit = 10, $fields = []) {

        $rediskey = __METHOD__ . $page . $limit;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'type', 1]
        ];

        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-sort'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientBankMessage($id, $fields = []) {
        $rediskey = __METHOD__ . $id;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            //return $redisData;
        }
        $where = [
            'and',
            // ['=', 'type', 1],
            ['=', 'id', $id]
        ];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

}
