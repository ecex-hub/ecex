<?php

namespace app\admin\model\points;

use think\Model;
use traits\model\SoftDelete;

class Order extends Model
{

    use SoftDelete;

    

    // 表名
    protected $name = 'points_order';
    
    // 自动写入时间戳字段
    protected $autoWriteTimestamp = 'integer';

    // 定义时间戳字段名
    protected $createTime = 'createtime';
    protected $updateTime = 'updatetime';
    protected $deleteTime = 'deletetime';

    
    // 关联商品
    public function goods()
    {
        return $this->belongsTo('app\admin\model\points\Goods', 'goods_id', 'id')->setEagerlyType(0);
    }
     // 关联用户（指向自定义的用户表）
     public function user()
     {
         return $this->belongsTo('app\admin\model\Account', 'user_id', 'uid')->setEagerlyType(0);
     }
 
     // 可选：关联收货地址
     public function address()
     {
         return $this->belongsTo('app\admin\model\points\Address', 'address_id', 'id')->setEagerlyType(0);
     }
    // 追加属性
    protected $append = [
        'status_text'
    ];
    

    
    public function getStatusList()
    {
        return ['0' => __('Status 0'), '1' => __('Status 1'), '2' => __('Status 2'), '3' => __('Status 3')];
    }


    public function getStatusTextAttr($value, $data)
    {
        $value = $value ? $value : (isset($data['status']) ? $data['status'] : '');
        $list = $this->getStatusList();
        return isset($list[$value]) ? $list[$value] : '';
    }




}
