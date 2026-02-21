<?php

namespace app\admin\controller;

use app\admin\model\Account;
use app\admin\model\Bill;
use app\common\controller\Backend;
use common\models\AccountInfo;
use think\Db;
use think\exception\DbException;
use think\exception\PDOException;
use think\exception\ValidateException;
use think\response\Json;

/**
 * 视频管理
 *
 * @icon fa fa-circle-o
 */
class Test extends Backend
{

    public function index()
    {
        $userIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
        foreach ($userIds as $uid) {
            Db::transaction(function () {
                //用户账号
                $money = 10000;
                $accountModel = new Account();
                $accountModel->where('uid', 2)
                    ->inc('dream_fund', $money)->update();

                $billData = [
                    'uid' => 0,
                    'money' => 0,
                    'itime' => time(),
                    'utime' => time(),
                ];
                $this->model->data($billData);
                $this->model->save();
            });
        }
        var_dump(111);
        die;
    }

    public function test()
    {
//        $accountModel = new Account();
//        $sql = $accountModel->where('uid', 1000000087)
//            ->inc("pay_back", 2)
//            ->inc('dream_fund', 10000)
////            ->fetchSql(true)
//            ->update();

        $accountModel = new Account();
        $sql = $accountModel->where('uid', 1000000087)
            ->inc("dream_fund", 100)
//            ->fetchSql(true)
            ->update([
                'realName' => '',
                'IDFrontUrl' => '',
                'IDOppositeUrl' => '',
                'IDCard' => '',
                'is_real' => 2,
            ]);
        var_dump($sql);
    }
}