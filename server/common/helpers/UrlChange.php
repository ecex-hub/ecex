<?php

/**
 * x消息发送.
 *
 */

namespace common\helpers;

use Yii;
use common\helpers\HttpHelper;

/**
 * Currency Helper
 */
class UrlChange extends BaseHelper {

    /**
     * construct.
     *
     * @return void.
     */
    public function __construct() {
        
    }

    /**
     * 转换url为短连接
     * @param type $startUrl
     * @return type
     */
    public static function changeUrlDynamic($startUrl) {
        $url = 'http://er.apip.vip/rapi.php';
        $data = [
            'longurl' => $startUrl
        ];
        $endData = HttpHelper::httpGet($url, $data);
        if (!empty($endData)) {
            $endData = json_decode($endData, TRUE);
            if (!empty($endData['ae_url'])) {
                $startUrl = $endData['ae_url'];
            }
        }
        return $startUrl;
    }

}
