# 生产环境部署指南

本文档详细说明如何在两台阿里云服务器上部署本系统。

## 📋 服务器配置要求

### 服务器 1 - 前端服务器
- **系统**: Alibaba Cloud Linux 3.2104 LTS 64位
- **配置**: 2核4G 或以上
- **带宽**: 5M 或以上（需要公网 IP）
- **磁盘**: 40GB 或以上

### 服务器 2 - 后端服务器
- **系统**: Alibaba Cloud Linux 3.2104 LTS 64位
- **配置**: 4核8G 或以上
- **带宽**: 1M 或以上（仅需内网通信）
- **磁盘**: 100GB 或以上

## 🔧 前置准备

### 1. 域名准备
- 准备一个已备案的域名
- 将域名 A 记录解析到前端服务器公网 IP（例如 `ecex.cc`）
- 将管理后台子域名 A 记录也解析到前端服务器公网 IP（例如 `admin.ecex.cc`）
- 确保 80 和 443 端口可访问

### 2. GitHub 准备
- 创建 GitHub 仓库
- 生成 Personal Access Token（需要 `write:packages` 权限）
- 将代码推送到 GitHub

### 3. 服务器网络配置
- 确保两台服务器在同一 VPC 内网
- 记录后端服务器的内网 IP 地址
- 配置安全组规则：
  - 前端服务器：开放 80、443 端口
  - 后端服务器：开放 8080 端口（仅内网，Yii2 API）
  - 后端服务器：开放 8097 端口（仅内网，管理后台）

## 🚀 部署步骤

### 第一步：准备两台服务器

在**两台服务器**上都执行以下操作：

```bash
# 1. 更新系统
sudo yum update -y

# 2. 安装 Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

# 3. 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 4. 安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 5. 验证安装
docker --version
docker-compose --version

# 6. 配置 Docker 镜像加速（阿里云）
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 第二步：推送代码到 GitHub

在**本地开发机器**上执行：

```bash
# 1. 初始化 Git 仓库（如果还没有）
cd /path/to/ecex
git init
git add .
git commit -m "Initial commit"

# 2. 关联远程仓库
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# 3. 推送代码
git branch -M main
git push -u origin main
```

推送后，GitHub Actions 会自动构建并推送 Docker 镜像到 GitHub Container Registry。

### 第三步：部署后端服务器

在**后端服务器**上执行：

```bash
# 1. 创建部署目录
mkdir -p ~/app/backend
cd ~/app/backend

# 2. 下载部署文件
# 方法 A: 使用 git clone
git clone https://github.com/ecex-hub/ecex.git temp
cp -r temp/deploy/backend/* .
rm -rf temp

# 方法 B: 手动创建文件（从 deploy/backend/ 目录复制）
# 需要的文件：
# - docker-compose.prod.yml
# - .env.example
# - deploy.sh

# 3. 配置环境变量
cp .env.example .env
vi .env
# 修改以下内容：
# DB_PASSWORD=设置强密码
# REDIS_PASSWORD=设置强密码

# 4. 修改 docker-compose.prod.yml
vi docker-compose.prod.yml
# 将 YOUR_GITHUB_USERNAME/YOUR_REPO_NAME 替换为实际值

# 5. 创建必要的目录
mkdir -p runtime assets uploads logs mysql-data redis-data mysql-conf
mkdir -p admin-runtime admin-uploads admin-logs

# 6. 导入数据库
# 从仓库获取 db.sql 文件
wget https://raw.githubusercontent.com/ecex-hub/ecex/main/db.sql

# 7. 登录 GitHub Container Registry
echo ${GITHUB_TOKEN} | docker login ghcr.io -u ${GITHUB_USERNAME} --password-stdin

# 8. 启动服务
chmod +x deploy.sh
bash deploy.sh

# 9. 导入数据库（首次部署）
# 等待 MySQL 启动完成
sleep 30
docker exec -i yii2-mysql mysql -uroot -p'EcEx@MySQL#2026!Prod$Secure' ecex < db.sql

# 10. 验证服务
curl http://localhost:8080
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs -f app
```

**重要配置说明：**

1. **修改后端配置文件**（如果需要）：
```bash
# 进入容器
docker exec -it yii2-app sh

# 编辑数据库配置
vi /var/www/html/common/config/main-local.php
```

2. **查看内网 IP**：
```bash
# 记录此 IP，前端需要用到
ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
```

3. **启动管理后台容器**（admin 镜像构建完成后）：
```bash
cd ~/app/backend

# 拉取管理后台镜像
docker pull ghcr.io/ecex-hub/ecex/admin:latest

# 启动管理后台容器
docker-compose -f docker-compose.prod.yml up -d admin

# 验证管理后台服务
curl http://localhost:8097
docker logs fastadmin-app
```

> **说明**：admin 服务与 Yii2 后端共享同一个 MySQL 和 Redis 容器。管理后台使用 ThinkPHP 框架，
> 数据库表前缀为 `t_`，通过 `PHP_` 前缀的环境变量传递配置（如 `PHP_DATABASE_HOSTNAME=mysql`）。
> docker-compose.prod.yml 中已包含 admin 服务的完整配置，无需额外修改。

### 第四步：部署前端服务器

在**前端服务器**上执行：

```bash
# 1. 创建部署目录
mkdir -p ~/app/frontend
cd ~/app/frontend

# 2. 下载部署文件
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git temp
cp -r temp/deploy/frontend/* .
rm -rf temp

# 3. 配置环境变量
cp .env.example .env
vi .env
# 修改以下内容：
# BACKEND_HOST=后端服务器内网IP:8080  # 例如：172.16.0.100:8080
# GITHUB_USERNAME=你的GitHub用户名
# GITHUB_TOKEN=你的GitHub Token

# 4. 配置 Caddyfile
cp Caddyfile.example Caddyfile
vi Caddyfile
# 修改以下内容：
# 1. 将 your-domain.com 替换为你的实际域名（如 ecex.cc）
# 2. 将 your-email@example.com 替换为你的邮箱
# 3. 将 172.16.0.100:8080 替换为后端服务器的实际内网地址
# 4. 将 admin.ecex.cc 中的 172.16.0.100:8097 替换为后端实际内网地址
# 注意：Caddyfile 中已包含 admin.ecex.cc 子域名配置，会自动申请 HTTPS 证书

# 5. 修改 docker-compose.prod.yml
vi docker-compose.prod.yml
# 将 YOUR_GITHUB_USERNAME/YOUR_REPO_NAME 替换为实际值

# 6. 创建必要的目录
mkdir -p caddy-data caddy-config logs

# 7. 登录 GitHub Container Registry
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# 8. 启动服务
chmod +x deploy.sh
bash deploy.sh

# 9. 验证服务
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs -f frontend

# 10. 测试访问
curl -I https://your-domain.com
```

### 第五步：验证部署

1. **测试前端访问**：
```bash
# 在浏览器访问
https://your-domain.com
```

2. **测试 API 接口**：
```bash
# 测试登录接口
curl -X POST https://your-domain.com/api/login/index \
  -H "Content-Type: application/json" \
  -d '{"account":"test","password":"123456"}'
```

3. **测试管理后台**：
```bash
# 在浏览器访问管理后台
https://admin.ecex.cc

# 或通过后端服务器内网直接测试
curl http://localhost:8097
```

4. **查看日志**：
```bash
# 后端日志
cd ~/app/backend
docker-compose -f docker-compose.prod.yml logs -f app

# 管理后台日志
docker-compose -f docker-compose.prod.yml logs -f admin

# 前端日志
cd ~/app/frontend
docker-compose -f docker-compose.prod.yml logs -f frontend
```

## 🔄 更新部署

### 更新后端

```bash
cd ~/app/backend
bash deploy.sh
```

### 更新管理后台

```bash
cd ~/app/backend
docker pull ghcr.io/ecex-hub/ecex/admin:latest
docker-compose -f docker-compose.prod.yml up -d admin
```

### 更新前端

```bash
cd ~/app/frontend
bash deploy.sh
```

## 🛠️ 常用运维命令

### 服务状态管理

```bash
cd ~/app/backend

# 查看所有服务状态
docker-compose -f docker-compose.prod.yml ps

# 查看所有容器资源占用
docker stats --no-stream

# 重启所有后端服务
docker-compose -f docker-compose.prod.yml restart

# 重启单个服务
docker-compose -f docker-compose.prod.yml restart app      # Yii2 API
docker-compose -f docker-compose.prod.yml restart admin    # 管理后台
docker-compose -f docker-compose.prod.yml restart mysql    # MySQL
docker-compose -f docker-compose.prod.yml restart redis    # Redis

# 停止/启动所有服务
docker-compose -f docker-compose.prod.yml stop
docker-compose -f docker-compose.prod.yml up -d

# 进入容器
docker exec -it yii2-app sh          # Yii2 API 容器
docker exec -it fastadmin-app sh     # 管理后台容器
docker exec -it yii2-mysql bash      # MySQL 容器
docker exec -it yii2-redis sh        # Redis 容器
```

### 📋 日志检查命令

#### Yii2 API 后端日志

```bash
# Docker 容器日志（stdout/stderr）
docker-compose -f docker-compose.prod.yml logs -f app
docker-compose -f docker-compose.prod.yml logs --tail 50 app

# Yii2 应用错误日志（记录在数据库 t_system_log 表中）
docker exec yii2-mysql mysql -uroot -p'EcEx@MySQL#2026!Prod$Secure' ecex -e "SELECT * FROM t_system_log ORDER BY id DESC LIMIT 20;"

# Yii2 请求日志
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' ecex -e "SELECT * FROM t_request_log ORDER BY id DESC LIMIT 20;"

# Nginx 访问日志
docker exec yii2-app tail -50 /var/log/nginx/access.log

# Nginx 错误日志
docker exec yii2-app tail -50 /var/log/nginx/error.log

# PHP 错误日志
docker exec yii2-app tail -50 /var/log/php_errors.log

# PHP-FPM 慢日志
docker exec yii2-app tail -50 /var/log/php-fpm-slow.log
```

#### 管理后台（FastAdmin）日志

```bash
# Docker 容器日志
docker-compose -f docker-compose.prod.yml logs -f admin
docker-compose -f docker-compose.prod.yml logs --tail 50 admin

# ThinkPHP 应用日志（按日期分目录，记录 error 和 sql）
# 查看日志目录结构
docker exec fastadmin-app ls -la /var/www/html/runtime/log/

# 查看最新日志文件
docker exec fastadmin-app find /var/www/html/runtime/log/ -name "*.log" -exec tail -30 {} \;

# 查看今天的错误日志
docker exec fastadmin-app cat /var/www/html/runtime/log/$(date +%Y%m)/$(date +%d).log 2>/dev/null

# 查看今天的 SQL 日志
docker exec fastadmin-app cat /var/www/html/runtime/log/$(date +%Y%m)/$(date +%d)_sql.log 2>/dev/null

# PHP 错误日志
docker exec fastadmin-app tail -50 /var/log/php_errors.log

# Nginx 访问日志
docker exec fastadmin-app tail -50 /var/log/nginx/admin-access.log

# Nginx 错误日志
docker exec fastadmin-app tail -50 /var/log/nginx/admin-error.log

# 宿主机上查看日志（通过 volume 映射）
ls -la ~/app/backend/admin-runtime/log/
tail -50 ~/app/backend/admin-logs/php_errors.log
tail -50 ~/app/backend/admin-logs/nginx/admin-error.log
```

#### MySQL 日志

```bash
# MySQL 容器日志
docker-compose -f docker-compose.prod.yml logs --tail 50 mysql

# MySQL 错误日志
docker exec yii2-mysql tail -50 /var/log/mysql/error.log 2>/dev/null

# 查看慢查询（如果开启）
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' -e "SHOW VARIABLES LIKE 'slow_query%';"
```

#### Redis 日志

```bash
# Redis 容器日志
docker-compose -f docker-compose.prod.yml logs --tail 50 redis

# Redis 运行信息
docker exec yii2-redis redis-cli -a '你的Redis密码' INFO server
docker exec yii2-redis redis-cli -a '你的Redis密码' INFO memory
```

#### 前端服务器日志

```bash
cd ~/app/frontend

# Caddy 容器日志
docker-compose -f docker-compose.prod.yml logs -f frontend
docker-compose -f docker-compose.prod.yml logs --tail 50 frontend

# Caddy 访问日志
docker exec ecex-frontend cat /var/log/caddy/access.log | tail -50
docker exec ecex-frontend cat /var/log/caddy/admin-access.log | tail -50
```

### 🗄️ 数据库运维

```bash
# 备份数据库
docker exec yii2-mysql mysqldump -uroot -p'你的数据库密码' ecex > backup_$(date +%Y%m%d).sql

# 备份数据库（压缩）
docker exec yii2-mysql mysqldump -uroot -p'你的数据库密码' ecex | gzip > backup_$(date +%Y%m%d).sql.gz

# 恢复数据库
docker exec -i yii2-mysql mysql -uroot -p'你的数据库密码' ecex < backup.sql

# 查看所有表
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' ecex -e "SHOW TABLES;"

# 查看表结构
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' ecex -e "DESC 表名;"

# 查看数据库大小
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' -e "
  SELECT table_schema AS '数据库',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS '大小(MB)'
  FROM information_schema.tables
  WHERE table_schema = 'ecex'
  GROUP BY table_schema;"

# 清除错误日志表
docker exec yii2-mysql mysql -uroot -p'EcEx@MySQL#2026!Prod$Secure' ecex -e "DELETE FROM t_system_log;"
docker exec yii2-mysql mysql -uroot -p'EcEx@MySQL#2026!Prod$Secure' ecex -e "DELETE FROM t_request_log;"

# 查看 MySQL 连接数
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' -e "SHOW STATUS LIKE 'Threads_connected';"
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' -e "SHOW PROCESSLIST;"
```

### 🧹 日志清理

```bash
# 清理 ThinkPHP 应用日志
docker exec fastadmin-app rm -rf /var/www/html/runtime/log/*

# 清理 ThinkPHP 缓存
docker exec fastadmin-app rm -rf /var/www/html/runtime/cache/*
docker exec fastadmin-app rm -rf /var/www/html/runtime/temp/*

# 清理 Yii2 应用日志
docker exec yii2-app sh -c "rm -rf /var/www/html/backend/runtime/logs/*"

# 清理 Nginx 日志
docker exec fastadmin-app sh -c "echo '' > /var/log/nginx/admin-access.log"
docker exec fastadmin-app sh -c "echo '' > /var/log/nginx/admin-error.log"
docker exec yii2-app sh -c "echo '' > /var/log/nginx/access.log"
docker exec yii2-app sh -c "echo '' > /var/log/nginx/error.log"

# 清理 PHP 错误日志
docker exec fastadmin-app sh -c "echo '' > /var/log/php_errors.log"
docker exec yii2-app sh -c "echo '' > /var/log/php_errors.log"

# 清理 Docker 日志（宿主机执行）
sudo truncate -s 0 $(docker inspect --format='{{.LogPath}}' fastadmin-app)
sudo truncate -s 0 $(docker inspect --format='{{.LogPath}}' yii2-app)
```

### 🔄 镜像更新部署

```bash
cd ~/app/backend

# 更新 Yii2 API
docker pull ghcr.io/ecex-hub/ecex/backend:latest
docker-compose -f docker-compose.prod.yml up -d app

# 更新管理后台
docker pull ghcr.io/ecex-hub/ecex/admin:latest
docker-compose -f docker-compose.prod.yml up -d admin

# 清理旧镜像
docker image prune -f
```

### 前端服务器

```bash
cd ~/app/frontend

# 查看服务状态
docker-compose -f docker-compose.prod.yml ps

# 查看日志
docker-compose -f docker-compose.prod.yml logs -f frontend

# 重启服务
docker-compose -f docker-compose.prod.yml restart frontend

# 重新加载 Caddyfile（无需重启）
docker-compose -f docker-compose.prod.yml exec frontend caddy reload --config /etc/caddy/Caddyfile

# 查看证书状态
docker-compose -f docker-compose.prod.yml exec frontend caddy list-certificates

# 更新前端镜像
docker pull ghcr.io/ecex-hub/ecex/frontend:latest
docker-compose -f docker-compose.prod.yml up -d frontend
```

### 🔍 故障排查快速命令

```bash
# 一键检查所有服务健康状态
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 检查端口监听
ss -tlnp | grep -E '8080|8097|3306|6379'

# 检查磁盘空间
df -h
docker system df

# 检查内存使用
free -h

# 测试 Yii2 API 是否正常
curl -I http://localhost:8080

# 测试管理后台是否正常
curl -I http://localhost:8097/stock.php

# 测试 MySQL 连接
docker exec yii2-mysql mysql -uroot -p'你的数据库密码' -e "SELECT 1;"

# 测试 Redis 连接
docker exec yii2-redis redis-cli -a '你的Redis密码' PING
```

## 🔒 安全加固建议

### 1. 防火墙配置

```bash
# 后端服务器 - 只允许前端服务器访问
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="前端服务器内网IP" port protocol="tcp" port="8080" accept'
sudo firewall-cmd --reload

# 前端服务器 - 只开放 80 和 443
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 2. 定期备份

```bash
# 创建备份脚本
cat > ~/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# 备份数据库
docker exec yii2-mysql mysqldump -uroot -p${DB_PASSWORD} ecex | gzip > $BACKUP_DIR/db_$DATE.sql.gz

# 备份上传文件
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz ~/app/backend/uploads

# 删除 7 天前的备份
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "备份完成: $DATE"
EOF

chmod +x ~/backup.sh

# 添加定时任务（每天凌晨 2 点备份）
crontab -e
# 添加：0 2 * * * /root/backup.sh >> /var/log/backup.log 2>&1
```

### 3. 监控告警

```bash
# 安装监控工具
sudo yum install -y sysstat htop

# 查看系统资源
htop
docker stats
```

## ❓ 常见问题

### 1. 无法拉取 GitHub 镜像

**问题**: `Error response from daemon: pull access denied`

**解决**:
```bash
# 确保 Token 有正确权限
# 重新登录
docker logout ghcr.io
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

### 2. Caddy 无法获取 HTTPS 证书

**问题**: `acme: error: 403`

**解决**:
- 确保域名已正确解析到服务器公网 IP
- 确保 80 和 443 端口已开放
- 检查域名是否已备案

### 3. 前端无法访问后端 API

**问题**: `502 Bad Gateway`

**解决**:
```bash
# 1. 检查后端服务是否正常
curl http://后端内网IP:8080

# 2. 检查 Caddyfile 配置是否正确
cat ~/app/frontend/Caddyfile

# 3. 查看 Caddy 日志
docker-compose -f docker-compose.prod.yml logs frontend
```

### 4. 数据库连接失败

**问题**: `SQLSTATE[HY000] [2002] Connection refused`

**解决**:
```bash
# 检查 MySQL 是否启动
docker-compose -f docker-compose.prod.yml ps mysql

# 查看 MySQL 日志
docker-compose -f docker-compose.prod.yml logs mysql

# 进入容器测试连接
docker exec -it yii2-app sh
php -r "new PDO('mysql:host=mysql;dbname=ecex', 'root', 'password');"
```

### 5. 管理后台访问异常

**问题**: `admin.ecex.cc` 无法访问或显示 502

**解决**:
```bash
# 1. 检查 admin 容器是否运行
cd ~/app/backend
docker ps | grep fastadmin

# 2. 检查 admin 容器日志
docker-compose -f docker-compose.prod.yml logs admin

# 3. 确认后端内网 8097 端口可访问
curl http://localhost:8097

# 4. 检查 DNS 解析是否生效
nslookup admin.ecex.cc

# 5. 检查前端 Caddyfile 是否包含 admin.ecex.cc 配置
cat ~/app/frontend/Caddyfile | grep -A 5 "admin.ecex.cc"
```

## 📞 技术支持

如有问题，请检查：
1. 服务器日志
2. Docker 容器状态
3. 网络连接
4. 配置文件

---

**部署完成后，请务必：**
- ✅ 修改所有默认密码
- ✅ 配置定期备份
- ✅ 启用监控告警
- ✅ 定期更新系统和 Docker 镜像

