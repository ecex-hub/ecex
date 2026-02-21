<?php

namespace app\admin\model;

use think\Model;


class UserSignIn extends Model
{

    

    

    // 表名
    protected $name = 'user_sign_in';
    
    // 自动写入时间戳字段
    protected $autoWriteTimestamp = false;

    // 定义时间戳字段名
    protected $createTime = false;
    protected $updateTime = false;
    protected $deleteTime = false;

    // 追加属性
    protected $append = [
        'itime_text',
        'utime_text'
    ];
    

    
   // 关联用户表，指定外键为 uid，关联主键为 uid
   // 使用 setEagerlyType(1) 使用 IN 查询，避免 JOIN 查询的字段歧义问题
   public function user()
   {
       return $this->belongsTo(
           'app\admin\model\Account', 'uid', 'uid', [], 'LEFT')
           ->setEagerlyType(1);  // 改为 1，使用 IN 查询而不是 JOIN
   }


    public function getItimeTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['itime']) ? $data['itime'] : '');
        return is_numeric($value) ? date("Y-m-d H:i:s", $value) : $value;
    }


    public function getUtimeTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['utime']) ? $data['utime'] : '');
        return is_numeric($value) ? date("Y-m-d H:i:s", $value) : $value;
    }

    protected function setItimeAttr($value)
    {
        return $value === '' ? null : ($value && !is_numeric($value) ? strtotime($value) : $value);
    }

    protected function setUtimeAttr($value)
    {
        return $value === '' ? null : ($value && !is_numeric($value) ? strtotime($value) : $value);
    }


}
