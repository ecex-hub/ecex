# 使用官方PHP 8.1 FPM镜像作为基础镜像
FROM php:8.1-fpm

# 设置工作目录
WORKDIR /var/www/html

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# 安装PHP扩展
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# 安装Redis扩展
RUN pecl install redis-5.3.7 \
    && docker-php-ext-enable redis

# 安装Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 安装Caddy
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt-get update \
    && apt-get install -y caddy \
    && rm -rf /var/lib/apt/lists/*

# 复制应用代码
COPY . /var/www/html

# 设置权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 安装PHP依赖
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 初始化Yii环境为生产环境（非交互式）
RUN php init --env=Production --overwrite=All <<< "yes"

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

# 启动Supervisor（管理Caddy和PHP-FPM）
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

