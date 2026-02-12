# 快速开始指南

## 本地开发环境搭建

### 前端开发

```bash
cd vue

# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 访问 http://localhost:3000
```

### 后端开发

```bash
cd server

# 安装依赖
composer install

# 初始化环境
php init

# 配置数据库
# 编辑 common/config/main-local.php

# 运行迁移
php yii migrate

# 启动PHP内置服务器（仅用于开发）
cd backend/web
php -S localhost:8080
```

---

## Docker本地测试

### 后端测试

```bash
cd server

# 配置环境变量
cp .env.example .env
# 编辑 .env 文件

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 访问 http://localhost:8080
```

### 前端测试

```bash
cd vue

# 配置API地址
cp .env.example .env
# 编辑 .env 文件，设置 VITE_API_BASE_URL=http://localhost:8080

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 访问 http://localhost
```

---

## 推送到GitHub

### 1. 创建GitHub仓库

访问 https://github.com/new 创建新仓库

### 2. 推送代码

```bash
# 初始化Git（如果还没有）
git init

# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit with Docker support"

# 推送到GitHub
git push -u origin main
```

### 3. 验证GitHub Actions

1. 访问仓库的 Actions 标签页
2. 查看工作流运行状态
3. 等待构建完成
4. 访问 Packages 查看生成的Docker镜像

---

## 生产环境部署

详细部署步骤请参考 [DEPLOYMENT.md](./DEPLOYMENT.md)

### 快速部署步骤

**后端服务器：**
```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO/server

# 2. 配置环境
cp .env.example .env
nano .env  # 修改数据库密码等配置

# 3. 启动服务
docker-compose up -d

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

# 3. 启动服务
docker-compose up -d
```

---

## 常见问题

### Q: 前端无法连接后端？
A: 检查 `vue/.env` 中的 `VITE_API_BASE_URL` 是否正确设置为后端服务器地址。

### Q: Docker构建失败？
A: 检查Docker和Docker Compose版本，确保满足最低要求。

### Q: 数据库连接失败？
A: 检查 `server/.env` 中的数据库配置是否正确。

### Q: GitHub Actions构建失败？
A: 查看Actions日志，通常是依赖安装或构建命令问题。

---

更多详细信息请参考 [DEPLOYMENT.md](./DEPLOYMENT.md)

