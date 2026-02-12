import { STORAGE_KEYS } from '@/config'

/**
 * 本地存储工具类
 */
class Storage {
  /**
   * 设置值
   * @param {string} key 键名
   * @param {any} value 值
   */
  set(key, value) {
    try {
      const data = JSON.stringify(value)
      localStorage.setItem(key, data)
    } catch (error) {
      console.error('存储失败:', error)
    }
  }

  /**
   * 获取值
   * @param {string} key 键名
   * @param {any} defaultValue 默认值
   * @returns {any}
   */
  get(key, defaultValue = null) {
    try {
      const data = localStorage.getItem(key)
      return data ? JSON.parse(data) : defaultValue
    } catch (error) {
      console.error('读取失败:', error)
      return defaultValue
    }
  }

  /**
   * 删除值
   * @param {string} key 键名
   */
  remove(key) {
    localStorage.removeItem(key)
  }

  /**
   * 清空所有
   */
  clear() {
    localStorage.clear()
  }

  /**
   * 设置 token
   * @param {string} token
   */
  setToken(token) {
    localStorage.setItem(STORAGE_KEYS.TOKEN, token)
  }

  /**
   * 获取 token
   * @returns {string|null}
   */
  getToken() {
    return localStorage.getItem(STORAGE_KEYS.TOKEN)
  }

  /**
   * 删除 token
   */
  removeToken() {
    localStorage.removeItem(STORAGE_KEYS.TOKEN)
  }

  /**
   * 设置用户信息
   * @param {object} userInfo
   */
  setUserInfo(userInfo) {
    this.set(STORAGE_KEYS.USER_INFO, userInfo)
  }

  /**
   * 获取用户信息
   * @returns {object|null}
   */
  getUserInfo() {
    return this.get(STORAGE_KEYS.USER_INFO)
  }

  /**
   * 删除用户信息
   */
  removeUserInfo() {
    this.remove(STORAGE_KEYS.USER_INFO)
  }
}

export default new Storage()
