<?php

namespace backend\controllers;

use common\models\Product;
use common\models\UserProduct;


class ProductController extends \backend\lib\ApiBaseController
{
    /**
     * @OA\POST(
     *   path="/product/list",
     *   summary="产品列表",
     *   description="产品列表",
     *   tags={"产品"},
     *   operationId="getHotAndPaginatedItems",
     *   @OA\Parameter(
     *     name="page",
     *     in="query",
     *     description="Page number for pagination",
     *     required=true,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Parameter(
     *     name="size",
     *     in="query",
     *     description="Number of items per page",
     *     required=true,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Response(
     *     response=200,
     *     description="Successful operation",
     *     @OA\JsonContent(
     *       @OA\Property(property="code", type="integer", example=200),
     *       @OA\Property(property="message", type="string", example="success"),
     *       @OA\Property(
     *         property="data",
     *         type="object",
     *         @OA\Property(
     *           property="hot_list",
     *           type="array",
     *           @OA\Items(
     *             type="object",
     *             @OA\Property(property="id", type="integer", example=4),
     *             @OA\Property(property="name", type="string", example="nihao"),
     *             @OA\Property(property="price", type="string", example="1.00"),
     *             @OA\Property(property="product_type", type="integer", example=1),
     *             @OA\Property(property="day", type="integer", example=1),
     *             @OA\Property(property="day_income", type="string", example="111.00"),
     *             @OA\Property(property="allowance", type="string", example="111.00")
     *             @OA\Property(property="month", type="string", example="111.00"),
     *             @OA\Property(property="month_income", type="string", example="111.00")
     *           )
     *         ),
     *         @OA\Property(
     *           property="list",
     *           type="array",
     *           @OA\Items(
     *             type="object",
     *             @OA\Property(property="id", type="integer", example=4),
     *             @OA\Property(property="name", type="string", example="nihao"),
     *             @OA\Property(property="price", type="string", example="1.00"),
     *             @OA\Property(property="day", type="integer", example=1),
     *             @OA\Property(property="day_income", type="string", example="111.00"),
     *             @OA\Property(property="allowance", type="string", example="111.00")
     *           )
     *         )
     *       )
     *     )
     *   )
     * )
     */
    public function actionList()
    {
        $params = $this->params([
            'page',
            'size',
        ]);
        //$uid = Yii::$app->user->identity->uid;
        //新闻
        $model = new Product();
        $hotList = $model->getList($params['page'], $params['size'], 1);
        $list = $model->getList($params['page'], $params['size']);
        $data = [
            'hot_list' => $hotList,
            'list' => $list,
        ];
        $this->output($data);
    }

    /**
     * @OA\POST(
     *   path="/product/info",
     *   summary="产品详情",
     *   description="产品详情",
     *   tags={"产品"},
     *   operationId="getItemById",
     *   @OA\Parameter(
     *     name="id",
     *     in="query",
     *     description="ID of the item to fetch",
     *     required=true,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Response(
     *     response=200,
     *     description="Successful operation",
     *     @OA\JsonContent(
     *       allOf={
     *         @OA\Schema(
     *           @OA\Property(
     *             property="data",
     *             type="object",
     *             @OA\Property(property="id", type="integer", example=4),
     *             @OA\Property(property="name", type="string", example="nihao"),
     *             @OA\Property(property="price", type="string", example="1.00"),
     *             @OA\Property(property="day", type="integer", example=1),
     *             @OA\Property(property="day_income", type="string", example="111.00"),
     *             @OA\Property(property="allowance", type="string", example="111.00"),
     *             @OA\Property(property="remark", type="string", example="111"),
     *             @OA\Property(property="is_hot", type="integer", example=1),
     *             @OA\Property(property="sort", type="integer", example=1),
     *             @OA\Property(property="type", type="integer", example=1),
     *             @OA\Property(property="itime", type="integer", example=1),
     *             @OA\Property(property="utime", type="integer", example=1)
     *           )
     *         )
     *       }
     *     )
     *   )
     * )
     */
    public function actionInfo()
    {
        $params = $this->params([
            'id',
        ]);
        //$uid = Yii::$app->user->identity->uid;
        //新闻
        $model = new Product();
        $data = $model->getInfo($params['id']);
        $this->output($data);
    }


    /**
     * @OA\POST(
     *   path="/product/buy",
     *   summary="产品购买",
     *   description="产品购买",
     *   tags={"产品"},
     *   @OA\Parameter(
     *     name="id",
     *     in="query",
     *     description="主键ID",
     *     required=true,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Parameter(
     *     name="num",
     *     in="query",
     *     description="数量",
     *     required=true,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Response(
     *         response=200,
     *         description="成功返回签到数据列表",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *    )
     * )
     */
    public function actionBuy()
    {
        $params = $this->params([
            'id', 'num',
        ]);
        $this->VerificationParameter($params, ['id', 'num']);
        $user = \Yii::$app->user->identity;
        $model = new Product();
        list($code, $msg) = $model->buyProduct($params['id'], $params['num'], $user);
        if (empty($code)) {
            $this->output();
        } else {
            $this->output_error($msg, 212);
        }
    }


    /**
     * @OA\POST(
     *     path="/product/user-list",
     *     summary="用户产品列表",
     *     tags={"产品"},
     *     operationId="getResourceList",
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="当前页码",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         description="每页大小",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Parameter(
     *         name="type",
     *         in="query",
     *         description="1-默认 2-完成",
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功的响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="string", example="6"),
     *                     @OA\Property(property="name", type="string", example="nihao"),
     *                     @OA\Property(property="total_price", type="number", format="float", example=1.00),
     *                     @OA\Property(property="itime", type="integer", format="unix-timestamp", example=1735108542),
     *                     @OA\Property(property="type", type="integer", example=1),
     *                     @OA\Property(property="create_time", type="string", format="date-time", example="2024-12-25 14:35:42")
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(response=400, description="无效的请求参数"),
     *     @OA\Response(response=500, description="服务器内部错误")
     * )
     */
    public function actionUserList()
    {
        $params = $this->params([
            'page', 'size', 'type'
        ]);
        $uid = \Yii::$app->user->identity->uid;
        $model = new Product();
        $list = $model->getUserList($uid, $params['page'], $params['size'], $params['type']);
        $this->output($list);
    }


    /**
     * @OA\POST(
     *   path="/product/user-info",
     *   summary="用户产品详情",
     *   description="用户产品详情",
     *   tags={"产品"},
     *   operationId="getItemById",
     *   @OA\Parameter(
     *     name="id",
     *     in="query",
     *     description="ID of the item to fetch",
     *     required=true,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Response(
     *     response=200,
     *     description="Successful operation",
     *     @OA\JsonContent(
     *       allOf={
     *         @OA\Schema(
     *           @OA\Property(
     *             property="data",
     *             type="object",
     *             @OA\Property(property="id", type="integer", example=4),
     *             @OA\Property(property="name", type="string", example="nihao"),
     *             @OA\Property(property="price", type="string", example="1.00"),
     *             @OA\Property(property="day", type="integer", example=1),
     *             @OA\Property(property="day_income", type="string", example="111.00"),
     *             @OA\Property(property="allowance", type="string", example="111.00"),
     *             @OA\Property(property="total_price", type="integer", example="111"),
     *             @OA\Property(property="num", type="integer", example=1),
     *             @OA\Property(property="type", type="integer", example=1),
     *             @OA\Property(property="income_price", type="integer", example=1),
     *           )
     *         )
     *       }
     *     )
     *   )
     * )
     */
    public function actionUserInfo()
    {
        $params = $this->params([
            'id',
        ]);
        $uid = \Yii::$app->user->identity->uid;
        $model = new UserProduct();
        $data = $model->getInfo($params['id'], $uid);
        $this->output($data);
    }
}