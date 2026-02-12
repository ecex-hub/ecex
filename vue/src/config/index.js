// 环境配置
const env = import.meta.env

export const config = {
  // API 基础地址
  baseURL: env.VITE_API_BASE_URL || 'http://localhost:8080',
  
  // 请求超时时间
  timeout: 10000,
  
  // 是否开启调试
  debug: env.MODE === 'development',
  
  // 应用配置
  app: {
    name: '移动端应用',
    version: '1.0.0'
  }
}

// 存储键名
export const STORAGE_KEYS = {
  TOKEN: 'token',
  USER_INFO: 'userInfo',
  THEME: 'theme'
}

// 请求状态码
export const HTTP_STATUS = {
  SUCCESS: 200,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  SERVER_ERROR: 500
}

// 业务状态码
export const BUSINESS_CODE = {
  SUCCESS: 0,
  ERROR: -1
}
