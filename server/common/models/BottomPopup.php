<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;

/**
 * ContactForm is the model behind the contact form.  底部弹窗 。
 */
//class UserMemberForm extends  BaseModel implements IdentityInterface
class BottomPopup extends BaseModel {

    protected $table = 't_bottom_popup';

    public static function tableName() {
        return '{{t_bottom_popup}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['_id', 'string'], //标记id
            ['popupContent', 'string'], //弹窗内容
            ['vid', 'number'], //视频id
            ['type', 'number'], //是否启用 。1启用 2关闭
            ['itime', 'number'], //时间
            ['utime', 'number'], //时间
        ];
    }

    public static function getDb() {
        return Yii::$app->get('adminData');
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    /**
     * 增加数据
     */
    public function addBottomPopup($popupContent, $vid) {
        $fields = [];
        $Video = Video::getWebVideoDataOne($vid, $fields);
        if (empty($Video) || $Video['up'] <> 1) {
            $this->addError('mesg', ['211', '请输入上架视频id']);
            return false;
        }
        $data = [
            '_id' => FuncHelper::uniqid12(),
            'popupContent' => $popupContent, //弹窗内容
            'vid' => $vid, //视频id
            'type' => 1, //是否启用 。1启用 2关闭
            'itime' => time(), //时间
            'utime' => time(), //时间
        ];
        $this->attributes = $data;
        if ($this->validate()) {
            $boor = $this->addData($data);
            if ($boor) {
                return true;
            }
        }
        $this->addError('mesg', ['211', '添加失败']);
        return false;
        return false;
    }

    /**
     * 获取列表
     * @return mixed.
     */
    public function getList($page = 1, $limit = 10, $fields = [], $uid = null) {
        $where = [
            'and'
        ];

        self::$key = $fields;
        //$data['content'] = $this->listFind(['page' => $page, 'row' => $limit])->where($where)->all();
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-_id'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        return $data;
    }

    /**
     * 修改数据
     * @param type $id
     * @param type $vid
     * @param type $popupContent
     * @param type $type
     * @return boolean
     */
    public function updateBottomPopup($id, $vid, $popupContent, $type) {
        $update = [];
        if (!empty($vid)) {
            $fields = [];
            $Video = Video::getWebVideoDataOne($vid, $fields);
            if (empty($Video) || $Video['up'] <> 1) {
                $this->addError('mesg', ['211', '请输入上架视频id']);
                return false;
            }
            $update['vid'] = $vid;
        }

        if (!empty($popupContent)) {
            $update['popupContent'] = $popupContent;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (empty($update)) {
            $this->addError('mesg', ['211', '修改数据不能为空']);
            return false;
        }
        $boor = $this->updateAll($update, ['_id' => $id]);
        if (!empty($boor)) {
            return true;
        }
        $this->addError('mesg', ['211', '请输入上架视频id']);
        return false;
    }

    /**
     * 获取上架列表
     * @return mixed.
     */
    public function getBottomPopupList($page = 1, $limit = 20, $fields = []) {
        $key = __METHOD__ . $page . $limit;
        $redisData = $this->getRedisCacheOperation(md5($key));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'type', 1]
        ];
        self::$key = $fields;
        $data = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-utime'])->where($where)->all();
//        $data['count'] = $this->listFind([])->where($where)->count();
//        $lastpg = ceil($data['count'] / $limit);
//        $data['pageend'] = ($page + 1) > $lastpg ? 1 : 0;
        //更新缓存
        $time = Yii::$app->params['redisTime'];
        self::redisCacheOperation(md5($key), $data, $time);
        return $data;
    }

    /**
     * 获取随机广告
     * @return string
     */
    public function getRandPopup() {
        $data = $this->getBottomPopupList();
        if (!empty($data)) {
            $rand = rand(0, count($data) - 1);
            $data = $data[$rand];
            $temp['popupContent'] = $data['popupContent'];
            $temp['vid'] = $data['vid'];
        } else {
            $temp['popupContent'] = '';
            $temp['vid'] = '';
        }
        return $temp;
    }

}
