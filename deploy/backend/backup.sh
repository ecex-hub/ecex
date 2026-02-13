#!/bin/bash

# 数据库和文件备份脚本
# 使用方法: bash backup.sh

set -e

# 配置
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)
KEEP_DAYS=7

# 创建备份目录
mkdir -p $BACKUP_DIR

echo "========================================="
echo "开始备份..."
echo "时间: $(date)"
echo "========================================="

# 加载环境变量
if [ -f .env ]; then
    source .env
else
    echo "警告: .env 文件不存在，使用默认配置"
    DB_NAME="ecex"
    DB_PASSWORD="password"
fi

# 1. 备份数据库
echo "1. 备份数据库..."
docker exec yii2-mysql mysqldump -uroot -p${DB_PASSWORD} \
    --single-transaction \
    --quick \
    --lock-tables=false \
    ${DB_NAME} | gzip > $BACKUP_DIR/db_${DATE}.sql.gz

DB_SIZE=$(du -h $BACKUP_DIR/db_${DATE}.sql.gz | cut -f1)
echo "   数据库备份完成: db_${DATE}.sql.gz ($DB_SIZE)"

# 2. 备份上传文件
echo "2. 备份上传文件..."
if [ -d uploads ]; then
    tar -czf $BACKUP_DIR/uploads_${DATE}.tar.gz uploads
    UPLOAD_SIZE=$(du -h $BACKUP_DIR/uploads_${DATE}.tar.gz | cut -f1)
    echo "   上传文件备份完成: uploads_${DATE}.tar.gz ($UPLOAD_SIZE)"
else
    echo "   跳过: uploads 目录不存在"
fi

# 3. 备份配置文件
echo "3. 备份配置文件..."
tar -czf $BACKUP_DIR/config_${DATE}.tar.gz \
    .env \
    docker-compose.prod.yml \
    Caddyfile 2>/dev/null || true
CONFIG_SIZE=$(du -h $BACKUP_DIR/config_${DATE}.tar.gz | cut -f1)
echo "   配置文件备份完成: config_${DATE}.tar.gz ($CONFIG_SIZE)"

# 4. 清理旧备份
echo "4. 清理 ${KEEP_DAYS} 天前的备份..."
DELETED=$(find $BACKUP_DIR -name "*.gz" -mtime +${KEEP_DAYS} -delete -print | wc -l)
echo "   已删除 $DELETED 个旧备份文件"

# 5. 显示备份列表
echo ""
echo "========================================="
echo "备份完成！"
echo "========================================="
echo "备份目录: $BACKUP_DIR"
echo ""
echo "最近的备份文件:"
ls -lh $BACKUP_DIR | tail -10
echo ""
echo "磁盘使用情况:"
du -sh $BACKUP_DIR
echo "========================================="

# 6. 可选：上传到对象存储（阿里云 OSS）
# 需要先安装 ossutil: https://help.aliyun.com/document_detail/120075.html
# if command -v ossutil64 &> /dev/null; then
#     echo "上传到 OSS..."
#     ossutil64 cp $BACKUP_DIR/db_${DATE}.sql.gz oss://your-bucket/backups/
#     ossutil64 cp $BACKUP_DIR/uploads_${DATE}.tar.gz oss://your-bucket/backups/
#     echo "OSS 上传完成"
# fi

