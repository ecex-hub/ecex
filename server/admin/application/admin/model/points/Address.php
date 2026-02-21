<?php

namespace app\admin\model\points;

use think\Model;
use traits\model\SoftDelete;

class Address extends Model
{

    use SoftDelete;

    

    // 表名
    protected $name = 'points_address';
    
    // 自动写入时间戳字段
    protected $autoWriteTimestamp = 'integer';

    // 定义时间戳字段名
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';
    protected $deleteTime = 'deletetime';
    // 关联用户
    public function user()
    {
        return $this->belongsTo('app\admin\model\Account', 'user_id', 'uid')->setEagerlyType(0);
    }
    // 追加属性
    protected $append = [
        'is_default_text'
    ];
    

    
    public function getIsDefaultList()
    {
        return ['0' => __('Is_default 0'), '1' => __('Is_default 1')];
    }


    public function getIsDefaultTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['is_default']) ? $data['is_default'] : '');
        $list = $this->getIsDefaultList();
        return isset($list[$value]) ? $list[$value] : '';
    }




}
