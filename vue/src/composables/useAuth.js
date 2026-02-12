import { computed } from 'vue'
import { useUserStore } from '@/stores/user'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'

/**
 * 认证相关的组合式函数
 */
export function useAuth() {
  const userStore = useUserStore()
  const router = useRouter()

  // 是否已登录
  const isLoggedIn = computed(() => userStore.loggedIn)

  // 用户信息
  const userInfo = computed(() => userStore.userInfo)

  // 登录
  const login = async (loginData) => {
    try {
      const res = await userStore.login(loginData)
      showToast('登录成功')
      // 跳转到首页或之前的页面
      const redirect = router.currentRoute.value.query.redirect || '/'
      router.push(redirect)
      return res
    } catch (error) {
      throw error
    }
  }

  // 注册
  const register = async (registerData) => {
    try {
      const res = await userStore.register(registerData)
      showToast('注册成功')
      // 注册成功后自动登录，跳转到首页或之前的页面
      const redirect = router.currentRoute.value.query.redirect || '/'
      router.push(redirect)
      return res
    } catch (error) {
      throw error
    }
  }

  // 退出登录
  const logout = async () => {
    try {
      await userStore.logout()
      showToast('已退出登录')
      router.push('/login')
    } catch (error) {
      throw error
    }
  }

  return {
    isLoggedIn,
    userInfo,
    login,
    register,
    logout
  }
}
