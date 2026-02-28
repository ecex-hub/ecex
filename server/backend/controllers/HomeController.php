<?php

namespace backend\controllers;

use common\components\FuncHelper;
use common\models\Video;
use common\models\News;
use common\models\Carousel;
use common\models\SystemConfigure;
use common\models\Notice;

/**
 * Site controller
 */
class HomeController extends \backend\lib\ApiBaseController
{

    public $layout = false;

    public function behaviors()
    {
        $behaviors = parent::behaviors();

        // 配置不需要鉴权的动作
        $behaviors['authenticator']['except'] = ['video', 'video-detail'];

        return $behaviors;
    }

    /**
     * @OA\POST(
     *     tags={"首页"},
     *     path="/home/index",
     *     summary="首页列表",
     *     operationId="getHomeIndex",
     *     description="获取首页的内容列表，包括轮播图、通知、新闻和视频等。",
     *     @OA\Response(
     *         response=200,
     *         description="成功响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="响应状态码"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="响应消息"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="data",
     *                     type="object",
     *                     @OA\Property(
     *                         property="carousel",
     *                         type="array",
     *                         @OA\Items(
     *                         @OA\Property(property="id", type="string", example="1", description="通知ID"),
     *                         @OA\Property(property="title", type="string", example="99", description="通知标题"),
     *                         @OA\Property(property="picUrl", type="string", example="999", description="图片"),
     *                         @OA\Property(property="sort", type="string", example="1", description="排序"),
     *                         @OA\Property(property="type", type="string", example="1", description="类型"),
     *                         @OA\Property(property="itime", type="string", example="0", description="创建时间"),
     *                         @OA\Property(property="utime", type="string", example="0", description="更新时间")
     *                         ),
     *                     ),
     *                     @OA\Property(
     *                         property="notice",
     *                         type="array",
     *                         @OA\Items(
     *                         @OA\Property(property="id", type="string", example="1", description="通知ID"),
     *                         @OA\Property(property="title", type="string", example="99", description="通知标题"),
     *                         @OA\Property(property="content", type="string", example="999", description="通知内容"),
     *                         @OA\Property(property="sort", type="string", example="1", description="排序"),
     *                         @OA\Property(property="type", type="string", example="1", description="类型"),
     *                         @OA\Property(property="itime", type="string", example="0", description="创建时间"),
     *                         @OA\Property(property="utime", type="string", example="0", description="更新时间")
     *                         )
     *                     ),
     *                     @OA\Property(
     *                         property="news",
     *                         type="array",
     *                         @OA\Items(
     *                             type="object",
     *                             @OA\Property(property="id", type="string", example="2", description="新闻ID"),
     *                             @OA\Property(property="title", type="string", example="1", description="新闻标题"),
     *                             @OA\Property(property="author", type="string", example="1", description="作者"),
     *                             @OA\Property(property="coverUrl", type="string", format="uri", example="http://127.0.0.1:8199/1", description="封面图片URL"),
     *                             @OA\Property(property="content", type="string", example="1", description="新闻内容"),
     *                             @OA\Property(property="type", type="string", example="1", description="类型"),
     *                             @OA\Property(property="itime", type="integer", example=1735022121, description="创建时间戳"),
     *                             @OA\Property(property="utime", type="integer", example=1735022121, description="更新时间戳"),
     *                             @OA\Property(property="is_hot", type="integer", example="1", description="1-默认 2-最热"),
     *                             @OA\Property(property="is_new", type="integer", example="1", description="1-默认 2-最新")
     *                         )
     *                     ),
     *                     @OA\Property(
     *                         property="video",
     *                         type="array",
     *                         @OA\Items(
     *                             type="object",
     *                             @OA\Property(property="id", type="string", example="2", description="视频ID"),
     *                             @OA\Property(property="title", type="string", example="nihoa ", description="视频标题"),
     *                             @OA\Property(property="coverUrl", type="string", format="uri", example="http://127.0.0.1:8199/1", description="封面图片URL"),
     *                             @OA\Property(property="video_url", type="string", format="uri", example="http://127.0.0.1:8199/111", description="视频URL"),
     *                             @OA\Property(property="video_duration", type="string", example="10", description="视频时长"),
     *                             @OA\Property(property="type", type="string", example="1", description="类型"),
     *                             @OA\Property(property="itime", type="string", example="1", description="创建时间"),
     *                             @OA\Property(property="utime", type="string", example="1", description="更新时间")
     *                         )
     *                     ),
     *                     @OA\Property(
     *                         property="customer_service",
     *                         type="string",
     *                         format="uri",
     *                         example="http://www.baidu.com",
     *                         description="客服链接"
     *                     ),
     *                     @OA\Property(
     *                         property="home_welfare_status",
     *                         type="string",
     *                         example="1",
     *                         description="首页福利状态"
     *                     ),
     *                     @OA\Property(
     *                         property="welfare_id",
     *                         type="string",
     *                         format="uri",
     *                         example="http://www.baidu.com",
     *                         description="福利ID链接"
     *                     )
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response="default",
     *         description="发生错误时的响应",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=400,
     *                 description="错误代码"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="An error occurred",
     *                 description="错误信息"
     *             )
     *         )
     *     )
     * )
     */
    public function actionIndex()
    {

        //$uid = Yii::$app->user->identity->uid;

        //轮播
        $model = new Carousel();
        $carousel = $model->getClientCarouselsList();
        foreach ($carousel as &$value) {
            $value['picUrl'] = FuncHelper::processImageUrl($value['picUrl']);
        }

        //公告提醒
        $model = new Notice();
        $notice = $model->getClientNoticeList();
        //新闻
        $model = new News();
        $news = $model->getClientNewsList(1, 3);
        foreach ($news as &$value) {
            $value['coverUrl'] = FuncHelper::processImageUrl($value['coverUrl']);
        }
        //视频
        $model = new Video();
        $video = $model->getClientNewsList(1, 3);
        foreach ($video as &$value) {
            $value['coverUrl'] = FuncHelper::processImageUrl($value['coverUrl']);
            $value['video_url'] = FuncHelper::processImageUrl($value['video_url']);
        }
        $data = [
            'carousel' => $carousel,
            'notice' => $notice,
            'news' => $news,
            'video' => $video,
            'customer_service' => SystemConfigure::getSystemConfigure(1), //客服地址
            'home_welfare_status' => SystemConfigure::getSystemConfigure(2),//首页福利弹窗开关
            'welfare_id' => SystemConfigure::getSystemConfigure(3),//福利跳转id
        ];
        $this->output($data);
    }

    /**
     * @OA\POST(
     *     path="/home/news",
     *     summary="新闻列表",
     *     description="This API returns a paginated list of items.",
     *     operationId="getItems",
     *     tags={"首页"},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="The page number for pagination.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=1
     *         )
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         description="The number of items per page.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=10
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="A successful response with a list of items.",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="list",
     *                     type="array",
     *                     @OA\Items(
     *                         type="object",
     *                         @OA\Property(
     *                             property="id",
     *                             type="string",
     *                             example="2"
     *                         ),
     *                         @OA\Property(
     *                             property="title",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="author",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="coverUrl",
     *                             type="string",
     *                             example="http://127.0.0.1:8199/1"
     *                         ),
     *                         @OA\Property(
     *                             property="content",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="type",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="itime",
     *                             type="string",
     *                             example="1735022121"
     *                         ),
     *                         @OA\Property(
     *                             property="utime",
     *                             type="string",
     *                             example="1735022121"
     *                         )
     *                     )
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Bad request, missing or incorrect parameters."
     *     ),
     *     @OA\Response(
     *         response=500,
     *         description="Internal server error."
     *     )
     * )
     */
    public function actionNews()
    {
        $params = $this->params([
            'page',
            'size',
        ]);
        //$uid = Yii::$app->user->identity->uid;
        //新闻
        $model = new News();
        $news = $model->getClientNewsList($params['page'], $params['size']);
        foreach ($news as &$value) {
            $value['coverUrl'] = FuncHelper::getCdnUrl($value['coverUrl']);
        }
        $this->output(['list' => $news]);
    }

    /**
     * @OA\POST(
     *     path="/home/video",
     *     summary="视频列表",
     *     description="This API returns a paginated list of items with video details.",
     *     operationId="getItems",
     *     tags={"首页"},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="The page number for pagination.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=1
     *         )
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         description="The number of items per page.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=10
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="A successful response with a list of items.",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="list",
     *                     type="array",
     *                     @OA\Items(
     *                         type="object",
     *                         @OA\Property(
     *                             property="id",
     *                             type="string",
     *                             example="2"
     *                         ),
     *                         @OA\Property(
     *                             property="title",
     *                             type="string",
     *                             example="nihoa"
     *                         ),
     *                         @OA\Property(
     *                             property="coverUrl",
     *                             type="string",
     *                             example="http://127.0.0.1:8199/1"
     *                         ),
     *                         @OA\Property(
     *                             property="video_url",
     *                             type="string",
     *                             example="http://127.0.0.1:8199/111"
     *                         ),
     *                         @OA\Property(
     *                             property="video_duration",
     *                             type="string",
     *                             example="10"
     *                         ),
     *                         @OA\Property(
     *                             property="type",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="itime",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="utime",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="is_hot",
     *                             type="string",
     *                             example="1"
     *                         ),
     *                         @OA\Property(
     *                             property="is_new",
     *                             type="string",
     *                             example="1"
     *                         )
     *                     )
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Bad request, missing or incorrect parameters."
     *     ),
     *     @OA\Response(
     *         response=500,
     *         description="Internal server error."
     *     )
     * )
     */

    public function actionVideo()
    {
        $params = $this->params([
            'page',
            'size',
        ]);      
        //视频
        $model = new Video();
        $video = $model->getClientNewsList($params['page'] ?? 1, $params['size'] ?? 10);
        foreach ($video as &$value) {            
            $value['coverUrl'] = FuncHelper::processImageUrl($value['coverUrl']);
            // 将 video_url 改为 videoUrl，保持前端字段名一致
            $value['videoUrl'] = FuncHelper::processImageUrl($value['video_url']);
            unset($value['video_url']); // 移除旧的字段名
            // 确保 video_duration 字段存在
            if (!isset($value['video_duration'])) {
                $value['video_duration'] = 0;
            }
        }
        $this->output(['list' => $video]);
    }

    public function actionVideoDetail()
    {
        $id = $this->request->get('id');      
        //视频
        $model = new Video();
        $video = $model->getClientNewsMessage($id);
        
        if (empty($video)) {
            $this->output_error('视频不存在');
            return;
        }
        
        // 处理图片和视频 URL
        $video['coverUrl'] = FuncHelper::processImageUrl($video['coverUrl']);
        $video['videoUrl'] = FuncHelper::processImageUrl($video['video_url']);
        unset($video['video_url']); // 移除旧的字段名
        
        $this->output(['data' => $video]);
    }

}
