<?php

namespace app\admin\model;

use think\Model;


class Withdrawal extends Model
{


    // 表名
    protected $name = 'withdrawal';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = false;

    // 定义时间戳字段名
    protected $createTime = false;
    protected $updateTime = false;
    protected $deleteTime = false;

    // 追加属性
    protected $append = [
//        'itime_text',
//        'utime_text',
//        'pay_time_text'
    ];


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


    public function getPayTimeTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['pay_time']) ? $data['pay_time'] : '');
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

    protected function setPayTimeAttr($value)
    {
        return $value === '' ? null : ($value && !is_numeric($value) ? strtotime($value) : $value);
    }

    public function user()
    {
        return $this->belongsTo(
            'app\admin\model\Account', 'uid', 'uid', [], 'LEFT')
            ->setEagerlyType(0);
    }

    public function admin()
    {
        return $this->belongsTo(
            'app\admin\model\Admin', 'ext_id', 'id', [], 'LEFT')
            ->setEagerlyType(0);
    }
}
