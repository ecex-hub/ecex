# 📚 GitHub仓库创建和Docker镜像推送完整教程

## 目录
1. [创建GitHub账号](#1-创建github账号)
2. [创建新仓库](#2-创建新仓库)
3. [配置本地Git](#3-配置本地git)
4. [推送代码到GitHub](#4-推送代码到github)
5. [创建Personal Access Token](#5-创建personal-access-token)
6. [配置GitHub Actions Secrets](#6-配置github-actions-secrets)
7. [验证自动构建](#7-验证自动构建)
8. [服务器拉取镜像](#8-服务器拉取镜像)

---

## 1. 创建GitHub账号

如果已有账号，跳过此步骤。

1. 访问 https://github.com
2. 点击右上角 **"Sign up"**
3. 填写信息：
   - Email address: 你的邮箱
   - Password: 设置密码
   - Username: 用户名（建议使用英文）
4. 验证邮箱
5. 完成注册

---

## 2. 创建新仓库

### 步骤：

1. **登录GitHub**
2. **点击右上角 "+" → "New repository"**

3. **填写仓库信息：**
   ```
   Repository name: ecex
   Description: ECEX股票交易系统 - Vue3 + Yii2 + Docker + Caddy
   
   ⚪ Public  (公开，任何人可见)
   ⚪ Private (私有，只有你可见)
   
   ❌ 不要勾选 "Add a README file"
   ❌ 不要勾选 "Add .gitignore"
   ❌ 不要勾选 "Choose a license"
   ```

4. **点击 "Create repository"**

5. **记录仓库URL：**
   ```
   https://github.com/YOUR_USERNAME/ecex.git
   ```

---

## 3. 配置本地Git

打开PowerShell，在 `e:\ecex` 目录下执行：

```powershell
# 配置用户信息（首次使用Git需要）
git config --global user.name "你的名字"
git config --global user.email "你的邮箱@example.com"

# 查看配置
git config --global --list
```

**示例：**
```powershell
git config --global user.name "Zhang San"
git config --global user.email "zhangsan@example.com"
```

---

## 4. 推送代码到GitHub

### 方法1：使用自动化脚本（推荐）

```powershell
# 在项目根目录执行
.\setup-github.ps1
```

脚本会引导你完成所有步骤。

### 方法2：手动执行命令

```powershell
# 1. 初始化Git仓库（如果还没初始化）
git init

# 2. 添加所有文件
git add .

# 3. 查看状态（可选）
git status

# 4. 提交到本地仓库
git commit -m "Initial commit: 添加Docker容器化配置，使用Caddy Web Server"

# 5. 添加远程仓库（替换YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/ecex.git

# 6. 推送到GitHub
git branch -M main
git push -u origin main
```

**⚠️ 推送时会提示输入凭据：**
- Username: 你的GitHub用户名
- Password: **Personal Access Token**（不是GitHub密码！）

如果还没有Token，继续下一步。

---

## 5. 创建Personal Access Token

GitHub已不支持密码推送，必须使用Token。

### 步骤：

1. **登录GitHub**
2. **点击右上角头像 → Settings**
3. **左侧菜单滚动到最下方 → Developer settings**
4. **Personal access tokens → Tokens (classic)**
5. **点击 "Generate new token" → "Generate new token (classic)"**

6. **填写Token信息：**
   ```
   Note: ECEX Docker Push
   Expiration: 90 days (或 No expiration)
   
   勾选权限：
   ✅ repo (完整仓库访问权限)
   ✅ write:packages (推送Docker镜像)
   ✅ read:packages (读取Docker镜像)
   ✅ delete:packages (删除Docker镜像)
   ```

7. **点击 "Generate token"**

8. **⚠️ 立即复制Token！**
   ```
   ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
   **这个Token只显示一次，请妥善保存！**

### 使用Token推送：

```powershell
git push -u origin main

# 提示输入：
Username: 你的GitHub用户名
Password: 粘贴刚才复制的Token
```

---

## 6. 配置GitHub Actions Secrets

为了让GitHub Actions自动构建Docker镜像，需要配置密钥。

### 步骤：

1. **进入你的GitHub仓库页面**
   ```
   https://github.com/YOUR_USERNAME/ecex
   ```

2. **点击 "Settings" 标签**

3. **左侧菜单 → Secrets and variables → Actions**

4. **点击 "New repository secret"**

5. **添加密钥：**
   ```
   Name: GHCR_TOKEN
   Secret: 粘贴你的Personal Access Token
   ```

6. **点击 "Add secret"**

✅ 配置完成！

---

## 7. 验证自动构建

推送代码后，GitHub Actions会自动运行。

### 查看构建状态：

1. **进入仓库页面**
   ```
   https://github.com/YOUR_USERNAME/ecex
   ```

2. **点击 "Actions" 标签**

3. **应该看到两个工作流正在运行：**
   - 🔄 Build and Push Frontend Docker Image
   - 🔄 Build and Push Backend Docker Image

4. **点击工作流查看详细日志**

5. **等待构建完成（约5-10分钟）**
   - ✅ 绿色勾号 = 成功
   - ❌ 红色叉号 = 失败（点击查看错误日志）

### 查看Docker镜像：

构建成功后：

1. **进入仓库主页**
2. **右侧 "Packages" 区域**
3. **应该看到：**
   - `frontend` 镜像
   - `backend` 镜像

或访问：
```
https://github.com/YOUR_USERNAME?tab=packages
```

---

## 8. 服务器拉取镜像

### 前提条件：

服务器需要安装：
- Docker
- Docker Compose

### 步骤：

#### 1. 登录GitHub Container Registry

```bash
# 在服务器上执行
echo "YOUR_TOKEN" | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

**示例：**
```bash
echo "ghp_xxxxxxxxxxxx" | docker login ghcr.io -u zhangsan --password-stdin
```

#### 2. 拉取代码

```bash
git clone https://github.com/YOUR_USERNAME/ecex.git
cd ecex
```

#### 3. 部署前端

```bash
cd vue
cp .env.example .env
nano .env  # 修改后端API地址

# 使用生产环境配置
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

#### 4. 部署后端

```bash
cd ../server
cp .env.example .env
nano .env  # 修改数据库密码

# 使用生产环境配置
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

#### 5. 查看运行状态

```bash
docker-compose ps
docker-compose logs -f
```

---

## 🎯 快速命令参考

### 本地开发

```powershell
# 初始化并推送
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/ecex.git
git push -u origin main
```

### 后续更新

```powershell
# 修改代码后
git add .
git commit -m "更新说明"
git push
```

### 服务器部署

```bash
# 拉取最新镜像并重启
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

---

## ❓ 常见问题

### Q1: 推送时提示 "Authentication failed"

**A:** 密码应该使用Personal Access Token，不是GitHub密码。

### Q2: GitHub Actions构建失败

**A:** 检查：
1. GHCR_TOKEN是否正确配置
2. Token权限是否包含 `write:packages`
3. 查看Actions日志了解具体错误

### Q3: 服务器拉取镜像失败

**A:** 检查：
1. 是否已登录 `docker login ghcr.io`
2. 镜像名称是否正确
3. 仓库是否为Private（需要登录）

### Q4: 如何更新服务器上的代码？

**A:** 
```bash
# 拉取最新镜像
docker-compose -f docker-compose.prod.yml pull
# 重启容器
docker-compose -f docker-compose.prod.yml up -d
```

---

## 📞 需要帮助？

- [GitHub文档](https://docs.github.com)
- [Docker文档](https://docs.docker.com)
- [Caddy文档](https://caddyserver.com/docs/)

---

**🎉 恭喜！你已经掌握了GitHub仓库创建和Docker镜像推送的完整流程！**

