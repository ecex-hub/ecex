# 移动端应用

基于 Vue 3 + Vite + Vant 构建的移动端网页应用

## 功能模块

- ✅ 首页 - 展示主要功能和新闻资讯
- ✅ 登录/注册 - 用户认证功能
- ✅ 身份认证/实名认证 - 用户身份验证
- ✅ 充值/提现 - 金融交易功能
- ✅ 我的团队 - 团队管理
- ✅ 积分商城 - 积分兑换商品
- ✅ 新闻资讯 - 资讯浏览
- ✅ 个人中心 - 用户信息和工具

## 技术栈

- **Vue 3** - 渐进式 JavaScript 框架
- **Vite** - 下一代前端构建工具
- **Vant** - 轻量、可靠的移动端 Vue 组件库
- **Vue Router** - 官方路由管理器
- **Pinia** - 新一代状态管理库
- **Axios** - HTTP 客户端

## 项目结构

```
mobile/
├── src/
│   ├── api/              # API 接口定义
│   │   └── index.js      # 所有 API 接口
│   ├── composables/      # 组合式函数
│   │   ├── useAuth.js    # 认证相关
│   │   └── useWallet.js  # 钱包相关
│   ├── config/           # 配置文件
│   │   └── index.js      # 全局配置
│   ├── stores/           # Pinia 状态管理
│   │   ├── index.js      # Pinia 实例
│   │   ├── user.js       # 用户状态
│   │   └── wallet.js     # 钱包状态
│   ├── utils/            # 工具函数
│   │   ├── request.js    # Axios 封装
│   │   ├── storage.js    # 本地存储工具
│   │   └── index.js      # 通用工具函数
│   ├── router/           # 路由配置
│   │   ├── index.js      # 路由定义
│   │   └── guard.js      # 路由守卫
│   ├── views/            # 页面组件
│   ├── layouts/          # 布局组件
│   ├── styles/           # 全局样式
│   ├── App.vue           # 根组件
│   └── main.js           # 入口文件
├── img/                  # 图片资源
├── prototype/            # 原型图
├── index.html            # HTML 模板
├── vite.config.js        # Vite 配置
└── package.json          # 项目配置
```

## 快速开始

### 安装依赖

```bash
npm install
```

### 环境配置

创建 `.env.development` 文件（开发环境）：

```env
VITE_API_BASE_URL=http://localhost:8080/api
```

创建 `.env.production` 文件（生产环境）：

```env
VITE_API_BASE_URL=https://api.example.com/api
```

### 开发运行

```bash
npm run dev
```

应用将在 `http://localhost:3000` 启动

### 构建生产版本

```bash
npm run build
```

### 预览生产构建

```bash
npm run preview
```

## 核心功能说明

### 1. 网络请求

使用 Axios 封装了统一的请求方法，包含：
- 请求/响应拦截器
- Token 自动添加
- 错误统一处理
- 加载状态管理

```javascript
import { userApi } from '@/api'

// 使用示例
const res = await userApi.login({ account, password })
```

### 2. 状态管理

使用 Pinia 进行状态管理，包含：
- 用户状态（登录、用户信息）
- 钱包状态（余额、交易记录）

```javascript
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
await userStore.login(loginData)
```

### 3. 路由守卫

自动处理登录状态检查，未登录用户自动跳转到登录页。

### 4. 工具函数

提供常用的工具函数：
- 日期格式化
- 金额格式化
- 手机号/身份证号格式化
- 防抖/节流
- 表单验证

### 5. 组合式函数

封装了常用的业务逻辑：
- `useAuth` - 认证相关操作
- `useWallet` - 钱包相关操作

## API 接口说明

所有 API 接口定义在 `src/api/index.js` 中，包括：

- **用户相关** (`userApi`): 登录、注册、获取用户信息等
- **认证相关** (`authApi`): 身份认证、实名认证等
- **钱包相关** (`walletApi`): 充值、提现、交易明细等
- **团队相关** (`teamApi`): 团队统计、成员列表等
- **商城相关** (`mallApi`): 积分信息、商品列表、兑换等
- **新闻相关** (`newsApi`): 新闻列表、详情等
- **文件上传** (`uploadApi`): 文件上传功能

## 页面路由

- `/` - 首页（默认）
- `/home` - 首页
- `/zone` - 助华专区
- `/profile` - 个人中心
- `/login` - 登录
- `/register` - 注册
- `/identity` - 身份认证
- `/realname` - 实名认证
- `/recharge` - 充值
- `/withdraw` - 提现
- `/team` - 我的团队
- `/mall` - 积分商城
- `/news` - 新闻资讯

## 注意事项

1. 本项目为移动端网页，建议在移动设备或浏览器开发者工具的移动模式下查看
2. 需要配置后端 API 地址（通过环境变量）
3. 部分功能需要后端 API 支持，目前为前端演示版本
4. 图片资源路径需要根据实际情况调整
5. Token 存储在 localStorage 中，实际项目中建议使用更安全的存储方式

## 浏览器支持

现代浏览器和移动端浏览器（iOS Safari、Chrome Mobile 等）
