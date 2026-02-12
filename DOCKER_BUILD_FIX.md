# Docker 构建修复指南

## 问题描述

GitHub Actions 构建失败，错误信息：
```
ERROR: failed to build: failed to solve: process "/bin/sh -c composer install..." did not complete successfully: exit code: 1
```

## 原因分析

1. **缺少 composer.lock 文件**：没有锁定依赖版本，导致每次构建可能拉取不同版本
2. **dev-master 依赖**：`composer.json` 中有不稳定的 dev 版本依赖
3. **网络问题**：GitHub Actions 访问某些 Composer 仓库可能不稳定
4. **内存限制**：某些依赖安装需要较多内存

## 解决方案

### 步骤1: 从服务器获取 composer.lock

服务器上的容器已经成功安装了所有依赖，我们需要复制 `composer.lock` 文件。

**在本地 PowerShell 执行：**

```powershell
# 运行自动化脚本
.\get-composer-lock.ps1
```

**或者手动执行：**

```powershell
# 1. 从容器复制到服务器
ssh root@8.212.40.70 "docker cp ecex-backend:/var/www/html/composer.lock /tmp/composer.lock"

# 2. 下载到本地
scp root@8.212.40.70:/tmp/composer.lock e:\ecex\server\composer.lock

# 3. 验证文件
cat server/composer.lock | Select-Object -First 20
```

### 步骤2: 验证修改

已经完成的修改：

1. ✅ **优化 composer.json**
   - 改为 `"minimum-stability": "stable"`
   - 添加 `"prefer-stable": true`
   - 修复 `yiisoft/yii2-redis` 版本（从 `2.0.x-dev` 改为 `~2.0.0`）
   - 添加优化配置

2. ✅ **优化 Dockerfile**
   - 先复制 `composer.json` 和 `composer.lock`，利用 Docker 缓存
   - 添加更详细的错误日志
   - 配置使用阿里云镜像源
   - 如果没有 `composer.lock`，自动生成

### 步骤3: 提交并推送

```bash
# 添加所有修改
git add server/composer.json server/composer.lock server/Dockerfile

# 提交
git commit -m "修复Docker构建: 添加composer.lock并优化配置"

# 推送
git push origin main
```

### 步骤4: 监控构建

访问 GitHub Actions 查看构建进度：
```
https://github.com/ecex-hub/ecex/actions
```

## 如果构建仍然失败

### 方案A: 检查具体错误

1. 查看 GitHub Actions 日志
2. 找到具体失败的依赖包
3. 在 `composer.json` 中锁定该包的版本

### 方案B: 使用多阶段构建缓存

在 `.github/workflows/build-and-push.yml` 中添加缓存：

```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v2
  with:
    buildkitd-flags: --debug

- name: Cache Docker layers
  uses: actions/cache@v3
  with:
    path: /tmp/.buildx-cache
    key: ${{ runner.os }}-buildx-${{ github.sha }}
    restore-keys: |
      ${{ runner.os }}-buildx-
```

### 方案C: 增加构建内存

在 Dockerfile 中添加：

```dockerfile
# 增加 PHP 内存限制
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory.ini
```

### 方案D: 使用预构建的 vendor 目录

如果以上方案都失败，可以：

1. 在服务器上打包 vendor 目录
2. 上传到 GitHub Release
3. 在 Dockerfile 中下载并解压

## 验证构建成功

构建成功后，镜像会推送到：
```
ghcr.io/ecex-hub/ecex/backend:latest
ghcr.io/ecex-hub/ecex/frontend:latest
```

可以在服务器上测试：

```bash
# 拉取新镜像
docker pull ghcr.io/ecex-hub/ecex/backend:latest

# 重启容器
docker-compose down
docker-compose up -d

# 检查日志
docker-compose logs -f backend
```

## 常见问题

### Q1: composer.lock 文件太大怎么办？

A: 这是正常的，`composer.lock` 文件通常有几百 KB 到几 MB。Git 可以处理。

### Q2: 为什么不直接提交 vendor 目录？

A: 
- vendor 目录通常有几十到几百 MB
- 会让仓库变得非常臃肿
- 违反最佳实践
- GitHub 有文件大小限制

### Q3: 如果服务器上的容器也没有 composer.lock 怎么办？

A: 在服务器容器内生成：

```bash
docker exec -it ecex-backend bash
cd /var/www/html
composer update --no-interaction
exit

# 然后复制出来
docker cp ecex-backend:/var/www/html/composer.lock /tmp/composer.lock
```

## 参考资料

- [Composer 文档](https://getcomposer.org/doc/)
- [Docker 多阶段构建](https://docs.docker.com/build/building/multi-stage/)
- [GitHub Actions 缓存](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)

