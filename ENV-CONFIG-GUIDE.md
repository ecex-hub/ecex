# 环境变量配置指南

## 📋 配置文件清单

已为你创建了以下配置文件:

### 部署配置文件 (服务器上使用)
1. **`deploy/backend/.env`** - 后端服务器部署配置
2. **`deploy/frontend/.env`** - 前端服务器部署配置

### 应用配置文件 (打包到 Docker 镜像中)
3. **`server/.env.production`** - 后端应用生产环境配置
4. **`vue/.env.production`** - 前端应用生产环境配置

---

## ⚠️ 必须修改的配置项

### 1. GitHub Token (所有文件)

**需要修改的文件**:
- `deploy/backend/.env`
- `deploy/frontend/.env`

**修改项**:
```bash
GITHUB_TOKEN=ghp_your_token_here_replace_this
```

**替换为**: 你在 https://github.com/settings/tokens 创建的 Token (名为 `ecex_test`)

**如何获取**:
1. 访问 https://github.com/settings/tokens
2. 找到 `ecex_test` Token
3. 如果看不到 Token 内容,点击 "Regenerate token"
4. 复制生成的 Token (以 `ghp_` 开头)
5. 替换配置文件中的 `ghp_your_token_here_replace_this`

---

### 2. 后端服务器内网 IP (前端配置)

**需要修改的文件**:
- `deploy/frontend/.env`

**修改项**:
```bash
BACKEND_HOST=172.16.0.100:8080
```

**替换为**: 后端服务器的实际内网 IP 地址

**如何获取后端服务器内网 IP**:
1. SSH 登录到后端服务器
2. 运行命令: `ip addr show` 或 `ifconfig`
3. 找到内网 IP (通常是 `172.x.x.x` 或 `192.168.x.x` 或 `10.x.x.x`)
4. 格式: `内网IP:8080` (端口固定为 8080)

**示例**:
```bash
BACKEND_HOST=172.16.0.100:8080
BACKEND_HOST=192.168.1.100:8080
BACKEND_HOST=10.0.0.100:8080
```

---

### 3. 前端域名 (后端配置)

**需要修改的文件**:
- `server/.env.production`

**修改项**:
```bash
FRONTEND_URL=https://your-domain.com
```

**替换为**: 你的实际域名

**示例**:
```bash
FRONTEND_URL=https://ecex.example.com
FRONTEND_URL=https://www.ecex.com
```

---

## 🔐 密码配置 (已预设强密码)

以下密码已经预设为强密码,你可以直接使用,也可以修改为自己的密码:

### MySQL 数据库密码
```bash
DB_PASSWORD=EcEx@MySQL#2026!Prod$Secure
```

**位置**:
- `deploy/backend/.env` (第13行)
- `server/.env.production` (第13行)

⚠️ **重要**: 这两个文件中的密码必须一致!

### Redis 密码
```bash
REDIS_PASSWORD=EcEx@Redis#2026!Cache$Strong
```

**位置**:
- `deploy/backend/.env` (第17行)
- `server/.env.production` (第19行)

⚠️ **重要**: 这两个文件中的密码必须一致!

### JWT 密钥
```bash
JWT_SECRET=EcEx@JWT#Secret$2026!ProductionKey@Secure#Random
```

**位置**:
- `server/.env.production` (第26行)

---

## 📝 可选配置项

### 支付配置 (如需使用支付功能)

**文件**: `server/.env.production`

#### 支付宝配置
```bash
ALIPAY_APP_ID=你的支付宝应用ID
ALIPAY_PUBLIC_KEY=支付宝公钥
ALIPAY_PRIVATE_KEY=你的应用私钥
```

#### 微信支付配置
```bash
WECHAT_APP_ID=你的微信应用ID
WECHAT_MCH_ID=你的微信商户号
WECHAT_KEY=你的微信支付密钥
```

---

## 🔄 配置文件同步

### 密码必须保持一致的配置项

| 配置项 | 文件1 | 文件2 |
|--------|-------|-------|
| MySQL密码 | `deploy/backend/.env` | `server/.env.production` |
| Redis密码 | `deploy/backend/.env` | `server/.env.production` |
| GitHub Token | `deploy/backend/.env` | `deploy/frontend/.env` |

---

## ✅ 配置检查清单

部署前请确认:

- [ ] 已将 `GITHUB_TOKEN` 替换为实际的 Token (4个文件)
- [ ] 已将 `BACKEND_HOST` 替换为后端服务器实际内网 IP
- [ ] 已将 `FRONTEND_URL` 替换为实际域名
- [ ] MySQL 密码在两个文件中一致
- [ ] Redis 密码在两个文件中一致
- [ ] (可选) 如需支付功能,已配置支付参数

---

## 🚀 下一步

配置完成后:

1. **提交配置文件到 Git** (可选,建议不提交 .env 文件到公开仓库)
2. **重新构建 Docker 镜像** (因为 `.env.production` 文件会打包到镜像中)
3. **按照 QUICK-START.md 开始部署**

---

## 🔒 安全提示

1. ⚠️ **不要将 `.env` 文件提交到公开的 Git 仓库**
2. ⚠️ **定期更换密码和密钥**
3. ⚠️ **GitHub Token 只授予必要的权限**
4. ⚠️ **生产环境使用强密码** (至少16位,包含大小写字母、数字、特殊字符)

