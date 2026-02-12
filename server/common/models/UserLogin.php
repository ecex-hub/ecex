<?php

namespace common\models;


use common\components\FuncHelper;
use yii\db\Expression;
use yii;

class UserLogin extends BaseModel
{

    protected $table = 't_user_login';

    public static function tableName()
    {
        return '{{t_user_login}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], //标记id
            ['uid', 'number'], //标题
            ['day', 'string'], //日期
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }
}