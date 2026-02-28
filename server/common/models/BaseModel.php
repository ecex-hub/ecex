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

    /**
     * Redis 缓存时间（秒）
     * @var int
     */
    public $redisTime = 3600;

    /**
     * 获取 Redis 缓存
     * @param string $key 缓存键
     * @return mixed 缓存值或 null
     */
    public function getRedisCacheOperation($key)
    {
        try {
            $redis = \Yii::$app->redis;
            if ($redis) {
                $data = $redis->get($key);
                return $data ? json_decode($data, true) : null;
            }
        } catch (\Exception $e) {
            \Yii::error('Redis get error: ' . $e->getMessage());
        }
        return null;
    }

    /**
     * 设置 Redis 缓存
     * @param string $key 缓存键
     * @param mixed $value 缓存值
     * @param int $expire 过期时间（秒）
     * @return bool 操作是否成功
     */
    public static function redisCacheOperation($key, $value, $expire = 3600)
    {
        try {
            $redis = \Yii::$app->redis;
            if ($redis) {
                $data = json_encode($value);
                if ($expire > 0) {
                    return $redis->setex($key, $expire, $data);
                } else {
                    return $redis->set($key, $data);
                }
            }
        } catch (\Exception $e) {
            \Yii::error('Redis set error: ' . $e->getMessage());
        }
        return false;
    }


}
