<?php

namespace common\models;

use common\models\BaseModel;
use Yii;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  公告
 */
class NoticeRead extends BaseModel
{

    protected $table = 't_notice_read';

    public static function tableName()
    {
        return '{{t_notice_read}}';
    }

    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标题
            ['notice_id', 'number'], //内容
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public function getInfo($uid, $noticeId)
    {

        // 如果缓存不存在，则执行数据库查询
        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'notice_id', $noticeId],
        ];
        $info = $this->find()
            ->select(['id'])
            ->where($where)->asArray()->one();
        return $info;
    }

}