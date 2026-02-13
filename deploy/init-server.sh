#!/bin/bash

# 服务器初始化脚本
# 适用于 Alibaba Cloud Linux 3.2104 LTS 64位
# 使用方法: bash init-server.sh

set -e

echo "========================================="
echo "开始初始化服务器..."
echo "========================================="

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户或 sudo 运行此脚本"
    exit 1
fi

# 1. 更新系统
echo "步骤 1/8: 更新系统..."
yum update -y

# 2. 安装基础工具
echo "步骤 2/8: 安装基础工具..."
yum install -y wget curl vim git htop sysstat net-tools

# 3. 安装 Docker
echo "步骤 3/8: 安装 Docker..."
yum install -y yum-utils
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

# 4. 配置 Docker 镜像加速
echo "步骤 4/8: 配置 Docker 镜像加速..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": [
    "https://mirror.ccs.tencentyun.com",
    "https://docker.mirrors.ustc.edu.cn"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# 5. 启动 Docker
echo "步骤 5/8: 启动 Docker..."
systemctl daemon-reload
systemctl start docker
systemctl enable docker

# 6. 安装 Docker Compose
echo "步骤 6/8: 安装 Docker Compose..."
DOCKER_COMPOSE_VERSION="v2.24.0"
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# 7. 配置防火墙
echo "步骤 7/8: 配置防火墙..."
systemctl start firewalld
systemctl enable firewalld

# 8. 优化系统参数
echo "步骤 8/8: 优化系统参数..."
cat >> /etc/sysctl.conf << 'EOF'

# Docker 优化
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1

# 网络优化
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30

# 文件描述符
fs.file-max = 65535
EOF

sysctl -p

# 设置文件描述符限制
cat >> /etc/security/limits.conf << 'EOF'
* soft nofile 65535
* hard nofile 65535
* soft nproc 65535
* hard nproc 65535
EOF

# 验证安装
echo ""
echo "========================================="
echo "验证安装..."
echo "========================================="
echo "Docker 版本:"
docker --version
echo ""
echo "Docker Compose 版本:"
docker-compose --version
echo ""
echo "系统信息:"
uname -a
echo ""

echo "========================================="
echo "服务器初始化完成！"
echo "========================================="
echo ""
echo "下一步操作："
echo "1. 如果是后端服务器，请运行后端部署脚本"
echo "2. 如果是前端服务器，请运行前端部署脚本"
echo ""
echo "重启系统以使所有配置生效（可选）："
echo "  reboot"
echo "========================================="

