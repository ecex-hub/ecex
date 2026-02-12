import { useUserStore } from '@/stores/user'
import storage from '@/utils/storage'
import { STORAGE_KEYS } from '@/config'

/**
 * 路由守卫
 */
export function setupRouterGuard(router) {
  // 白名单路由（不需要登录）
  const whiteList = ['/login', '/register']

  router.beforeEach(async (to, from, next) => {
    const userStore = useUserStore()
    const token = storage.getToken()

    // 如果有 token，尝试获取用户信息
    if (token && !userStore.userInfo) {
      try {
        await userStore.fetchUserInfo()
      } catch (error) {
        // 获取用户信息失败，清除 token
        userStore.clearUserInfo()
      }
    }

    // 检查是否需要登录
    if (whiteList.includes(to.path)) {
      // 白名单路由，直接放行
      next()
    } else {
      // 需要登录的路由
      if (token && userStore.loggedIn) {
        // 已登录，放行
        next()
      } else {
        // 未登录，跳转到登录页
        next({
          path: '/login',
          query: { redirect: to.fullPath }
        })
      }
    }
  })

  router.afterEach(() => {
    // 路由切换后的处理
  })
}
