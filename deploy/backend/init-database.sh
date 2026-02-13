#!/bin/bash

# 数据库初始化脚本
# 使用方法: bash init-database.sh

set -e

echo "========================================="
echo "开始初始化数据库..."
echo "========================================="

# 检查 .env 文件
if [ ! -f .env ]; then
    echo "错误: .env 文件不存在"
    exit 1
fi

# 加载环境变量
source .env

# 检查 MySQL 容器是否运行
if ! docker ps | grep -q yii2-mysql; then
    echo "错误: MySQL 容器未运行，请先启动服务"
    exit 1
fi

# 等待 MySQL 启动完成
echo "等待 MySQL 启动..."
sleep 10

# 检查数据库是否已存在数据
TABLE_COUNT=$(docker exec yii2-mysql mysql -uroot -p${DB_PASSWORD} -e "SELECT COUNT(*) as count FROM information_schema.tables WHERE table_schema = '${DB_NAME}';" -s -N 2>/dev/null || echo "0")

if [ "$TABLE_COUNT" -gt "0" ]; then
    echo "警告: 数据库中已存在 $TABLE_COUNT 个表"
    read -p "是否要重新导入数据库？这将删除所有现有数据！(yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "取消操作"
        exit 0
    fi
    
    # 删除数据库
    echo "删除现有数据库..."
    docker exec yii2-mysql mysql -uroot -p${DB_PASSWORD} -e "DROP DATABASE IF EXISTS ${DB_NAME};"
    docker exec yii2-mysql mysql -uroot -p${DB_PASSWORD} -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
fi

# 下载 db.sql（如果本地没有）
if [ ! -f db.sql ]; then
    echo "下载数据库文件..."
    # 替换为你的实际仓库地址
    wget https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/db.sql
fi

# 导入数据库
echo "导入数据库..."
docker exec -i yii2-mysql mysql -uroot -p${DB_PASSWORD} ${DB_NAME} < db.sql

# 验证导入
TABLE_COUNT=$(docker exec yii2-mysql mysql -uroot -p${DB_PASSWORD} -e "SELECT COUNT(*) as count FROM information_schema.tables WHERE table_schema = '${DB_NAME}';" -s -N)

echo ""
echo "========================================="
echo "数据库初始化完成！"
echo "========================================="
echo "数据库名称: ${DB_NAME}"
echo "表数量: $TABLE_COUNT"
echo ""
echo "测试连接:"
docker exec yii2-mysql mysql -uroot -p${DB_PASSWORD} -e "USE ${DB_NAME}; SHOW TABLES;" | head -20
echo "========================================="

