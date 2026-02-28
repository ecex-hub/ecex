<?php

namespace backend\controllers;

use Yii;
use common\models\News;
use common\components\FuncHelper;

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
            $value['coverUrl'] = $this->processImageUrl($value['coverUrl']);
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
        
        if($news['type'] == 3){
            $content = preg_replace('/width\s*:\s*\d+px/i', 'width:100%', $news['content']);         
            $content = preg_replace('/\swidth="\d+"/i', '', $content);
            $news['content'] = $content;
        }

        $news['coverUrl'] = $this->processImageUrl($news['coverUrl']);
        
        $this->output($news);
    }

    /**
     * 处理图片URL，确保返回完整的可访问地址
     * @param string $imageUrl 图片URL
     * @return string 处理后的完整URL
     */
    private function processImageUrl($imageUrl)
    {
        if (empty($imageUrl)) {
            return '';
        }
        
        // 如果已经是完整URL，直接返回
        if (strpos($imageUrl, 'http://') === 0 || strpos($imageUrl, 'https://') === 0 || strpos($imageUrl, '//') === 0) {
            return $imageUrl;
        }
        
        // 相对路径，先尝试使用 getUrl
        $processedUrl = FuncHelper::getUrl($imageUrl);
        
        // 如果处理后还是相对路径（以 / 开头但不是完整 URL），则尝试 getCdnUrl
        if (strpos($processedUrl, '/') === 0 && strpos($processedUrl, 'http') !== 0) {
            $processedUrl = FuncHelper::getCdnUrl($imageUrl);
            
            // 如果 getCdnUrl 也返回相对路径，尝试使用 admin_cdn_url 或 base_url 配置
            if (strpos($processedUrl, '/') === 0 && strpos($processedUrl, 'http') !== 0) {
                // 优先使用 admin_cdn_url（admin 项目的 CDN 地址）
                $adminCdnUrl = Yii::$app->params['admin_cdn_url'] ?? '';
                if (!empty($adminCdnUrl)) {
                    return rtrim($adminCdnUrl, '/') . $imageUrl;
                }
                
                // 备选使用 base_url
                $baseUrl = Yii::$app->params['base_url'] ?? '';
                if (!empty($baseUrl)) {
                    return rtrim($baseUrl, '/') . $imageUrl;
                }
                
                // 如果都没有配置，尝试使用 cdn_url
                $cdnUrl = Yii::$app->params['cdn_url'] ?? '';
                if (!empty($cdnUrl)) {
                    return rtrim($cdnUrl, '/') . $imageUrl;
                }
                
                // 如果都没有配置，保持相对路径，让前端或 Nginx 处理
                return $imageUrl;
            }
        }
        
        return $processedUrl;
    }
}
