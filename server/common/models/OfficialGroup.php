<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  官方群
 */
class OfficialGroup extends BaseModel {

    protected $table = 't_official_group';

    public static function tableName() {
        return '{{t_official_group}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['groupNo', 'string'], //群号
            ['groupName', 'string'], //群名字
            ['groupUrl', 'string'], //二维码
            ['sort', 'number'], //状态  1为启用   2为关闭
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addOfficialGroupData($groupNo, $groupName, $groupUrl, $type,$sort) {

        $data = [
            'groupNo' => $groupNo, //群号
            'groupName' => $groupName, //群名字
            'groupUrl' => $groupUrl, //二维码
            'sort'=>$sort,
            'type' => 1, //状态  1为成功可使用   2为已使用
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
    public function getOfficialGroupList($page = 1, $limit = 10, $fields = []) {
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
    public function updateOfficialGroupData($id, $groupNo, $groupName, $groupUrl, $type,$sort) {
        $update = [];
        if (!empty($groupNo)) {
            $update['groupNo'] = $groupNo;
        }
        if (!empty($groupName)) {
            $update['groupName'] = $groupName;
        }
        if (!empty($groupUrl)) {
            $update['groupUrl'] = $groupUrl;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (!empty($sort)) {
            $update['sort'] = $sort;
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
     * 获取新闻列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientOfficialGroupList($page = 1, $limit = 10, $fields = []) {

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

}
