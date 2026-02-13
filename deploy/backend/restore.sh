#!/bin/bash

# 数据库和文件恢复脚本
# 使用方法: bash restore.sh [backup_date]
# 示例: bash restore.sh 20240101_120000

set -e

BACKUP_DIR=~/backups

if [ -z "$1" ]; then
    echo "使用方法: bash restore.sh [backup_date]"
    echo ""
    echo "可用的备份:"
    ls -lh $BACKUP_DIR | grep "db_" | awk '{print $9}' | sed 's/db_//' | sed 's/.sql.gz//'
    exit 1
fi

BACKUP_DATE=$1

echo "========================================="
echo "开始恢复备份..."
echo "备份时间: $BACKUP_DATE"
echo "========================================="

# 检查备份文件是否存在
if [ ! -f "$BACKUP_DIR/db_${BACKUP_DATE}.sql.gz" ]; then
    echo "错误: 备份文件不存在: db_${BACKUP_DATE}.sql.gz"
    exit 1
fi

# 确认操作
read -p "警告: 此操作将覆盖当前数据库！是否继续？(yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "取消操作"
    exit 0
fi

# 加载环境变量
if [ -f .env ]; then
    source .env
else
    echo "错误: .env 文件不存在"
    exit 1
fi

# 1. 恢复数据库
echo "1. 恢复数据库..."
gunzip < $BACKUP_DIR/db_${BACKUP_DATE}.sql.gz | docker exec -i yii2-mysql mysql -uroot -p${DB_PASSWORD} ${DB_NAME}
echo "   数据库恢复完成"

# 2. 恢复上传文件
if [ -f "$BACKUP_DIR/uploads_${BACKUP_DATE}.tar.gz" ]; then
    echo "2. 恢复上传文件..."
    rm -rf uploads.bak
    if [ -d uploads ]; then
        mv uploads uploads.bak
    fi
    tar -xzf $BACKUP_DIR/uploads_${BACKUP_DATE}.tar.gz
    echo "   上传文件恢复完成"
else
    echo "2. 跳过: 上传文件备份不存在"
fi

# 3. 恢复配置文件（可选）
if [ -f "$BACKUP_DIR/config_${BACKUP_DATE}.tar.gz" ]; then
    read -p "是否恢复配置文件？(yes/no): " RESTORE_CONFIG
    if [ "$RESTORE_CONFIG" == "yes" ]; then
        echo "3. 恢复配置文件..."
        tar -xzf $BACKUP_DIR/config_${BACKUP_DATE}.tar.gz
        echo "   配置文件恢复完成"
    fi
fi

echo ""
echo "========================================="
echo "恢复完成！"
echo "========================================="
echo "请重启服务以应用更改:"
echo "  docker-compose -f docker-compose.prod.yml restart"
echo "========================================="

