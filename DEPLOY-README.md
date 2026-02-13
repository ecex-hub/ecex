# 生产环境部署方案

## 📁 项目结构

```
ecex/
├── server/                          # 后端代码
│   ├── Dockerfile                   # 后端 Docker 镜像构建文件
│   ├── docker-compose.yml           # 本地开发环境
│   ├── .dockerignore                # Docker 构建忽略文件
│   ├── .env.production.example      # 生产环境变量模板
│   └── docker/                      # Docker 配置文件
│       ├── nginx/                   # Nginx 配置
│       │   ├── nginx.conf
│       │   └── default.conf
│       ├── php/                     # PHP 配置
│       │   ├── php.ini
│       │   └── www.conf
│       └── supervisor/              # 进程管理
│           └── supervisord.conf
│
├── vue/                             # 前端代码
│   ├── Dockerfile                   # 前端 Docker 镜像构建文件
│   ├── Caddyfile                    # Caddy 配置（反向代理 + HTTPS）
│   ├── .dockerignore                # Docker 构建忽略文件
│   └── .env.production.example      # 生产环境变量模板
│
├── deploy/                          # 部署脚本和配置
│   ├── init-server.sh               # 服务器初始化脚本
│   ├── monitor.sh                   # 服务监控脚本
│   ├── backend/                     # 后端部署配置
│   │   ├── docker-compose.prod.yml  # 生产环境 Docker Compose
│   │   ├── .env.example             # 环境变量模板
│   │   ├── deploy.sh                # 部署脚本
│   │   ├── init-database.sh         # 数据库初始化脚本
│   │   ├── backup.sh                # 备份脚本
│   │   └── restore.sh               # 恢复脚本
│   └── frontend/                    # 前端部署配置
│       ├── docker-compose.prod.yml  # 生产环境 Docker Compose
│       ├── .env.example             # 环境变量模板
│       ├── Caddyfile.example        # Caddy 配置模板
│       └── deploy.sh                # 部署脚本
│
├── .github/workflows/               # GitHub Actions CI/CD
│   ├── backend.yml                  # 后端镜像构建和推送
│   └── frontend.yml                 # 前端镜像构建和推送
│
├── DEPLOYMENT.md                    # 详细部署文档
├── QUICK-START.md                   # 快速开始指南
└── DEPLOY-README.md                 # 本文件
```

## 🏗️ 架构设计

### 技术栈

**后端服务器**:
- Docker + Docker Compose
- PHP 7.4-FPM
- Nginx
- MySQL 5.7
- Redis 6
- Supervisor（进程管理）

**前端服务器**:
- Docker + Docker Compose
- Caddy 2（Web 服务器 + 反向代理 + 自动 HTTPS）
- Vue 3 构建产物

### 部署架构

```
┌─────────────────────────────────────────────────────────────┐
│                         互联网                               │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTPS (443)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  前端服务器（公网）                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Caddy (Docker)                                       │   │
│  │  ├─ 自动 HTTPS (Let's Encrypt)                        │   │
│  │  ├─ 静态文件服务 (Vue 构建产物)                        │   │
│  │  └─ API 反向代理 → http://后端内网IP:8080             │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │ 内网
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  后端服务器（内网）                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  应用容器 (Docker)                                     │   │
│  │  ├─ Nginx (监听 80)                                   │   │
│  │  ├─ PHP-FPM 7.4                                       │   │
│  │  └─ Supervisor (进程管理)                             │   │
│  ├──────────────────────────────────────────────────────┤   │
│  │  MySQL 5.7 (Docker)                                   │   │
│  │  └─ 数据持久化到宿主机                                 │   │
│  ├──────────────────────────────────────────────────────┤   │
│  │  Redis 6 (Docker)                                     │   │
│  │  └─ 数据持久化到宿主机                                 │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 部署流程

### 1. CI/CD 流程

```
开发者推送代码到 GitHub
         ↓
GitHub Actions 自动触发
         ↓
    构建 Docker 镜像
         ↓
推送到 GitHub Container Registry
         ↓
   服务器拉取最新镜像
         ↓
      重启容器
```

### 2. 部署步骤概览

1. **准备阶段**
   - 准备两台阿里云服务器
   - 准备域名并完成备案
   - 创建 GitHub 仓库和 Token

2. **初始化服务器**
   - 运行 `init-server.sh` 安装 Docker

3. **推送代码**
   - 推送代码到 GitHub
   - GitHub Actions 自动构建镜像

4. **部署后端**
   - 配置环境变量
   - 运行 `deploy.sh`
   - 初始化数据库

5. **部署前端**
   - 配置 Caddyfile（域名、后端地址）
   - 运行 `deploy.sh`

6. **验证部署**
   - 访问域名测试

## 📚 文档说明

### 快速开始
👉 [QUICK-START.md](QUICK-START.md) - 5 步快速部署指南

### 详细文档
👉 [DEPLOYMENT.md](DEPLOYMENT.md) - 完整部署文档，包含：
- 详细的部署步骤
- 配置说明
- 运维命令
- 安全加固
- 故障排查

## 🔧 核心配置文件说明

### 后端配置

**Dockerfile** (`server/Dockerfile`)
- 基于 `php:7.4-fpm-alpine`
- 安装所有必需的 PHP 扩展
- 集成 Nginx + PHP-FPM + Supervisor

**docker-compose.prod.yml** (`deploy/backend/docker-compose.prod.yml`)
- 定义 3 个服务：app、mysql、redis
- 使用 GitHub Container Registry 镜像
- 数据持久化配置

### 前端配置

**Dockerfile** (`vue/Dockerfile`)
- 多阶段构建：Node.js 构建 + Caddy 服务
- 自动优化构建产物

**Caddyfile** (`vue/Caddyfile`)
- 自动 HTTPS（Let's Encrypt）
- 反向代理到后端
- 安全头配置
- 静态资源缓存

## 🛠️ 运维工具

### 部署脚本
- `deploy.sh` - 一键部署/更新
- `init-database.sh` - 数据库初始化
- `backup.sh` - 数据备份
- `restore.sh` - 数据恢复
- `monitor.sh` - 服务监控

### 常用命令

```bash
# 查看服务状态
docker-compose -f docker-compose.prod.yml ps

# 查看日志
docker-compose -f docker-compose.prod.yml logs -f

# 重启服务
docker-compose -f docker-compose.prod.yml restart

# 更新服务
bash deploy.sh

# 备份数据
bash backup.sh

# 监控服务
bash monitor.sh
```

## 🔒 安全特性

1. **网络隔离**
   - 后端服务器仅内网访问
   - 前端通过内网反向代理访问后端

2. **HTTPS 加密**
   - Caddy 自动申请和续期 Let's Encrypt 证书
   - 强制 HTTPS 访问

3. **容器隔离**
   - 每个服务运行在独立容器中
   - 使用 Docker 网络隔离

4. **数据持久化**
   - 数据库和上传文件持久化到宿主机
   - 定期自动备份

5. **安全头**
   - HSTS、XSS Protection、CSP 等安全头

## 📊 监控和日志

### 日志位置

**后端**:
- 应用日志: `~/app/backend/logs/`
- Nginx 日志: 容器内 `/var/log/nginx/`
- PHP 日志: 容器内 `/var/log/php-fpm-*.log`

**前端**:
- Caddy 日志: `~/app/frontend/logs/`

### 监控

运行监控脚本查看系统状态：
```bash
bash deploy/monitor.sh
```

## 🆘 故障排查

### 常见问题

1. **无法拉取镜像** → 检查 GitHub Token 权限
2. **HTTPS 证书失败** → 检查域名解析和端口开放
3. **API 502 错误** → 检查后端服务和网络连接
4. **数据库连接失败** → 检查 MySQL 容器状态

详细故障排查请参考 [DEPLOYMENT.md](DEPLOYMENT.md)。

## 📞 技术支持

遇到问题请：
1. 查看详细文档: [DEPLOYMENT.md](DEPLOYMENT.md)
2. 检查服务日志
3. 运行监控脚本诊断

---

**开始部署**: 请阅读 [QUICK-START.md](QUICK-START.md)

