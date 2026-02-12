# 构建阶段
FROM node:18-alpine AS builder

WORKDIR /app

# 复制package文件
COPY package*.json ./

# 安装依赖
RUN npm ci --only=production

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 生产阶段 - 使用Caddy
FROM caddy:2-alpine

# 复制构建产物
COPY --from=builder /app/dist /srv

# 复制Caddyfile配置
COPY docker/caddy/Caddyfile /etc/caddy/Caddyfile

# 暴露端口
EXPOSE 80 443

# Caddy会自动启动

