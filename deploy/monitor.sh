#!/bin/bash

# 服务监控脚本
# 使用方法: bash monitor.sh

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "服务监控报告"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
echo ""

# 1. 系统信息
echo "【系统信息】"
echo "主机名: $(hostname)"
echo "系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "内核: $(uname -r)"
echo "运行时间: $(uptime -p)"
echo ""

# 2. CPU 使用率
echo "【CPU 使用率】"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "CPU 使用: ${CPU_USAGE}%"
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo -e "${RED}警告: CPU 使用率过高！${NC}"
fi
echo ""

# 3. 内存使用
echo "【内存使用】"
free -h
MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.1f"), $3/$2 * 100.0}')
echo "内存使用率: ${MEMORY_USAGE}%"
if (( $(echo "$MEMORY_USAGE > 80" | bc -l) )); then
    echo -e "${RED}警告: 内存使用率过高！${NC}"
fi
echo ""

# 4. 磁盘使用
echo "【磁盘使用】"
df -h | grep -E '^/dev/'
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
if [ "$DISK_USAGE" -gt 80 ]; then
    echo -e "${RED}警告: 磁盘使用率过高！${NC}"
fi
echo ""

# 5. Docker 状态
echo "【Docker 服务】"
if systemctl is-active --quiet docker; then
    echo -e "${GREEN}✓ Docker 服务运行正常${NC}"
else
    echo -e "${RED}✗ Docker 服务未运行${NC}"
fi
echo ""

# 6. 容器状态
echo "【容器状态】"
if command -v docker &> /dev/null; then
    CONTAINERS=$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}")
    if [ -z "$CONTAINERS" ]; then
        echo -e "${YELLOW}没有运行中的容器${NC}"
    else
        echo "$CONTAINERS"
        
        # 检查容器健康状态
        UNHEALTHY=$(docker ps --filter "health=unhealthy" --format "{{.Names}}")
        if [ ! -z "$UNHEALTHY" ]; then
            echo -e "${RED}警告: 以下容器不健康: $UNHEALTHY${NC}"
        fi
    fi
else
    echo "Docker 未安装"
fi
echo ""

# 7. 网络连接
echo "【网络连接】"
ESTABLISHED=$(netstat -an | grep ESTABLISHED | wc -l)
TIME_WAIT=$(netstat -an | grep TIME_WAIT | wc -l)
echo "ESTABLISHED 连接: $ESTABLISHED"
echo "TIME_WAIT 连接: $TIME_WAIT"
if [ "$TIME_WAIT" -gt 1000 ]; then
    echo -e "${YELLOW}提示: TIME_WAIT 连接较多${NC}"
fi
echo ""

# 8. 端口监听
echo "【端口监听】"
netstat -tlnp | grep LISTEN | awk '{print $4, $7}' | column -t
echo ""

# 9. 最近的系统日志错误
echo "【系统日志（最近 10 条错误）】"
journalctl -p err -n 10 --no-pager || echo "无法读取系统日志"
echo ""

# 10. Docker 容器资源使用
echo "【容器资源使用】"
if command -v docker &> /dev/null && [ "$(docker ps -q)" ]; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
else
    echo "没有运行中的容器"
fi
echo ""

# 11. 检查服务可用性（如果是后端服务器）
if docker ps | grep -q yii2-app; then
    echo "【后端服务检查】"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || echo "000")
    if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "302" ]; then
        echo -e "${GREEN}✓ 后端服务响应正常 (HTTP $HTTP_CODE)${NC}"
    else
        echo -e "${RED}✗ 后端服务响应异常 (HTTP $HTTP_CODE)${NC}"
    fi
    
    # 检查 MySQL
    if docker exec yii2-mysql mysqladmin ping -h localhost -uroot -p${DB_PASSWORD} &>/dev/null; then
        echo -e "${GREEN}✓ MySQL 服务正常${NC}"
    else
        echo -e "${RED}✗ MySQL 服务异常${NC}"
    fi
    
    # 检查 Redis
    if docker exec yii2-redis redis-cli ping &>/dev/null; then
        echo -e "${GREEN}✓ Redis 服务正常${NC}"
    else
        echo -e "${RED}✗ Redis 服务异常${NC}"
    fi
    echo ""
fi

# 12. 检查前端服务（如果是前端服务器）
if docker ps | grep -q vue-frontend; then
    echo "【前端服务检查】"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost || echo "000")
    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✓ 前端服务响应正常 (HTTP $HTTP_CODE)${NC}"
    else
        echo -e "${RED}✗ 前端服务响应异常 (HTTP $HTTP_CODE)${NC}"
    fi
    echo ""
fi

echo "========================================="
echo "监控报告完成"
echo "========================================="

