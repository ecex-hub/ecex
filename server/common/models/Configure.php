<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  系统配置
 */
class Configure extends BaseModel
{

    protected $table = 't_config';

    public static function tableName()
    {
        return '{{t_config}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'integer'], //标识id
            ['value', 'string'], //配置value
            ['remarks', 'string'], //备注
            ['name', 'string'], //唯一标识
            ['sort', 'number'], //排序
            ['itime', 'number'], //创建时间
            ['utime', 'number'], //更新时间,
        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    

    /**
     * =获取配置  如果没有缓存则添加缓存
     * @param type $configure_key
     * @return type
     */
    public static function getConfigure($key)
    {


        $where = [
            'and',
            ['name' => $key]
        ];
        $data = self::find()->where($where)->asArray()->one();
        if (empty($data)) {
            return "";
        }
        return $data['value'];
    }


    /**
     * 获取列表
     * @param type $page
     * @param type $limit
     * @param type $fields
     * @return type
     */
    public function getSystemConfigureList($page = 1, $limit = 10, $fields = [])
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
     * 修改配置
     * @param type $id
     * @param type $configure_value
     * @return boolean
     */
    public function updateSystemConfigureData($id, $configure_value)
    {
        $update = [];
        if (!empty($configure_value)) {
            $update['configure_value'] = $configure_value;
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

}
