import { computed, onMounted } from 'vue'
import { useWalletStore } from '@/stores/wallet'
import { showToast } from 'vant'

/**
 * 钱包相关的组合式函数
 */
export function useWallet() {
  const walletStore = useWalletStore()

  // 余额
  const balance = computed(() => walletStore.balance)
  
  // 充值钱包
  const rechargeBalance = computed(() => walletStore.rechargeBalance)
  
  // 待审核金额
  const pendingAmount = computed(() => walletStore.pendingAmount)
  
  // 总余额
  const totalBalance = computed(() => walletStore.totalBalance)
  
  // 可提现金额
  const withdrawableAmount = computed(() => walletStore.withdrawableAmount)

  // 获取钱包信息
  const fetchWalletInfo = async () => {
    try {
      await walletStore.fetchWalletInfo()
    } catch (error) {
      console.error('获取钱包信息失败:', error)
    }
  }

  // 充值（创建订单并返回支付链接，由页面决定如何跳转）
  const recharge = async (data) => {
    try {
      const res = await walletStore.recharge(data)
      return res
    } catch (error) {
      throw error
    }
  }

  // 提现
  const withdraw = async (data) => {
    try {
      const res = await walletStore.withdraw(data)
      showToast('提现申请已提交')
      return res
    } catch (error) {
      throw error
    }
  }

  // 初始化时获取钱包信息
  onMounted(() => {
    fetchWalletInfo()
  })

  return {
    balance,
    rechargeBalance,
    pendingAmount,
    totalBalance,
    withdrawableAmount,
    fetchWalletInfo,
    recharge,
    withdraw
  }
}
