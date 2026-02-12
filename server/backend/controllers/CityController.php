<?php

namespace backend\controllers;

use common\models\City;
use Yii;

class  CityController extends \backend\lib\ApiBaseController
{
    /**
     * @OA\POST(
     *   path="/city/list",
     *   summary="城市三级分类",
     *   tags={"地区管理"},
     *   @OA\Parameter(
     *     name="id",
     *     in="path",
     *     description="地区ID",
     *     required=true,
     *     @OA\Schema(type="integer")
     *   ),
     *   @OA\Response(
     *     response=200,
     *     description="成功的操作",
     *     @OA\JsonContent(
     *       type="object",
     *       @OA\Property(property="id", type="string"),
     *       @OA\Property(property="name", type="string"),
     *       @OA\Property(
     *         property="sub",
     *         type="array",
     *         @OA\Items(
     *           type="object",
     *           @OA\Property(property="id", type="string"),
     *           @OA\Property(property="name", type="string"),
     *           @OA\Property(
     *             property="sub",
     *             type="array",
     *             @OA\Items(
     *               type="object",
     *               @OA\Property(property="id", type="string"),
     *               @OA\Property(property="name", type="string")
     *             )
     *           )
     *         )
     *       )
     *     )
     *   )
     * )
     */
    public function actionList()
    {
        $model = new City();
        $list = $model->getList();
        $this->output($list);
    }
}