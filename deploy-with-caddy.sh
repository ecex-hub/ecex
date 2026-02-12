#!/bin/bash

# 生产环境部署脚本 - 使用 Caddy 反向代理
# 用途：在服务器上部署前端和配置 Caddy

set -e  # 遇到错误立即退出

echo "=========================================="
echo "开始部署 ECEX 系统（Caddy 反向代理模式）"
echo "=========================================="

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 配置变量
PROJECT_DIR="/root/ecex"
FRONTEND_BUILD_DIR="$PROJECT_DIR/vue/dist"
FRONTEND_DEPLOY_DIR="/var/www/html/frontend"
CADDY_CONFIG="/etc/caddy/Caddyfile"

# 步骤1: 拉取最新代码
echo -e "${YELLOW}[1/6] 拉取最新代码...${NC}"
cd $PROJECT_DIR
git pull origin main

# 步骤2: 安装前端依赖
echo -e "${YELLOW}[2/6] 安装前端依赖...${NC}"
cd $PROJECT_DIR/vue
npm install

# 步骤3: 构建前端
echo -e "${YELLOW}[3/6] 构建前端...${NC}"
npm run build

# 步骤4: 部署前端文件
echo -e "${YELLOW}[4/6] 部署前端文件...${NC}"
# 创建部署目录
mkdir -p $FRONTEND_DEPLOY_DIR

# 备份旧版本（如果存在）
if [ -d "$FRONTEND_DEPLOY_DIR/index.html" ]; then
    BACKUP_DIR="$FRONTEND_DEPLOY_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    echo "备份旧版本到: $BACKUP_DIR"
    cp -r $FRONTEND_DEPLOY_DIR $BACKUP_DIR
fi

# 复制新版本
echo "复制构建产物到部署目录..."
rm -rf $FRONTEND_DEPLOY_DIR/*
cp -r $FRONTEND_BUILD_DIR/* $FRONTEND_DEPLOY_DIR/

# 设置权限
chown -R www-data:www-data $FRONTEND_DEPLOY_DIR
chmod -R 755 $FRONTEND_DEPLOY_DIR

# 步骤5: 配置 Caddy
echo -e "${YELLOW}[5/6] 配置 Caddy...${NC}"

# 检查 Caddy 是否安装
if ! command -v caddy &> /dev/null; then
    echo -e "${RED}错误: Caddy 未安装${NC}"
    echo "请先安装 Caddy:"
    echo "  Ubuntu/Debian: sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https"
    echo "                 curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg"
    echo "                 curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list"
    echo "                 sudo apt update && sudo apt install caddy"
    exit 1
fi

# 备份原有配置
if [ -f "$CADDY_CONFIG" ]; then
    cp $CADDY_CONFIG $CADDY_CONFIG.backup.$(date +%Y%m%d_%H%M%S)
fi

# 复制新配置
cp $PROJECT_DIR/Caddyfile.production $CADDY_CONFIG

# 验证配置
echo "验证 Caddy 配置..."
caddy validate --config $CADDY_CONFIG

# 步骤6: 重启 Caddy
echo -e "${YELLOW}[6/6] 重启 Caddy...${NC}"
systemctl restart caddy
systemctl status caddy --no-pager

echo ""
echo -e "${GREEN}=========================================="
echo "部署完成！"
echo "==========================================${NC}"
echo ""
echo "访问地址:"
echo "  前端: http://8.212.40.70"
echo "  后端API: http://8.212.40.70/api"
echo ""
echo "检查服务状态:"
echo "  Caddy: systemctl status caddy"
echo "  后端: systemctl status ecex-backend"
echo ""
echo "查看日志:"
echo "  Caddy: journalctl -u caddy -f"
echo "  后端: journalctl -u ecex-backend -f"
echo ""

