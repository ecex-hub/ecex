<?php

namespace common\models;

use common\models\BaseModel;
use Yii;
use common\components\FuncHelper;

/**
 * 积分商品模型
 */
class PointsGoods extends BaseModel
{
    public static function tableName()
    {
        return '{{t_points_goods}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            ['id', 'number'],
            ['category_id', 'number'],
            ['name', 'string'],
            ['image', 'string'],
            ['points', 'number'],
            ['stock', 'number'],
            ['content', 'string'],
            ['weigh', 'number'],
            ['status', 'number'],
            ['createtime', 'number'],
            ['updatetime', 'number'],
        ];
    }

    /**
     * 获取商品列表
     * @param int $page 页码
     * @param int $limit 每页数量
     * @return array
     */
    public function getList($page = 1, $limit = 10)
    {
        $data = $this->listFind(['page' => $page, 'row' => $limit])
            ->select([
                'id', 'name', 'image', 'points', 'stock', 'content', 'weigh', 'status'
            ])
            ->where(['status' => 1]) // 只获取启用状态的商品
            ->orderBy("weigh desc, id desc")
            ->asArray()
            ->all();
        
        foreach ($data as &$row) {
            // 处理图片 URL
            $imageUrl = trim($row['image'] ?? '');
            if (empty($imageUrl)) {
                $row['image'] = '';
            } elseif (strpos($imageUrl, 'http://') === 0 || strpos($imageUrl, 'https://') === 0 || strpos($imageUrl, '//') === 0) {
                // 已经是完整 URL，直接使用
                $row['image'] = $imageUrl;
            } else {
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
                            $row['image'] = rtrim($adminCdnUrl, '/') . $imageUrl;
                        } else {
                            // 备选使用 base_url
                            $baseUrl = Yii::$app->params['base_url'] ?? '';
                            if (!empty($baseUrl)) {
                                $row['image'] = rtrim($baseUrl, '/') . $imageUrl;
                            } else {
                                // 如果都没有配置，保持相对路径，让前端或 Nginx 处理
                                $row['image'] = $imageUrl;
                            }
                        }
                    } else {
                        $row['image'] = $processedUrl;
                    }
                } else {
                    $row['image'] = $processedUrl;
                }
            }
            $row['points'] = intval($row['points'] ?? 0);
            $row['stock'] = intval($row['stock'] ?? 0);
        }
        
        return $data;
    }

    /**
     * 获取商品详情
     * @param int $id 商品ID
     * @return array|null
     */
    public function getInfo($id)
    {
        $data = $this->find()
            ->where(['id' => $id, 'status' => 1])
            ->asArray()
            ->one();
        
        if ($data) {
            // 处理图片 URL
            $imageUrl = trim($data['image'] ?? '');
            if (empty($imageUrl)) {
                $data['image'] = '';
            } elseif (strpos($imageUrl, 'http://') === 0 || strpos($imageUrl, 'https://') === 0 || strpos($imageUrl, '//') === 0) {
                // 已经是完整 URL，直接使用
                $data['image'] = $imageUrl;
            } else {
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
                            $data['image'] = rtrim($adminCdnUrl, '/') . $imageUrl;
                        } else {
                            // 备选使用 base_url
                            $baseUrl = Yii::$app->params['base_url'] ?? '';
                            if (!empty($baseUrl)) {
                                $data['image'] = rtrim($baseUrl, '/') . $imageUrl;
                            } else {
                                // 如果都没有配置，保持相对路径，让前端或 Nginx 处理
                                $data['image'] = $imageUrl;
                            }
                        }
                    } else {
                        $data['image'] = $processedUrl;
                    }
                } else {
                    $data['image'] = $processedUrl;
                }
            }
            $data['points'] = intval($data['points'] ?? 0);
            $data['stock'] = intval($data['stock'] ?? 0);
        }
        
        return $data;
    }
}
