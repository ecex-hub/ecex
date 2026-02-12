# ============================================
# 阶段1: 构建阶段
# ============================================
FROM php:8.1-fpm AS builder

# 设置工作目录
WORKDIR /var/www/html

# 安装系统依赖和PHP扩展构建工具（一次性安装）
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install -j$(nproc) pdo_mysql mbstring exif pcntl bcmath gd zip \
    && pecl install redis-5.3.7 \
    && docker-php-ext-enable redis \
    && rm -rf /var/lib/apt/lists/*

# 安装Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 复制composer文件
COPY composer.json composer.lock ./

# 配置Composer - 允许所有插件并增加超时时间
RUN composer config --global process-timeout 2000 \
    && composer config --global --no-plugins allow-plugins.yiisoft/yii2-composer true \
    && composer config --global --no-plugins allow-plugins true

# 安装PHP依赖（利用Docker缓存）
# 注意：使用--no-scripts避免运行post-install脚本
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-interaction \
    --no-scripts \
    --prefer-dist \
    --verbose \
    2>&1 | tee /tmp/composer-install.log || (cat /tmp/composer-install.log && exit 1)

# 复制应用代码
COPY . .

# 初始化Yii环境为生产环境
RUN php init --env=Production --overwrite=All --interactive=0 || true

# ============================================
# 阶段2: 生产阶段
# ============================================
FROM php:8.1-fpm

# 设置工作目录
WORKDIR /var/www/html

# 只安装运行时必需的依赖
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2 \
    libzip-dev \
    supervisor \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 从构建阶段复制PHP扩展
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# 安装Caddy
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt-get update \
    && apt-get install -y caddy \
    && rm -rf /var/lib/apt/lists/*

# 从构建阶段复制应用代码和依赖
COPY --from=builder --chown=www-data:www-data /var/www/html /var/www/html

# 复制Caddyfile配置
COPY docker/caddy/Caddyfile /etc/caddy/Caddyfile

# 复制Supervisor配置
COPY docker/supervisor/supervisord-caddy.conf /etc/supervisor/conf.d/supervisord.conf

# 创建运行时目录
RUN mkdir -p /var/www/html/backend/runtime \
    && mkdir -p /var/www/html/backend/web/assets \
    && chown -R www-data:www-data /var/www/html/backend/runtime \
    && chown -R www-data:www-data /var/www/html/backend/web/assets

# 暴露端口
EXPOSE 80 443

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# 启动Supervisor（管理Caddy和PHP-FPM）
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

