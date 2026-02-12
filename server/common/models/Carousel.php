<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  轮播
 */
class Carousel extends BaseModel
{

    protected $table = 't_carousel';

    public static function tableName()
    {
        return '{{t_carousel}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['picUrl', 'string'], //图片地址
            ['sort', 'number'], //排序
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    public function addCarouselData($title, $picUrl, $sort)
    {

        $data = [
            'title' => $title, //标题
            'picUrl' => $picUrl, //
            'sort' => $sort, //
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
    public function getCarouselList($page = 1, $limit = 10, $fields = [])
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
    public function updateCarouselsData($id, $title, $picUrl, $sort, $type)
    {
        $update = [];
        if (!empty($title)) {
            $update['title'] = $title;
        }
        if (!empty($picUrl)) {
            $update['picUrl'] = $picUrl;
        }
        if (!empty($sort)) {
            $update['sort'] = $sort;
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
    public function getClientCarouselsList()
    {

        $where = [
            'and',
            ['=', 'type', 1]
        ];
        // 执行数据库查询
        $list = $this->find()->where($where)
            ->orderBy("sort asc")
            ->asArray()->all();
        return $list;
    }


}
