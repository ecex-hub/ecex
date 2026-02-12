<?php

/*
 * 资源上传类
 * */

namespace common\helpers;

/**
 * CarouselImage Helper
 */
class Ssh2Helper extends BaseHelper {

    const IMG_TYPE_JPG = ".jpg";
    const IMG_TYPE_PNG = ".png";
    //图片类型
    const IMG_TYPE_1 = 1; //后台web图片
    const IMG_TYPE_2 = 2; //im图片
    const IMG_TYPE_3 = 3; //客服头像图片
    const IMG_TYPE_4 = 4; //支付二维码图片
    const IMG_TYPE_5 = 5; //视频图片
    const IMG_TYPE_6 = 6; //txt文件
    const IMG_TYPE_7 = 7; //视频封面文件
    const IMG_TYPE_8 = 8; //直播图片文件

    public $pid;
    public $createTime;

    /**
     * construct.
     *
     * @return void.
     */
    public function __construct() {
        
    }

    /**
     * sftpImgUrl paramer.
     * 后台上传图片到资源服
     *
     * @param string $file_name     文件名.
     * @param string $localFileSrc  本地文件位置.
     * @param string $imgHost  图片资源服配置.
     * @param integer $type  1 web图片， 2 im 图片.
     * @return mixed.
     */
    public function sftpImgUrl($file_name, $localFileSrc, $imgHost, $type = 1) {
        $connection = @ssh2_connect($imgHost['host'], $imgHost['port']);
        $boor = @ssh2_auth_password($connection, $imgHost['username'], $imgHost['password']);
        if (!$boor) {
            throw new \Exception("登录资源服失败", 217);
        }
        $dst = $this->getRemoteDirectory($file_name, $imgHost, $type);
        if (file_exists($localFileSrc)) {
            $sftp = @ssh2_sftp($connection);
            $stream = @fopen('ssh2.sftp://' . intval($sftp) . $dst, 'wb');
            //$stream = fopen("ssh2.sftp://$sftp$dst", 'wb');
            if (!$stream) {
                throw new \Exception("无法打开文件", 214);
            }
            $data = @file_get_contents($localFileSrc);
            if ($data === false) {
                throw new \Exception("无法打开本地文件", 215);
            }
            if (@fwrite($stream, $data) === false) {
                throw new \Exception("无法从文件发送数据", 216);
            }
            fclose($stream);
            unlink($localFileSrc);
            return true;
            /*
             * sftp->fopen->file_get_contents->fwrite 比
             * ssh2_scp_send 有更好的性能
             */
            /*
              $flag = ssh2_scp_send($connection, $localFileSrc, $dst, 0644);  //默认权限为0644，返回为bool
              if ($flag) {
              unlink($localFileSrc);
              ssh2_disconnect($connection);
              return true;
              }
              throw new \Exception("上传失败", 215);
             */
        }
        throw new \Exception('图片不存在', 213);
    }

    /**
     * sftpImgUrl paramer.
     * 后台上传到资源服
     *
     * @param string $file_name     文件名.
     * @param string $localFileSrc  本地文件位置.
     * @param string $imgHost  图片资源服配置.
     * @param integer $type  1 web图片， 2 im 图片.
     * @return mixed.
     */
    public function sftpImgTxtUrl($file_name, $data, $imgHost, $type = 1) {
        $connection = @ssh2_connect($imgHost['host'], $imgHost['port']);
        $boor = @ssh2_auth_password($connection, $imgHost['username'], $imgHost['password']);
        if (!$boor) {
            throw new \Exception("登录资源服失败", 217);
        }
        $dst = $this->getRemoteDirectory($file_name, $imgHost, $type);
        // if (file_exists($localFileSrc)) {
        $sftp = @ssh2_sftp($connection);
        $stream = @fopen('ssh2.sftp://' . intval($sftp) . $dst, 'wb');
        //$stream = fopen("ssh2.sftp://$sftp$dst", 'wb');
        if (!$stream) {
            throw new \Exception("无法打开文件", 214);
        }
        //$data = @file_get_contents($localFileSrc);
        if ($data === false) {
            throw new \Exception("无法打开本地文件", 215);
        }
        if (@fwrite($stream, $data) === false) {
            throw new \Exception("无法从文件发送数据", 216);
        }
        fclose($stream);
        //phpunlink($localFileSrc);
        return true;
        /*
         * sftp->fopen->file_get_contents->fwrite 比
         * ssh2_scp_send 有更好的性能
         */
        /*
          $flag = ssh2_scp_send($connection, $localFileSrc, $dst, 0644);  //默认权限为0644，返回为bool
          if ($flag) {
          unlink($localFileSrc);
          ssh2_disconnect($connection);
          return true;
          }
          throw new \Exception("上传失败", 215);
         */
        //  }
        //  throw new \Exception('图片不存在', 213);
    }

    /**
     * imSftpImgUrl paramer.
     * 上传图片到资源服
     *
     * @param string $file_name      文件名.
     * @param string $file_data  文件流.
     * @param string $imgHost  图片资源服配置.
     * @param integer $type  1 web图片， 2 im 图片.
     * @return mixed.
     */
    public function imSftpImgUrl($file_name, $file_data, $imgHost, $type = 1) {
        $connection = @ssh2_connect($imgHost['host'], $imgHost['port']);
        $boor = @ssh2_auth_password($connection, $imgHost['username'], $imgHost['password']);
        if (!$boor) {
            throw new \Exception("登录资源服失败", 217);
        }
        $dst = $this->getRemoteDirectory($file_name, $imgHost, $type);
        $sftp = @ssh2_sftp($connection);
        $stream = @fopen('ssh2.sftp://' . intval($sftp) . $dst, 'wb');
        if (!$stream) {
            throw new \Exception("无法打开文件", 214);
        }
        if (@fwrite($stream, $file_data) === false) {
            throw new \Exception("无法从文件发送数据", 216);
        }
        fclose($stream);
        return true;
    }

    /**
     * getRemoteDirectory paramer.
     * 获取远程目录地址
     *
     * @param string $file_name 文件名.  2021/1/11fdaf.txt
     * @param array $imgHost  图片资源服配置.
     * @param integer $type  图片类型 1 web图片， 2 im 图片 3.
     * @return mixed.
     */
    public function getRemoteDirectory($file_name, $imgHost = [], $type = 1) {
        switch ($type) {
            case self::IMG_TYPE_1;
                $dst = $imgHost['web_path'] . '/' . $file_name;  //远程目录地址
                break;
            case self::IMG_TYPE_2;
                $dst = $imgHost['im_path'] . '/' . $file_name;  //远程目录地址
                break;
            case self::IMG_TYPE_3;
                $dst = $imgHost['flash_payment_path'] . '/' . $file_name;  //远程目录地址
                break;
            case self::IMG_TYPE_4;
                $dst = $imgHost['pay_path'] . '/' . $file_name;  //远程目录地址
                break;
            case self::IMG_TYPE_5;
                $dst = $imgHost['url_path'] . '/' . $file_name;  //远程目录地址
                break;
            case self::IMG_TYPE_6;
                $dst = $imgHost['txt_path'] . '/' . $file_name;  //远程目录地址
                break;
            case self::IMG_TYPE_7;
                $dst = $imgHost['video_url_path'] . '/' . $file_name;  //远程目录地址
                break;
            case self::IMG_TYPE_8;
                $dst = $imgHost['url_live_path'] . '/' . $file_name;  //远程目录地址
                break;
            default:
                $dst = $imgHost['web_path'] . '/' . $file_name;
        }
        return $dst;
    }

    /**
     * getRemoteImageAddress .
     * 获取远程图片地址
     *
     * @param array $imgUrl 图片资源配置.
     * @param string $file_name 文件名.
     * @param integer $img_type  图片类型 1 web图片， 2 im 图片 3.
     * @return mixed.
     */
    public function getRemoteImageAddress($imgUrl, $file_name, $img_type) {
        switch ($img_type) {
            case self::IMG_TYPE_1;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $imgUrl['web_path'] . '/' . $file_name;
                break;
            case self::IMG_TYPE_2;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $imgUrl['im_path'] . '/' . $file_name;
                break;
            case self::IMG_TYPE_3;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $imgUrl['flash_payment_path'] . '/' . $file_name;
                break;
            case self::IMG_TYPE_4;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $imgUrl['pay_path'] . '/' . $file_name;
                break;
            default:
                $res = '';
        }
        return $res;
    }

    /**
     * getRemoteImageAddress .
     * 获取远程图片地址
     *
     * @param array $imgUrl 图片资源配置.
     * @param string $file_name 文件名.
     * @param integer $img_type  图片类型 1 web图片， 2 im 图片 3.
     * @return mixed.
     */
    public function getRemoteImageAddressName($imgUrl, $file_name, $img_type) {
        switch ($img_type) {
            case self::IMG_TYPE_1;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $file_name;
                break;
            case self::IMG_TYPE_2;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $file_name;
                break;
            case self::IMG_TYPE_3;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $file_name;
                break;
            case self::IMG_TYPE_4;
                $res = $imgUrl['scheme'] . '://' . $imgUrl['domain'] . '/' . $file_name;
                break;
            default:
                $res = '';
        }
        return $res;
    }

    /**
     * 指向远程命令行
     * @param type $imgHost
     * @param type $tcmd
     * @return boolean
     * @throws \Exception
     */
    public function sftpServerExec($imgHost, $tcmd) {
        $connection = @ssh2_connect($imgHost['host'], $imgHost['port']);
        $boor = @ssh2_auth_password($connection, $imgHost['username'], $imgHost['password']);
        if (!$boor) {
            throw new \Exception("登录资源服失败", 217);
        }

        $stream = @ssh2_exec($connection, $tcmd);
        return $stream;
    }

    public function scp_dir($dir, $todir, $imgHost) {
        $ssh2 = ssh2_connect($imgHost['host'], $imgHost['port']);        //先用SSH连接linux服务器，这里略过，具体方法参考另一篇博文http://www.cnblogs.com/suiyuewuxin/p/6858105.html
        $boor = ssh2_auth_password($ssh2, $imgHost['username'], $imgHost['password']);
        if (!$boor) {
            throw new \Exception("登录资源服失败", 217);
        }


        $dir = rtrim($dir, '/');
        $todir = rtrim($todir, '/');
        if (is_dir($dir)) {
            $path = $todir;
            $c = "mkdir -p -m 777 " . $path;
            ssh2_exec($ssh2, $c);

            $dirHandle = opendir($dir);
            while (false !== ($fileName = readdir($dirHandle))) {
                $subFile = $dir . DIRECTORY_SEPARATOR . $fileName;
                if (is_file($subFile)) {
                    $b = $path . "/" . $fileName;
                    ssh2_scp_send($ssh2, $subFile, $b, 0644);
                } elseif (is_dir($subFile) && str_replace('.', '', $fileName) != '') {
                    $c = "mkdir -m 777 " . $path . "/" . $subFile;
                    ssh2_exec($ssh2, $c);
                    scp_dir($subFile, $path, $ssh2);
                }
            }
            closedir($dirHandle);
        }
    }

}
