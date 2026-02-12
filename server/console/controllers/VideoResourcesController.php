<?php

namespace console\controllers;

use yii\console\Controller;
use Yii;
use common\models\Video;
use common\models\VideoM3u8;
use common\helpers\ModApi;
use common\helpers\Ssh2Helper;
use common\helpers\HttpHelper;

class VideoResourcesController extends Controller {

    /**
     * This command echoes what you have entered as the message.
     * @param string $message the message to be echoed.
     */
    public $YiiUploadUrl = '/home/webroot4';

    /**
     * 操作数据库api接口
     * @param type $url
     * @param type $data
     * @return type
     */
    public function apiDataoOperation($url, $data) {
        $data['password'] = 'eebAEJUvFP8Aun7c';
        $path = Yii::$app->params['videoUrl'] . $url;
        var_dump($path);
        var_dump($data);
        $data = HttpHelper::curl_post($path, $data);

        if ($url == 'video-resources-api/get-m3u8-data') {
            var_dump($data);
        }

        if (!empty($data)) {
            return json_decode($data, true);
        }
        return false;
    }

    /**
     * 操作数据库api接口
     * @param type $url
     * @param type $data
     * @return type
     */
    public function apiDataoOperationYS($url, $data) {
        $data['password'] = 'eebAEJUvFP8Aun7c';
        $path = Yii::$app->params['videoUrlYs'] . $url;

        $data = HttpHelper::curl_post($path, $data);
        if (!empty($data)) {
            return json_decode($data, true);
        }
        return false;
    }

    public function actionTest() {
        $data = [[26801, 'cec71fdba79ec2078dca66ac265dfbd0b05407e4'], [26802, '0992b5e90e24a38712abd4d345bc61adf5edd71c'], [26803, 'cf7d8c0e4d95db18684beb7ae604d6785fab90ee'], [26805, 'e9fc58093c7e64f953f8adb2135daeba5ebbd105'], [26806, 'b16af6226cd0c568fc6c0bbf2c795d9394a3cf29'], [26807, '304b05609b3c949eead898064b10c3147ae389f2'], [26808, '34af23c324e8fd198ef163b1ad490d3f14cc5c92'], [26809, '1b9242db59f69dd70075b6092df551c875108115'], [26810, 'ca0f619bfcb82ac4838c5acf0a37e33e9386308e'], [26811, 'b214e397b4c67160d38235c3cb9fdf015d8e6d6a'], [26812, 'e6cd97173f0d97518d8d5f5238f59dfd8a576090'], [26813, '161359bc2b64fc48b69b8d1385e4458795290a14'], [26814, '7e99c16cf94dfd1be2c3acceb6700f9cfae42fa4'], [26815, '95738858aadab1cefdafa8ebdaf498d1efb12e93'], [26816, 'dc5c1d8fe9684199540dde8b0ad4f96ef15cd992'], [26817, 'bc74c990a77a750f041997e68b922defad9f3cf0'], [26818, 'cd43bbf87a2e04f5743d6eebd88cc737a80f8df1'], [26819, 'b188ec2ed0d0a4b157583c7e0f1248e3b81d081f'], [26820, '0ea8d9338d6809da92b7b63635251c3c200aa179'], [26822, '3a28c895ff08bd6fe5ce89162fb824cb5dc6d72a'], [26823, '37bbb1994d38e0e8fd9fadab3f234d215cc4bdb8'], [26824, '8fdbe2991d9645062d2c05c3fd6c606b6382e5ad'], [26825, '9b280faff6404c1cdd0d1710b6a635f31da8d473'], [26826, 'cd39258aae6451764a67126cfe3fd39ecbe2067a'], [26827, 'e2941a0d9dc2ea08ea5ca5ea639cedef251d1076'], [26828, 'b03c5ea4e967372392edf6dac3aedb2fb8e8f850'], [26829, 'cf23b5f60c380a068aa6e3eb772b9a4583765216'], [26830, 'e68c9eff766221499e7cd05c2e24f037eb71c23b'], [26831, '88180d0e03d6f2ea34f9f324aec1c1112bf411ff'], [26832, '5d0310b560e8c79608f77c357aec2e4c0cac8369'], [26833, 'a6db6c4a11ec7023717155ade6799fa112101fc6'], [26834, '98244e3d08466358430f124e02124560b85fecc6'], [26835, '9a6ae19d3b348d25548b69152c15b69e7c0d83fe'], [26836, '23cd80d708c85b513fa751dd478c7fdce0d5a938'], [26837, '405f7c4ec85a4c58789e85652127f5432732b1c0'], [26838, '867cdd7d506897b337efac53cebcda1c1cda3594'], [26839, '05c55d1c0df1669f424ff01cde9682fd5ed6308a'], [26840, 'f169a8795d9449636df7e0111aee9b90293e4a4f'], [26841, '1f8639e08e4f5eaf1214e1609f8276b63b2af4c7'], [26842, 'ebea0b852b8a9de1d9b0eba24f78621b2b51f3cb'], [26843, '5d3f415fb01a9a4c019f35f649430b6df7f9b31f'], [26844, '4cad0cda3d471b5f9535c93607870f35222b714e'], [26845, '7a21fee6bddb411b8600f948c63d48ed6671666c'], [26846, 'cc1edda586512ca58a5ef6fa5d64f3579f829e56'], [26847, 'f740ddc9d69d2826ea6db60b84d60da7a6fd7b12'], [26848, '9e8d917d6b6b51ff0c69f392bc3974372ff68854'], [26849, '6586df1750b1bd6090d5e7e2224e1f43d07fdcd0'], [26850, '144c6147e2abb019cc508a936daab2f6ab61554d'], [26851, '3dbc2b98c960d87a05a9e97a3004bed7660ab748'], [26852, 'dfefb09941a361510ee22d103fa492872825e6e1'], [26853, '2d58f36b489de5b8e5c800458bb24e2361c67f49'], [26854, '83767b84a5adf2e32f25612f669ce6c111d61d00']];
        foreach ($data as $key => $value) {
            $this->actionM3u8($value[0], $value[1]);
        }
    }

    /**
     * 数据  每天0点后一次
     */
    public function actionVideoMu38() {

        $fileUrl = $this->YiiUploadUrl . '/lock/lock2.txt';
        $myfile = fopen($fileUrl, 'w');
        fwrite($myfile, date('Y-m-d H:i:s'));
        fclose($myfile);

        $fileUrl = $this->YiiUploadUrl . '/lock/lock.txt';
        if (file_exists($fileUrl)) {
            $contents = file_get_contents($fileUrl);
            if ($contents == 1) {//未锁定
                try {
                    //锁定文件
                    $myfile = fopen($fileUrl, 'w');
                    fwrite($myfile, 2);
                    fclose($myfile);
                    /////////////////////////////////业务逻辑///////////////////////////////////////////////
                    //hls 目录只要2021年
//                $model = new Video();
//                $data = $model->getNOVideoMu38Data();
                    $video_url = 'video-resources-api/get-m3u8-data';
                    $video_data = [];
                    $data = $this->apiDataoOperation($video_url, $video_data);
                    $mp4gTemp = '';
                    if (!empty($data)) {
                        foreach ($data as $key => $value1) {
                            $sid = $value1['sid'];
                            $fix = substr($sid, 0, 1);
                            $namefix = $fix . '/' . $sid;
                            //获取影片信息
                            $ffmpeg = "ffmpeg -i  " . $this->YiiUploadUrl . "/videofile1/$namefix.mp4  2>&1";
                            $b = [];
                            $a = exec($ffmpeg, $b);
                            $length = '';
                            //获取影片时长
                            $mp4g = true;
                            foreach ($b as $key => $value) {
                                $x = false;
                                $x = strstr($value, "Duration: ");
                                if (!empty($x)) {

                                    var_dump($x);
                                    $length = $value;
                                }
                                $x = strstr($value, "Video: ");
                                if (!empty($x)) {
                                    $h264 = explode('Video: ', $value);
                                    if (!empty($h264[1])) {
                                        $mp4gTemp = substr($h264[1], 0, 4);
                                        if ($mp4gTemp == 'h264') {//|| $mp4gTemp == 'hevc'
                                            $mp4g = false;
                                        }
                                    }
                                }
                            }

                            $url = $this->YiiUploadUrl . "/videofile1/$namefix.mp4";

                            if ($mp4g) {//需要转编码
                                echo '需要转编码';
                                $ffmpeg = " ffmpeg -threads 10  -i  " . $url . "   -vcodec h264  -preset ultrafast " . $this->YiiUploadUrl . "/videofile1/$namefix" . "_1.mp4";
                                exec($ffmpeg);
                                $url = $this->YiiUploadUrl . "/videofile1/$namefix" . "_1.mp4";
                                if (!file_exists($url)) {//转码失败 。则删除原文件
                                    //删除转码失败视频
                                    $video_url = 'video-resources-api/delete-video';
                                    $video_data = ['vid' => $value1['vid']];
                                    $boor = $this->apiDataoOperation($video_url, $video_data);

                                    //删除转码失败视频1。0
                                    //$video_url = 'video-resources-api/delete-video';
                                    //$video_data = ['vid' => $value1['vid']];
                                    //$boor = $this->apiDataoOperationYS($video_url, $video_data);
                                    echo '跳出循环' . $value1['vid'];
                                    continue; //跳出循环
                                }
                            }
                            $fen_mp4 = '1920x1080';
                            $ffmpegFenBian = "ffmpeg -i   " . $url . "  2>&1 | perl -lane 'print $1 if /(\d{3,5}x\d{3,5})/'";

                            $c = [];
                            $d = exec($ffmpegFenBian, $c);
                            if (!empty($c[0])) {
                                $fen_mp4 = $c[0];
                            }


                            $shijian = substr($length, 12, 11);
                            var_dump($shijian);
                            $time = strtotime('1970-1-1 ' . $shijian) + 8 * 3600; //视频时长

                            var_dump('视频时长' . $time);
                            //var_dump($b);
                            // exit;
                            //平均十一份
                            $start_end = floor($time / 11);
                            $pic_url = $this->YiiUploadUrl . "/picvideostore/";
                            $imgData = [];
                            for ($i = 1; $i < 11; $i++) {
                                //文件名
                                $name = "2021/$fix/" . sha1($sid . time() . $i) . '.jpg';
                                $ss = $start_end * $i;
                                $sql = "ffmpeg -ss $ss -i " . $url . " -y -f image2    -t 0.001 -s $fen_mp4 $pic_url$name";

                                exec($sql);
                                var_dump($sql);
                                $imgData[] = $name;
                                var_dump('图片' . $i . '---' . $pic_url . $name);
                                var_dump(file_exists($pic_url . $name));
                            }

                            //exit;
                            $img = json_encode($imgData);

                            //原始分辨率  切片
//                        if ($mp4gTemp == 'hevc') {
//                            $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf hevc_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . $this->YiiUploadUrl . "/aes/$sid.keyinfo -hls_segment_filename " . $this->YiiUploadUrl . "/hls/2021/$namefix/m/v%04d.png " . $this->YiiUploadUrl . "/m3u8/$sid" . "_m.m3u8";
//                        } else {
//
//                            $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . $this->YiiUploadUrl . "/aes/$sid.keyinfo -hls_segment_filename " . $this->YiiUploadUrl . "/hls/2021/$namefix/m/v%04d.png " . $this->YiiUploadUrl . "/m3u8/$sid" . "_m.m3u8";
//                        }
                            $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . $this->YiiUploadUrl . "/aes/$sid.keyinfo -hls_segment_filename " . $this->YiiUploadUrl . "/hls/2021/$namefix/m/v%04d.png " . $this->YiiUploadUrl . "/m3u8/$sid" . "_m.m3u8";
                            // }

                            exec($ffmpeg);
                            var_dump($mp4gTemp);
                            //exit;
                            echo '1';
                            // exit;
                            //创建远程目录
                            //$chmod = 'ssh root@107.148.198.248 "mkdir -p -m 777  /home/www/hls/2021/' . $namefix . '/m"';
                            //exec($chmod);
                            //赋予权限		
                            //$chmod = 'ssh root@107.148.198.248 "chmod 755 /home/www/hls/2021/' . $namefix . '"';
                            //exec($chmod);

                            echo '2';
                            //粘贴数据到cdn目录
                            // $boscdn = "scp -r " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/m/ root@107.148.198.248:/home/www/hls/2021/$namefix/";
                            // $boscdn = "rsync -r --bwlimit=3072 " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix 107.148.198.248:/home/www/hls/2021/$fix/";
                            $boscdn = "mkdir -p -m 777  /home/www/hls/2021/$namefix/m";
                            var_dump($boscdn);
                            exec($boscdn);
                            $boscdn = "mv  " . $this->YiiUploadUrl . "/hls/2021/$namefix/m" . " /home/www/hls/2021/$namefix";

                            echo '拷贝';
                            var_dump($boscdn);
                            exec($boscdn);

                            //将m3u8数据写入数据库，并替换掉相关的敏感数据。以及将分片数据 。调整为oss正式地址
                            $this->actionCutfinish($value1['vid'], $img, $time, $value1);
                            echo '5';
                            //自动切精彩  11-12  momo  300部批量上传 临时关闭自动精彩
                            if ($value1['m3u8_s_type'] == 1) {
                                $this->actionM3u8($value1['vid'], $sid);
                            }
                            // 
                            // var_dump($mp4gTemp);
                            //需要删除的内容目录
//                        $fileurl2 = "rm -rf " . $this->YiiUploadUrl . "/hls/2021/$namefix/l/";
//                        exec($fileurl2);
                            $fileurl2 = "rm -rf " . $this->YiiUploadUrl . "/hls/2021/$namefix/m/";
                            exec($fileurl2);
//                        $fileurl2 = "rm -rf " . $this->YiiUploadUrl . "/hls/2021/$namefix/h/";
//                        exec($fileurl2);
                            //需要删除的mp4文件
                            $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix.mp4";
                            if (file_exists($fileurl1))
                                $boor = unlink($fileurl1);
                            //$boor = unlink($fileurl1);
                            $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix" . "_1.mp4";
                            if (file_exists($fileurl1))
                                $boor = unlink($fileurl1);
                        }
                    }


                    //获取精彩影片需要切片的数据
                    $video_url = 'video-resources-api/get-m3u8-data-try';
                    $video_data = [];
                    $data = $this->apiDataoOperation($video_url, $video_data);
                    echo '精彩';
                    // var_dump($data);
                    if (!empty($data)) {

                        // $data = $model->getNOVideoMarvellousMu38Data();
                        foreach ($data as $key => $value) {
                            $sid = $value['sid'];
                            $fix = substr($sid, 0, 1);
                            $namefix = $fix . '/' . $sid;

                            $url = $this->YiiUploadUrl . "/videofile1/$namefix" . '_s' . ".mp4";

                            if (!file_exists($url)) {
                                $this->actionCutfinishResetTry($value['vid'], $value, 1);
                                //文件不存在 。直接关掉
                                continue;
                            }

                            //获取影片信息
                            $ffmpeg = "ffmpeg -i  " . $url . " 2>&1";
                            $b = [];
                            $a = exec($ffmpeg, $b);
                            $length = '';
                            $mp4g = true;
                            foreach ($b as $key => $value1) {
                                $x = strstr($value1, "Video: ");
                                if (!empty($x)) {
                                    $h264 = explode('Video: ', $value1);
                                    if (!empty($h264[1])) {
                                        $mp4gTemp = substr($h264[1], 0, 4);
                                        if ($mp4gTemp == 'h264') {
                                            $mp4g = false;
                                        }
                                    }
                                }
                            }
                            if ($mp4g) {//需要转编码
                                $ffmpeg = " ffmpeg -threads 10 -i " . $url . "   -vcodec h264 -preset ultrafast " . $this->YiiUploadUrl . "/videofile1/$namefix" . '_s_2' . ".mp4";
                                exec($ffmpeg);
                                $url = $this->YiiUploadUrl . "/videofile1/$namefix" . '_s_2' . ".mp4";
                            }

                            //$this->YiiUploadUrl . "/hls/2021/$namefix/s
                            $m3u8_l = $this->YiiUploadUrl . "/hls/2021/$namefix/s";
                            if (!is_dir($m3u8_l))
                                mkdir($m3u8_l, 0755, true);

                            //原始分辨率
                            $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . $this->YiiUploadUrl . "/aes/$sid" . ".keyinfo -hls_segment_filename " . $this->YiiUploadUrl . "/hls/2021/$namefix/s/v%04d.png " . $this->YiiUploadUrl . "/m3u8/$sid" . "_s.m3u8";
                            exec($ffmpeg);

                            echo '4';
                            //创建远程目录
                            // $chmod = 'ssh root@107.148.198.248 "mkdir -p -m 777 /home/www/hls/2021/' . $namefix . '/s"';
                            // exec($chmod);
                            //赋予权限		
                            //$chmod = 'ssh root@107.148.198.248 "chmod 755 /home/www/hls/2021/' . $namefix . '"';
                            //exec($chmod);
                            //粘贴数据到远程目录
                            echo '5';
                            //$boscdn = "scp -r " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/s/ root@107.148.198.248:/home/www/hls/2021/$namefix/";
                            //$boscdn = "rsync -r " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix 107.148.198.248:/home/www/hls/2021/$namefix/";
                            // $boscdn = "rsync -r -v --bwlimit=3072 " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/s 107.148.198.248:/home/www/hls/2021/$fix/s/";
                            //粘贴数据到远程目录 
                            //先清空目录
                            $fileurl1 = "/home/www/hls/2021/$namefix/s";
                            if (file_exists($fileurl1)) {
                                $fileurl2 = "rm -rf " . "/home/www/hls/2021/$namefix/s";
                                exec($fileurl2);
                            }
                            //在创建目录
                            $boscdn = "mkdir -p -m 777  /home/www/hls/2021/$namefix/s";
                            var_dump($boscdn);
                            exec($boscdn);
                            //拷贝
                            $boscdn = "mv   " . $this->YiiUploadUrl . "/hls/2021/$namefix/s" . " /home/www/hls/2021/$namefix";
                            exec($boscdn);

                            echo '7';
                            //将m3u8数据写入数据库，并替换掉相关的敏感数据。以及将分片数据 。调整为oss正式地址
                            $this->actionCutfinishTry($value['vid'], $value, $m3u8_type = 1);
//                    //删除s切片
                            $fileurl2 = "rm -rf " . $this->YiiUploadUrl . "/hls/2021/$namefix/s/";
                            exec($fileurl2);
                            //删除源s目录
                            $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix" . '_s' . ".mp4";
                            if (file_exists($fileurl1))
                                $boor = unlink($fileurl1);
                            $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix" . '_s_2' . ".mp4";
                            if (file_exists($fileurl1))
                                unlink($fileurl1);
                        }
                        ////////////////////////////////////////////////////////////////////////////////////
                    }



                    //获取L影片需要切片的数据
                    $video_url = 'video-resources-api/get-m3u8-data-l';
                    $video_data = [];
                    $data = $this->apiDataoOperation($video_url, $video_data);
                    echo 'L影片';
                    var_dump($data);
                    if (!empty($data)) {

                        // $data = $model->getNOVideoMarvellousMu38Data();
                        foreach ($data as $key => $value) {
                            $sid = $value['sid'];
                            $fix = substr($sid, 0, 1);
                            $namefix = $fix . '/' . $sid;

                            $url = $this->YiiUploadUrl . "/videofile1/$namefix" . '_l' . ".mp4";
                            if (file_exists($url)) {
                                //获取影片信息
                                $ffmpeg = "ffmpeg -i  " . $url . " 2>&1";
                                $b = [];
                                $a = exec($ffmpeg, $b);
                                $length = '';
                                $mp4g = true;
                                foreach ($b as $key => $value1) {
                                    $x = strstr($value1, "Video: ");
                                    if (!empty($x)) {
                                        $h264 = explode('Video: ', $value1);
                                        if (!empty($h264[1])) {
                                            $mp4gTemp = substr($h264[1], 0, 4);
                                            if ($mp4gTemp == 'h264') {
                                                $mp4g = false;
                                            }
                                        }
                                    }
                                }
                                if ($mp4g) {//需要转编码
                                    $ffmpeg = " ffmpeg -threads 10 -i " . $url . "   -vcodec h264 -preset ultrafast " . $this->YiiUploadUrl . "/videofile1/$namefix" . '_l_2' . ".mp4";
                                    exec($ffmpeg);
                                    $url = $this->YiiUploadUrl . "/videofile1/$namefix" . '_l_2' . ".mp4";
                                }
                                $m3u8_l = $this->YiiUploadUrl . "/hls/2021/$namefix/l";
                                if (!is_dir($m3u8_l))
                                    mkdir($m3u8_l, 0755, true);

                                //原始分辨率
                                $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . $this->YiiUploadUrl . "/aes/$sid" . ".keyinfo -hls_segment_filename " . $this->YiiUploadUrl . "/hls/2021/$namefix/l/v%04d.png " . $this->YiiUploadUrl . "/m3u8/$sid" . "_l.m3u8";
                                exec($ffmpeg);

                                echo '4';
                                ////粘贴数据到远程目录 
                                //先清空目录
                                $fileurl1 = "/home/www/hls/2021/$namefix/l";
                                if (file_exists($fileurl1)) {
                                    $fileurl2 = "rm -rf " . "/home/www/hls/2021/$namefix/l";
                                    exec($fileurl2);
                                }
                                //在创建目录
                                $boscdn = "mkdir -p -m 777  /home/www/hls/2021/$namefix/l";
                                var_dump($boscdn);
                                exec($boscdn);
                                //拷贝
                                $boscdn = "mv   " . $this->YiiUploadUrl . "/hls/2021/$namefix/l" . " /home/www/hls/2021/$namefix";
                                exec($boscdn);

                                echo '7';
                                //将m3u8数据写入数据库，并替换掉相关的敏感数据。以及将分片数据 。调整为oss正式地址
                                $this->actionCutfinishTry($value['vid'], $value, $m3u8_type = 2);
//                           //删除s切片
                                $fileurl2 = "rm -rf " . $this->YiiUploadUrl . "/hls/2021/$namefix/l/";
                                exec($fileurl2);
                                //删除源s目录
                                $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix" . '_l' . ".mp4";
                                var_dump($fileurl1);
                                unlink($fileurl1);
                                $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix" . '_l_2' . ".mp4";
                                if (file_exists($fileurl1))
                                    unlink($fileurl1);
                            } else {
                                echo '文件不存在' . $url;
                            }
                        }
                        ////////////////////////////////////////////////////////////////////////////////////
                    }


                    //获取L影片需要切片的数据
                    $video_url = 'video-resources-api/get-m3u8-data-h';
                    $video_data = [];
                    $data = $this->apiDataoOperation($video_url, $video_data);
                    echo 'H影片';
                    // var_dump($data);
                    if (!empty($data)) {

                        // $data = $model->getNOVideoMarvellousMu38Data();
                        foreach ($data as $key => $value) {
                            $sid = $value['sid'];
                            $fix = substr($sid, 0, 1);
                            $namefix = $fix . '/' . $sid;

                            $url = $this->YiiUploadUrl . "/videofile1/$namefix" . '_h' . ".mp4";
                            //获取影片信息
                            $ffmpeg = "ffmpeg -i  " . $url . " 2>&1";
                            $b = [];
                            $a = exec($ffmpeg, $b);
                            $length = '';
                            $mp4g = true;
                            foreach ($b as $key => $value1) {
                                $x = strstr($value1, "Video: ");
                                if (!empty($x)) {
                                    $h264 = explode('Video: ', $value1);
                                    if (!empty($h264[1])) {
                                        $mp4gTemp = substr($h264[1], 0, 4);
                                        if ($mp4gTemp == 'h264') {
                                            $mp4g = false;
                                        }
                                    }
                                }
                            }
                            if ($mp4g) {//需要转编码
                                $ffmpeg = " ffmpeg -threads 10 -i " . $url . "   -vcodec h264 -preset ultrafast " . $this->YiiUploadUrl . "/videofile1/$namefix" . '_h_2' . ".mp4";
                                exec($ffmpeg);
                                $url = $this->YiiUploadUrl . "/videofile1/$namefix" . '_h_2' . ".mp4";
                            }
                            $m3u8_l = $this->YiiUploadUrl . "/hls/2021/$namefix/h";
                            if (!is_dir($m3u8_l))
                                mkdir($m3u8_l, 0755, true);

                            //原始分辨率
                            $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . $this->YiiUploadUrl . "/aes/$sid" . ".keyinfo -hls_segment_filename " . $this->YiiUploadUrl . "/hls/2021/$namefix/h/v%04d.png " . $this->YiiUploadUrl . "/m3u8/$sid" . "_h.m3u8";
                            exec($ffmpeg);

                            echo '4';
                            ////粘贴数据到远程目录 
                            //先清空目录
                            $fileurl1 = "/home/www/hls/2021/$namefix/h";
                            if (file_exists($fileurl1)) {
                                $fileurl2 = "rm -rf " . "/home/www/hls/2021/$namefix/h";
                                exec($fileurl2);
                            }
                            //在创建目录
                            $boscdn = "mkdir -p -m 777  /home/www/hls/2021/$namefix/h";
                            var_dump($boscdn);
                            exec($boscdn);
                            //拷贝
                            $boscdn = "mv   " . $this->YiiUploadUrl . "/hls/2021/$namefix/h" . " /home/www/hls/2021/$namefix";
                            exec($boscdn);

                            echo '7';
                            //将m3u8数据写入数据库，并替换掉相关的敏感数据。以及将分片数据 。调整为oss正式地址
                            $this->actionCutfinishTry($value['vid'], $value, $m3u8_type = 3);
//                    //删除s切片
                            $fileurl2 = "rm -rf " . $this->YiiUploadUrl . "/hls/2021/$namefix/h/";
                            exec($fileurl2);
                            //删除源s目录
                            $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix" . '_h' . ".mp4";
                            var_dump($fileurl1);
                            unlink($fileurl1);
                            $fileurl1 = $this->YiiUploadUrl . "/videofile1/$namefix" . '_h_2' . ".mp4";
                            if (file_exists($fileurl1))
                                unlink($fileurl1);
                        }
                        ////////////////////////////////////////////////////////////////////////////////////
                    }



                    //解锁文件
                    $myfile = fopen($fileUrl, 'w');
                    fwrite($myfile, 1);
                    fclose($myfile);
                } catch (\Exception $e) {
                    Yii::info('切片失败---------' . $e, 'request');
                    //解锁文件
                    $myfile = fopen($fileUrl, 'w');
                    fwrite($myfile, 1);
                    fclose($myfile);
                    //$this->returnJsonError($msg = $e->getMessage(), [], $e->getCode());
                }
            }
        }
    }

    /**
     * 数据  每天0点后一次
     */
    public function actionAudioMu38() {

        $fileUrl = $this->YiiUploadUrl . '/lock/lockAudio2.txt';
        $myfile = fopen($fileUrl, 'w');
        fwrite($myfile, date('Y-m-d H:i:s'));
        fclose($myfile);

        $fileUrl = $this->YiiUploadUrl . '/lock/lockAudio.txt';
        if (file_exists($fileUrl)) {
            $contents = file_get_contents($fileUrl);
            if ($contents == 1) {//未锁定
                try {
                    //锁定文件
                    $myfile = fopen($fileUrl, 'w');
                    fwrite($myfile, 2);
                    fclose($myfile);
                    /////////////////////////////////业务逻辑///////////////////////////////////////////////
                    //hls 目录只要2021年
//                $model = new Video();
//                $data = $model->getNOVideoMu38Data();
                    $video_url = 'video-resources-api/get-audio-m3u8';
                    $video_data = [];
                    $data = $this->apiDataoOperation($video_url, $video_data);
                    $mp4gTemp = '';
                    if (!empty($data)) {
                        foreach ($data as $key => $value1) {
                            $sid = $value1['sid'];
                            $fix = substr($sid, 0, 1);
                            $namefix = $fix . '/' . $sid;
                            $chapter = $value1['chapter'];
                            $audioUrl = $this->YiiUploadUrl . "/audiofile/$namefix" . "_" . "$chapter.mp3";

                            // $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . $this->YiiUploadUrl . "/aes/$sid.keyinfo -hls_segment_filename " . $this->YiiUploadUrl . "/hls/2021/$namefix/m/v%04d.png " . $this->YiiUploadUrl . "/audiom3u8/$sid_$chapter.m3u8";
                            //$this->YiiUploadUrl/mp3/2021/$namefix/$chapter/
                            $boscdn = "mkdir -p -m 777  $this->YiiUploadUrl/mp3/2021/$namefix/$chapter/";
                            var_dump($boscdn);
                            exec($boscdn);

                            $ffmpeg = "ffmpeg -y -i $audioUrl -threads 5 -preset ultrafast -hls_time 100 -hls_list_size 0 -hls_key_info_file $this->YiiUploadUrl/aes/$sid.keyinfo -hls_playlist_type vod -hls_segment_filename $this->YiiUploadUrl/mp3/2021/$namefix/$chapter/v%04d.png $this->YiiUploadUrl/audiom3u8/{$sid}_{$chapter}.m3u8";

                            exec($ffmpeg);

                            $boscdn = "mkdir -p -m 777  /home/www/mp3/2021/$namefix/$chapter";
                            var_dump($boscdn);
                            exec($boscdn);
                            $boscdn = "mv  " . $this->YiiUploadUrl . "/mp3/2021/$namefix/$chapter" . " /home/www/mp3/2021/$namefix";

                            echo '拷贝';
                            var_dump($boscdn);

                            echo '2';
                            exec($boscdn);
                            echo '3';
                            $s = $this->YiiUploadUrl . "/audiom3u8/{$sid}_{$chapter}.m3u8";
                            var_dump($s);
                            //处理m3u8数据
                            $m3u8_m = file_get_contents($this->YiiUploadUrl . "/audiom3u8/{$sid}_{$chapter}.m3u8");
                            //更新m3u8数据
                            echo '4';
                            $video_url = 'video-resources-api/audio-chapter';
                            $video_data = ['id' => $value1['id'], 'm3u8_m' => $m3u8_m];
                            $boor = $this->apiDataoOperation($video_url, $video_data);
                            echo '5';
                            var_dump('更新m3u8');
                            var_dump($boor);
                            //需要删除的内容目录
                            $fileurl2 = "rm -rf " . $this->YiiUploadUrl . "/mp3/2021/$namefix/$chapter/";
                            exec($fileurl2);
                            //需要删除的mp4文件
                            $fileurl1 = $this->YiiUploadUrl . "/audiofile/$namefix" . "_" . "$chapter.mp3";
                            if (file_exists($fileurl1))
                                $boor = unlink($fileurl1);
                        }
                    }


                    //解锁文件
                    $myfile = fopen($fileUrl, 'w');
                    fwrite($myfile, 1);
                    fclose($myfile);
                } catch (\Exception $e) {
                    Yii::info('切片失败---------' . $e, 'request');
                    //解锁文件
                    $myfile = fopen($fileUrl, 'w');
                    fwrite($myfile, 1);
                    fclose($myfile);
                    //$this->returnJsonError($msg = $e->getMessage(), [], $e->getCode());
                }
            }
        }
    }

    public function actionTestOne() {
        $video['sid'] = '389af5bc4cb65b33f3e96c20e8a2e80007a52a1e';
        $video['vid'] = 27502;
        $t = 2021;
        $fix = substr($video['sid'], 0, 1);
        //mu38目录
        $path = $t . '/' . $fix . '/';
        //处理m3u8数据
        $m3u8_m = file_get_contents($this->YiiUploadUrl . "/m3u8/{$video['sid']}_m.m3u8");
        //更新m3u8数据
        $video_url = 'video-resources-api/update-m3u8-data';
        $video_data = ['vid' => $video['vid'], 'm3u8_m' => $m3u8_m];
        $boor = $this->apiDataoOperation($video_url, $video_data);
        var_dump('更新m3u8');
        var_dump($boor);
    }

    //正片切片完成后  进行数据更新
    public function actionCutfinish($vid, $img, $time, $video) {
        $t = 2021;
        $fix = substr($video['sid'], 0, 1);
        //mu38目录
        $path = $t . '/' . $fix . '/';
        //处理m3u8数据
        $m3u8_m = file_get_contents($this->YiiUploadUrl . "/m3u8/{$video['sid']}_m.m3u8");
        //更新m3u8数据
        $video_url = 'video-resources-api/update-m3u8-data';
        $video_data = ['vid' => $video['vid'], 'm3u8_m' => $m3u8_m];
        $boor = $this->apiDataoOperation($video_url, $video_data);
        if (empty($boor)) {
            $boor = $this->apiDataoOperation($video_url, $video_data);
        }
        var_dump('更新m3u8');
        var_dump($boor);
        //更新1。0m3u8
        $video_url = 'video-resources-api/update-m3u8-data-sid';
        $video_data['sid'] = $video['sid'];
        $boor = $this->apiDataoOperationYS($video_url, $video_data);
        if (empty($boor)) {
            $boor = $this->apiDataoOperationYS($video_url, $video_data);
        }
        var_dump('更新m3u8-1.0');
        var_dump($boor);
        //处理封面
        $imgData = json_decode($img, true);
        $file_path = $this->YiiUploadUrl . "/picvideostore/";

        foreach ($imgData as $key => $value) {
            $temp = [];
            $temp[] = $value;
            if (file_exists($file_path . $value)) {
                //切片封面上传到cdn
                $data = ModApi::img_encrypt(base64_encode(file_get_contents($file_path . $value)));

                //获取cdn原目录
                $img_type = 7;
                $imgHost = Yii::$app->params['img_host'];
                $res = Ssh2Helper::getInstance()->getRemoteDirectory($value, $imgHost, $img_type);

                if (($TxtRes = fopen($res, "w+")) === FALSE) {
                    return false;
                }
                if (!fwrite($TxtRes, $data)) { //将信息写入文件
                    fclose($TxtRes);
                    return false;
                }
                fclose($TxtRes); //关闭指针
                //删除原文件
                if (file_exists($file_path . $value)) {
                    $boor = unlink($file_path . $value);
                    //var_dump($boor);
                }
            }
        }
        $hpic = '';
        if (empty($video['hpic'])) {
            $hpic = $imgData[0];
        }

        //更新数据切片后的数据
        $video_url = 'video-resources-api/update-video-data';
        $video_data = [
            'vid' => $video['vid'],
            'img' => $img,
            'hpic' => $hpic,
            'time' => $time,
            'path' => $path
        ];
        $boor = $this->apiDataoOperation($video_url, $video_data);

        //更新数据1。0
        //更新数据切片后的数据
        $video_url = 'video-resources-api/update-video-data-sid';
        $video_data['sid'] = $video['sid'];
        $boor = $this->apiDataoOperationYS($video_url, $video_data);
//        $model = new Video();
//        $model->updateVideoM3u8Message($video['vid'], $img, $hpic, $time, $path);
    }

    //正片切片完成后  进行数据更新
    public function actionCutfinishTry($vid, $video, $m3u8_type = 1) {

        $definitionData = [1 => 's', 2 => 'l', 3 => 'h'];
        $type = $definitionData[$m3u8_type];
        //处理m3u8数据
        $m3u8_m = file_get_contents($this->YiiUploadUrl . "/m3u8/{$video['sid']}_$type.m3u8");
        //更新m3u8数据
        $video_url = 'video-resources-api/update-m3u8-try';
        $video_data = [
            'vid' => $video['vid'],
            'm3u8_m' => $m3u8_m,
            'm3u8_type' => $m3u8_type
        ];

        $boor = $this->apiDataoOperation($video_url, $video_data);
        echo '切片数据测试';
        var_dump($video_data);
        var_dump($boor);
        if ($m3u8_type == 1) {
            echo '精彩1。0数据';
            $video_url = 'video-resources-api/update-m3u8-try-sid';
            $video_data['sid'] = $video['sid'];
            $boor = $this->apiDataoOperationYS($video_url, $video_data);
            var_dump($boor);
        }


//        $model = new VideoM3u8();
//        $model->addVideoM3u8S($video['vid'], $m3u8_m);
        //更新数据切片后的数据
//        $video_url = 'video-resources-api/update-video-try';
//        $video_data = [
//            'vid' => $video['vid']
//        ];
//        $boor = $this->apiDataoOperation($video_url, $video_data);
//        $model = new Video();
//        $model->updateVideoM3u8Stype($video['vid']);
    }

    function read($path) {
        $file = fopen($path, "r");
        $user = array();
        $i = 0;
        //输出文本中所有的行，直到文件结束为止。
        while (!feof($file)) {
            $user[$i] = fgets($file); //fgets()函数从文件指针中读取一行
            $i++;
        }
        fclose($file);
        $user = array_filter($user);
        return $user;
    }

    /**
     * 自动切精彩影片
     * @param type $vid
     */
    public function actionM3u8($vid, $sid) {
//        $url = 'C:\Users\Administrator\Desktop\temp\小辣椒1.0\m3u8\00a018e408e64ec295ae73694d399d0ee290e894_m.m3u8';
//        $path = 'C:\Users\Administrator\Desktop\temp\小辣椒1.0\m3u8\00a018e408e64ec295ae73694d399d0ee290e894_s.m3u8';
        //   $model = new Video();
        $webrootUrl = $this->YiiUploadUrl;
        //$noExistData = [];
        //$dataAll = $model->getVideoRecordList($page, $limit);
        //  $video = Video::getWebVideoDataOne($vid);
        //var_dump($video);
        // if (!empty($video)) {
        // foreach ($dataAll['data'] as $key => $value) {
        $m3u8Url = $webrootUrl . '/m3u8/' . $sid . '_m.m3u8';
        $boor = file_exists($m3u8Url);
        //var_dump($boor);
        if (!empty($boor)) {
            $path = $webrootUrl . '/m3u8/' . $sid . '_s.m3u8';
            $data = $this->read($m3u8Url);
            //总片数
            $len = (count($data) - 6) / 2;
            //删除源文件
            if (file_exists($path)) {
                unlink($path);
            }
            //打开文件
            $myfile = fopen($path, "a");
            if ($len > 30) {
                $zj = floor($len / 2);
                $start = $zj * 2 + 5;
                for ($j = 0; $j < 5; $j++) {
                    fwrite($myfile, $data[$j]);
                }
                for ($k = $start; $k < $start + 24; $k++) {
                    fwrite($myfile, $data[$k]);
                }
                fwrite($myfile, $data[count($data) - 1]);
            } else {//数据过短  直接复制过来
                foreach ($data as $key => $value) {
                    fwrite($myfile, $value);
                }
            }
            fclose($myfile);
            /////////////
            var_dump($path);
            if (file_exists($path)) {
                $m3u8 = file_get_contents($path);
                $video_url = 'video-resources-api/update-m3u8-try-auto';
                $video_data = ['vid' => $vid, 'm3u8_m' => $m3u8];
                var_dump($video_data);
                $boor = $this->apiDataoOperation($video_url, $video_data);
                var_dump('更新m3u8精彩片段');
                var_dump($boor);
                //1.0
                $video_url = 'video-resources-api/update-m3u8-try-auto-sid';
                $video_data['sid'] = $sid;
                var_dump($video_data);
                $boor = $this->apiDataoOperationYS($video_url, $video_data);
                var_dump('更新1.0m3u8精彩片段');
                var_dump($boor);
            }


//            VideoM3u8::updateM3u8TypeS($vid);
//            //将精彩片段置为m
//            Video::updateM3u8TypeS($vid);
        }




        //}
        //  }
    }

    /**
     * 原文件目录
     * @param type $file_path
     * @param type $save_name
     * @return type
     */
    function uploadImg($file_path) {
        $suffix = '.jpg';
        //文件名
        $name = sha1(rand(10000, 99999) . uniqid()) . $suffix;
        $day = 2021;
        $save_name = $day . '/' . substr($name, 0, 1) . '/' . $name;
        //上传到cdn
        $data = ModApi::img_encrypt(base64_encode(file_get_contents($file_path)));

        //获取cdn原目录
        $img_type = 5;
        $imgHost = Yii::$app->params['img_host'];
        $res = Ssh2Helper::getInstance()->getRemoteDirectory($save_name, $imgHost, $img_type);

        if (($TxtRes = fopen($res, "w+")) === FALSE) {
            return false;
        }
        if (!fwrite($TxtRes, $data)) { //将信息写入文件
            fclose($TxtRes);
            return false;
        }
        fclose($TxtRes); //关闭指针
        // $up = Ssh2Helper::getInstance()->sftpImgTxtUrl($save_name, $data, $imgHost, $img_type);
        return 'images/' . $save_name;
    }

    //正片切片完成后  进行数据更新 重置状态
    public function actionCutfinishResetTry($vid, $video, $m3u8_type = 1) {

        $definitionData = [1 => 's', 2 => 'l', 3 => 'h'];
        $type = $definitionData[$m3u8_type];
        //处理m3u8数据
        $m3u8_m = file_get_contents($this->YiiUploadUrl . "/m3u8/{$video['sid']}_$type.m3u8");
        //更新m3u8数据
        $video_url = 'video-resources-api/update-m3u8-try-reset';
        $video_data = [
            'vid' => $video['vid']
        ];

        $boor = $this->apiDataoOperation($video_url, $video_data);
        echo '关闭没有源的切片数据测试';
        var_dump($video_data);
        var_dump($boor);
        if ($m3u8_type == 1) {
            echo '精彩1。0关闭没有源的切片数据测试';
            $video_url = 'video-resources-api/reset-m3u8-try-sid';
            $video_data['sid'] = $video['sid'];
            $boor = $this->apiDataoOperationYS($video_url, $video_data);
            var_dump($boor);
        }
    }

}
