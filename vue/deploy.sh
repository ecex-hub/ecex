#!/bin/bash

# 前端部署脚本
# 使用方法: ./deploy.sh [dev|prod]

set -e

ENV=${1:-dev}

echo "========================================="
echo "开始部署前端服务 - 环境: $ENV"
echo "========================================="

# 检查环境变量文件
if [ ! -f .env ]; then
    echo "错误: .env 文件不存在"
    echo "请复制 .env.example 并配置后端API地址："
    echo "  cp .env.example .env"
    echo "  nano .env"
    exit 1
fi

# 显示配置的API地址
echo "后端API地址配置："
cat .env | grep VITE_API_BASE_URL

# 停止现有服务
echo ""
echo "停止现有服务..."
docker-compose down

# 根据环境选择部署方式
if [ "$ENV" = "prod" ]; then
    echo "使用生产环境配置..."
    
    # 检查是否已登录GitHub Container Registry
    if ! docker info | grep -q "ghcr.io"; then
        echo "提示: 请先登录GitHub Container Registry"
        echo "  echo YOUR_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin"
    fi
    
    # 拉取最新镜像
    echo "拉取最新镜像..."
    docker-compose -f docker-compose.prod.yml pull
    
    # 启动服务
    echo "启动服务..."
    docker-compose -f docker-compose.prod.yml up -d
else
    echo "使用开发环境配置..."
    
    # 构建并启动
    echo "构建并启动服务..."
    docker-compose up -d --build
fi

# 等待服务启动
echo "等待服务启动..."
sleep 5

# 检查服务状态
echo ""
echo "========================================="
echo "服务状态："
echo "========================================="
docker-compose ps

# 显示日志
echo ""
echo "========================================="
echo "最近日志："
echo "========================================="
docker-compose logs --tail=20

echo ""
echo "========================================="
echo "部署完成！"
echo "========================================="
echo "前端访问地址: http://localhost"
echo ""
echo "查看日志: docker-compose logs -f"
echo "停止服务: docker-compose down"
echo "========================================="

