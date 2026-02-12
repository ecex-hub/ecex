<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  支付按钮
 */
class PayButton extends BaseModel {

    protected $table = 't_pay_button';

    public static function tableName() {
        return '{{t_pay_button}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['payNo', 'number'], //绑定通道编号 。暂时不用
            ['payConfigType', 'number'], //支付类型 。1支付宝 2微信  3银行卡  4备付金 。5银行卡转帐
            ['payname', 'string'], //按钮名称
            ['remarks', 'string'], //备注
            ['sort', 'number'], //排序
            ['payType', 'number'], //支付启用类型 。1投资 。 2备付金充值 。3混合
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

//    public $payConfigType = [
//        1 => '支付宝',
//        2 => '微信',
//        3 => '银行卡',
//        4 => '备付金',
//        5 => '银行卡转帐'
//    ];

    public static function selectColumn() {
        return self::$key;
    }

    public function addPayButtonData($payNo, $payname, $payConfigType, $remarks, $sort, $payType) {

        $data = [
            'payNo' => $payNo, //绑定通道编号 。暂时不用
            'payConfigType' => $payConfigType, //支付类型 。1支付宝 2微信  3银行卡  4备付金 。5银行卡转帐
            'payname' => $payname, //按钮名称
            'remarks' => $remarks, //备注
            'sort' => $sort,
            'type' => 1, //状态  1为成功可使用   2为已使用
            'payType' => $payType,
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
    public function getPayButtonList($page = 1, $limit = 10, $fields = []) {
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
    public function updatePayButtonData($id, $sort, $type, $payNo, $payConfigType, $payname, $remarks, $payType) {
        $update = [];
        //if (!empty($payNo)) {
        $update['payNo'] = $payNo;
        //}
        if (!empty($payname)) {
            $update['payname'] = $payname;
        }
        if (!empty($payConfigType)) {
            $update['payConfigType'] = $payConfigType;
        }
        if (!empty($remarks)) {
            $update['remarks'] = $remarks;
        }
        if (!empty($sort)) {
            $update['sort'] = $sort;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (!empty($payConfigType)) {
            $update['payConfigType'] = $payConfigType;
        }
        if (!empty($payType)) {
            $update['payType'] = $payType;
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
    public function getClientPayButtonList($page = 1, $limit = 10, $fields = [], $type, $payType = 1) {

        $rediskey = __METHOD__ . $page . $limit . $type . $payType;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            // return $redisData;
        }

        $where = [
            'and',
            ['=', 'type', 1],
            ['or',
                ['=', 'payType', $payType],
                ['=', 'payType', 3]
            ]
        ];
        if (!empty($type)) {
            if ($type == 3) {
                $where[] = ['in', 'payConfigType', [1, 2, 3]];
            } else {
                $where[] = ['<>', 'payConfigType', 4];
            }
        }
        self::$key = $fields;
        $data = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-sort'])->where($where)->all();

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取单条信息
     * @param type $id
     * @return type
     */
    public static function getPayButtonMessage($id) {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }

}
