<?php

namespace common\models;

use app\admin\model\Account;
use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  银行卡绑定信息
 */
class BindBankCard extends BaseModel
{

    protected $table = 't_bind_bank_card';

    public static function tableName()
    {
        return '{{t_bind_bank_card}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //用户id
            ['realName', 'string'], //姓名
            ['bankName', 'string'], //银行名字
            ['bankCard', 'string'], //银行卡号
            ['type', 'number'], //1-正常2-关闭
            ['alipay_card', 'string'], //支付宝账号
            ['pay_type', 'number'], //1-银行卡 2-支付宝
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public $bankNameList = [
        1 => "中国银行",
        2 => "建设银行",
        3 => "工商银行",
        4 => "交通银行",
        5 => "农业银行",
        6 => "邮政银行",
        7 => "招商银行",
        8 => "中信银行",
        9 => "光大银行",
        10 => "民生银行",
        11 => "广发银行",
        12 => "平安银行",
        13 => "渤海银行",
        14 => "浙商银行",
        15 => "华夏银行",
        16 => "浦发银行",
        17 => "恒丰银行"
    ];

    public static function selectColumn()
    {
        return self::$key;
    }

    public function addBindBankCard($user, $params)
    {
        $uid = $user->uid;
        $bankCard = $params['bankCard'];
        $bankName = "";
        $bankNameId = $params['bankNameId'];
        $realName = $params['realName'];
        $alipayCard = $params['alipay_card'];
        if ($params['pay_type'] == 1) {
            //其他银行卡
            if ($params['otherBankName']) {
                $bankName = $params['otherBankName'];
            } else {
                $bankNameList = $this->bankNameList;
                if (empty($bankNameList[$bankNameId])) {
                    $this->addError('mesg', ['212', '请选择正确的银行']);
                    return false;
                }
                $bankName = $bankNameList[$bankNameId];
            }
            $existCount = $this->find()->where(['uid' => $uid, 'type' => 1])->count() ?? 0;
            if ($existCount >= 5) {
                $this->addError('mesg', ['212', '绑定银行卡已经达到上限']);
                return false;
            }
            $existData = $this->find()->where(['bankCard' => $bankCard, 'type' => 1])->asArray()->one();
            if (!empty($existData)) {
                $this->addError('mesg', ['212', '该银行卡已经绑定了']);
                return false;
            }
        }
        if ($user['realName'] <> $realName) {
            $this->addError('mesg', ['212', '收款人名需要与实名认证人名一致']);
            return false;
        }
        $data = [
            'uid' => $uid, //
            'bankName' => $bankName, //银行名字
            'bankCard' => $bankCard, //银行卡号
            'alipay_card' => $alipayCard,//支付宝
            'realName' => $realName, //姓名
            'pay_type' => $params['pay_type'],
            'type' => 1,
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $this->attributes = $data;
        $boor = $this->insertData($data);
        if ($boor) {
            return true;
        }
        $this->addError('mesg', ['211', '数据异常，检查数据']);
        return false;
    }


    public function getBindBankCardList($page = 1, $limit = 10, $fields = [])
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

    /**
     * 关闭银行卡
     * @param type $id
     * @return boolean
     */
    public function closeBindBankCardData($id, $uid)
    {
        $update = ['type' => 2];
        $where = [
            'and',
            ['=', 'id', $id],
            ['=', 'uid', $uid]
        ];
        $boor = $this->updateAll($update, $where);
        if ($boor) {
            return true;
        }
        $this->addError('mesg', ['211', '删除失败']);
        return false;
    }

    /**
     * 获取新闻列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientBindBankCardList($page = 1, $limit = 10, $uid, $fields = [])
    {

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'type', 1]
        ];
        $list = $this->listFind(['page' => $page, 'row' => $limit])
            ->orderBy('id desc')
            ->where($where)
            ->select($fields)
            ->all();
        return $list;
    }

    /**
     * 获取绑定详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getInfo($uid, $id, $fields = [])
    {

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'id', $id],
            ['=', 'uid', $uid]
        ];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();

        return $data;
    }

}
