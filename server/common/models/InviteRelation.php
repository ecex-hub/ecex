<?php

namespace common\models;

use Yii;
use common\models\BaseModel;
use common\components\FuncHelper;
use yii\behaviors\TimestampBehavior;
use yii\data\Pagination;
use yii\db\ActiveRecord;


class InviteRelation extends BaseModel
{

    protected $table = 't_invite_relation';

    public static function tableName()
    {
        return '{{t_invite_relation}}';
    }


    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //
            ['pid', 'number'], //投资id
        ];
    }

}