<?php

namespace backend\controllers;

use common\models\BillRecord;
use Yii;
use common\models\AccountInfo;

class BillController extends \backend\lib\ApiBaseController
{
    /**
     * @OA\Post(
     *     path="/bill/convert",
     *     summary="回报钱包到充值余额",
     *     tags={"账单"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="money",
     *                     description="金额",
     *                     type="string",
     *                     example="1.00"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionConvert()
    {
        $params = $this->params(['money']);
        $this->VerificationParameter($params, ['money']);
        $user = Yii::$app->user->identity;
        $model = new AccountInfo();
        $boor = $model->payBackConvert($user, $params['money']);
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }

    /**
     * @OA\POST(
     *     path="/bill/list",
     *     summary="账单列表",
     *     description="Retrieve a paginated list of bank cards bound to the user.",
     *     tags={"账单"},
     *     security={{"bearerAuth": {}}},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         required=false,
     *         description="The page number to retrieve (starting from 1).",
     *         @OA\Schema(type="integer", default=1, minimum=1),
     *         example=1
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         required=false,
     *         description="The number of items per page.",
     *         @OA\Schema(type="integer", default=10, minimum=1, maximum=100),
     *         example=10
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
     *                     @OA\Property(property="money", type="integer", example="1.0"),
     *                     @OA\Property(property="money_type", type="integer", example="1"),
     *                     @OA\Property(property="bill_unit", type="integer", example="1"),
     *                 )
     *             )
     *         )
     *     ),
     * )
     */
    public function actionList()
    {
        $params = $this->params([
            'page',
            'size',
        ]);
        $user = Yii::$app->user->identity;
        $model = new BillRecord();
        $list = $model->getList($user->id, $params['page'], $params['size']);
        $this->output($list);
    }
}