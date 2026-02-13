# 前端 Dockerfile - 多阶段构建
# 阶段 1: 构建 Vue 应用
FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package 文件
COPY package*.json ./

# 设置 npm 镜像源（淘宝镜像）
RUN npm config set registry https://registry.npmmirror.com

# 安装依赖（使用精确版本）
RUN npm ci --legacy-peer-deps

# 复制源代码
COPY . .

# 构建生产版本
RUN npm run build

# 阶段 2: 使用 Caddy 服务静态文件和反向代理
FROM caddy:2-alpine

# 复制构建产物
COPY --from=builder /app/dist /usr/share/caddy

# 复制 Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# 暴露端口
EXPOSE 80 443

# Caddy 会自动使用 /etc/caddy/Caddyfile
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]

