<?php

namespace backend\controllers;

use common\components\FuncHelper;
use common\models\Sys;


class  SysController extends \backend\lib\ApiBaseController
{
    /**
     * @OA\POST(
     *     path="/sys/list",
     *     summary="支付列表",
     *     description="Retrieve a paginated list of bank cards bound to the user.",
     *     operationId="getBankCardBindings",
     *     tags={"支付"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\Parameter(
     *           name="pay_type",
     *           in="query",
     *           required=false,
     *           description="1-支付宝 2-微信 3-银行",
     *           example=1
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successful response with a list of bank card bindings",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="HTTP status code"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="Response message"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="integer", example=1),
     *                     @OA\Property(property="name", type="string", example="支付宝"),
     *                 )
     *             )
     *         )
     *     )
     * )
     */

    public function actionList()
    {
        $model = new Sys();
        $list = $model->getList();
        $this->output($list);
    }


    public function actionImg()
    {
        $list = [
            [
                'url' => FuncHelper::getCdnUrl("/uploads/1.png"),
                'path' => '/uploads/1.png',
            ],
            [
                'url' => FuncHelper::getCdnUrl("/uploads/2.png"),
                'path' => '/uploads/2.png',
            ],
            [
                'url' => FuncHelper::getCdnUrl("/uploads/3.png"),
                'path' => '/uploads/3.png',
            ],
            [
                'url' => FuncHelper::getCdnUrl("/uploads/4.png"),
                'path' => '/uploads/4.png',
            ]
        ];
        $this->output($list);
    }
}