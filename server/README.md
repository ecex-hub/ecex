### lnmp环境
```
php 7.4+
mysql 5.7
nginx 1.20
redis 3.2
```
### 项目说明
```
api接口由yii2.0提供服务。
api项目配置就是在，environments 目录下配置相关参数，然后执行 php init 命令
然后配置nginx即可。nginx在对应根目录下。

api接口 只记录err日志，存放在mysql的t_system_log中。
```

### 生成文档
```
composer gen doc
```
### 定时任务
```
## 每月基金脚本
0 0 1 * * php yii fund/month
## 每天产品补助
0 1 * * * php yii product/day
## 结束产品
* * * * * php yii product/end
## 统计当天
* * * * * php yii tongji/day
## 统计昨天
30 0 * * * php yii tongji/last
```
### 访问服务器
```
ssh -i /path/to/testgz.pem centos@18.166.27.7
```

### 解决图片上传问题
```
## 配置php.ini
upload_max_filesize = 300M
post_max_size = 300M
## 配置nginx
client_max_body_size 300M; # 设置允许上传的最大文件大小
```