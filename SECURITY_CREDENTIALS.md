# 🔐 安全凭据配置说明

## ⚠️ 重要安全提示

**本项目已移除所有硬编码的敏感信息,改为使用环境变量管理。**

---

## 📋 需要配置的环境变量

### 1. 阿里云短信服务

在生产环境中,需要设置以下环境变量:

```bash
# 阿里云AccessKey ID
ALIYUN_ACCESS_KEY_ID=your_actual_access_key_id

# 阿里云AccessKey Secret
ALIYUN_ACCESS_KEY_SECRET=your_actual_access_key_secret
```

**获取方式:**
1. 登录阿里云控制台: https://ak-console.aliyun.com/
2. 创建或查看AccessKey
3. 复制AccessKey ID和AccessKey Secret

---

## 🚀 部署配置

### Docker部署

在 `server/.env` 文件中配置:

```env
# 阿里云短信服务配置
ALIYUN_ACCESS_KEY_ID=your_actual_access_key_id_here
ALIYUN_ACCESS_KEY_SECRET=your_actual_access_key_secret_here
```

**注意:** `.env` 文件已在 `.gitignore` 中,不会被提交到Git仓库。

### 服务器环境变量

也可以在服务器上直接设置环境变量:

```bash
# 临时设置(当前会话)
export ALIYUN_ACCESS_KEY_ID="your_key_id"
export ALIYUN_ACCESS_KEY_SECRET="your_key_secret"

# 永久设置(添加到 ~/.bashrc 或 ~/.profile)
echo 'export ALIYUN_ACCESS_KEY_ID="your_key_id"' >> ~/.bashrc
echo 'export ALIYUN_ACCESS_KEY_SECRET="your_key_secret"' >> ~/.bashrc
source ~/.bashrc
```

---

## 🔒 安全最佳实践

### 1. 不要提交敏感信息到Git

✅ **正确做法:**
- 使用环境变量
- 使用 `.env` 文件(确保在 `.gitignore` 中)
- 使用密钥管理服务(如AWS Secrets Manager、阿里云KMS)

❌ **错误做法:**
- 硬编码在代码中
- 提交到Git仓库
- 在公开文档中暴露

### 2. 定期轮换密钥

- 建议每3-6个月更换一次AccessKey
- 如果密钥泄露,立即在阿里云控制台禁用并重新生成

### 3. 最小权限原则

- 只授予必要的权限
- 为不同环境使用不同的AccessKey
- 生产环境和测试环境分离

---

## 📝 相关文件

- `server/common/models/SendSMS.php` - 短信发送类(已修改为读取环境变量)
- `server/.env` - 环境变量配置文件(不提交到Git)
- `server/.env.example` - 环境变量模板(可以提交到Git)

---

## 🆘 如果密钥已泄露

1. **立即禁用泄露的AccessKey**
   - 登录阿里云控制台
   - 找到对应的AccessKey
   - 点击"禁用"或"删除"

2. **生成新的AccessKey**
   - 创建新的AccessKey
   - 更新所有使用该密钥的服务

3. **检查是否有异常使用**
   - 查看阿里云账单
   - 检查短信发送记录
   - 查看API调用日志

4. **更新Git历史(如果已提交)**
   ```bash
   # 使用BFG Repo-Cleaner清理Git历史
   # 或者重新创建仓库
   ```

---

## 📞 联系方式

如有安全问题,请联系项目管理员。

**记住:安全无小事,保护好你的密钥!** 🔐

