import { createRouter, createWebHistory } from 'vue-router'
import { setupRouterGuard } from './guard'

const routes = [
  {
    path: '/',
    component: () => import('../layouts/MainLayout.vue'),
    redirect: '/home',
    children: [
      {
        path: 'home',
        name: 'Home',
        component: () => import('../views/Home.vue')
      },
      {
        path: 'zone',
        name: 'Zone',
        component: () => import('../views/Zone.vue')
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('../views/Profile.vue')
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue')
  },
  {
    path: '/identity',
    name: 'Identity',
    component: () => import('../views/Identity.vue')
  },
  {
    path: '/realname',
    name: 'Realname',
    component: () => import('../views/Realname.vue')
  },
  {
    path: '/reset-password',
    name: 'ResetPassword',
    component: () => import('../views/my/ResetPassword.vue')
  },
  {
    path: '/payment-accounts',
    name: 'PaymentAccounts',
    component: () => import('../views/my/PaymentAccounts.vue')
  },
  {
    path: '/recharge',
    name: 'Recharge',
    component: () => import('../views/Recharge.vue')
  },
  {
    path: '/withdraw',
    name: 'Withdraw',
    component: () => import('../views/Withdraw.vue')
  },
  {
    path: '/team',
    name: 'Team',
    component: () => import('../views/Team.vue')
  },
  {
    path: '/team/invite',
    name: 'InviteFriend',
    component: () => import('../views/team/InviteFriend.vue')
  },
  {
    path: '/mall',
    name: 'Mall',
    component: () => import('../views/mall/Mall.vue')
  },
  {
    path: '/mall/product-detail',
    name: 'ProductDetail',
    component: () => import('../views/mall/ProductDetail.vue')
  },
  {
    path: '/news',
    name: 'News',
    component: () => import('../views/News.vue')
  },
  {
    path: '/news/detail/:id',
    name: 'NewsDetail',
    component: () => import('../views/news/NewsDetail.vue')
  },
  {
    path: '/news/video/:id',
    name: 'VideoPlayer',
    component: () => import('../views/news/VideoPlayer.vue')
  },
  {
    path: '/help/data-management',
    name: 'DataManagement',
    component: () => import('../views/help/DataManagement.vue')
  },
  {
    path: '/payment-progress',
    name: 'PaymentProgress',
    component: () => import('../views/progress/PaymentProgress.vue')
  },
  {
    path: '/finance/fund-detail',
    name: 'FundDetail',
    component: () => import('../views/finance/FundDetail.vue')
  },
  {
    path: '/exchange/asset-redemption',
    name: 'AssetRedemption',
    component: () => import('../views/exchange/AssetRedemption.vue')
  },
  {
    path: '/kefu',
    name: 'Kefu',
    component: () => import('../views/kefu/Index.vue')
  },
  {
    path: '/product',
    name: 'Product',
    component: () => import('../views/product/Product.vue')
  },
  {
    path: '/signin',
    name: 'SignIn',
    component: () => import('../views/sign/SignIn.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 设置路由守卫
setupRouterGuard(router)

export default router