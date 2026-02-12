<?php

namespace backend\controllers;

use Yii;
use common\models\Upload;

/**
 * Site controller
 */
class UploadController extends \backend\lib\ApiBaseController
{

    public $layout = false;

    /**
     * 上传图片资源接口。
     * @OA\Post(
     *     path="/upload/img",
     *     summary="上传图片资源",
     *     description="上传图片资源到服务器，并返回保存路径",
     *     operationId="uploadImage",
     *     tags={"上传"},
     *     @OA\RequestBody(
     *         required=true,
     *             @OA\MediaType(
     *                 mediaType="multipart/form-data",
     *                 @OA\Schema(
     *                     required={"file"},
     *                     @OA\Property(
     *                         property="file",
     *                         description="要上传的文件",
     *                         type="string",
     *                         format="binary"
     *                     )
     *                 )
     *             )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功上传文件",
     *         content={
     *             @OA\MediaType(
     *                 mediaType="application/json",
     *                 @OA\Schema(
     *                     type="object",
     *                     @OA\Property(property="code", type="integer", example=200),
     *                     @OA\Property(property="message", type="string", example="success"),
     *                     @OA\Property(
     *                         property="data",
     *                         type="object",
     *                         @OA\Property(property="filePath", type="string", example="uploads/images/example.jpg")
     *                     )
     *                 )
     *             )
     *         }
     *     )
     * )
     */
    public function actionImg()
    {
        try {
            //上传文件
            $model = new Upload();
            $data = $model->uploadImgResources($_FILES['upload']);
            if (!empty($data)) {
                $this->output($data);
            } else {
                $error_mesg = $model->getErrors('mesg');
                $this->output_error($error_mesg[0][1], $error_mesg[0][0], false);
            }
        } catch (\Exception $e) {
            var_dump($e->getMessage());
            $this->output_error('系统异常', 400, false);
        }
    }

    /**
     * 上传文件接口（通用）
     * @OA\Post(
     *     path="/upload/file",
     *     summary="上传文件",
     *     description="上传文件到服务器，并返回保存路径",
     *     operationId="uploadFile",
     *     tags={"上传"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\MediaType(
     *             mediaType="multipart/form-data",
     *             @OA\Schema(
     *                 required={"file"},
     *                 @OA\Property(
     *                     property="file",
     *                     description="要上传的文件",
     *                     type="string",
     *                     format="binary"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功上传文件",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(property="filePath", type="string", example="uploads/images/example.jpg"),
     *                 @OA\Property(property="url", type="string", example="http://example.com/uploads/images/example.jpg")
     *             )
     *         )
     *     )
     * )
     */
    public function actionFile()
    {
        try {
            // 检查是否有文件上传
            if (empty($_FILES['file'])) {
                $this->output_error('请选择要上传的文件', 400, false);
            }
            
            //上传文件
            $model = new Upload();
            // 适配前端传过来的file字段名
            $fileData = $model->uploadImgResources($_FILES['file']);
            
            if (!empty($fileData)) {
                // 如果返回的是路径，转换为完整URL
                if (is_string($fileData)) {
                    $fileData = [
                        'filePath' => $fileData,
                        'url' => \common\components\FuncHelper::getCdnUrl($fileData)
                    ];
                } elseif (is_array($fileData) && !isset($fileData['url'])) {
                    // 如果只有路径，添加URL
                    if (isset($fileData['filePath'])) {
                        $fileData['url'] = \common\components\FuncHelper::getCdnUrl($fileData['filePath']);
                    }
                }
                $this->output($fileData);
            } else {
                $error_mesg = $model->getErrors('mesg');
                $this->output_error($error_mesg[0][1] ?? '上传失败', $error_mesg[0][0] ?? 400, false);
            }
        } catch (\Exception $e) {
            $this->output_error('系统异常：' . $e->getMessage(), 400, false);
        }
    }

}
