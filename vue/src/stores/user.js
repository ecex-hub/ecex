import { defineStore } from 'pinia'
import { userApi } from '@/api'
import storage from '@/utils/storage'
import { STORAGE_KEYS } from '@/config'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: storage.getToken() || '',
    userInfo: storage.getUserInfo() || null,
    isLoggedIn: false
  }),

  getters: {
    // 是否已登录
    loggedIn: (state) => !!state.token,
    
    // 用户昵称
    nickname: (state) => state.userInfo?.nickname || '',
    
    // 用户ID
    userId: (state) => state.userInfo?.id || '',
    
    // 用户等级
    userLevel: (state) => state.userInfo?.level || ''
  },

  actions: {
    // 设置 token
    setToken(token) {
      this.token = token
      storage.setToken(token)
    },

    // 设置用户信息
    setUserInfo(userInfo) {
      this.userInfo = userInfo
      storage.setUserInfo(userInfo)
      this.isLoggedIn = true
    },

    // 登录
    async login(loginData) {
      try {
        const res = await userApi.login(loginData)
        // 后端返回格式：{ code: 200, message: 'success', data: { login_token, uid, e_uid, invite_code, is_real } }
        if (res.code === 200 && res.data) {
          // 后端返回的是 login_token，需要映射为 token
          this.setToken(res.data.login_token)
          // 将后端返回的数据映射为用户信息
          this.setUserInfo({
            id: res.data.uid,
            e_uid: res.data.e_uid,
            invite_code: res.data.invite_code,
            is_real: res.data.is_real
          })
          return Promise.resolve(res)
        }
        return Promise.reject(res)
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 注册
    async register(registerData) {
      try {
        const res = await userApi.register(registerData)
        // 后端返回格式：{ code: 200, message: 'success', data: { login_token, uid, e_uid, invite_code, is_real } }
        if (res.code === 200 && res.data) {
          // 后端返回的是 login_token，需要映射为 token
          this.setToken(res.data.login_token)
          // 将后端返回的数据映射为用户信息
          this.setUserInfo({
            id: res.data.uid,
            e_uid: res.data.e_uid,
            invite_code: res.data.invite_code,
            is_real: res.data.is_real
          })
          return Promise.resolve(res)
        }
        return Promise.reject(res)
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 获取用户信息
    async fetchUserInfo() {
      try {
        const res = await userApi.getUserInfo()
        if (res.code === 0 && res.data) {
          this.setUserInfo(res.data)
          return Promise.resolve(res)
        }
        return Promise.reject(res)
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 退出登录
    async logout() {
      try {
        await userApi.logout()
      } catch (error) {
        console.error('退出登录失败:', error)
      } finally {
        this.token = ''
        this.userInfo = null
        this.isLoggedIn = false
        storage.removeToken()
        storage.removeUserInfo()
      }
    },

    // 清除用户信息
    clearUserInfo() {
      this.token = ''
      this.userInfo = null
      this.isLoggedIn = false
      storage.removeToken()
      storage.removeUserInfo()
    }
  }
})
