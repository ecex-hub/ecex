# 后端 Dockerfile - 基于 PHP 7.4
# 生产环境 Docker 镜像
FROM php:7.4-fpm-alpine

# 设置工作目录
WORKDIR /var/www/html

# 安装系统依赖
RUN apk add --no-cache \
    nginx \
    supervisor \
    git \
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
    make \
    openssl-dev \
    pcre-dev

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

# 安装 Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# 复制应用代码
COPY . /var/www/html

# 设置 Composer 镜像源（阿里云）
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# 安装依赖（生产环境优化）
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# 初始化 Yii2 环境（生产环境）
RUN php init --env=Production --overwrite=All

# 设置权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/backend/runtime \
    && chmod -R 777 /var/www/html/backend/web/assets \
    && mkdir -p /var/www/html/backend/web/uploads \
    && chown -R www-data:www-data /var/www/html/backend/web/uploads \
    && chmod -R 777 /var/www/html/backend/web/uploads

# 创建 Nginx 日志目录和临时目录（worker 以 www-data 运行，需要访问权限）
RUN rm -rf /var/lib/nginx/logs \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/lib/nginx/tmp/client_body \
    && ln -sf /var/log/nginx /var/lib/nginx/logs \
    && chmod 755 /var/lib/nginx \
    && chown -R www-data:www-data /var/lib/nginx/tmp \
    && chown -R nginx:nginx /var/log/nginx

# 复制 Nginx 配置
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf

# 复制 PHP 配置
COPY docker/php/php.ini /usr/local/etc/php/php.ini
COPY docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# 复制 Supervisor 配置
COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

# 暴露端口
EXPOSE 80

# 启动 Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

