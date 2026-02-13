# GitHub Actions 权限配置指南

## 问题说明

如果你在 GitHub Actions 构建时遇到以下错误:

```
ERROR: failed to push ghcr.io/ecex-hub/ecex/frontend:main: denied: permission_denied: write_package
```

这是因为 GitHub Actions 没有权限推送到 GitHub Container Registry (ghcr.io)。

## 解决方案

### 方法 1: 启用 GitHub Actions 的 Workflow 权限（推荐）

1. **访问仓库设置**
   - 打开你的 GitHub 仓库: `https://github.com/ecex-hub/ecex`
   - 点击 **Settings** (设置)

2. **配置 Actions 权限**
   - 在左侧菜单中找到 **Actions** → **General**
   - 滚动到 **Workflow permissions** 部分
   - 选择 **Read and write permissions** (读写权限)
   - ✅ 勾选 **Allow GitHub Actions to create and approve pull requests**
   - 点击 **Save** 保存

3. **重新运行 GitHub Actions**
   - 访问 `https://github.com/ecex-hub/ecex/actions`
   - 找到失败的工作流
   - 点击 **Re-run all jobs** (重新运行所有任务)

### 方法 2: 使用 Personal Access Token (备选方案)

如果方法 1 不起作用,可以使用 Personal Access Token:

1. **创建 Personal Access Token**
   - 访问 `https://github.com/settings/tokens`
   - 点击 **Generate new token** → **Generate new token (classic)**
   - 设置名称: `GHCR_TOKEN`
   - 选择权限:
     - ✅ `write:packages` - 上传包到 GitHub Package Registry
     - ✅ `read:packages` - 从 GitHub Package Registry 下载包
     - ✅ `delete:packages` - 从 GitHub Package Registry 删除包
   - 点击 **Generate token**
   - **复制生成的 token** (只显示一次!)

2. **添加 Secret 到仓库**
   - 打开仓库: `https://github.com/ecex-hub/ecex`
   - 点击 **Settings** → **Secrets and variables** → **Actions**
   - 点击 **New repository secret**
   - Name: `GHCR_TOKEN`
   - Secret: 粘贴刚才复制的 token
   - 点击 **Add secret**

3. **修改 GitHub Actions 配置**

编辑 `.github/workflows/frontend.yml` 和 `.github/workflows/backend.yml`:

将:
```yaml
- name: Log in to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ${{ env.REGISTRY }}
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

改为:
```yaml
- name: Log in to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ${{ env.REGISTRY }}
    username: ${{ github.actor }}
    password: ${{ secrets.GHCR_TOKEN }}
```

4. **提交并推送更改**
```bash
git add .github/workflows/
git commit -m "使用 GHCR_TOKEN 进行认证"
git push origin main
```

## 验证构建状态

访问 GitHub Actions 页面查看构建状态:
```
https://github.com/ecex-hub/ecex/actions
```

成功后,你应该能看到:
- ✅ Build and Push Backend Docker Image - 成功
- ✅ Build and Push Frontend Docker Image - 成功

## 查看已发布的镜像

访问仓库的 Packages 页面:
```
https://github.com/ecex-hub/ecex/pkgs/container/ecex%2Fbackend
https://github.com/ecex-hub/ecex/pkgs/container/ecex%2Ffrontend
```

或者访问你的个人 Packages 页面:
```
https://github.com/orgs/ecex-hub/packages
```

## 常见问题

### Q: 为什么需要这些权限?
A: GitHub Container Registry 需要特定的权限才能推送 Docker 镜像。默认的 `GITHUB_TOKEN` 可能没有足够的权限。

### Q: 哪种方法更好?
A: **方法 1** 更简单,推荐优先使用。如果方法 1 不起作用,再使用方法 2。

### Q: Token 会过期吗?
A: Personal Access Token 可以设置过期时间。建议设置较长的过期时间(如 1 年),或者选择 "No expiration"(不过期)。

### Q: 如何确认权限已生效?
A: 重新运行 GitHub Actions,如果构建成功并且能在 Packages 页面看到镜像,说明权限已生效。

## 下一步

权限配置完成后,继续按照 **QUICK-START.md** 进行部署。

