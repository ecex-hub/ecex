# ECEX项目部署指南

> 适用于 Alibaba Cloud Linux 3.2104 LTS 64位系统

本文档将指导你从零开始在阿里云服务器上部署ECEX项目。

---

## 📋 前置要求

- ✅ 一台阿里云ECS服务器（Alibaba Cloud Linux 3.2104 LTS 64位）
- ✅ 服务器已开放端口：80（前端）、8080（后端）
- ✅ 有服务器的SSH登录权限
- ✅ 有GitHub账号和访问权限

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
DB_HOST=your_database_host
DB_NAME=your_database_name
DB_USER=your_database_user
DB_PASSWORD=your_database_password

# 阿里云短信服务配置
ALIYUN_ACCESS_KEY_ID=your_access_key_id
ALIYUN_ACCESS_KEY_SECRET=your_access_key_secret
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

**祝你部署顺利！** 🚀