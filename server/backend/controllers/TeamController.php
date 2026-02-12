<?php

namespace backend\controllers;

use common\models\Province;
use common\models\UserProduct;
use Yii;
use common\models\AccountInfo;

class TeamController extends \backend\lib\ApiBaseController
{
    /**
     * @OA\POST(
     *   path="/team/list",
     *   tags={"团队"},
     *   summary="团队详情页",
     *   description="根据指定的过滤条件获取用户列表。",
     *   @OA\Response(
     *     response=200,
     *     description="成功的操作",
     *     @OA\JsonContent(
     *       type="object",
     *       @OA\Property(property="code", type="integer", example=200),
     *       @OA\Property(property="message", type="string", example="success"),
     *       @OA\Property(
     *         property="data",
     *         type="object",
     *         @OA\Property(property="buy_product_money", type="string", example="0"),
     *         @OA\Property(property="register_num", type="string", example="10"),
     *         @OA\Property(
     *           property="list",
     *           type="array",
     *           @OA\Items(
     *             type="object",
     *             @OA\Property(property="uid", type="string", example="6"),
     *             @OA\Property(property="account", type="string", example="18081077690"),
     *             @OA\Property(property="nickname", type="string", example="千千阙歌"),
     *             @OA\Property(property="itime", type="string", example="0"),
     *             @OA\Property(property="buy_product_money", type="string", example="0.00")
     *           )
     *         )
     *       )
     *     )
     *   ),
     *   @OA\Parameter(
     *     name="level",
     *     in="query",
     *     description="用户等级",
     *     required=false,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Parameter(
     *     name="page",
     *     in="query",
     *     description="页码",
     *     required=false,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Parameter(
     *     name="size",
     *     in="query",
     *     description="每页大小",
     *     required=false,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Parameter(
     *     name="keywords",
     *     in="query",
     *     description="关键词搜索",
     *     required=false,
     *     @OA\Schema(type="string")
     *   )
     * )
     */
    public function actionList()
    {
        $params = $this->params(['level', 'page', 'size', 'keywords']);
        $model = new AccountInfo();
        $user = Yii::$app->user->identity;
        $uid = $user->uid;
        $list = $model->getTeamList($uid, $params['level'],
            $params['page'], $params['size'], $params['keywords']);
        foreach ($list as &$row) {
            $path = $row['path'];
            if ($path == "") {
                $path = $row['uid'] . "," . "%";
            } else {
                $path = $path . $row['uid'] . "," . "%";
            }
            $map = ['like', 'path', $path, false];
            $model = new AccountInfo();
            $row['num'] = $model->find()->where($map)->count();
            $row['itime'] = date("Y-m-d H:i:s", $row['itime']);

            $userProductM = new UserProduct();
            $userProduct = $userProductM->find()
                ->select(["id"])
                ->where(['uid' => $row['uid']])
                ->one();
            $row['is_buy'] = false;
            if ($userProduct) {
                $row['is_buy'] = true;
            }
        }
        $count = $model->getTeamCount($uid, $params['level'], $params['keywords']);
        $registerNum = $model->getTeamRegisterNum($uid, $user->path);
        $where1 = [
            'and',
            ['=', 'oneLevel', $uid],
        ];
        $oneLevel = $model->find()
            ->where($where1)
            ->count();
        $where2 = [
            'and',
            ['=', 'twoLevel', $uid],
        ];
        $twoLevel = $model->find()
            ->where($where2)
            ->count();

        $where3 = [
            'and',
            ['=', 'threeLevel', $uid],
        ];
        $threeLevel = $model->find()
            ->where($where3)
            ->count();
        $otherNum = max(0, $registerNum - $oneLevel - $twoLevel - $threeLevel);
        $data = [
            'buy_product_money' => $model->getTeamBuyMoney($uid),
            'register_num' => $registerNum,
            'list' => $list,
            'count' => $count,
            'one_num' => $oneLevel,
            'two_num' => $twoLevel,
            'three_num' => $threeLevel,
            'other_num' => $otherNum,
            'reward' => [
                [
                    'key' => 5,
                    'value' => 88,
                ],
                [
                    'key' => 10,
                    'value' => 288,
                ],
                [
                    'key' => 25,
                    'value' => 888,
                ],
                [
                    'key' => 50,
                    'value' => 2088,
                ],
                [
                    'key' => 100,
                    'value' => 6888,
                ],
            ]
        ];
        $this->output($data);
    }


    /**
     * @OA\Get(
     *     path="/team/stats",
     *     tags={"团队"},
     *     summary="获取团队统计",
     *     description="获取当前用户的团队统计数据",
     *     security={{"bearerAuth": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(property="buy_product_money", type="string", example="0", description="团队购买产品总金额"),
     *                 @OA\Property(property="register_num", type="string", example="10", description="注册人数"),
     *                 @OA\Property(property="one_num", type="integer", example=5, description="一级人数"),
     *                 @OA\Property(property="two_num", type="integer", example=3, description="二级人数"),
     *                 @OA\Property(property="three_num", type="integer", example=2, description="三级人数"),
     *                 @OA\Property(property="other_num", type="integer", example=0, description="其他级人数")
     *             )
     *         )
     *     )
     * )
     */
    public function actionStats()
    {
        $model = new AccountInfo();
        $user = Yii::$app->user->identity;
        $uid = $user->uid;
        
        $registerNum = $model->getTeamRegisterNum($uid, $user->path);
        
        $where1 = [
            'and',
            ['=', 'oneLevel', $uid],
        ];
        $oneLevel = $model->find()
            ->where($where1)
            ->count();
        $where2 = [
            'and',
            ['=', 'twoLevel', $uid],
        ];
        $twoLevel = $model->find()
            ->where($where2)
            ->count();

        $where3 = [
            'and',
            ['=', 'threeLevel', $uid],
        ];
        $threeLevel = $model->find()
            ->where($where3)
            ->count();
        $otherNum = max(0, $registerNum - $oneLevel - $twoLevel - $threeLevel);
        
        $data = [
            'buy_product_money' => $model->getTeamBuyMoney($uid),
            'register_num' => $registerNum,
            'one_num' => $oneLevel,
            'two_num' => $twoLevel,
            'three_num' => $threeLevel,
            'other_num' => $otherNum,
        ];
        $this->output($data);
    }

    public function actionProvince()
    {
        $model = new Province();
        $list = $model->find()->all();
        $this->output($list);
    }
}