<?php

namespace app\admin\model;

use think\Model;


class Account extends Model
{


    // 表名
    protected $name = 'account_info';

    // 自动写入时间戳字段
    protected $autoWriteTimestamp = false;

    // 定义时间戳字段名
    protected $createTime = false;
    protected $updateTime = false;
    protected $deleteTime = false;

    // 追加属性
    protected $append = [

    ];

  
    public function upuser()
    {
        // 只获取上级用户的关键字段，避免返回过多无用数据
        return $this->belongsTo('app\admin\model\Account', 'oneLevel', 'uid' ,[], 'LEFT')
            ->field('uid,nickname')
            ->setEagerlyType(1);
    }
    public function bank()
    {
        return $this->belongsTo(
            'app\admin\model\Bank', 'uid', 'uid', [], 'LEFT')
            ->setEagerlyType(0);
    }

}
