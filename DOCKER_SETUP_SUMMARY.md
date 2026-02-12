# Docker 容器化部署配置总结

## ✅ 已完成的工作

### 1. 后端Docker配置 (server/)

#### 创建的文件：
- ✅ `Dockerfile` - 后端容器镜像配置
  - 基于 PHP 7.4-FPM
  - 包含 Nginx + PHP-FPM + Supervisor
  - 自动安装依赖和初始化环境
  
- ✅ `docker-compose.yml` - 本地开发环境编排
  - Backend服务 (Yii2)
  - MySQL 8.0
  - Redis 7
  
- ✅ `docker-compose.prod.yml` - 生产环境编排
  - 使用GitHub Container Registry镜像
  
- ✅ `docker/nginx/backend.conf` - Nginx配置
  - PHP路由配置
  - 静态资源缓存
  
- ✅ `docker/supervisor/supervisord.conf` - 进程管理
  - 管理Nginx和PHP-FPM进程
  
- ✅ `.env` - 环境变量配置
- ✅ `.env.example` - 环境变量示例
- ✅ `.dockerignore` - Docker构建忽略文件
- ✅ `deploy.sh` - 部署脚本

#### 修改的文件：
- ✅ `environments/prod/common/config/main-local.php` - 支持环境变量

### 2. 前端Docker配置 (vue/)

#### 创建的文件：
- ✅ `Dockerfile` - 前端容器镜像配置
  - 多阶段构建（构建阶段 + 生产阶段）
  - 基于 Node 18 构建，Nginx Alpine运行
  
- ✅ `docker-compose.yml` - 本地开发环境编排
- ✅ `docker-compose.prod.yml` - 生产环境编排
- ✅ `docker/nginx/frontend.conf` - Nginx配置
  - Vue Router支持
  - Gzip压缩
  - 静态资源缓存
  
- ✅ `.env` - 环境变量配置
- ✅ `.env.example` - 环境变量示例
- ✅ `.env.production` - 生产环境配置
- ✅ `.dockerignore` - Docker构建忽略文件
- ✅ `deploy.sh` - 部署脚本

### 3. GitHub Actions CI/CD (.github/workflows/)

#### 创建的文件：
- ✅ `backend-docker.yml` - 后端镜像自动构建
  - 监听server/目录变化
  - 自动构建并推送到GHCR
  
- ✅ `frontend-docker.yml` - 前端镜像自动构建
  - 监听vue/目录变化
  - 自动构建并推送到GHCR

### 4. 文档 (根目录)

#### 创建的文件：
- ✅ `README.md` - 项目总览
- ✅ `QUICKSTART.md` - 快速开始指南
- ✅ `DEPLOYMENT.md` - 详细部署文档
- ✅ `ARCHITECTURE.md` - 系统架构文档
- ✅ `.gitignore` - Git忽略配置

## 📋 部署架构

```
前端服务器 (公网)          后端服务器 (内网)
┌─────────────┐           ┌─────────────┐
│   Nginx     │           │   Nginx     │
│   Port 80   │◄─────────►│  Port 8080  │
│             │  内网通信  │             │
│   Vue3      │           │   Yii2      │
│   静态文件   │           │   PHP-FPM   │
└─────────────┘           │             │
                          │   MySQL     │
                          │   Redis     │
                          └─────────────┘
```

## 🚀 使用方法

### 本地开发测试

**后端：**
```bash
cd server
cp .env.example .env
# 编辑 .env 配置数据库密码
docker-compose up -d
```

**前端：**
```bash
cd vue
cp .env.example .env
# 编辑 .env 配置后端API地址
docker-compose up -d
```

### 推送到GitHub

```bash
git add .
git commit -m "Add Docker support"
git push origin main
```

GitHub Actions会自动构建镜像并推送到：
- `ghcr.io/YOUR_USERNAME/YOUR_REPO/backend:latest`
- `ghcr.io/YOUR_USERNAME/YOUR_REPO/frontend:latest`

### 生产环境部署

**后端服务器：**
```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO/server

# 2. 配置环境
cp .env.example .env
nano .env  # 修改数据库密码

# 3. 部署
chmod +x deploy.sh
./deploy.sh prod

# 4. 查看内网IP
hostname -I
```

**前端服务器：**
```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO/vue

# 2. 配置后端地址
cp .env.example .env
nano .env  # 设置后端内网IP

# 3. 部署
chmod +x deploy.sh
./deploy.sh prod
```

## 🔑 关键配置

### 后端环境变量 (server/.env)
```env
DB_HOST=mysql
DB_PORT=3306
DB_NAME=stock
DB_USER=root
DB_PASSWORD=YOUR_SECURE_PASSWORD  # 必须修改

REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DATABASE=0
```

### 前端环境变量 (vue/.env)
```env
# 后端API地址（使用后端服务器内网IP）
VITE_API_BASE_URL=http://10.0.0.2:8080
```

## 🔒 安全建议

1. **修改默认密码**
   - MySQL root密码
   - 使用强密码（至少16位，包含大小写字母、数字、特殊字符）

2. **防火墙配置**
   ```bash
   # 后端服务器：只允许前端服务器访问
   sudo ufw allow from FRONTEND_IP to any port 8080
   
   # 前端服务器：允许公网访问
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp  # 如果使用HTTPS
   ```

3. **HTTPS配置**（推荐）
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d your-domain.com
   ```

4. **定期备份**
   ```bash
   # 备份数据库
   docker-compose exec mysql mysqldump -uroot -p stock > backup.sql
   ```

## 📊 监控和维护

### 查看服务状态
```bash
docker-compose ps
docker-compose logs -f
```

### 更新部署
```bash
git pull origin main
./deploy.sh prod
```

### 资源监控
```bash
docker stats
df -h
```

## 🐛 故障排查

### 后端无法连接数据库
```bash
docker-compose logs mysql
docker-compose exec backend env | grep DB_
```

### 前端无法访问后端
```bash
# 从前端服务器测试
curl http://BACKEND_INTERNAL_IP:8080
ping BACKEND_INTERNAL_IP
```

### 容器启动失败
```bash
docker-compose logs backend
docker-compose logs frontend
```

## 📚 相关文档

- [README.md](./README.md) - 项目总览
- [QUICKSTART.md](./QUICKSTART.md) - 快速开始
- [DEPLOYMENT.md](./DEPLOYMENT.md) - 详细部署步骤
- [ARCHITECTURE.md](./ARCHITECTURE.md) - 系统架构

## ✨ 特性

- ✅ 前后端完全分离
- ✅ Docker容器化部署
- ✅ 支持内网通信
- ✅ GitHub Actions自动构建
- ✅ 一键部署脚本
- ✅ 完整的文档
- ✅ 安全配置建议
- ✅ 环境变量管理
- ✅ 多阶段构建优化
- ✅ 日志管理
- ✅ 数据持久化

## 🎯 下一步

1. **推送代码到GitHub**
   ```bash
   git add .
   git commit -m "Add Docker containerization support"
   git push origin main
   ```

2. **配置GitHub Secrets**（如果需要私有仓库）
   - 访问仓库设置 → Secrets and variables → Actions
   - 添加必要的密钥

3. **准备服务器**
   - 安装Docker和Docker Compose
   - 配置网络和防火墙
   - 获取服务器IP地址

4. **执行部署**
   - 按照DEPLOYMENT.md步骤操作
   - 验证服务正常运行

---

**配置完成！** 🎉

现在你可以：
1. 推送代码到GitHub仓库
2. GitHub Actions自动构建Docker镜像
3. 服务器拉取镜像并部署
4. 前后端通过内网通信

如有问题，请参考详细文档或提交Issue。

