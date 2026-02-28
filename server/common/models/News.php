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
class News extends BaseModel
{

    protected $table = 't_news';

    public static function tableName()
    {
        return '{{t_news}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['subtitle', 'string'], //标题
            ['author', 'string'], //作者
            ['coverUrl', 'string'], //封面
            ['content', 'string'], //内容 。富文本格式
            ['type', 'number'], //状态  1为启用   2为关闭
            ['is_new', 'number'], //状态  1-新闻
            ['new_type', 'number'], //内容 。富文本格式
            ['url', 'string'], //外部跳转地址
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    public function addNewsData($title, $author, $coverUrl, $content)
    {

        $data = [
            'title' => $title, //标题
            'author' => $author, //作者
            'coverUrl' => $coverUrl, //封面
            'content' => $content, //内容 。富文本格式
            'type' => 2, //状态  1为成功可使用   2为已使用
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
    public function getNewsList($page = 1, $limit = 10, $fields = [])
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
     * 修改数据
     * @param type $id
     * @param type $title
     * @param type $author
     * @param type $coverUrl
     * @param type $content
     * @param type $type
     * @return boolean
     */
    public function updateNewsData($id, $title, $author, $coverUrl, $content, $type)
    {
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
    public function getClientNewsList($page = 1, $limit = 10, $fields = [])
    {

        // 如果缓存不存在，则执行数据库查询
        
        $where = [
            'and',
            ['=', 'display_position', 1]
        ];
        //$where = [];
        $list = $this->listFind(['page' => $page, 'row' => $limit])
            ->orderBy(['itime' => SORT_DESC])
            ->where($where)->asArray()->all();
        return $list;
    }


    /**
     * 获取新闻详情
     * @param type $id
     * @param type $fields
     * @return type
     */
    public function getClientNewsMessage($id, $fields = [])
    {
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
        $fields = [];
        self::$key = $fields;
        $data = $this->find()->where($where)->asArray()->one();
        //更新缓存
        $time = $this->redisTime;
        self::redisCacheOperation(md5($rediskey), $data, $time);

        return $data;
    }

}
