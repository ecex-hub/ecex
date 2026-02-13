# 快速部署指南

本文档提供最简化的部署步骤，适合快速上手。详细说明请参考 [DEPLOYMENT.md](DEPLOYMENT.md)。

## 📋 准备清单

- [ ] 两台阿里云服务器（Alibaba Cloud Linux 3.2104 LTS）
- [ ] 一个已备案的域名
- [ ] GitHub 账号和仓库
- [ ] GitHub Personal Access Token（需要 `write:packages` 权限）

## 🚀 5 步快速部署

### 步骤 1: 推送代码到 GitHub

```bash
# 在本地执行
cd /path/to/ecex
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

等待 GitHub Actions 自动构建镜像（约 5-10 分钟）。

### 步骤 2: 初始化后端服务器

```bash
# SSH 登录后端服务器
ssh root@后端服务器IP

# 下载并运行初始化脚本
wget https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/deploy/init-server.sh
bash init-server.sh

# 创建部署目录
mkdir -p ~/app/backend && cd ~/app/backend

# 下载部署文件
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git temp
cp -r temp/deploy/backend/* .
rm -rf temp

# 配置环境变量
cp .env.example .env
vi .env  # 修改数据库密码等

# 修改 docker-compose.prod.yml 中的镜像地址
vi docker-compose.prod.yml  # 替换 YOUR_GITHUB_USERNAME/YOUR_REPO_NAME

# 登录 GitHub 并部署
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
chmod +x *.sh
bash deploy.sh

# 初始化数据库
bash init-database.sh

# 记录内网 IP（前端需要用）
ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
```

### 步骤 3: 初始化前端服务器

```bash
# SSH 登录前端服务器
ssh root@前端服务器IP

# 下载并运行初始化脚本
wget https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/deploy/init-server.sh
bash init-server.sh

# 创建部署目录
mkdir -p ~/app/frontend && cd ~/app/frontend

# 下载部署文件
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git temp
cp -r temp/deploy/frontend/* .
rm -rf temp

# 配置环境变量
cp .env.example .env
vi .env  # 修改后端内网地址、GitHub 信息

# 配置 Caddyfile
cp Caddyfile.example Caddyfile
vi Caddyfile  # 修改域名、邮箱、后端地址

# 修改 docker-compose.prod.yml 中的镜像地址
vi docker-compose.prod.yml  # 替换 YOUR_GITHUB_USERNAME/YOUR_REPO_NAME

# 登录 GitHub 并部署
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
chmod +x *.sh
bash deploy.sh
```

### 步骤 4: 配置域名解析

在域名服务商处添加 A 记录：
```
类型: A
主机记录: @（或 www）
记录值: 前端服务器公网IP
TTL: 600
```

### 步骤 5: 验证部署

```bash
# 访问网站
https://your-domain.com

# 测试 API
curl -X POST https://your-domain.com/api/login/index \
  -H "Content-Type: application/json" \
  -d '{"account":"test","password":"123456"}'
```

## 🔄 日常运维

### 更新应用

```bash
# 后端服务器
cd ~/app/backend
bash deploy.sh

# 前端服务器
cd ~/app/frontend
bash deploy.sh
```

### 备份数据

```bash
# 后端服务器
cd ~/app/backend
bash backup.sh

# 设置定时备份（每天凌晨 2 点）
crontab -e
# 添加: 0 2 * * * cd ~/app/backend && bash backup.sh >> /var/log/backup.log 2>&1
```

### 查看日志

```bash
# 后端日志
cd ~/app/backend
docker-compose -f docker-compose.prod.yml logs -f app

# 前端日志
cd ~/app/frontend
docker-compose -f docker-compose.prod.yml logs -f frontend
```

### 重启服务

```bash
# 后端
cd ~/app/backend
docker-compose -f docker-compose.prod.yml restart

# 前端
cd ~/app/frontend
docker-compose -f docker-compose.prod.yml restart
```

## ⚠️ 重要提醒

1. **修改默认密码**: 部署后立即修改 `.env` 中的所有密码
2. **配置防火墙**: 只开放必要的端口
3. **定期备份**: 设置自动备份任务
4. **监控服务**: 定期检查服务状态和资源使用

## 📞 遇到问题？

查看详细文档: [DEPLOYMENT.md](DEPLOYMENT.md)

常见问题:
- 无法拉取镜像 → 检查 GitHub Token 权限
- 无法获取 HTTPS 证书 → 检查域名解析和端口开放
- API 502 错误 → 检查后端服务和内网连接
- 数据库连接失败 → 检查 MySQL 容器状态

---

**部署成功后，请务必修改所有默认密码并配置定期备份！**

