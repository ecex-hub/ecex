<?php

namespace console\controllers;

use yii\console\Controller;
use Yii;
use common\models\Video;
use common\models\VideoM3u8;
use common\helpers\ModApi;
use common\helpers\Ssh2Helper;

class VideoController extends Controller {
    /**
     * This command echoes what you have entered as the message.
     * @param string $message the message to be echoed.
     */

    /**
     * 数据  每天0点后一次
     */
    public function actionVideoMu38() {
        $fileUrl = Yii::$app->params['YiiUploadUrl'] . '/lock/lock.txt';
        if (file_exists($fileUrl)) {
            $contents = file_get_contents($fileUrl);
            if ($contents == 1) {//未锁定
                //锁定文件
                $myfile = fopen($fileUrl, 'w');
                fwrite($myfile, 2);
                fclose($myfile);
                /////////////////////////////////业务逻辑///////////////////////////////////////////////
                //hls 目录只要2021年
                $model = new Video();
                $data = $model->getNOVideoMu38Data();
                foreach ($data as $key => $value1) {
                    $sid = $value1['sid'];
                    $fix = substr($sid, 0, 1);
                    $namefix = $fix . '/' . $sid;
                    //获取影片信息
                    $ffmpeg = "ffmpeg -i  " . Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix.mp4  2>&1";
                    $b = [];
                    $a = exec($ffmpeg, $b);
                    $length = '';
                    //获取影片时长
                    $mp4g = '';
                    foreach ($b as $key => $value) {
                        $x = false;
                        $x = strstr($value, "Duration: ");
                        if (!empty($x)) {
                            $length = $value;
                        }
                        $x = strstr($value, "Video: ");
                        if (!empty($x)) {
                            $h264 = explode('Video: ', $value);
                            if (!empty($h264[1])) {
                                $mp4g = substr($h264[1], 0, 5);
                            }
                        }
                    }
                    $url = Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix.mp4";

                    if ($mp4g == 'mpeg4') {//需要转编码
                        $ffmpeg = " ffmpeg -i " . $url . "   -vcodec h264 " . Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix" . "_1.mp4";
                        exec($ffmpeg);
                        $url = Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix" . "_1.mp4";
                    }

                    $fen_mp4 = '1920x1080';
                    $ffmpegFenBian = "ffmpeg -i   " . $url . "  2>&1 | perl -lane 'print $1 if /(\d{3,5}x\d{3,5})/'";
                    $c = [];
                    $d = exec($ffmpegFenBian, $c);
                    if (!empty($c[0])) {
                        $fen_mp4 = $c[0];
                    }


                    $shijian = substr($length, 12, 11);

                    $time = strtotime('1970-1-1 ' . $shijian) + 8 * 3600; //视频时长
                    //平均十一份
                    $start_end = floor($time / 11);
                    $pic_url = Yii::$app->params['YiiUploadUrl'] . "/picvideostore/";
                    $imgData = [];
                    for ($i = 1; $i < 11; $i++) {
                        //文件名
                        $name = "2021/$fix/" . sha1($sid . time() . $i) . '.jpg';
                        $ss = $start_end * $i;
                        $sql = "ffmpeg -ss $ss -i " . $url . " -y -f image2    -t 0.001 -s $fen_mp4 $pic_url$name";
                        exec($sql);
                        $imgData[] = $name;
                    }
                    $img = json_encode($imgData);

                    //原始分辨率  切片
                    $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . Yii::$app->params['YiiUploadUrl'] . "/aes/$sid.keyinfo -hls_segment_filename " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/m/v%04d.png " . Yii::$app->params['YiiUploadUrl'] . "/m3u8/$sid" . "_m.m3u8";

                    exec($ffmpeg);

                    //创建远程目录
                    $chmod = 'ssh root@8.218.221.235 "mkdir  /home/www/hls/2021/' . $namefix . '"';
                    exec($chmod);
                    //赋予权限		
                    $chmod = 'ssh root@8.218.221.235 "chmod 755 /home/www/hls/2021/' . $namefix . '"';
                    exec($chmod);

                    //粘贴数据到远程目录
                    $boscdn = "scp -r " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/m root@8.218.221.235:/home/www/hls/2021/$namefix";
                    exec($boscdn);
                    //将m3u8数据写入数据库，并替换掉相关的敏感数据。以及将分片数据 。调整为oss正式地址
                    $this->actionCutfinish($value1['vid'], $img, $time);
                    //自动切精彩  11-12  momo  300部批量上传 临时关闭自动精彩
                    $this->actionM3u8($value1['vid']);
                    //需要删除的内容目录
                    $fileurl2 = "rm -rf " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/l/";
                    exec($fileurl2);
                    $fileurl2 = "rm -rf " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/m/";
                    exec($fileurl2);
                    $fileurl2 = "rm -rf " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/h/";
                    exec($fileurl2);
                    //需要删除的mp4文件
                    $fileurl1 = Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix.mp4";
                    $boor = unlink($fileurl1);
                    $fileurl1 = Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix" . "_1.mp4";
                    if (file_exists($fileurl1))
                        $boor = unlink($fileurl1);
                }

                //获取精彩影片需要切片的数据
                $data = $model->getNOVideoMarvellousMu38Data();
                foreach ($data as $key => $value) {
                    $sid = $value['sid'];
                    $fix = substr($sid, 0, 1);
                    $namefix = $fix . '/' . $sid;

                    $url = Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix" . '_s' . ".mp4";
                    //获取影片信息
                    $ffmpeg = "ffmpeg -i  " . $url . " 2>&1";
                    $b = [];
                    $a = exec($ffmpeg, $b);
                    $length = '';
                    $mp4g = '';
                    foreach ($b as $key => $value1) {
                        $x = strstr($value1, "Video: ");
                        if (!empty($x)) {
                            $h264 = explode('Video: ', $value1);
                            if (!empty($h264[1])) {
                                //$mp4g = substr($h264[1], 0, 5);
                                $mp4g1 = substr($h264[1], 0, 5);
                                if ($mp4g1 == 'mpeg4') {
                                    $mp4g = $mp4g1;
                                }
                            }
                        }
                    }
                    if ($mp4g == 'mpeg4') {//需要转编码
                        $ffmpeg = " ffmpeg -i " . $url . "   -vcodec h264 " . Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix" . '_s_2' . ".mp4";
                        exec($ffmpeg);
                        $url = Yii::$app->params['YiiUploadUrl'] . "/videofile1/$namefix" . '_s_2' . ".mp4";
                    }


                    //原始分辨率
                    $ffmpeg = "ffmpeg -i " . $url . " -vcodec copy -acodec copy -vbsf h264_mp4toannexb -threads 5 -preset ultrafast -hls_time 5 -hls_list_size 0 -hls_key_info_file " . Yii::$app->params['YiiUploadUrl'] . "/aes/$sid" . ".keyinfo -hls_segment_filename " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/s/v%04d.png " . Yii::$app->params['YiiUploadUrl'] . "/m3u8/$sid" . "_s.m3u8";
                    exec($ffmpeg);
                    //创建远程目录
                    $chmod = 'ssh root@8.218.221.235 "mkdir  /home/www/hls/2021/' . $namefix . '"';
                    exec($chmod);
                    //赋予权限		
                    $chmod = 'ssh root@8.218.221.235 "chmod 755 /home/www/hls/2021/' . $namefix . '"';
                    exec($chmod);
                    //粘贴数据到远程目录
                    $boscdn = "scp -r " . Yii::$app->params['YiiUploadUrl'] . "/hls/2021/$namefix/s root@8.218.221.235:/home/www/hls/2021/$namefix";
                    exec($boscdn);
                    //将m3u8数据写入数据库，并替换掉相关的敏感数据。以及将分片数据 。调整为oss正式地址
                    // $cutfinish = " php74 /var/www/html/video_yii/yii  video/cutfinish-try {$value['vid']}"; 
                    $this->actionCutfinishTry($value['vid']);
                    // exec($cutfinish);
                    //删除s切片
                    $fileurl2 = "rm -rf " . "/usr/local/webroot/hls/2021/$namefix/s/";
                    exec($fileurl2);
                    //删除源s目录
                    $fileurl1 = "/usr/local/webroot/videofile1/$namefix" . '_s' . ".mp4";
                    unlink($fileurl1);
                    $fileurl1 = "/usr/local/webroot/videofile1/$namefix" . '_s_2' . ".mp4";
                    if (file_exists($fileurl1))
                    unlink($fileurl1);
                }
                ////////////////////////////////////////////////////////////////////////////////////
                //解锁文件
                $myfile = fopen($fileUrl, 'w');
                fwrite($myfile, 1);
                fclose($myfile);
            }
        }
    }

    //正片切片完成后  进行数据更新
    public function actionCutfinish($vid, $img, $time) {

//        $params = $this->params(['vid', 'img', 'time']);
//        $this->VerificationParameter($params, ['vid', 'img', 'time']);
        $video = Video::getWebVideoDataOne($vid);
        if (!empty($video)) {
            $level = 'm';
            $t = 2021;
            $fix = substr($video['sid'], 0, 1);
            //mu38目录
            $path = $t . '/' . $fix . '/';
            //处理m3u8数据
            $m3u8_m = file_get_contents(Yii::$app->params['YiiUploadUrl'] . "/m3u8/{$video['sid']}_m.m3u8");
//            $m3u8_m = preg_replace('/v([\d]+)\.png/', $url . '/hls/' . $path . $video['sid'] . '/' . $level . '/v\\1.png', $m3u8_m);
//            $m3u8_m = preg_replace('/([0-9a-z]+)\.jpg/', $url . '/' . $path . $video['sid'] . '/' . $level . '/\\1.jpg', $m3u8_m);
//            $m3u8_m = str_replace('key', '###', $m3u8_m);
            //更新m3u8数据
            $model = new VideoM3u8();
            $data['video_id'] = $video['vid'];
            $data['media_url'] = $m3u8_m;
            $data['free_media_url'] = '';
            $model->addVideoM3u8($data);
            //处理封面
            $imgData = json_decode($img, true);
            $file_path = Yii::$app->params['YiiUploadUrl'] . "/picvideostore/";

            $img_type = 7;
            $imgHost = Yii::$app->params['img_host'];
            foreach ($imgData as $key => $value) {
                //切片封面上传到cdn
                $data = ModApi::img_encrypt(base64_encode(file_get_contents($file_path . $value)));
                $up = Ssh2Helper::getInstance()->sftpImgTxtUrl($value, $data, $imgHost, $img_type);
            }
            //更新数据切片后的数据
            $model = new Video();
            $model->updateVideoM3u8Message($video['vid'], $img, $imgData[0], $time, $path);
        }
    }

    //正片切片完成后  进行数据更新
    public function actionCutfinishTry($vid) {
//        $params = $this->params(['vid']);
//        $this->VerificationParameter($params, ['vid']);
        $video = Video::getWebVideoDataOne($vid);
        if (!empty($video)) {
            $level = 's';
            $t = 2021;
            $fix = substr($video['sid'], 0, 1);
            //mu38目录
            $path = $t . '/' . $fix . '/';
            //处理m3u8数据
            $m3u8_m = file_get_contents(Yii::$app->params['YiiUploadUrl'] . "/m3u8/{$video['sid']}_s.m3u8");
//            $m3u8_m = preg_replace('/v([\d]+)\.png/', $url . '/hls/' . $path . $video['sid'] . '/' . $level . '/v\\1.png', $m3u8_m);
//            $m3u8_m = preg_replace('/([0-9a-z]+)\.jpg/', $url . '/' . $path . $video['sid'] . '/' . $level . '/\\1.jpg', $m3u8_m);
//            $m3u8_m = str_replace('key', '###', $m3u8_m);
            //更新m3u8数据
            $model = new VideoM3u8();
            $model->addVideoM3u8S($video['vid'], $m3u8_m);
            //更新数据切片后的数据
            $model = new Video();
            $model->updateVideoM3u8Stype($video['vid']);
        }
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
    public function actionM3u8($vid) {
//        $url = 'C:\Users\Administrator\Desktop\temp\小辣椒1.0\m3u8\00a018e408e64ec295ae73694d399d0ee290e894_m.m3u8';
//        $path = 'C:\Users\Administrator\Desktop\temp\小辣椒1.0\m3u8\00a018e408e64ec295ae73694d399d0ee290e894_s.m3u8';
        //   $model = new Video();
        $webrootUrl = Yii::$app->params['webrootUrl'];
        //$noExistData = [];
        //$dataAll = $model->getVideoRecordList($page, $limit);
        $video = Video::getWebVideoDataOne($vid);
        //var_dump($video);
        if (!empty($video)) {
            // foreach ($dataAll['data'] as $key => $value) {
            $m3u8Url = $webrootUrl . '/m3u8/' . $video['sid'] . '_m.m3u8';
            $boor = file_exists($m3u8Url);
            //var_dump($boor);
            if (!empty($boor)) {
                $path = $webrootUrl . '/m3u8/' . $video['sid'] . '_s.m3u8';
                $data = $this->read($m3u8Url);
                //总片数
                $len = (count($data) - 6) / 2;
                //删除源文件
                if (file_exists($path)) {
                    unlink($path);
                }
                //打开文件
                $myfile = fopen($path, "a");
                if ($len > 15) {
                    $zj = floor($len / 2);
                    $start = $zj * 2 + 5;
                    for ($j = 0; $j < 5; $j++) {
                        fwrite($myfile, $data[$j]);
                    }
                    for ($k = $start; $k < $start + 12; $k++) {
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
            }
            //}
        }
    }

}
