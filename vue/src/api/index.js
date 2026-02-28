import request from '@/utils/request'

/**
 * 用户相关 API
 */
export const userApi = {
  // 登录
  login (data) {
    return request({
      url: '/login/index',
      method: 'post',
      data
    })
  },

  // 注册
  register (data) {
    return request({
      url: '/register/index',
      method: 'post',
      data
    })
  },

  // 发送注册验证码
  sendRegisterCode (data) {
    return request({
      url: '/register/code',
      method: 'post',
      data
    })
  },

  // 获取用户信息
  getUserInfo () {
    return request({
      url: '/user/info',
      method: 'get'
    })
  },

  // 修改密码
  changePassword (data) {
    return request({
      url: '/user/password',
      method: 'put',
      data
    })
  },

  // 退出登录
  logout () {
    return request({
      url: '/user/logout',
      method: 'post'
    })
  }
}

/**
 * 认证相关 API
 */
export const authApi = {
  // 身份认证
  identityAuth (data) {
    return request({
      url: '/auth/identity',
      method: 'post',
      data
    })
  },

  // 实名认证
  realnameAuth (data) {
    return request({
      url: '/auth/realname',
      method: 'post',
      data
    })
  },

  // 获取认证状态
  getAuthStatus () {
    return request({
      url: '/auth/status',
      method: 'get'
    })
  }
}

/**
 * 钱包相关 API
 */
export const walletApi = {
  // 获取钱包信息
  getWalletInfo () {
    return request({
      url: '/wallet/info',
      method: 'get'
    })
  },

  // 充值
  recharge (data) {
    return request({
      url: '/wallet/recharge',
      method: 'post',
      data
    })
  },

  // 获取支付通道列表
  getPaymentChannels (data) {
    return request({
      url: '/wallet/payment-channels',
      method: 'post',
      data
    })
  },

  // 提现
  withdraw (data) {
    return request({
      url: '/wallet/withdraw',
      method: 'post',
      data
    })
  },

  // 资金明细
  getTransactionList (params) {
    return request({
      url: '/wallet/transactions',
      method: 'get',
      params
    })
  }
}

/**
 * 收款账户相关 API
 * 注意：具体接口地址需根据后端实际路由调整
 */
export const paymentAccountApi = {
  // 获取收款账户列表
  getAccountList (params) {
    return request({
      url: '/payment-accounts/list',
      method: 'get',
      params
    })
  },

  // 删除收款账户
  deleteAccount (id) {
    return request({
      url: '/payment-accounts/delete',
      method: 'post',
      data: { id }
    })
  }
}

/**
 * 团队相关 API
 */
export const teamApi = {
  // 获取团队统计
  getTeamStats () {
    return request({
      url: '/team/stats',
      method: 'get'
    })
  },

  // 获取团队成员列表
  getTeamList (params) {
    return request({
      url: '/team/list',
      method: 'get',
      params
    })
  }
}

/**
 * 积分商城相关 API
 */
export const mallApi = {
  // 获取积分信息
  getPointsInfo () {
    return request({
      url: '/mall/points',
      method: 'get'
    })
  },

  // 获取商品列表
  getProductList (params) {
    return request({
      url: '/mall/products',
      method: 'get',
      params
    })
  },

  // 兑换商品
  exchangeProduct (data) {
    return request({
      url: '/mall/exchange',
      method: 'post',
      data
    })
  }
}

/**
 * 签到相关 API
 */
export const signApi = {
  // 获取签到详情
  getSignDetail (data) {
    return request({
      url: '/sign-in/detail',
      method: 'post',
      data
    })
  },

  // 执行签到
  receive () {
    return request({
      url: '/sign-in/receive',
      method: 'post'
    })
  }
}

/**
 * 帮助与资料管理 API
 */
export const helpApi = {
  // 提交资料信息管理表单
  submitDataManagement (data) {
    return request({
      url: '/help/data-management',
      method: 'post',
      data
    })
  },

  // 获取最近一次提交的资料信息，用于页面回显
  getLatestDataManagement () {
    return request({
      url: '/help/data-management-latest',
      method: 'get'
    })
  }
}

/**
 * 新闻相关 API
 */
export const newsApi = {
  // 获取新闻列表
  getNewsList (params) {
    return request({
      url: '/news/list',
      method: 'get',
      params
    })
  },

  // 获取新闻详情
  getNewsDetail (id) {
    return request({
      url: `/news/${id}`,
      method: 'get'
    })
  }
}

/**
 * 首页相关 API
 */
export const homeApi = {
  // 获取首页所有数据（包括轮播图、新闻等）
  getIndexData () {
    return request({
      url: '/home/index',
      method: 'get'
    })
  }
}

/**
 * 视频相关 API
 */
export const videoApi = {
  // 获取视频列表
  getVideoList (params) {
    return request({
      url: '/home/video',
      method: 'get',
      params
    })
  },
  // 获取视频详情
  getVideoDetail (id) {
    return request({
      url: '/home/video-detail',
      method: 'get',
      params: { id }
    })
  }

}



/**
 * 文件上传 API
 */
export const uploadApi = {
  // 上传文件
  uploadFile (file, onProgress) {
    const formData = new FormData()
    formData.append('file', file)

    return request({
      url: '/upload/file',
      method: 'post',
      data: formData,
      headers: {
        'Content-Type': 'multipart/form-data'
      },
      onUploadProgress: (progressEvent) => {
        if (onProgress) {
          const percent = Math.round((progressEvent.loaded * 100) / progressEvent.total)
          onProgress(percent)
        }
      }
    })
  }
}
