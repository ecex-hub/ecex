<?php

namespace common\models;

use common\components\FuncHelper;
use Yii;


class Address extends BaseModel
{

    protected $table = 't_address';


    protected $PDO_CONN = false;

    public static function tableName()
    {
        return '{{t_address}}';
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
            ['id', 'number'], //
            ['uid', 'number'], //
            ['name', 'string'], //
            ['phone', 'string'], //
            ['address', 'string'], //地址
            ['is_default', 'number'], //1-默认 2-确定
            ['city_id', 'number'], //1-默认 2-确定
            ['city_id_a', 'number'], //省
            ['city_id_b', 'number'], //市
            ['type', 'number'], //
            ['itime', 'number'], //
            ['utime', 'number'], //
        ];
    }

    public function addAddress($uid, $name, $phone, $address, $isDefault, $cityId)
    {
        $IDCardType = FuncHelper::phoneCorrect($phone);
        if (!$IDCardType) {
            $this->addError('mesg', ['212', '手机号格式不正确']);
            return false;
        }
        $city = new City();
        $cityInfo = $city->getInfo($cityId);
        if (empty($cityInfo)) {
            $this->addError('mesg', ['212', '未选择省市县']);
            return false;
        }
        $city = new City();
        $provinceInfo = $city->getInfo($cityInfo['parent_id']);
        if (empty($provinceInfo)) {
            $this->addError('mesg', ['212', '未选择省市县']);
            return false;
        }
        $data = [
            'uid' => $uid,
            'name' => $name,
            'phone' => $phone,
            'address' => $address,
            'is_default' => $isDefault,
            'city_id' => $cityId,
            'city_id_b' => $cityInfo['parent_id'],
            'city_id_a' => $provinceInfo['parent_id'],
            'itime' => time(),
            'utime' => time(),
        ];
        $boor = $this->insertData($data);
        if (!empty($boor)) {
            if ($isDefault == 2) {
                $this->setDefault($uid, $this->id);
            }
            return true;
        }
        $this->addError('mesg', ['212', '修改失败']);
        return false;
    }

    public function setDefault($uid, $id)
    {
        $data = [
            'is_default' => 1,
        ];
        $condition = [
            'and',
            ['!=', 'id', $id], // 排除指定的ID
            ['uid' => $uid],
            ['is_default' => 2],
        ];
        $bool = $this->updateAll($data, $condition);
    }

    public function getList($page = 1, $limit = 10, $uid, $fields = [])
    {

        $where = [
            'and',
            ['=', 'uid', $uid],
            ['=', 'type', 1]
        ];
        $list = $this->listFind(['page' => $page, 'row' => $limit])
            ->select($fields)
            ->orderBy('is_default desc,id desc')
            ->where($where)
            ->asArray()
            ->all();
        return $list;
    }

}