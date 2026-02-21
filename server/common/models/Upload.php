<?php

namespace common\models;

use Yii;
use common\helpers\ModApi;

/**
 * ContactForm is the model behind the contact form.  上传文件
 */
class Upload extends BaseModel
{

    protected $table = 't_upload';

    public static function tableName()
    {
        return '{{t_upload}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
        ];
    }

    private static $key = [];

    public static function selectColumn()
    {
        return self::$key;
    }

    private $imgTypeArr = [
        'image/jpeg',
        'image/jpg',
        'image/png',
//        'image/gif',
//        'image/webp',
    ];

    public function uploadImgResources($fileData, $maxsize = 1024 * 50, $aes = true)
    {
        if (!in_array($fileData['type'], $this->imgTypeArr)) {
            $this->addError('mesg', ['210', '上传资源类型异常' . $fileData['type']]);
            return false;
        }
        if ($maxsize > 0 && $fileData['size'] > $maxsize * 1024) {
            $this->addError('mesg', ['211', "上传资源最大限制为$maxsize" . 'KB']);
            return false;
        }
        $uploadDir = Yii::getAlias('@webroot') . '/uploads/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true); // 确保目录存在并设置权限
        }
        $suffix = '.jpg';
        if ($fileData['type'] == 'image/gif') {
            $suffix = '.gif';
        } else if ($fileData['type'] == 'image/webp') {
            $suffix = '.webp';
        }
        //文件名
        $name = sha1(rand(10000, 99999) . uniqid()) . $suffix;
        $savePath = $uploadDir . $name;
        if (move_uploaded_file($fileData['tmp_name'], $savePath)) {
//            if ($aes) {
//                $data = ModApi::img_encrypt(base64_encode(file_get_contents($savePath)));
//            }
            $bool = file_get_contents($savePath);
            if ($bool === false) {
                $this->addError('mesg', ['212', "上传失败"]);
            }
            return "/uploads/" . $name;
        } else {
            @unlink($fileData['tmp_name']);
            $this->addError('mesg', ['212', "上传失败"]);
            return false;
        }
    }

}
