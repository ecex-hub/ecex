<?php

namespace backend\controllers;

use Yii;
use common\models\AccountInfo;
use common\models\Product;
use common\models\PointsGoods;

/**
 * 积分商城相关接口控制器
 */
class MallController extends \backend\lib\ApiBaseController
{
    public $layout = false;

    /**
     * @OA\Get(
     *     path="/mall/points",
     *     tags={"积分商城"},
     *     summary="获取积分信息",
     *     description="获取当前用户的积分信息",
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
     *                 @OA\Property(property="points", type="integer", example=1000, description="当前积分"),
     *                 @OA\Property(property="total_points", type="integer", example=5000, description="累计积分")
     *             )
     *         )
     *     )
     * )
     */
    public function actionPoints()
    {
        $user = Yii::$app->user->identity;
        $data = [
            'points' => intval($user->dream_fund ?? 0), // 积分使用圆梦基金，可根据实际业务调整
            'total_points' => intval($user->dream_fund ?? 0),
        ];
        $this->output($data);
    }

    /**
     * @OA\Get(
     *     path="/mall/products",
     *     tags={"积分商城"},
     *     summary="获取商品列表",
     *     description="获取积分商城商品列表",
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         required=false,
     *         description="页码",
     *         @OA\Schema(type="integer", default=1, minimum=1),
     *         example=1
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         required=false,
     *         description="每页数量",
     *         @OA\Schema(type="integer", default=10, minimum=1, maximum=100),
     *         example=10
     *     ),
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
     *                 @OA\Property(
     *                     property="list",
     *                     type="array",
     *                     @OA\Items(
     *                         type="object",
     *                         @OA\Property(property="id", type="integer", example=1),
     *                         @OA\Property(property="name", type="string", example="商品名称"),
     *                         @OA\Property(property="price", type="number", format="float", example=100.00),
     *                         @OA\Property(property="points", type="integer", example=1000, description="所需积分"),
     *                         @OA\Property(property="image", type="string", example="http://example.com/image.jpg"),
     *                         @OA\Property(property="stock", type="integer", example=100, description="库存")
     *                     )
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionProducts()
    {
        $params = $this->params(['page', 'size']);
        $page = $params['page'] ?? 1;
        $size = $params['size'] ?? 10;
        
        // 从 t_points_goods 表获取积分商品列表
        $model = new PointsGoods();
        $list = $model->getList($page, $size);
        
        $this->output(['list' => $list]);
    }

    /**
     * @OA\Post(
     *     path="/mall/exchange",
     *     tags={"积分商城"},
     *     summary="兑换商品",
     *     description="使用积分兑换商品",
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"productId", "addressId"},
     *                 @OA\Property(
     *                     property="productId",
     *                     type="integer",
     *                     description="商品ID",
     *                     example=1
     *                 ),
     *                 @OA\Property(
     *                     property="addressId",
     *                     type="integer",
     *                     description="收货地址ID",
     *                     example=1
     *                 ),
     *                 @OA\Property(
     *                     property="quantity",
     *                     type="integer",
     *                     description="兑换数量",
     *                     example=1
     *                 )
     *             )
     *         )
     *     ),
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
     *                 @OA\Property(property="orderId", type="string", example="123456", description="订单ID")
     *             )
     *         )
     *     )
     * )
     */
    public function actionExchange()
    {
        $params = $this->params(['productId', 'addressId', 'quantity']);
        $this->VerificationParameter($params, ['productId', 'addressId']);
        
        $quantity = $params['quantity'] ?? 1;
        $user = Yii::$app->user->identity;
        
        // 获取积分商品信息
        $goodsModel = new PointsGoods();
        $goods = $goodsModel->getInfo($params['productId']);
        
        if (empty($goods)) {
            $this->output_error('商品不存在', 404);
        }
        
        // 检查库存
        if ($goods['stock'] < $quantity) {
            $this->output_error('库存不足', 400);
        }
        
        // 计算所需积分
        $requiredPoints = intval($goods['points'] ?? 0) * $quantity;
        $userPoints = intval($user->dream_fund ?? 0);
        
        if ($userPoints < $requiredPoints) {
            $this->output_error('积分不足', 400);
        }
        
        // TODO: 实现兑换逻辑
        // 1. 扣除用户积分
        // 2. 创建兑换订单
        // 3. 减少商品库存
        
        // 暂时返回成功
        $this->output(['orderId' => 'EX' . time()]);
    }
}
