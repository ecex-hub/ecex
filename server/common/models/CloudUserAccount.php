<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  新闻
 */
class CloudUserAccount extends BaseModel {

    protected $table = 'cloud_times_api_user';

    public static function tableName() {
        return '{{cloud_times_api_user}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['author', 'string'], //作者
            ['coverUrl', 'string'], //封面
            ['content', 'string'], //内容 。富文本格式
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addCloudUserAccountData() {
        $where = [
            'and',
           // ['=','id',16984]
        ];
        $model = new AccountInfo();
        for ($i = 1; $i < 170; $i++) {
            $data = $this->listFind(['page' => $i, 'row' => 1000, 'sort' => 'id'])->where($where)->all();
            if (empty($data)) {
                echo 'gg';
                exit;
            } else {
                //id  mobile  password  payword  parent_user_id  bonus_share  initial_share
                foreach ($data as $key => $value) {
                    $boor = $model->RegisterAccountTemp($value['id'], $value['mobile'], $value['password'], $value['payword'], $value['parent_user_id'], $value['bonus_share'], $value['initial_share']);
                    if (empty($boor)) {
                        $error_mesg = $model->getErrors('mesg');
                        var_dump($error_mesg[0][1]);
                    }
                }
            }
        }
    }

    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getNewsList($page = 1, $limit = 10, $fields = []) {
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
    public function updateNewsData($id, $title, $author, $coverUrl, $content, $type) {
        $update = [];
        if (!empty($title)) {
            $update['title'] = $title;
        }
        if (!empty($author)) {
            $update['author'] = $author;
        }
        if (!empty($coverUrl)) {
            $update['coverUrl'] = $coverUrl;
        }
        if (!empty($content)) {
            $update['content'] = $content;
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
     * 获取新闻列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getClientNewsList($page = 1, $limit = 10, $fields = []) {

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
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-itime'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

    /**
     * 获取新闻详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientNewsMessage($id, $fields = []) {
        $rediskey = __METHOD__ . $id;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }
        $where = [
            'and',
            ['=', 'type', 1],
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
