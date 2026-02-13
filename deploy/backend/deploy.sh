#!/bin/bash

# 后端服务器部署脚本
# 使用方法: bash deploy.sh

set -e

echo "========================================="
echo "开始部署后端服务..."
echo "========================================="

# 检查 .env 文件
if [ ! -f .env ]; then
    echo "错误: .env 文件不存在，请先复制 .env.example 并配置"
    exit 1
fi

# 加载环境变量
source .env

# 登录 GitHub Container Registry
echo "登录 GitHub Container Registry..."
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

# 拉取最新镜像
echo "拉取最新后端镜像..."
docker-compose -f docker-compose.prod.yml pull app

# 停止旧容器
echo "停止旧容器..."
docker-compose -f docker-compose.prod.yml down

# 启动新容器
echo "启动新容器..."
docker-compose -f docker-compose.prod.yml up -d

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 检查服务状态
echo "检查服务状态..."
docker-compose -f docker-compose.prod.yml ps

# 查看日志
echo "查看最近日志..."
docker-compose -f docker-compose.prod.yml logs --tail=50 app

echo "========================================="
echo "后端服务部署完成！"
echo "========================================="
echo "访问地址: http://localhost:8080"
echo "查看日志: docker-compose -f docker-compose.prod.yml logs -f app"
echo "========================================="

