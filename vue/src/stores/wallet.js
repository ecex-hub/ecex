import { defineStore } from 'pinia'
import { walletApi } from '@/api'

export const useWalletStore = defineStore('wallet', {
  state: () => ({
    balance: 0,           // 余额钱包
    rechargeBalance: 0,   // 充值钱包
    pendingAmount: 0,     // 待审核金额
    transactionList: []   // 交易明细
  }),

  getters: {
    // 总余额
    totalBalance: (state) => state.balance + state.rechargeBalance,
    
    // 可提现金额
    withdrawableAmount: (state) => state.balance
  },

  actions: {
    // 设置钱包信息
    setWalletInfo(data) {
      this.balance = data.balance || 0
      this.rechargeBalance = data.rechargeBalance || 0
      this.pendingAmount = data.pendingAmount || 0
    },

    // 获取钱包信息
    async fetchWalletInfo() {
      try {
        const res = await walletApi.getWalletInfo()
        if (res.code === 200 && res.data) {
          this.setWalletInfo(res.data)
          return Promise.resolve(res)
        }
        return Promise.reject(res)
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 充值（仅创建订单并返回支付链接，不在这里刷新钱包）
    async recharge(data) {
      try {
        const res = await walletApi.recharge(data)
        return Promise.resolve(res)
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 提现
    async withdraw(data) {
      try {
        const res = await walletApi.withdraw(data)
        if (res.code === 200) {
          // 刷新钱包信息
          await this.fetchWalletInfo()
        }
        return Promise.resolve(res)
      } catch (error) {
        return Promise.reject(error)
      }
    },

    // 获取交易明细
    async fetchTransactionList(params) {
      try {
        const res = await walletApi.getTransactionList(params)
        if (res.code === 200 && res.data) {
          this.transactionList = res.data.list || []
          return Promise.resolve(res)
        }
        return Promise.reject(res)
      } catch (error) {
        return Promise.reject(error)
      }
    }
  }
})
