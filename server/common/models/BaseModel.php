<?php

namespace common\models;

use yii\db\ActiveRecord;

class BaseModel extends ActiveRecord
{
    public function getCurrentTimestamp()
    {
        return time();
    }

    public function listFind($params = [])
    {
        $query = $this->find();
        $page = 1;
        $limit = 10;
        if ($params['page']) {
            $page = $params['page'];
        }
        if ($params['row']) {
            $limit = $params['row'];
        }
        $query->limit($limit)->offset(($page - 1) * $limit);
        return $query;
    }

    public function insertData(array $data)
    {

        $transaction = \Yii::$app->db->beginTransaction();
        try {
            $this->attributes = $data;
            if (!$this->validate()) {
                $validate = [
                    'err' => $this->errors
                ];
                throw new \Exception('Validation failed: ' . json_encode($validate));
            }
            if (!$this->save(false)) {
                throw new \Exception('Failed to save');
            }
            $transaction->commit();
            return true;
        } catch (\Exception $e) {
            $transaction->rollBack();
            \Yii::error($e->getMessage());
            return false;
        }
    }


}
