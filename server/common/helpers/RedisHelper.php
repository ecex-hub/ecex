<?php

namespace common\helpers;

use yii\redis\Connection as RedisConnection;
use yii\base\Exception;

class RedisHelper
{
    const user_id_by_token = "u_token";
    const expireTime = 86400; //一天
    const tokenKeyPrefix = "access_token:uid_";
    const SignNotice = "sign:uid_";
    const SignNoticeTime = "259200";

    /**
     * @var RedisConnection
     */
    protected static $redis;

    /**
     * 这个方法中给 key 增加前缀
     * 所有与key相关的方法都要调用这个方法
     * @param $key
     * @return string
     */
    protected static function buildKey($key)
    {
        return \Yii::$app->params['redis.prefix'] . $key;
    }

    /**
     * @return \yii\redis\Connection
     */
    protected static function getRedis()
    {
        return \Yii::$app->redis;
    }

    /**
     * 获取缓存项
     *
     * @param string $key 缓存键
     * @return mixed 缓存值或 null
     */
    public static function getCache($key)
    {
        $key = self::buildKey($key);
        $data = self::getRedis()->get($key);
        return $data ? json_decode($data, true) : null;
    }

    /**
     * 设置缓存项
     *
     * @param string $key 缓存键
     * @param mixed $value 缓存值
     * @param int|null $expire 过期时间（秒）
     * @return bool 操作是否成功
     */
    public static function setCache($key, $value, $expire = null)
    {
        $key = self::buildKey($key);
        if ($expire !== null) {
            return self::getRedis()->setex($key, $expire, json_encode($value));
        } else {
            return self::getRedis()->set($key, json_encode($value));
        }
    }


    public static function delCache($key)
    {
        $key = self::buildKey($key);
        $data = self::getRedis()->del($key);
        return $data;
    }

    /**
     * # exists key
     *
     * 检查key是否存在
     * @param string $key
     * @return bool
     */
    public static function exists($key)
    {
        $key = self::buildKey($key);
        $redis = self::getRedis();
        return (bool)$redis->exists($key);
    }


    /**
     * 根据用户ID获取或生成访问令牌
     *
     * @param int $uid 用户唯一标识符
     * @param int $expireTime 过期时间（秒）
     * @return string 返回有效的令牌
     */
    public static function getTokenByUid($uid)
    {
        // 构建令牌键名
        $tokenKeyPrefix = self::tokenKeyPrefix . $uid;

        // 尝试从 Redis 获取用户的令牌
        $existingToken = RedisHelper::getCache($tokenKeyPrefix);

        if ($existingToken !== null) {
            // 续签用户映射关系
            RedisHelper::setCache(RedisHelper::user_id_by_token . $existingToken, $uid, self::expireTime);

            return $existingToken;
        } else {
            // 如果令牌不存在或已过期，则生成新的令牌
            $accessToken = \Yii::$app->security->generateRandomString();

            // 存储新生成的令牌到 Redis 并设置过期时间
            RedisHelper::setCache($tokenKeyPrefix, $accessToken, self::expireTime);

            //存储用户映射关系。
            RedisHelper::setCache(RedisHelper::user_id_by_token . $accessToken, $uid, self::expireTime);
            return $accessToken;
        }
    }

    /**
     * 根据 accessToken 获取用户 ID
     *
     * @param string $accessToken 访问令牌
     * @return int|null 返回用户 ID 或 null 如果找不到
     */
    public static function getUidByAccessToken($accessToken)
    {
        $uid = RedisHelper::getCache(RedisHelper::user_id_by_token . $accessToken);
        if ($uid === null) {
            return null;
        }
        $tokenKeyPrefix = self::tokenKeyPrefix . $uid;
        //对token续期
        RedisHelper::setCache(RedisHelper::user_id_by_token . $accessToken, $uid, self::expireTime);
        //对映射续期
        RedisHelper::setCache($tokenKeyPrefix, $accessToken, self::expireTime);
        return $uid;
    }


    public static function getSignToken($uid)
    {
        $key = self::SignNotice . $uid;
        $money = RedisHelper::getCache($key);
        return $money;
    }

    public static function cleanSignToken($uid)
    {
        $key = self::SignNotice . $uid;
        $bool = RedisHelper::delCache($key);
        return $bool;
    }

    /**
     * 根据用户 ID 删除其在 Redis 中的访问令牌及映射关系
     *
     * 用于用户退出登录时清理 token：
     * 1. 根据 uid 读取 tokenKeyPrefix:uid_{uid} 中保存的 accessToken
     * 2. 删除存储 token 的键（access_token:uid_{uid}）
     * 3. 删除 token 到 uid 的映射键（u_token{accessToken}）
     *
     * @param int $uid
     * @return bool 是否删除成功（如果本来就没有 token 也视为成功）
     */
    public static function deleteTokenByUid($uid)
    {
        // 构建保存 token 的键名
        $tokenKey = self::tokenKeyPrefix . $uid;

        // 先从 Redis 读取该用户当前的 token
        $accessToken = RedisHelper::getCache($tokenKey);

        // 如果没有找到 token，说明已过期或不存在，直接返回 true
        if (empty($accessToken)) {
            return true;
        }

        // 删除 token 映射：access_token:uid_{uid}
        RedisHelper::delCache($tokenKey);

        // 删除 token -> uid 的映射：u_token{accessToken}
        RedisHelper::delCache(RedisHelper::user_id_by_token . $accessToken);

        return true;
    }
}