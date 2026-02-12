import axios from 'axios'
import { showToast, showDialog } from 'vant'
import { config, STORAGE_KEYS, HTTP_STATUS, BUSINESS_CODE } from '@/config'
import router from '@/router'

// 创建 axios 实例
const service = axios.create({
  baseURL: config.baseURL,
  timeout: config.timeout,
  headers: {
    'Content-Type': 'application/json;charset=UTF-8'
  }
})

// 请求拦截器
service.interceptors.request.use(
  (config) => {
    // 从本地存储获取 token
    const token = localStorage.getItem(STORAGE_KEYS.TOKEN)
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    
    // 开发环境打印请求信息
    if (config.debug) {
      console.log('请求:', config.method?.toUpperCase(), config.url, config.data || config.params)
    }
    
    return config
  },
  (error) => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  (response) => {
    const res = response.data
    
    // 开发环境打印响应信息
    if (config.debug) {
      console.log('响应:', response.config.url, res)
    }
    
    // 如果响应数据是二进制流（如下载文件），直接返回
    if (response.config.responseType === 'blob') {
      return response
    }
    
    // 根据业务状态码处理
    if (res.code !== undefined) {
      // 业务成功：后端返回 code: 200 表示成功
      if (res.code === HTTP_STATUS.SUCCESS || res.code === BUSINESS_CODE.SUCCESS) {
        return res
      }
      
      // token 过期或未登录
      if (res.code === HTTP_STATUS.UNAUTHORIZED) {
        showDialog({
          title: '提示',
          message: '登录已过期，请重新登录',
        }).then(() => {
          // 清除本地存储
          localStorage.removeItem(STORAGE_KEYS.TOKEN)
          localStorage.removeItem(STORAGE_KEYS.USER_INFO)
          // 跳转到登录页
          router.push('/login')
        })
        return Promise.reject(new Error(res.message || '登录已过期'))
      }
      
      // 其他业务错误（后端返回非 200 的状态码）
      const message = res.message || '请求失败'
      // 使用 setTimeout 确保 toast 能正常显示，避免被后续的 closeToast 关闭
      setTimeout(() => {
        showToast({
          message: message,
          duration:1000 // 显示 3 秒
        })
      }, 1000)
      return Promise.reject(new Error(message))
    }
    
    // 如果没有 code 字段，直接返回数据
    return res
  },
  (error) => {
    console.error('响应错误:', error)
    
    let message = '网络错误，请稍后重试'
    
    if (error.response) {
      const { status, data } = error.response
      
      switch (status) {
        case HTTP_STATUS.UNAUTHORIZED:
          message = '未授权，请重新登录'
          localStorage.removeItem(STORAGE_KEYS.TOKEN)
          localStorage.removeItem(STORAGE_KEYS.USER_INFO)
          router.push('/login')
          break
        case HTTP_STATUS.FORBIDDEN:
          message = '拒绝访问'
          break
        case HTTP_STATUS.NOT_FOUND:
          message = '请求地址不存在'
          break
        case HTTP_STATUS.SERVER_ERROR:
          message = '服务器错误'
          break
        default:
          message = data?.message || `请求失败 ${status}`
      }
    } else if (error.request) {
      message = '网络连接失败，请检查网络'
    } else {
      message = error.message || '请求失败'
    }
    
    // 使用 setTimeout 确保 toast 能正常显示，避免被后续的 closeToast 关闭
    setTimeout(() => {
      showToast({
        message: message,
        duration: 3000 // 显示 3 秒
      })
    }, 100)
    return Promise.reject(error)
  }
)

export default service
