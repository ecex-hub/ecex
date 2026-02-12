<?php

namespace common\models;

use Yii;

/**
 * 用户资料信息管理表单记录
 */
class UserDataManagement extends BaseModel
{
    protected $table = 't_user_data_management';

    public static function tableName()
    {
        return '{{t_user_data_management}}';
    }

    public static function getDb()
    {
        return Yii::$app->get('db');
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'], // 标记 id
            ['uid', 'number'], // 用户 id
            ['name', 'string', 'max' => 64], // 姓名
            ['id_number', 'string', 'max' => 32], // 身份证号
            ['projects', 'string'], // 曾参加的项目（长文本）
            ['contribution', 'number'], // 业绩贡献（金额）
            ['additional_notes', 'string'], // 补充说明（长文本）
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    /**
     * 新增一条资料信息记录
     *
     * @param int $uid
     * @param string $name
     * @param string $idNumber
     * @param string $projects
     * @param string|null $contribution
     * @param string|null $additionalNotes
     * @return bool
     */
    public function addRecord($uid, $name, $idNumber, $projects, $contribution = null, $additionalNotes = null)
    {
        if (empty($uid)) {
            $this->addError('mesg', ['212', '用户未登录']);
            return false;
        }

        if (empty($name) || empty($idNumber) || empty($projects)) {
            $this->addError('mesg', ['212', '姓名、身份证号、曾参加的项目为必填项']);
            return false;
        }

        // 业绩贡献如果填写了，则必须为数字
        if ($contribution !== null && $contribution !== '') {
            if (!is_numeric($contribution)) {
                $this->addError('mesg', ['212', '业绩贡献必须为数字']);
                return false;
            }
            $contribution = (float)$contribution;
        }

        $data = [
            'uid' => (int)$uid,
            'name' => $name,
            'id_number' => $idNumber,
            'projects' => $projects,
            'contribution' => $contribution === '' ? null : $contribution,
            'additional_notes' => $additionalNotes,
            'itime' => time(),
            'utime' => time(),
        ];

        $this->attributes = $data;
        // 先做一次显式校验，便于拿到更清晰的错误信息
        if (!$this->validate()) {
            $errors = $this->getFirstErrors();
            $firstMsg = reset($errors) ?: '数据校验失败';
            $this->addError('mesg', ['212', $firstMsg]);
            return false;
        }

        $result = $this->insertData($data);
        if (!empty($result)) {
            return true;
        }

        $this->addError('mesg', ['212', '保存失败，请稍后重试']);
        return false;
    }
}

