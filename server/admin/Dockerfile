# 管理后台 Dockerfile - ThinkPHP FastAdmin
# 基于 PHP 7.4-fpm-alpine + Nginx + Supervisor
FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

# 安装系统依赖
RUN apk add --no-cache \
    nginx \
    supervisor \
    zip \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    icu-dev \
    oniguruma-dev \
    autoconf \
    g++ \
    make

# 安装 PHP 扩展
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mysqli \
    mbstring \
    zip \
    gd \
    intl \
    opcache \
    bcmath

# 安装 Redis 扩展
RUN pecl install redis-5.3.7 \
    && docker-php-ext-enable redis

# 复制应用代码
COPY . /var/www/html

# 删除容器内的 .env 文件（使用环境变量替代）
RUN rm -f /var/www/html/.env

# 创建必要的目录（runtime 和 uploads 被 .gitignore 排除，需要手动创建）
RUN mkdir -p /var/www/html/runtime/cache \
    && mkdir -p /var/www/html/runtime/log \
    && mkdir -p /var/www/html/runtime/temp \
    && mkdir -p /var/www/html/public/uploads

# 设置权限（只对需要写入的目录设置 www-data 所有权）
RUN chmod -R 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html/runtime \
    && chmod -R 777 /var/www/html/runtime \
    && chown -R www-data:www-data /var/www/html/public/uploads \
    && chmod -R 777 /var/www/html/public/uploads

# 创建 Nginx 日志目录和临时目录
RUN rm -rf /var/lib/nginx/logs \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/lib/nginx/tmp/client_body \
    && ln -sf /var/log/nginx /var/lib/nginx/logs \
    && chown -R nginx:nginx /var/log/nginx /var/lib/nginx

# 复制 Nginx 配置
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf

# 复制 PHP 配置
COPY docker/php/php.ini /usr/local/etc/php/php.ini

# 复制 Supervisor 配置
COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

# 暴露端口
EXPOSE 80

# 启动 Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

