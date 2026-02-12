# 🚀 快速参考卡片

## 📋 一、首次推送到GitHub

### 使用自动化脚本（推荐）
```powershell
.\setup-github.ps1
```

### 手动执行
```powershell
# 1. 配置Git
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

# 2. 初始化并推送
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/ecex.git
git push -u origin main
```

---

## 🔑 二、创建Personal Access Token

1. GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. Generate new token (classic)
4. 勾选权限：
   - ✅ `repo`
   - ✅ `write:packages`
   - ✅ `read:packages`
5. 复制Token（只显示一次！）

---

## 🔐 三、配置GitHub Secrets

1. 仓库 → Settings → Secrets and variables → Actions
2. New repository secret
3. Name: `GHCR_TOKEN`
4. Secret: 粘贴Token
5. Add secret

---

## 🐳 四、服务器拉取镜像

### 登录GitHub Container Registry
```bash
echo "YOUR_TOKEN" | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

### 部署前端
```bash
cd vue
cp .env.example .env
nano .env  # 修改 VITE_API_BASE_URL

docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

### 部署后端
```bash
cd server
cp .env.example .env
nano .env  # 修改 DB_PASSWORD

docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

---

## 🔄 五、日常更新流程

### 本地修改代码后
```powershell
git add .
git commit -m "更新说明"
git push
```

### 服务器更新
```bash
# 拉取最新镜像
docker-compose -f docker-compose.prod.yml pull

# 重启服务
docker-compose -f docker-compose.prod.yml up -d

# 查看日志
docker-compose logs -f
```

---

## 🛠️ 六、常用命令

### Git命令
```powershell
git status              # 查看状态
git log                 # 查看提交历史
git remote -v           # 查看远程仓库
git branch              # 查看分支
```

### Docker命令
```bash
docker ps               # 查看运行中的容器
docker images           # 查看镜像
docker-compose ps       # 查看服务状态
docker-compose logs -f  # 查看日志
docker-compose down     # 停止服务
docker-compose up -d    # 启动服务
```

---

## 📊 七、镜像地址

构建成功后，镜像地址为：

**前端：**
```
ghcr.io/YOUR_USERNAME/ecex/frontend:latest
```

**后端：**
```
ghcr.io/YOUR_USERNAME/ecex/backend:latest
```

---

## ⚠️ 八、注意事项

1. **Token安全**
   - 不要提交到代码仓库
   - 不要分享给他人
   - 定期更换

2. **环境变量**
   - `.env` 文件不要提交到Git
   - 每个服务器单独配置

3. **端口开放**
   - 前端：80, 443
   - 后端：8080（内网）

4. **数据备份**
   - 定期备份MySQL数据
   - 定期备份Redis数据

---

## 🔍 九、故障排查

### GitHub Actions失败
```
1. 查看Actions日志
2. 检查GHCR_TOKEN配置
3. 检查Dockerfile语法
```

### 服务器拉取失败
```bash
# 重新登录
docker logout ghcr.io
echo "YOUR_TOKEN" | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# 清理缓存
docker system prune -a
```

### 容器启动失败
```bash
# 查看日志
docker-compose logs

# 检查端口占用
netstat -tulpn | grep :80
netstat -tulpn | grep :8080
```

---

## 📞 十、获取帮助

- **详细教程**: [GITHUB_SETUP_GUIDE.md](./GITHUB_SETUP_GUIDE.md)
- **部署文档**: [DEPLOYMENT.md](./DEPLOYMENT.md)
- **架构说明**: [ARCHITECTURE.md](./ARCHITECTURE.md)
- **Caddy迁移**: [CADDY_MIGRATION.md](./CADDY_MIGRATION.md)

---

**💡 提示：将此文件保存为书签，方便随时查阅！**

