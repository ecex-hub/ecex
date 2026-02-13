# 部署检查清单

使用此清单确保部署过程中不遗漏任何重要步骤。

## 📋 部署前准备

### 服务器准备
- [ ] 已购买两台阿里云服务器（Alibaba Cloud Linux 3.2104 LTS 64位）
- [ ] 前端服务器配置：2核4G 或以上，5M 带宽，有公网 IP
- [ ] 后端服务器配置：4核8G 或以上，1M 带宽
- [ ] 两台服务器在同一 VPC 内网
- [ ] 已记录后端服务器内网 IP 地址：`___________________`

### 域名准备
- [ ] 已购买域名：`___________________`
- [ ] 域名已完成 ICP 备案
- [ ] 域名 A 记录已解析到前端服务器公网 IP
- [ ] DNS 解析已生效（可用 `ping` 测试）

### GitHub 准备
- [ ] 已创建 GitHub 仓库：`https://github.com/___________/___________`
- [ ] 已生成 Personal Access Token（需要 `write:packages` 权限）
- [ ] Token 已保存：`ghp_____________________________`

### 安全组配置
- [ ] 前端服务器安全组已开放：80、443 端口
- [ ] 后端服务器安全组已开放：8080 端口（仅内网）
- [ ] 已禁用不必要的端口

## 🔧 配置文件修改

### GitHub Actions 配置
- [ ] `.github/workflows/backend.yml` - 无需修改
- [ ] `.github/workflows/frontend.yml` - 无需修改

### 后端配置文件
- [ ] `deploy/backend/docker-compose.prod.yml`
  - [ ] 已将 `YOUR_GITHUB_USERNAME/YOUR_REPO_NAME` 替换为实际值
- [ ] `deploy/backend/.env`
  - [ ] 已设置强密码：`DB_PASSWORD`
  - [ ] 已设置强密码：`REDIS_PASSWORD`
- [ ] `deploy/backend/init-database.sh`
  - [ ] 已修改下载地址（如果需要）

### 前端配置文件
- [ ] `deploy/frontend/docker-compose.prod.yml`
  - [ ] 已将 `YOUR_GITHUB_USERNAME/YOUR_REPO_NAME` 替换为实际值
- [ ] `deploy/frontend/Caddyfile`
  - [ ] 已将 `your-domain.com` 替换为实际域名
  - [ ] 已将 `your-email@example.com` 替换为实际邮箱
  - [ ] 已将 `172.16.0.100:8080` 替换为后端实际内网地址
- [ ] `deploy/frontend/.env`
  - [ ] 已设置 `BACKEND_HOST` 为后端内网地址
  - [ ] 已设置 `GITHUB_USERNAME`
  - [ ] 已设置 `GITHUB_TOKEN`

## 🚀 部署步骤

### 步骤 1: 推送代码到 GitHub
- [ ] 已初始化 Git 仓库
- [ ] 已添加所有文件到 Git
- [ ] 已提交代码
- [ ] 已关联远程仓库
- [ ] 已推送代码到 GitHub
- [ ] GitHub Actions 已成功构建镜像（检查 Actions 页面）

### 步骤 2: 初始化后端服务器
- [ ] 已 SSH 登录后端服务器
- [ ] 已下载 `init-server.sh`
- [ ] 已运行 `init-server.sh`
- [ ] Docker 已成功安装（运行 `docker --version`）
- [ ] Docker Compose 已成功安装（运行 `docker-compose --version`）

### 步骤 3: 部署后端服务
- [ ] 已创建部署目录 `~/app/backend`
- [ ] 已下载部署文件
- [ ] 已复制 `.env.example` 为 `.env`
- [ ] 已编辑 `.env` 文件
- [ ] 已修改 `docker-compose.prod.yml`
- [ ] 已创建必要的目录
- [ ] 已下载 `db.sql` 文件
- [ ] 已登录 GitHub Container Registry
- [ ] 已运行 `deploy.sh`
- [ ] 已运行 `init-database.sh`
- [ ] 后端服务已启动（运行 `docker-compose ps`）
- [ ] 可以访问 `http://localhost:8080`

### 步骤 4: 初始化前端服务器
- [ ] 已 SSH 登录前端服务器
- [ ] 已下载 `init-server.sh`
- [ ] 已运行 `init-server.sh`
- [ ] Docker 已成功安装
- [ ] Docker Compose 已成功安装

### 步骤 5: 部署前端服务
- [ ] 已创建部署目录 `~/app/frontend`
- [ ] 已下载部署文件
- [ ] 已复制 `.env.example` 为 `.env`
- [ ] 已编辑 `.env` 文件
- [ ] 已复制 `Caddyfile.example` 为 `Caddyfile`
- [ ] 已编辑 `Caddyfile` 文件
- [ ] 已修改 `docker-compose.prod.yml`
- [ ] 已创建必要的目录
- [ ] 已登录 GitHub Container Registry
- [ ] 已运行 `deploy.sh`
- [ ] 前端服务已启动（运行 `docker-compose ps`）
- [ ] 可以访问 `http://localhost`

### 步骤 6: 验证部署
- [ ] 可以通过域名访问网站：`https://your-domain.com`
- [ ] HTTPS 证书已自动获取
- [ ] 可以正常登录
- [ ] API 接口正常工作
- [ ] 可以上传文件
- [ ] 数据库连接正常

## 🔒 部署后安全加固

### 密码安全
- [ ] 已修改所有默认密码
- [ ] 数据库密码强度足够（至少 16 位，包含大小写字母、数字、特殊字符）
- [ ] Redis 密码强度足够
- [ ] 已删除或禁用默认账户

### 防火墙配置
- [ ] 前端服务器只开放 80、443 端口
- [ ] 后端服务器 8080 端口只允许前端服务器内网访问
- [ ] 已禁用不必要的服务

### 备份配置
- [ ] 已测试备份脚本 `backup.sh`
- [ ] 已设置定时备份任务（crontab）
- [ ] 已测试恢复脚本 `restore.sh`
- [ ] 备份文件已保存到安全位置

### 监控配置
- [ ] 已测试监控脚本 `monitor.sh`
- [ ] 已设置定时监控任务（可选）
- [ ] 已配置告警通知（可选）

## 📊 功能测试

### 用户功能
- [ ] 用户注册功能正常
- [ ] 用户登录功能正常
- [ ] 密码修改功能正常
- [ ] 个人信息修改功能正常

### 业务功能
- [ ] 产品列表显示正常
- [ ] 产品购买功能正常
- [ ] 充值功能正常
- [ ] 提现功能正常
- [ ] 团队功能正常
- [ ] 签到功能正常

### 系统功能
- [ ] 文件上传功能正常
- [ ] 图片显示正常
- [ ] 新闻资讯显示正常
- [ ] 轮播图显示正常

## 📝 文档和记录

### 部署信息记录
- [ ] 已记录服务器 IP 地址
- [ ] 已记录数据库密码（安全保存）
- [ ] 已记录 Redis 密码（安全保存）
- [ ] 已记录 GitHub Token（安全保存）
- [ ] 已记录域名和 DNS 配置

### 文档准备
- [ ] 已阅读 `QUICK-START.md`
- [ ] 已阅读 `DEPLOYMENT.md`
- [ ] 已阅读 `DEPLOY-README.md`
- [ ] 已保存运维命令备查

## ✅ 最终检查

- [ ] 所有服务正常运行
- [ ] 网站可以正常访问
- [ ] HTTPS 证书有效
- [ ] 所有功能测试通过
- [ ] 备份任务已配置
- [ ] 监控已配置
- [ ] 文档已归档

---

**部署完成日期**: ___________________

**部署人员**: ___________________

**备注**: 
```
___________________________________________
___________________________________________
___________________________________________
```

