# Docker 部署指南

本项目采用前后端分离架构，使用Docker容器化部署，前后端部署在不同服务器上，通过内网通信。

## 架构说明

```
┌─────────────────┐         内网          ┌─────────────────┐
│   前端服务器     │ ◄──────────────────► │   后端服务器     │
│  (Vue3 + Caddy) │   HTTP API 调用      │ (Yii2 + MySQL)  │
│   Port: 80/443  │                      │   Port: 8080    │
└─────────────────┘                      └─────────────────┘
        │                                         │
        │                                         │
    公网访问                                  内网访问
```

## 前置要求

### 两台服务器都需要安装：
- Docker (>= 20.10)
- Docker Compose (>= 2.0)
- Git

### 网络要求：
- 前端服务器：需要公网IP，开放80端口
- 后端服务器：只需内网IP，开放8080端口给前端服务器
- 两台服务器需要在同一内网或通过VPN互通

## 一、后端服务器部署

### 1. 克隆代码仓库

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO/server
```

### 2. 配置环境变量

```bash
cp .env.example .env
nano .env
```

修改以下配置：
```env
# 数据库配置
DB_HOST=mysql
DB_PORT=3306
DB_NAME=stock
DB_USER=root
DB_PASSWORD=YOUR_SECURE_PASSWORD  # 修改为强密码

# Redis配置
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DATABASE=0
```

### 3. 启动服务

```bash
# 构建并启动所有服务（后端、MySQL、Redis）
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f backend
```

### 4. 初始化数据库

```bash
# 进入后端容器
docker-compose exec backend bash

# 运行数据库迁移（如果有）
php yii migrate

# 退出容器
exit
```

### 5. 验证后端服务

```bash
# 测试后端API是否正常
curl http://localhost:8080

# 或从前端服务器测试（替换为后端服务器内网IP）
curl http://BACKEND_INTERNAL_IP:8080
```

### 6. 获取后端服务器内网IP

```bash
# 查看内网IP地址
ip addr show
# 或
hostname -I
```

记录下内网IP，例如：`10.0.0.2`，后续前端配置需要使用。

---

## 二、前端服务器部署

### 1. 克隆代码仓库

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO/vue
```

### 2. 配置后端API地址

```bash
cp .env.example .env
nano .env
```

修改为后端服务器的内网地址：
```env
# 后端API地址（使用后端服务器的内网IP）
VITE_API_BASE_URL=http://10.0.0.2:8080
```

**重要**：这里必须使用后端服务器的内网IP地址！

### 3. 构建并启动前端服务

```bash
# 构建并启动前端服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f frontend
```

### 4. 验证前端服务

```bash
# 本地测试
curl http://localhost

# 从外网访问（替换为前端服务器公网IP）
curl http://YOUR_PUBLIC_IP
```

---

## 三、从GitHub拉取镜像部署（推荐）

### 前提条件
1. 代码已推送到GitHub
2. GitHub Actions已自动构建镜像
3. 服务器已登录GitHub Container Registry

### 1. 登录GitHub Container Registry

```bash
# 创建GitHub Personal Access Token (需要read:packages权限)
# 访问: https://github.com/settings/tokens

# 登录
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

### 2. 后端服务器部署

创建 `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  frontend:
    image: ghcr.io/YOUR_USERNAME/YOUR_REPO/frontend:latest
    container_name: ecex-frontend
    restart: unless-stopped
    ports:
      - "80:80"
    networks:
      - ecex-network

networks:
  ecex-network:
    driver: bridge
```

启动服务：
```bash
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

---

## 四、更新部署

### 后端更新

```bash
cd YOUR_REPO/server

# 拉取最新代码
git pull origin main

# 重新构建并启动
docker-compose down
docker-compose up -d --build

# 或使用GitHub镜像
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

### 前端更新

```bash
cd YOUR_REPO/vue

# 拉取最新代码
git pull origin main

# 重新构建并启动
docker-compose down
docker-compose up -d --build

# 或使用GitHub镜像
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

---

## 五、常用命令

### 查看服务状态
```bash
docker-compose ps
```

### 查看日志
```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f backend
docker-compose logs -f frontend
```

### 重启服务
```bash
# 重启所有服务
docker-compose restart

# 重启特定服务
docker-compose restart backend
```

### 停止服务
```bash
# 停止所有服务
docker-compose down

# 停止并删除数据卷（危险操作！）
docker-compose down -v
```

### 进入容器
```bash
# 进入后端容器
docker-compose exec backend bash

# 进入前端容器
docker-compose exec frontend sh

# 进入MySQL容器
docker-compose exec mysql mysql -uroot -p
```

---

## 六、安全建议

### 1. 防火墙配置

**后端服务器：**
```bash
# 只允许前端服务器访问8080端口
sudo ufw allow from FRONTEND_INTERNAL_IP to any port 8080
sudo ufw enable
```

**前端服务器：**
```bash
# 允许公网访问80端口
sudo ufw allow 80/tcp
sudo ufw enable
```

### 2. 修改默认密码
- 修改MySQL root密码
- 修改Redis密码（如需要）
- 使用强密码策略

### 3. 启用HTTPS（推荐）
```bash
# Caddy会自动申请和续期SSL证书，无需手动配置！
# 只需在Caddyfile中使用域名即可：

# 编辑 vue/docker/caddy/Caddyfile
your-domain.com {
    root * /srv
    file_server
    encode gzip
    try_files {path} /index.html
}

# 编辑 server/docker/caddy/Caddyfile
api.your-domain.com {
    root * /var/www/html/backend/web
    php_fastcgi localhost:9000
    file_server
    encode gzip
}

# 重新构建并启动，Caddy会自动申请Let's Encrypt证书
docker-compose up -d --build
```

### 4. 定期备份
```bash
# 备份MySQL数据
docker-compose exec mysql mysqldump -uroot -p stock > backup_$(date +%Y%m%d).sql

# 备份整个数据卷
docker run --rm -v ecex_mysql-data:/data -v $(pwd):/backup alpine tar czf /backup/mysql-backup.tar.gz /data
```

---

## 七、故障排查

### 1. 后端无法连接数据库
```bash
# 检查MySQL是否运行
docker-compose ps mysql

# 查看MySQL日志
docker-compose logs mysql

# 检查环境变量
docker-compose exec backend env | grep DB_
```

### 2. 前端无法访问后端API
```bash
# 从前端服务器测试后端连接
curl http://BACKEND_INTERNAL_IP:8080

# 检查网络连通性
ping BACKEND_INTERNAL_IP

# 检查防火墙规则
sudo ufw status
```

### 3. 容器启动失败
```bash
# 查看详细错误信息
docker-compose logs backend

# 检查端口占用
sudo netstat -tulpn | grep :8080
```

---

## 八、监控和维护

### 1. 资源监控
```bash
# 查看容器资源使用情况
docker stats

# 查看磁盘使用
df -h
docker system df
```

### 2. 日志管理
```bash
# 清理旧日志
docker-compose logs --tail=100 backend > backend.log
truncate -s 0 $(docker inspect --format='{{.LogPath}}' ecex-backend)
```

### 3. 定期清理
```bash
# 清理未使用的镜像
docker image prune -a

# 清理未使用的容器
docker container prune

# 清理未使用的卷
docker volume prune
```

---

## 九、联系支持

如遇到问题，请提供以下信息：
1. 服务器系统版本：`cat /etc/os-release`
2. Docker版本：`docker --version`
3. 错误日志：`docker-compose logs`
4. 网络配置：`ip addr show`

---

## 附录：完整部署检查清单

### 后端服务器
- [ ] 安装Docker和Docker Compose
- [ ] 克隆代码仓库
- [ ] 配置.env文件
- [ ] 启动docker-compose
- [ ] 初始化数据库
- [ ] 验证API可访问
- [ ] 记录内网IP地址
- [ ] 配置防火墙规则

### 前端服务器
- [ ] 安装Docker和Docker Compose
- [ ] 克隆代码仓库
- [ ] 配置后端API地址（内网IP）
- [ ] 启动docker-compose
- [ ] 验证前端可访问
- [ ] 配置防火墙规则
- [ ] （可选）配置HTTPS

### GitHub配置
- [ ] 推送代码到GitHub
- [ ] 验证GitHub Actions运行成功
- [ ] 检查镜像已推送到GHCR
- [ ] 配置Personal Access Token
- [ ] 服务器登录GHCR

---

**部署完成！** 🎉

---

## 三、从GitHub拉取镜像部署（推荐）

### 前提条件
1. 代码已推送到GitHub
2. GitHub Actions已自动构建镜像
3. 服务器已登录GitHub Container Registry

### 1. 登录GitHub Container Registry

```bash
# 创建GitHub Personal Access Token (需要read:packages权限)
# 访问: https://github.com/settings/tokens

# 登录
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

### 2. 后端服务器部署

创建 `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  backend:
    image: ghcr.io/YOUR_USERNAME/YOUR_REPO/backend:latest
    container_name: ecex-backend
    restart: unless-stopped
    ports:
      - "8080:80"
    env_file:
      - .env
    networks:
      - ecex-network
    depends_on:
      - mysql
      - redis

  mysql:
    image: mysql:8.0
    container_name: ecex-mysql
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - ecex-network

  redis:
    image: redis:7-alpine
    container_name: ecex-redis
    restart: unless-stopped
    volumes:
      - redis-data:/data
    networks:
      - ecex-network

networks:
  ecex-network:
    driver: bridge

volumes:
  mysql-data:
  redis-data:
```

启动服务：
```bash
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

