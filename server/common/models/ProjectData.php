<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;

/**
 * ContactForm is the model behind the contact form.  项目内容
 */
class ProjectData extends BaseModel {

    protected $table = 't_project_data';

    public static function tableName() {
        return '{{t_project_data}}';
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
            ['id', 'number'], //标记id
            ['title', 'string'], //标题
            ['subtitle', 'string'], //副标题
            ['content', 'string'], //内容 。
            ['coverUrl', 'string'], //封面
            ['projectType', 'number'], //项目类型  1级项目 。2级项目
            ['superiorId', 'number'], //二级项目上级id
            ['investMoney', 'number'], //投资金额
            ['sort', 'number'], //排序
            ['type', 'number'], //状态  1为启用   2为关闭
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    private static $key = [];

    public static function selectColumn() {
        return self::$key;
    }

    public function addProjectData($title, $subtitle, $content, $coverUrl, $projectType, $superiorId, $sort,$investMoney) {
        if ($projectType == 2) {
            if (empty($superiorId)) {
                $this->addError('mesg', ['212', '填写上级项目id']);
                return false;
            }

            $existData = $this->find()->where(['id' => $superiorId])->asArray()->one();
            if (empty($existData) || $existData['projectType'] <> 1) {
                $this->addError('mesg', ['212', '上级项目id异常']);
                return false;
            }
        }

        $data = [
            'title' => $title, //标题
            'subtitle' => $subtitle, //副标题
            'content' => $content, //内容 。
            'coverUrl' => $coverUrl, //封面
            'projectType' => $projectType, //项目内容  1级项目 。2级项目
            'superiorId' => $superiorId, //二级项目上级id
            'sort' => $sort,
            'investMoney'=>$investMoney,
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
    public function getProjectList($page = 1, $limit = 10, $fields = [], $projectType = null,$superiorId=null) {
        $where = [
            'and'
        ];
        if (!empty($projectType)) {
            $where[] = [
                '=', 'projectType', $projectType
            ];
        }
        if(!empty($superiorId))
            $where[] = ['=','superiorId',$superiorId];
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
    public function updateProjectData($id, $title, $subtitle, $content, $coverUrl, $sort, $type,$investMoney) {
        $update = [];
        if (!empty($title)) {
            $update['title'] = $title;
        }
        if (!empty($subtitle)) {
            $update['subtitle'] = $subtitle;
        }
        if (!empty($content)) {
            $update['content'] = $content;
        }
        if (!empty($coverUrl)) {
            $update['coverUrl'] = $coverUrl;
        }
        if (!empty($type)) {
            $update['type'] = $type;
        }
        if (!empty($sort)) {
            $update['sort'] = $sort;
        }
        if(!empty($investMoney))
            $update['investMoney'] = $investMoney;

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
    public function getClientProjectList($page = 1, $limit = 10, $fields = [], $projectType, $superiorId = null) {

        $rediskey = __METHOD__ . $page . $limit . $projectType . $superiorId;
        $redisData = $this->getRedisCacheOperation(md5($rediskey));
        if (!empty($redisData)) {
            return $redisData;
        }

        $where = [
            'and',
            ['=', 'type', 1],
            ['=', 'projectType', $projectType]
        ];
        if (!empty($superiorId)) {
            $where[] = ['=', 'superiorId', $superiorId];
        }


        self::$key = $fields;
        $data['data'] = $this->listFind(['page' => $page, 'row' => $limit, 'sort' => '-sort'])->where($where)->all();
        $data['count'] = $this->listFind([])->where($where)->count();
        $data['page'] = ceil($data['count'] / $limit);

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
    public static function getProjectDataMessage($id) {
        $data = self::find()->where(['id' => $id])->asArray()->one();
        return $data;
    }
    
    
       
    /**
     * 获取指定id列表
     * @param type $id
     * @return type
     */
    public static function getProjectDataListMessage($id) {
        $where = [
            'and',
            ['in','id',$id]
        ];
        
        $temp = self::find()->where($where)->asArray()->all();
        $data = [];
        foreach ($temp as $key => $value) {
            $data[$value['id']] = $value['title'];
        }
        return $data;
    }
    

}
