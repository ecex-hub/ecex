<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  公告
 */
class Notice extends BaseModel
{

    protected $table = 't_notice';

    public static function tableName()
    {
        return '{{t_notice}}';
    }

    const IsWithdrawal = 1;//发起提现
    const IsRealPass = 2;//实名认证通过
    const IsRealNoPass = 3;//实名认证拒绝
    const IsWithdrawPass = 22;//实名认证拒绝
    const IsWithdrawNoPass = 33;//实名认证拒绝

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['subtitle', 'string'], //副标题
            ['image', 'string'], //标题
            ['content', 'string'], //内容
            ['sort', 'number'], //排序
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
            ['uid', 'number'], //用户
            ['msg_type', 'number'], //状态  1为启用   2为关闭
            ['is_read', 'number'], //状态  1为已读
        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    public function getInfo($id)
    {

        $where = [
            'and',
            ['=', 'id', $id],
        ];
        $list = $this->find()->where($where)
            ->asArray()->one();
        return $list;
    }


    /**
     * 获取新闻列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientNoticeList()
    {

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'uid', 0],
        ];
        $list = $this->find()->where($where)
            ->orderBy("sort asc")
            ->asArray()->all();
        foreach ($list as &$value) {
            $value['image'] = FuncHelper::getCdnUrl($value['image']);
        }
        return $list;
    }

    public function getClientList($page = 1, $limit = 10, $fields = [])
    {

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'uid', 0]
        ];
        $list = $this->listFind(['page' => $page, 'row' => $limit])
            ->select(['id', 'title', 'subtitle', 'image', 'content', 'itime'])
            ->orderBy(['sort' => SORT_ASC])
            ->where($where)->asArray()->all();
        foreach ($list as &$value) {
            $value['image'] = FuncHelper::getCdnUrl($value['image']);
        }
        return $list;
    }


    public function getUserList($uid, $page = 1, $limit = 10, $fields = [])
    {

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'uid', $uid]
        ];
        $list = $this->listFind(['page' => $page, 'row' => $limit])
            ->select(['id', 'title', 'subtitle', 'image', 'content', 'itime', 'is_read'])
            ->orderBy(['sort' => SORT_ASC])
            ->where($where)->asArray()->all();
        foreach ($list as &$value) {
            $value['image'] = FuncHelper::getCdnUrl($value['image']);
        }
        return $list;
    }

    public function getAllIds()
    {

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'uid', 0]
        ];
        $ids = $this->find()
            ->select('id')
            ->where($where)
            ->column();
        return $ids;
    }

    public function getLastNotice()
    {

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'uid', 0],
        ];
        $info = $this->find()->where($where)
            ->select(['id', 'title', 'subtitle', 'content', 'image', 'itime', 'is_read'])
            ->orderBy("sort asc")
            ->asArray()->one();
        if (empty($info)) {
            return [];
        }
        $info['image'] = FuncHelper::getCdnUrl($info['image']);
        return $info;
    }
}
