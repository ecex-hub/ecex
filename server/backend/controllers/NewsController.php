<?php

namespace backend\controllers;

use Yii;
use common\models\News;

/**
 * 新闻相关接口控制器
 */
class NewsController extends \backend\lib\ApiBaseController
{
    public $layout = false;

    public function behaviors()
    {
        $behaviors = parent::behaviors();
        // 新闻列表和详情不需要认证
        $behaviors['authenticator']['except'] = ['list', 'detail'];
        return $behaviors;
    }

    /**
     * @OA\Get(
     *     path="/news/list",
     *     tags={"新闻"},
     *     summary="获取新闻列表",
     *     description="获取新闻列表，支持分页",
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
     *                         @OA\Property(property="title", type="string", example="新闻标题"),
     *                         @OA\Property(property="author", type="string", example="作者"),
     *                         @OA\Property(property="coverUrl", type="string", example="http://example.com/cover.jpg"),
     *                         @OA\Property(property="content", type="string", example="新闻内容"),
     *                         @OA\Property(property="type", type="integer", example=1),
     *                         @OA\Property(property="itime", type="integer", example=1735022121),
     *                         @OA\Property(property="utime", type="integer", example=1735022121),
     *                         @OA\Property(property="is_hot", type="integer", example=1),
     *                         @OA\Property(property="is_new", type="integer", example=1)
     *                     )
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionList()
    {
        $params = $this->params(['page', 'size']);
        $page = $params['page'] ?? 1;
        $size = $params['size'] ?? 10;
        
        $model = new News();
        $news = $model->getClientNewsList($page, $size);
        
        foreach ($news as &$value) {
            $value['coverUrl'] = \common\components\FuncHelper::getCdnUrl($value['coverUrl']);
        }
        
        $this->output(['list' => $news]);
    }

    /**
     * @OA\Get(
     *     path="/news/{id}",
     *     tags={"新闻"},
     *     summary="获取新闻详情",
     *     description="根据ID获取新闻详情",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         description="新闻ID",
     *         @OA\Schema(type="integer"),
     *         example=1
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
     *                 @OA\Property(property="id", type="integer", example=1),
     *                 @OA\Property(property="title", type="string", example="新闻标题"),
     *                 @OA\Property(property="author", type="string", example="作者"),
     *                 @OA\Property(property="coverUrl", type="string", example="http://example.com/cover.jpg"),
     *                 @OA\Property(property="content", type="string", example="新闻内容"),
     *                 @OA\Property(property="type", type="integer", example=1),
     *                 @OA\Property(property="itime", type="integer", example=1735022121),
     *                 @OA\Property(property="utime", type="integer", example=1735022121),
     *                 @OA\Property(property="is_hot", type="integer", example=1),
     *                 @OA\Property(property="is_new", type="integer", example=1)
     *             )
     *         )
     *     )
     * )
     */
    public function actionDetail($id)
    {
        if (empty($id)) {
            $this->output_error('新闻ID不能为空', 400);
        }
        
        $model = new News();
        $news = $model->find()->where(['id' => $id])->asArray()->one();
        
        if (empty($news)) {
            $this->output_error('新闻不存在', 404);
        }
        
        $news['coverUrl'] = \common\components\FuncHelper::getCdnUrl($news['coverUrl']);
        
        $this->output($news);
    }
}
