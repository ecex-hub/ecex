<template>
  <div class="payment-accounts-page">
    <!-- 顶部导航栏 -->
    <van-nav-bar
      title="收款方式"
      left-arrow
      @click-left="$router.back()"
    />

    <!-- 账户列表 -->
    <div class="accounts-list">
      <!-- 微信支付 -->
      <div 
        v-for="account in paymentAccounts" 
        :key="account.id"
        class="account-card"
        :class="`account-card-${account.type}`"
        :style="{ backgroundImage: `url(${account.background})` }"
      >
        <div class="account-content-wrapper">
          <div class="account-left">
            <div class="account-icon-wrapper">
              <img :src="account.icon" :alt="account.name" class="account-icon" />
            </div>
            <div class="account-brand">
              <img :src="account.brandImage" :alt="account.name" class="brand-image" />
            </div>
          </div>
          <div class="divider"></div>
          <div class="account-info">
            <div class="info-item">
              <span class="info-label">账户名:</span>
              <span class="info-value">{{ account.accountName }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">账号:</span>
              <span class="info-value">{{ formatAccountNumber(account.accountNumber) }}</span>
            </div>
          </div>
          <div class="delete-btn" @click="handleDelete(account)">
            删除
          </div>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-if="paymentAccounts.length === 0" class="empty-state">
        <img :src="emptyImage" alt="空状态" class="empty-image" />
        <div class="empty-text">暂无收款方式，点击下方添加</div>
      </div>
    </div>

    <!-- 底部添加按钮 -->
    <div class="add-button-wrapper">
      <van-button 
        block 
        round
        class="add-button"
        @click="handleAdd"
      >
        添加收款方式
      </van-button>
    </div>

    <!-- 添加收款方式抽屉 -->
    <van-popup
      v-model:show="showAddDrawer"
      position="bottom"
      :style="{ height: 'auto' }"
      round
    >
      <div class="add-drawer">
        <!-- 标题栏 -->
        <div class="drawer-header">
          <div class="header-btn cancel-btn" @click="handleCancel">取消</div>
          <div class="header-title">添加收款方式</div>
          <div class="header-btn confirm-btn" @click="handleConfirm">确定</div>
        </div>

        <!-- 支付方式列表 -->
        <div class="payment-options">
          <div
            v-for="option in paymentOptions"
            :key="option.type"
            class="payment-option-item"
            :class="{ active: selectedPaymentType === option.type }"
            :style="{ backgroundImage: `url(${option.background})` }"
            @click="selectedPaymentType = option.type"
          >
            <div class="option-icon-wrapper">
              <img :src="option.icon" :alt="option.name" class="option-icon" />
            </div>
            <div class="option-text">{{ option.label }}</div>
            <div class="radio-wrapper">
              <div class="custom-radio" :class="{ checked: selectedPaymentType === option.type }">
                <div class="radio-dot" v-if="selectedPaymentType === option.type"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </van-popup>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showConfirmDialog, showSuccessToast, showFailToast } from 'vant'
import { paymentAccountApi } from '@/api'
import wepayIcon from '@/assets/icons/png/pay/w.png'
import alipayIcon from '@/assets/icons/png/pay/a.png'
import unionpayIcon from '@/assets/icons/png/pay/b.png'
import emptyImage from '@/assets/icons/png/empty.png'
import wechatBack from '@/assets/images/backgrounds/wechatback.png'
import alipayBack from '@/assets/images/backgrounds/aliback.png'
import bankBack from '@/assets/images/backgrounds/bankback.png'
import weixinBrand from '@/assets/icons/png/pay/weixin.png'
import zhifubaoBrand from '@/assets/icons/png/pay/zhifubao.png'
import yinlianBrand from '@/assets/icons/png/pay/yinlian.png'

const router = useRouter()

// 抽屉显示状态
const showAddDrawer = ref(false)

// 选中的支付方式
const selectedPaymentType = ref('wechat')

// 支付方式选项
const paymentOptions = ref([
  {
    type: 'wechat',
    name: '微信',
    label: '添加微信收款',
    icon: wepayIcon,
    background: wechatBack
  },
  {
    type: 'alipay',
    name: '支付宝',
    label: '添加支付宝收款',
    icon: alipayIcon,
    background: alipayBack
  },
  {
    type: 'unionpay',
    name: '银联',
    label: '添加银联收款',
    icon: unionpayIcon,
    background: bankBack
  }
])

// 收款账户列表（进入页面后通过接口获取）
const paymentAccounts = ref([])

// 格式化账号显示（隐藏中间部分）
const formatAccountNumber = (accountNumber) => {
  if (!accountNumber) return ''
  const str = String(accountNumber)
  if (str.length <= 7) return str
  // 手机号格式：139****1564
  if (str.length === 11 && /^1\d{10}$/.test(str)) {
    return `${str.slice(0, 3)}****${str.slice(-4)}`
  }
  // 银行卡号格式：显示前4位和后4位
  if (str.length > 8) {
    return `${str.slice(0, 4)}****${str.slice(-4)}`
  }
  return str
}

// 删除账户
const handleDelete = async (account) => {
  try {
    await showConfirmDialog({
      title: '确认删除',
      message: `确定要删除${account.name}收款账户吗？`
    })
    
    // 先调用删除接口，再更新本地列表
    await paymentAccountApi.deleteAccount(account.id)

    const index = paymentAccounts.value.findIndex(item => item.id === account.id)
    if (index > -1) {
      paymentAccounts.value.splice(index, 1)
    }

    showSuccessToast('删除成功')
  } catch (error) {
    // 用户取消删除
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      showFailToast('删除失败，请重试')
    }
  }
}

// 添加收款方式
const handleAdd = () => {
  showAddDrawer.value = true
  // 默认选中第一个
  selectedPaymentType.value = 'wechat'
}

// 取消添加
const handleCancel = () => {
  showAddDrawer.value = false
}

// 确认添加
const handleConfirm = () => {
  const selectedOption = paymentOptions.value.find(opt => opt.type === selectedPaymentType.value)
  if (selectedOption) {
    showAddDrawer.value = false
    // TODO: 跳转到对应的添加页面或显示表单
    showSuccessToast(`已选择${selectedOption.name}`)
    // 这里可以跳转到具体的添加表单页面
    // router.push(`/payment-accounts/add/${selectedPaymentType.value}`)
  }
}

// 获取收款账户列表
const fetchPaymentAccounts = async () => {
  try {
    const res = await paymentAccountApi.getAccountList()
    const list = res?.data || []

    if (Array.isArray(list)) {
      paymentAccounts.value = list.map((item, index) => {
        const type = item.type || item.pay_type || 'wechat'

        let icon = wepayIcon
        let brandImage = weixinBrand
        let background = wechatBack
        let name = '微信'
        let nameEn = ''

        if (type === 'alipay') {
          icon = alipayIcon
          brandImage = zhifubaoBrand
          background = alipayBack
          name = '支付宝'
          nameEn = 'ALIPAY'
        } else if (type === 'unionpay' || type === 'bank') {
          icon = unionpayIcon
          brandImage = yinlianBrand
          background = bankBack
          name = '中国银联'
          nameEn = 'China Unionpay'
        }

        return {
          id: item.id ?? index,
          type,
          name: item.name || name,
          nameEn: item.nameEn || nameEn,
          icon,
          brandImage,
          accountName: item.accountName || item.account_name || item.real_name || '',
          accountNumber: item.accountNumber || item.account || item.card_no || '',
          background
        }
      })
    } else {
      paymentAccounts.value = []
    }
  } catch (error) {
    console.error('获取收款账户列表失败:', error)
    showFailToast('获取收款账户失败，请稍后重试')
    paymentAccounts.value = []
  }
}

onMounted(() => {
  fetchPaymentAccounts()
})
</script>

<style scoped>
.payment-accounts-page {
  min-height: 100vh;
  background: #ffffff;
  padding-bottom: 100px;
}

.payment-accounts-page :deep(.van-nav-bar) {
  background: #fff;
}

.payment-accounts-page :deep(.van-nav-bar__title) {
  color: #000;
  font-weight: bold;
}

.payment-accounts-page :deep(.van-nav-bar__arrow) {
  color: #000;
}

/* 账户列表 */
.accounts-list {
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 30px;
}

/* 账户卡片 */
.account-card {
  position: relative;
  border-radius: 12px;
  padding: 40px 6px 6px 6px;
  display: flex;
  align-items: flex-start;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); 
}

.account-card-wechat,
.account-card-alipay,
.account-card-unionpay {
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

/* 账户内容容器 */
.account-content-wrapper {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  background: #ffffff;
  border-radius: 12px;
  padding: 12px 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  width: 100%;
  position: relative;
  overflow: visible;
}

/* 左侧图标和品牌 */
.account-left {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
  position: relative;
  padding-top: 20px;
  width: 80px;
}

.account-icon-wrapper {
  width: 55px;
  height: 55px;
  background: #f5f5f5;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: absolute;
  top: -45px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 10;
}

.account-icon {
  width: 32px;
  height: 32px;
  object-fit: contain;
}

.account-brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
}

.brand-image {
  width: auto;
  height: 22px;
  object-fit: contain;
}

/* 分割线 */
.divider {
  width: 1px;
  height: 40px;
  background: #e0e0e0;
  flex-shrink: 0;
  margin: 0 8px;
}

/* 账户信息 */
.account-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 4px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-label {
  font-size: 14px;
  color: #666666;
  white-space: nowrap;
}

.info-value {
  font-size: 14px;
  color: #333333;
  font-weight: 500;
}

/* 删除按钮 */
.delete-btn {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 4px 10px;
  background: rgba(0, 0, 0, 0.05);
  border-radius: 12px;
  font-size: 12px;
  color: #666666;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: 500;
}

.delete-btn:active {
  background: rgba(0, 0, 0, 0.1);
  transform: scale(0.95);
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  min-height: 400px;
}

.empty-image {
  width: 200px;
  height: 200px;
  object-fit: contain;
  margin-bottom: 24px;
}

.empty-text {
  font-size: 14px;
  color: #999;
  text-align: center;
  line-height: 1.5;
}

/* 底部添加按钮 */
.add-button-wrapper {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
  background: #fff;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
  z-index: 100;
}

.add-button {
  height: 50px;
  background: #e53e3e;
  border: none;
  color: #ffffff;
  font-size: 16px;
  font-weight: bold;
  box-shadow: 0 4px 12px rgba(229, 62, 62, 0.3);
}

.add-button:active {
  opacity: 0.9;
}

/* 添加收款方式抽屉 */
.add-drawer {
  background: #fff;
  border-radius: 20px 20px 0 0;
  overflow: hidden;
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid #f0f0f0;
}

.header-btn {
  font-size: 16px;
  padding: 4px 8px;
  cursor: pointer;
  user-select: none;
}

.cancel-btn {
  color: #666;
}

.confirm-btn {
  color: #e53e3e;
  font-weight: 500;
}

.header-title {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

/* 支付方式选项列表 */
.payment-options {
  padding: 8px 0;
}

.payment-option-item {
  display: flex;
  align-items: center;
  padding: 16px 20px;
  cursor: pointer;
  transition: opacity 0.2s;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  margin: 8px 16px;
  border-radius: 12px;
  min-height: 60px;
}

.payment-option-item:active {
  opacity: 0.8;
}

.option-icon-wrapper {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
  flex-shrink: 0;
}



.option-icon {
  width: 50px;
  height: 50px;
  object-fit: contain;
}

.option-text {
  flex: 1;
  font-size: 16px;
  color: #333;
  font-weight: bold;
}

.radio-wrapper {
  margin-left: auto;
  flex-shrink: 0;
}

.custom-radio {
  width: 20px;
  height: 20px;
  border: 2px solid #ddd;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  background: #fff;
}

.custom-radio.checked {
  border-color: #e53e3e;
  background: #e53e3e;
}

.radio-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #fff;
}
</style>