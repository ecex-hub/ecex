<?php
namespace app\admin\model;

use think\Model;
use think\Db;

class AccountInfo extends Model
{
    protected $name = 'account_info';
    protected $pk = 'uid';
	
	
	
	// 获取用户ID为 $uid 的所有后代（depth > 0）
// $count = Db::name('referral_tree')
    // ->where('ancestor_id', $uid)
    // ->where('depth', '>', 0)
    // ->count();
	
    public static function init()
    {
        self::afterInsert(function ($user) {
            $uid = $user->uid;
            $referrerId = $user->getAttr('referrer_id');

            Db::startTrans();
            try {
                // 1. 插入自身关系
                Db::name('referral_tree')->insert([
                    'ancestor_id'   => $uid,
                    'descendant_id' => $uid,
                    'depth'         => 0
                ]);

                // 2. 如果有推荐人，插入所有祖先关系
                if ($referrerId) {
                    // 获取推荐人的所有祖先（包括推荐人自身）
                    $ancestors = Db::name('referral_tree')
                        ->where('descendant_id', $referrerId)
                        ->select();

                    $data = [];
                    foreach ($ancestors as $row) {
                        $data[] = [
                            'ancestor_id'   => $row['ancestor_id'],
                            'descendant_id' => $uid,
                            'depth'         => $row['depth'] + 1
                        ];
                    }
                    if (!empty($data)) {
                        Db::name('referral_tree')->insertAll($data);
                    }
                }

                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                // 记录错误日志
                trace('推荐关系建立失败：' . $e->getMessage(), 'error');
            }
        });
    }
}