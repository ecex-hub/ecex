# ECEX 项目

基于 Vue3 + Yii2 的前后端分离移动端应用，支持Docker容器化部署。

## 📋 项目简介

这是一个完整的前后端分离项目，包含：
- **前端**：Vue 3 + Vite + Vant 移动端应用
- **后端**：Yii2 PHP框架 RESTful API
- **数据库**：MySQL 8.0
- **缓存**：Redis 7

## 🏗️ 架构设计

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

## 🚀 快速开始

### 📚 新手入门

**第一次使用GitHub？** 查看完整教程：
- 📖 [GitHub仓库创建教程](./GITHUB_SETUP_GUIDE.md) - 从零开始创建仓库并推送镜像
- 🚀 [快速参考卡片](./QUICK_REFERENCE.md) - 常用命令速查
- 🤖 [自动化脚本](./setup-github.ps1) - 一键完成GitHub配置

### 本地开发

查看 [QUICKSTART.md](./QUICKSTART.md) 了解如何在本地运行项目。

### 生产部署

查看 [DEPLOYMENT.md](./DEPLOYMENT.md) 了解完整的生产环境部署流程。

## 📦 项目结构

```
ecex/
├── vue/                    # 前端项目
│   ├── src/               # 源代码
│   ├── Dockerfile         # 前端Docker配置
│   ├── docker-compose.yml # 前端编排文件
│   └── package.json       # 依赖配置
│
├── server/                # 后端项目
│   ├── backend/          # 后端应用
│   ├── common/           # 公共代码
│   ├── Dockerfile        # 后端Docker配置
│   ├── docker-compose.yml # 后端编排文件
│   └── composer.json     # 依赖配置
│
├── .github/              # GitHub Actions配置
│   └── workflows/        # CI/CD工作流
│       ├── backend-docker.yml  # 后端镜像构建
│       └── frontend-docker.yml # 前端镜像构建
│
├── DEPLOYMENT.md         # 部署文档
├── QUICKSTART.md         # 快速开始指南
└── README.md            # 项目说明
```

## 🛠️ 技术栈

### 前端
- Vue 3 - 渐进式JavaScript框架
- Vite - 下一代前端构建工具
- Vant - 移动端UI组件库
- Vue Router - 路由管理
- Pinia - 状态管理
- Axios - HTTP客户端

### 后端
- Yii2 - PHP框架
- MySQL 8.0 - 关系型数据库
- Redis 7 - 缓存数据库
- JWT - 身份认证

### DevOps
- Docker - 容器化
- Docker Compose - 容器编排
- GitHub Actions - CI/CD
- Caddy - Web服务器（自动HTTPS）

## 📝 功能模块

- ✅ 用户认证（登录/注册）
- ✅ 身份认证/实名认证
- ✅ 充值/提现
- ✅ 团队管理
- ✅ 积分商城
- ✅ 新闻资讯
- ✅ 个人中心

## 🔧 环境要求

### 开发环境
- Node.js >= 18
- PHP >= 7.4
- Composer >= 2.0
- MySQL >= 8.0
- Redis >= 7.0

### 生产环境
- Docker >= 20.10
- Docker Compose >= 2.0
- 两台服务器（前端+后端）
- 内网互通

## 📖 文档

- [快速开始指南](./QUICKSTART.md) - 本地开发和测试
- [部署文档](./DEPLOYMENT.md) - 生产环境部署详细步骤
- [前端README](./vue/README.md) - 前端项目说明

## 🔐 安全建议

1. **修改默认密码**：部署前务必修改所有默认密码
2. **使用HTTPS**：生产环境建议配置SSL证书
3. **防火墙配置**：限制端口访问，只允许必要的连接
4. **定期备份**：定期备份数据库和重要数据
5. **环境变量**：不要将 `.env` 文件提交到Git仓库

## 🚢 部署流程

### 1. 推送代码到GitHub
```bash
git add .
git commit -m "Your commit message"
git push origin main
```

### 2. GitHub Actions自动构建
- 自动构建Docker镜像
- 推送到GitHub Container Registry

### 3. 服务器拉取镜像
```bash
# 后端服务器
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d

# 前端服务器
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

MIT License

## 📧 联系方式

如有问题，请提交Issue或联系项目维护者。

---

**开始使用：** 查看 [QUICKSTART.md](./QUICKSTART.md)

**生产部署：** 查看 [DEPLOYMENT.md](./DEPLOYMENT.md)

