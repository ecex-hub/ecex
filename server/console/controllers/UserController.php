<?php

namespace console\controllers;

use common\models\AccountInfo;
use common\models\Pay;
use common\models\Real;
use common\models\Tongji;
use common\models\UserLogin;
use common\models\UserProduct;
use common\models\UserSignIn;
use common\models\WithdrawalOrder;
use yii\console\Controller;
use Yii;

class UserController extends Controller
{
    //每天更新一次
    public function actionIndex()
    {
        $userM = new AccountInfo();
        $uidArr = $userM->find()
            ->select('uid')
            ->where(["oneLevel" => 1000000143])
            ->column();
        if (count($uidArr) > 0) {

            foreach ($uidArr as $uid) {
                AccountInfo::updateAll(
                    ["is_business" => $uid], // 需要更新的字段
                    ["uid" => $uid]     // 条件
                );
            
                $userModel = new AccountInfo();
                $tmpArr = $userModel->find()
                    ->select('uid')
                    ->where(['like', 'path', $uid])
                    ->column();
                if (count($tmpArr) > 0) {
                    AccountInfo::updateAll(
                        ["is_business" => $uid], // 需要更新的字段
                        ["uid" => $tmpArr]     // 条件
                    );
                }
            }
        }
    }
}