# ECEX项目部署指南

> 适用于 Alibaba Cloud Linux 3.2104 LTS 64位系统

本文档将指导你从零开始在阿里云服务器上部署ECEX项目。

---

## 📋 前置要求

- ✅ 一台阿里云ECS服务器（Alibaba Cloud Linux 3.2104 LTS 64位）
- ✅ 服务器已开放端口：80（HTTP）、443（HTTPS，可选）
- ✅ 有服务器的SSH登录权限
- ✅ 有GitHub账号和访问权限

## 🏗️ 架构说明

### 使用 Caddy 反向代理方案（推荐）

```
                    公网 IP: 8.212.40.70
                            |
                    +-------+-------+
                    |    Caddy      |  (监听 :80)
                    |  反向代理      |
                    +-------+-------+
                            |
            +---------------+---------------+
            |                               |
    前端静态文件                      后端 API
    /var/www/html/frontend          172.16.0.87:8080
    (Vue.js SPA)                    (Spring Boot)
```

**优势**:
- ✅ 统一入口：前端和后端都通过公网 IP 访问
- ✅ 路径分离：前端访问 `/`，后端 API 访问 `/api/*`
- ✅ 安全性：后端不直接暴露到公网，只需开放 80 端口
- ✅ 易扩展：可轻松添加 HTTPS、负载均衡等
- ✅ 自动 HTTPS：Caddy 可自动申请和续期 SSL 证书

---

## 第一步：连接到服务器

使用SSH连接到你的阿里云服务器：

```bash
ssh root@YOUR_SERVER_IP
```

> 💡 将 `YOUR_SERVER_IP` 替换为你的服务器公网IP地址

---

## 第二步：安装Docker

### 2.1 更新系统

```bash
# 更新软件包列表
yum update -y
```

### 2.2 安装Docker

```bash
# 安装Docker
yum install -y docker

# 启动Docker服务
systemctl start docker

# 设置Docker开机自启
systemctl enable docker

# 验证Docker安装
docker --version
```

你应该看到类似这样的输出：
```
Docker version 20.10.x, build xxxxx
```

### 2.3 安装Docker Compose

```bash
# 下载Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 添加执行权限
chmod +x /usr/local/bin/docker-compose

# 验证安装
docker-compose --version
```

你应该看到类似这样的输出：
```
Docker Compose version v2.24.0
```

---

## 第三步：配置防火墙

### 3.1 开放必要端口

```bash
# 开放80端口（前端）
firewall-cmd --permanent --add-port=80/tcp

# 开放8080端口（后端）
firewall-cmd --permanent --add-port=8080/tcp

# 重载防火墙配置
firewall-cmd --reload

# 查看已开放的端口
firewall-cmd --list-ports
```

### 3.2 配置阿里云安全组

1. 登录阿里云控制台
2. 进入 **云服务器ECS** → **实例**
3. 点击你的实例 → **安全组** → **配置规则**
4. 添加以下入方向规则：

| 端口范围 | 授权对象 | 描述 |
|---------|---------|------|
| 80/80   | 0.0.0.0/0 | 前端HTTP |
| 8080/8080 | 0.0.0.0/0 | 后端API |

---

## 第四步：登录GitHub Container Registry

### 4.1 创建GitHub Personal Access Token

1. 访问：https://github.com/settings/tokens
2. 点击 **Generate new token (classic)**
3. 勾选权限：
   - ✅ `read:packages`
4. 点击 **Generate token**
5. **复制Token**（格式：`ghp_xxxxxxxxxxxx`）

### 4.2 登录Docker Registry

```bash
# 登录GHCR（将YOUR_GITHUB_TOKEN替换为你的Token）
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u ecex-hub --password-stdin
```

成功后会显示：
```
Login Succeeded
```

---

## 第五步：创建项目目录

```bash
# 创建项目目录
mkdir -p /opt/ecex
cd /opt/ecex

# 创建必要的子目录
mkdir -p server
```

---

## 第六步：配置环境变量

### 6.1 创建后端环境配置文件

```bash
# 创建.env文件
cat > server/.env << 'EOF'
# 数据库配置
DB_HOST=mysql
DB_PORT=3306
DB_NAME=stock
DB_USER=root
DB_PASSWORD=SecurePassword123!

# Redis配置
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DATABASE=0

# 应用配置
YII_ENV=Production
YII_DEBUG=false
EOF
```

### 6.2 编辑配置文件

```bash
# 使用vi编辑器修改配置
vi server/.env
```

按 `i` 进入编辑模式，修改以下内容：

- `DB_HOST`: 你的数据库地址（如：rm-xxxxx.mysql.rds.aliyuncs.com）
- `DB_NAME`: 数据库名称
- `DB_USER`: 数据库用户名
- `DB_PASSWORD`: 数据库密码
- `ALIYUN_ACCESS_KEY_ID`: 阿里云AccessKey ID
- `ALIYUN_ACCESS_KEY_SECRET`: 阿里云AccessKey Secret

按 `ESC`，输入 `:wq`，按 `Enter` 保存退出。

---

## 第七步：创建Docker Compose配置

```bash
# 创建docker-compose.yml文件
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # 后端服务
  backend:
    image: ghcr.io/ecex-hub/ecex/backend:latest
    container_name: ecex-backend
    ports:
      - "8080:8080"
    volumes:
      - ./server/.env:/var/www/html/.env
    restart: unless-stopped
    networks:
      - ecex-network

  # 前端服务
  frontend:
    image: ghcr.io/ecex-hub/ecex/frontend:latest
    container_name: ecex-frontend
    ports:
      - "80:80"
    restart: unless-stopped
    networks:
      - ecex-network

networks:
  ecex-network:
    driver: bridge
EOF
```

---

## 第八步：拉取并启动服务

### 8.1 拉取最新镜像

```bash
# 拉取前端镜像
docker pull ghcr.io/ecex-hub/ecex/frontend:latest

# 拉取后端镜像
docker pull ghcr.io/ecex-hub/ecex/backend:latest
```

### 8.2 启动所有服务

```bash
# 启动服务
docker-compose up -d

# 查看服务状态
docker-compose ps
```

你应该看到类似这样的输出：
```
NAME                IMAGE                                    STATUS
ecex-backend        ghcr.io/ecex-hub/ecex/backend:latest    Up
ecex-frontend       ghcr.io/ecex-hub/ecex/frontend:latest   Up
```

### 8.3 查看日志

```bash
# 查看所有服务日志
docker-compose logs -f

# 只查看后端日志
docker-compose logs -f backend

# 只查看前端日志
docker-compose logs -f frontend
```

按 `Ctrl+C` 退出日志查看。

---

## 第九步：验证部署

### 9.1 验证后端服务

```bash
# 在服务器上测试
curl http://localhost:8080

# 从外网访问（替换为你的服务器公网IP）
curl http://YOUR_SERVER_IP:8080
```

### 9.2 验证前端服务

```bash
# 在服务器上测试
curl http://localhost

# 从外网访问（替换为你的服务器公网IP）
# 在浏览器中打开：
http://YOUR_SERVER_IP
```

---

## 第十步：常用管理命令

### 查看服务状态

```bash
# 查看所有容器状态
docker-compose ps

# 查看容器资源使用情况
docker stats
```

### 重启服务

```bash
# 重启所有服务
docker-compose restart

# 只重启后端
docker-compose restart backend

# 只重启前端
docker-compose restart frontend
```

### 停止服务

```bash
# 停止所有服务
docker-compose down

# 停止并删除所有数据（危险操作！）
docker-compose down -v
```

### 更新服务

```bash
# 拉取最新镜像
docker-compose pull

# 重新启动服务
docker-compose up -d
```

### 查看日志

```bash
# 查看最近100行日志
docker-compose logs --tail=100

# 实时查看日志
docker-compose logs -f

# 查看特定服务的日志
docker-compose logs -f backend
```

---

## 🎯 部署完成！

恭喜！你已经成功部署了ECEX项目！

### 访问地址

- **前端**: http://YOUR_SERVER_IP
- **后端API**: http://YOUR_SERVER_IP:8080

### 下一步建议

1. **配置域名**：将域名解析到服务器IP
2. **启用HTTPS**：Caddy会自动申请SSL证书
3. **定期备份**：备份数据库和配置文件
4. **监控服务**：定期查看日志和服务状态

---

## ⚠️ 故障排查

### 问题1：容器无法启动

```bash
# 查看详细错误信息
docker-compose logs backend

# 检查端口是否被占用
netstat -tulpn | grep :8080
netstat -tulpn | grep :80
```

### 问题2：无法访问服务

```bash
# 检查防火墙状态
firewall-cmd --list-ports

# 检查容器是否运行
docker-compose ps

# 检查阿里云安全组规则
# 登录阿里云控制台检查
```

### 问题3：数据库连接失败

```bash
# 检查环境变量
cat server/.env

# 测试数据库连接
# 进入后端容器
docker-compose exec backend bash

# 在容器内测试
ping your_database_host
```

### 问题4：镜像拉取失败

```bash
# 检查登录状态
docker login ghcr.io

# 重新登录
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u ecex-hub --password-stdin

# 手动拉取镜像
docker pull ghcr.io/ecex-hub/ecex/backend:latest
docker pull ghcr.io/ecex-hub/ecex/frontend:latest
```

---

## 📞 获取帮助

如遇到问题，请提供以下信息：

1. 系统版本：`cat /etc/os-release`
2. Docker版本：`docker --version`
3. 错误日志：`docker-compose logs`
4. 服务状态：`docker-compose ps`

---

## 🔄 使用 Caddy 反向代理部署（推荐方案）

### 为什么使用 Caddy？

相比直接暴露后端端口，使用 Caddy 反向代理有以下优势：

1. **统一访问入口**：前端和后端都通过公网 IP 访问，避免跨域问题
2. **安全性更高**：后端服务不直接暴露到公网
3. **自动 HTTPS**：Caddy 可自动申请和续期 SSL 证书
4. **配置简单**：Caddyfile 配置语法简洁易懂
5. **性能优秀**：内置 HTTP/2、Gzip 压缩等优化

### 部署步骤

#### 1. 安装 Caddy

```bash
# SSH 登录到服务器
ssh root@8.212.40.70

# 进入项目目录
cd /root/ecex

# 拉取最新代码
git pull origin main

# 运行 Caddy 安装脚本
bash install-caddy.sh
```

#### 2. 确保后端服务运行

```bash
# 检查后端服务状态
systemctl status ecex-backend

# 如果未运行，启动后端
systemctl start ecex-backend

# 测试后端是否可访问（内网）
curl http://172.16.0.87:8080/actuator/health
```

#### 3. 部署前端并配置 Caddy

```bash
# 运行部署脚本（会自动构建前端、配置 Caddy）
bash deploy-with-caddy.sh
```

#### 4. 验证部署

```bash
# 检查 Caddy 状态
systemctl status caddy

# 测试前端访问
curl http://8.212.40.70

# 测试后端 API 访问（通过 Caddy 代理）
curl http://8.212.40.70/api/actuator/health
```

### 访问地址

- **前端**: http://8.212.40.70
- **后端 API**: http://8.212.40.70/api

### Caddy 常用命令

```bash
# 启动 Caddy
systemctl start caddy

# 停止 Caddy
systemctl stop caddy

# 重启 Caddy
systemctl restart caddy

# 查看状态
systemctl status caddy

# 查看日志
journalctl -u caddy -f

# 重新加载配置（无需重启）
systemctl reload caddy

# 验证配置文件
caddy validate --config /etc/caddy/Caddyfile
```

### 故障排查

#### 问题1：API 请求超时

```bash
# 1. 检查后端是否运行
systemctl status ecex-backend

# 2. 测试后端直接访问
curl http://172.16.0.87:8080/actuator/health

# 3. 检查 Caddy 配置
cat /etc/caddy/Caddyfile

# 4. 查看 Caddy 日志
journalctl -u caddy -n 50
```

#### 问题2：前端无法访问

```bash
# 1. 检查 Caddy 是否运行
systemctl status caddy

# 2. 检查前端文件是否存在
ls -la /var/www/html/frontend

# 3. 查看 Caddy 日志
journalctl -u caddy -f
```

#### 问题3：防火墙问题

```bash
# 检查防火墙状态
firewall-cmd --list-all

# 开放 80 端口
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

# 或者使用 ufw (Ubuntu)
ufw allow 80/tcp
ufw reload
```

### 升级到 HTTPS（可选）

如果有域名，可以启用自动 HTTPS：

1. 将域名解析到服务器 IP
2. 修改 `/etc/caddy/Caddyfile`，将 `:80` 改为域名
3. 重启 Caddy，它会自动申请 SSL 证书

```caddy
your-domain.com {
    handle /api/* {
        uri strip_prefix /api
        reverse_proxy 172.16.0.87:8080
    }

    handle {
        root * /var/www/html/frontend
        file_server
        try_files {path} /index.html
    }
}
```

---

**祝你部署顺利！** 🚀