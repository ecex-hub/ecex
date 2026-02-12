#!/bin/bash

# Caddy 安装脚本
# 适用于 Ubuntu/Debian 系统

set -e

echo "=========================================="
echo "安装 Caddy Web Server"
echo "=========================================="

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    echo "使用: sudo bash install-caddy.sh"
    exit 1
fi

# 检查系统类型
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "无法检测操作系统类型"
    exit 1
fi

echo "检测到操作系统: $OS"

# 安装 Caddy
if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
    echo "开始安装 Caddy..."
    
    # 安装依赖
    apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
    
    # 添加 Caddy GPG 密钥
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    
    # 添加 Caddy 仓库
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    
    # 更新并安装
    apt update
    apt install -y caddy
    
elif [ "$OS" = "centos" ] || [ "$OS" = "rhel" ] || [ "$OS" = "fedora" ]; then
    echo "开始安装 Caddy..."
    
    # 添加 Caddy 仓库
    dnf install -y 'dnf-command(copr)'
    dnf copr enable -y @caddy/caddy
    
    # 安装 Caddy
    dnf install -y caddy
    
else
    echo "不支持的操作系统: $OS"
    echo "请手动安装 Caddy: https://caddyserver.com/docs/install"
    exit 1
fi

# 验证安装
echo ""
echo "验证 Caddy 安装..."
caddy version

# 启用并启动服务
echo ""
echo "启用 Caddy 服务..."
systemctl enable caddy
systemctl start caddy

# 检查状态
echo ""
echo "Caddy 服务状态:"
systemctl status caddy --no-pager

echo ""
echo "=========================================="
echo "Caddy 安装完成！"
echo "=========================================="
echo ""
echo "下一步:"
echo "1. 运行部署脚本: bash deploy-with-caddy.sh"
echo "2. 检查服务状态: systemctl status caddy"
echo "3. 查看日志: journalctl -u caddy -f"
echo ""

