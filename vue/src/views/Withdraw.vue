<template>
  <div class="withdraw-page">
    <van-nav-bar
      title="提现"
      left-arrow
      @click-left="$router.back()"
      @click-right="showService"
    >
      <template #right>
        <img :src="recordIcon" alt="客服" class="service-icon" @click="showService" />
      </template>
    </van-nav-bar>

    <div class="content">
      <!-- 账户余额 -->
      <div class="balance-card">
        <div class="balance-label">
          <img :src="balanceIcon" alt="余额" class="balance-icon" />
          <span>{{ currentWalletName }}</span>
          <button class="change-btn" @click="openWalletDrawer">更换</button>
        </div>
        <div class="balance-amount">
          <span style="font-size: 24px;">¥</span>
          {{ withdrawableAmount.toFixed(2) }}
        </div>       
      </div>
    </div>

    <div class="account-wrapper">
      <!-- 提现账户 -->
      <div class="account-section">
        <div class="section-title-center">支付渠道</div>
        
        <!-- 支付方式选择 -->
        <div class="payment-methods">
          <div 
            class="payment-method-btn"
            :class="{ active: selectedPaymentMethod === 'alipay' }"
            @click="selectedPaymentMethod = 'alipay'"
          >
            <img :src="alipayIcon" alt="支付宝" class="payment-icon-large" />
            <div class="payment-name" 
            :style="{ color: selectedPaymentMethod === 'alipay' ? '#e53e3e' : '#333' }"
            >支付宝</div>
          </div>
          <div 
            class="payment-method-btn"
            :class="{ active: selectedPaymentMethod === 'bank' }"
            @click="selectedPaymentMethod = 'bank'"
          >
            <img :src="unionpayIcon" alt="银行卡" class="payment-icon-large" />
            <div class="payment-name"
            :style="{ color: selectedPaymentMethod === 'bank' ? '#e53e3e' : '#333' }"
            >银行卡</div>
          </div>
        </div>

        <!-- 账户信息输入 -->
        <div class="account-inputs">
          <div class="input-group" v-if="selectedPaymentMethod === 'alipay'">
            <label class="input-label">支付宝账号</label>
            <van-field
              v-model="alipayAccount"
              placeholder="请输入您的支付宝账号"
              class="account-input-field"
            >
              <template #right-icon>
                <van-icon name="arrow-down" />
              </template>
            </van-field>
          </div>
          <div class="input-group" v-if="selectedPaymentMethod === 'bank'">
            <label class="input-label">银行卡号</label>
            <van-field
              v-model="bankAccount"
              placeholder="请输入您的银行卡号"
              class="account-input-field"
            >
              <template #right-icon>
                <van-icon name="arrow-down" />
              </template>
            </van-field>
          </div>
          <div class="input-group">
            <label class="input-label">账户姓名</label>
            <van-field
              v-model="accountName"
              placeholder="请输入您真实姓名"
              class="account-input-field"
            />
          </div>
        </div>
      </div>
    </div>
    <div style="padding: 0 10px;">
      <div class="amount-wrapper">
        <!-- 提现金额 -->
        <div class="amount-section">
          <div class="section-title">提现金额</div>
          <van-field
            v-model="amount"
            type="number"
            placeholder="请输入提现金额"
            class="amount-input"
          >
            <template #left-icon>
              <span class="currency">¥</span>
            </template>
          </van-field>
          <div class="amount-tips">
            <span>可用余额：【¥{{ withdrawableAmount.toFixed(2) }}】</span>
            <span @click="amount = withdrawableAmount.toFixed(2)">全部提现</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 立即提现按钮 -->
    <div class="action-section">
        <van-button 
          round 
          block 
          type="primary" 
          class="withdraw-btn"
          :disabled="!amount || parseFloat(amount) < 100 || loading"
          :loading="loading"
          @click="handleWithdraw"
        >
          确认提现
        </van-button>
    </div>

    <!-- 钱包选择抽屉 -->
    <van-popup
      v-model:show="showWalletDrawer"
      position="bottom"
      :style="{ height: '50%' }"
      round
      class="wallet-drawer"
    >
      <div class="drawer-header">
        <div class="drawer-cancel" @click="showWalletDrawer = false">取消</div>
        <div class="drawer-title">选择钱包</div>
        <div class="drawer-confirm" @click="confirmWallet">确定</div>
      </div>
      
      <div class="drawer-content-wrapper" ref="drawerWrapperRef">
        <div class="drawer-selection-indicator"></div>
        <div class="drawer-content" ref="drawerContentRef" @scroll="handleScroll" @touchstart="handleTouchStart" @touchend="handleTouchEnd">
          <div class="wallet-spacer"></div>
          <div 
            v-for="wallet in walletList" 
            :key="wallet.id"
            class="wallet-item"
            :class="{ active: selectedWalletId === wallet.id }"
            :ref="el => setWalletItemRef(el, wallet.id)"
          >
            <div class="wallet-name">{{ wallet.name }}</div>
          </div>
          <div class="wallet-spacer"></div>
        </div>
      </div>
    </van-popup>
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted } from 'vue'
import { useWallet } from '@/composables/useWallet'
import { showToast, showDialog, showLoadingToast, closeToast } from 'vant'
import recordIcon from '@/assets/icons/png/record2.png'
import balanceIcon from '@/assets/icons/png/balance.png'
import alipayIcon from '@/assets/icons/png/pay/alipay2.png'
import unionpayIcon from '@/assets/icons/png/pay/unionpay2.png'

const { withdrawableAmount, withdraw } = useWallet()

const amount = ref('')
const loading = ref(false)
const selectedPaymentMethod = ref('alipay')
const alipayAccount = ref('')
const bankAccount = ref('')
const accountName = ref('')

// 钱包选择相关
const showWalletDrawer = ref(false)
const selectedWalletId = ref(1)
const currentWalletName = ref('余额钱包')
const walletList = ref([
  { id: 1, name: '余额钱包' },
  { id: 2, name: '充值钱包' },
  { id: 3, name: '待审核钱包' }
])
const drawerContentRef = ref(null)
const drawerWrapperRef = ref(null)
const walletItemRefs = ref({})
let isScrolling = false
let touchStartY = 0
let isTouching = false

const selectAccount = () => {
  showToast('选择提现账户')
}

const showService = () => {
  showToast('联系客服')
}

const setWalletItemRef = (el, id) => {
  if (el) {
    walletItemRefs.value[id] = el
  }
}

let scrollTimer = null
let isUserScrolling = false

const handleTouchStart = (e) => {
  touchStartY = e.touches[0].clientY
  isTouching = true
  isUserScrolling = true
}

const handleTouchEnd = () => {
  isTouching = false
  // 触摸结束后，确保选中项居中
  setTimeout(() => {
    if (!isTouching) {
      scrollToCenter()
    }
  }, 100)
}

const handleScroll = () => {
  if (isScrolling) return
  
  isUserScrolling = true
  
  // 清除之前的定时器
  if (scrollTimer) {
    clearTimeout(scrollTimer)
  }
  
  // 滚动时实时更新选中项
  updateSelectedItem()
  
  // 滚动过程中持续对齐到中间（仅在非触摸时）
  if (!isTouching) {
    requestAnimationFrame(() => {
      if (isUserScrolling && !isScrolling) {
        scrollToCenter()
      }
    })
  }
  
  // 滚动停止后再次更新，确保选中中间项
  scrollTimer = setTimeout(() => {
    isUserScrolling = false
    updateSelectedItem()
    // 如果当前选中项不在中间，滚动到中间
    scrollToCenter()
  }, 150)
}

const updateSelectedItem = () => {
  const container = drawerContentRef.value
  const wrapper = drawerWrapperRef.value
  if (!container || !wrapper) return
  
  const wrapperRect = wrapper.getBoundingClientRect()
  const wrapperCenter = wrapperRect.top + wrapperRect.height / 2
  
  let closestItem = null
  let closestDistance = Infinity
  
  walletList.value.forEach(wallet => {
    const item = walletItemRefs.value[wallet.id]
    if (item) {
      const itemRect = item.getBoundingClientRect()
      const itemCenter = itemRect.top + itemRect.height / 2
      const distance = Math.abs(itemCenter - wrapperCenter)
      
      if (distance < closestDistance) {
        closestDistance = distance
        closestItem = wallet
      }
    }
  })
  
  if (closestItem && selectedWalletId.value !== closestItem.id) {
    selectedWalletId.value = closestItem.id
    // 选中项改变后，立即对齐到中间
    nextTick(() => {
      scrollToCenter()
    })
  }
}

const scrollToCenter = () => {
  const selectedItem = walletItemRefs.value[selectedWalletId.value]
  const container = drawerContentRef.value
  const wrapper = drawerWrapperRef.value
  if (selectedItem && container && wrapper && !isScrolling) {
    const wrapperRect = wrapper.getBoundingClientRect()
    const containerRect = container.getBoundingClientRect()
    
    // 使用offsetTop获取元素相对于容器的精确位置
    const itemOffsetTop = selectedItem.offsetTop
    const itemHeight = selectedItem.offsetHeight
    const itemCenter = itemOffsetTop + itemHeight / 2
    
    // wrapper的中心位置（相对于container的scrollTop + container的可见区域中心）
    const wrapperCenter = wrapperRect.height / 2
    // 当前可见区域的中心位置（相对于container的scrollTop）
    const visibleCenter = container.scrollTop + wrapperCenter
    
    const scrollOffset = itemCenter - visibleCenter
    
    // 只有当偏移量大于阈值时才滚动
    if (Math.abs(scrollOffset) > 1) {
      isScrolling = true
      const targetScrollTop = container.scrollTop + scrollOffset
      
      // 使用 requestAnimationFrame 实现平滑滚动
      const startScrollTop = container.scrollTop
      const distance = targetScrollTop - startScrollTop
      const duration = isTouching ? 100 : 200 // 触摸时更快响应
      let startTime = null
      
      const animateScroll = (currentTime) => {
        if (startTime === null) startTime = currentTime
        const elapsed = currentTime - startTime
        const progress = Math.min(elapsed / duration, 1)
        
        // 使用缓动函数
        const easeOut = 1 - Math.pow(1 - progress, 3)
        container.scrollTop = startScrollTop + distance * easeOut
        
        if (progress < 1) {
          requestAnimationFrame(animateScroll)
        } else {
          isScrolling = false
          // 滚动完成后再次检查并微调
          nextTick(() => {
            const finalWrapperRect = wrapper.getBoundingClientRect()
            const finalItemOffsetTop = selectedItem.offsetTop
            const finalItemHeight = selectedItem.offsetHeight
            const finalItemCenter = finalItemOffsetTop + finalItemHeight / 2
            const finalWrapperCenter = finalWrapperRect.height / 2
            const finalVisibleCenter = container.scrollTop + finalWrapperCenter
            const finalOffset = finalItemCenter - finalVisibleCenter
            
            if (Math.abs(finalOffset) > 0.5) {
              container.scrollTop += finalOffset
            }
          })
        }
      }
      
      requestAnimationFrame(animateScroll)
    } else {
      isScrolling = false
    }
  }
}

const scrollToSelected = () => {
  nextTick(() => {
    const selectedItem = walletItemRefs.value[selectedWalletId.value]
    const container = drawerContentRef.value
    const wrapper = drawerWrapperRef.value
    if (selectedItem && container && wrapper) {
      isScrolling = true
      const wrapperRect = wrapper.getBoundingClientRect()
      
      // 使用offsetTop获取元素相对于容器的精确位置
      const itemOffsetTop = selectedItem.offsetTop
      const itemHeight = selectedItem.offsetHeight
      const itemCenter = itemOffsetTop + itemHeight / 2
      
      const wrapperCenter = wrapperRect.height / 2
      const visibleCenter = container.scrollTop + wrapperCenter
      const scrollOffset = itemCenter - visibleCenter
      
      container.scrollTo({
        top: container.scrollTop + scrollOffset,
        behavior: 'smooth'
      })
      
      setTimeout(() => {
        isScrolling = false
        updateSelectedItem()
      }, 500)
    }
  })
}

const openWalletDrawer = () => {
  // 根据当前钱包名称设置选中的ID
  const currentWallet = walletList.value.find(w => w.name === currentWalletName.value)
  if (currentWallet) {
    selectedWalletId.value = currentWallet.id
  }
  showWalletDrawer.value = true
  nextTick(() => {
    scrollToSelected()
  })
}

const confirmWallet = () => {
  const selectedWallet = walletList.value.find(w => w.id === selectedWalletId.value)
  if (selectedWallet) {
    currentWalletName.value = selectedWallet.name
  }
  showWalletDrawer.value = false
}

const handleWithdraw = async () => {
  if (loading.value) return
  
  if (!amount.value) {
    showToast('请输入提现金额')
    return
  }
  const amountNum = parseFloat(amount.value)
  if (amountNum < 100) {
    showToast('最低提现金额为100元')
    return
  }
  if (amountNum > withdrawableAmount.value) {
    showToast('提现金额不能超过可提现金额')
    return
  }

  // 校验账户信息
  if (selectedPaymentMethod.value === 'alipay') {
    if (!alipayAccount.value) {
      showToast('请输入支付宝账号')
      return
    }
  } else if (selectedPaymentMethod.value === 'bank') {
    if (!bankAccount.value) {
      showToast('请输入银行卡号')
      return
    }
  }

  if (!accountName.value) {
    showToast('请输入账户姓名')
    return
  }

  // 组装提现账户文案
  const accountTypeText = selectedPaymentMethod.value === 'alipay' ? '支付宝' : '银行卡'
  const accountNumberText =
    selectedPaymentMethod.value === 'alipay' ? alipayAccount.value : bankAccount.value
  
  try {
    await showDialog({
      title: '确认提现',
      message: `提现金额：¥${amount.value}\n提现账户：${accountTypeText} ${accountNumberText}\n账户姓名：${accountName.value}`,
    })
    
    loading.value = true
    showLoadingToast({
      message: '提交中...',
      forbidClick: true
    })
    
    // 调用提现接口
    await withdraw({
      amount: amountNum,
      // 提现方式：alipay / bank
      pay_type: selectedPaymentMethod.value,
      // 提现账户信息
      account: accountNumberText,
      real_name: accountName.value,
      // 可选：当前选择的钱包名称，可根据后端字段调整
      wallet_name: currentWalletName.value
    })
    
    closeToast()
    amount.value = ''
    // 提现成功后可清空账户信息（按需）
    // alipayAccount.value = ''
    // bankAccount.value = ''
    // accountName.value = ''
  } catch (error) {
    closeToast()
    if (error !== 'cancel') {
      console.error('提现失败:', error)
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.withdraw-page {
  min-height: 100vh;
  background: #f5f5f5 url('@/assets/images/backgrounds/withdrawback.png') no-repeat top center;
  background-size: 100% auto;
  background-attachment: fixed;
  padding-bottom: 80px;
}

.withdraw-page :deep(.van-nav-bar) {
  position: relative;
  z-index: 10;
  background: transparent;
}

.withdraw-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}

.withdraw-page :deep(.van-nav-bar__title) {
  color: #ffffff;
  font-weight: bold;
}

.withdraw-page :deep(.van-nav-bar__text) {
  color: #333;
}

.withdraw-page :deep(.van-nav-bar__arrow) {
  color: #ffffff;
}

.service-icon {
  width: 22px;
  height: 22px;
  cursor: pointer;
  display: block;
}

.content {
  padding: 16px;
}

.balance-card {
  background: url('@/assets/images/backgrounds/balanceback.png') no-repeat center;
  background-size: 100% auto;
  border-radius: 12px;
  padding: 20px;
  text-align: left;
  color: #2e0a0a;
  margin-bottom: 16px;
  aspect-ratio: 664 / 334;
  /* 根据背景图片的实际宽高比调整，例如 3:1 表示宽度是高度的3倍 */
  display: flex;
  flex-direction: column; 
}

.balance-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  opacity: 0.9;
  margin-bottom: 8px;
  font-weight: bold;
}

.balance-icon {
  width: 20px;
  height: 16px;
  display: block;
}

.change-btn {
  margin-left: 8px;
  padding: 1px 8px;
  border: 1px solid #e53e3e;
  border-radius: 12px;
  background: transparent;
  color: #e53e3e;
  font-size: 10px;
  cursor: pointer;
  font-weight: normal;
}

.balance-amount {
  font-size: 36px;
  font-weight: bold;
  margin-top: 20px;
}

.balance-tip {
  font-size: 12px;
  opacity: 0.8;
  cursor: pointer;
}

.amount-section {
  background: transparent;
  border-radius: 12px;
  padding: 0;
  margin-bottom: 16px;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 16px;
}

.section-title-center {
  background: url('@/assets/images/backgrounds/section-title-center.png') no-repeat center;
  background-size: 100% 61%;
  text-align: center;
  font-size: 12px;
  font-weight: bold;
  color: #ffffff;
  margin: 0 0 20px;
  padding: 8px 0;
  width: 100%;
}

.amount-input {
  margin-bottom: 12px;
  border: 1px solid #89423E;
  background: #FFF8F6;
  border-radius: 8px;
}

.currency {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.amount-tips {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #999;
}

.amount-tips span:last-child {
  color: #e53e3e;
  cursor: pointer;
}

.account-wrapper {
  background: url('@/assets/images/backgrounds/withdrawwayboxback.png') no-repeat center;
  background-size: 100% 100%;
  border-radius: 12px;
  margin-bottom: 16px;
  padding: 16px;
  margin-top: -99px;
}
.amount-wrapper{
  background: url('@/assets/images/backgrounds/withdrawamountback.png') no-repeat center;
  background-size: 100% 100%;
  border-radius: 12px;
  margin-bottom: 16px;  
  padding: 20px;
}
.account-section {
  background: transparent;
  border-radius: 12px;
  padding: 20px;
}

.payment-methods {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  justify-content: space-around;
}

.payment-method-btn {
  flex: 0 0 auto;
  width: 100px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 16px;
  border: 1px solid #AAAAAA;
  border-radius: 8px;
  background: #fff;
  cursor: pointer;
  transition: all 0.3s;
  height: 70px;
}

.payment-method-btn.active {
  border-color: #e53e3e;
  background: #fff5f5;
}

.payment-icon-large {
  width: 30px;
  height: 30px;
  margin-bottom: 8px;
}

.payment-name {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

.account-inputs {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.input-label {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

.account-input-field {
  background: #f5f5f5;
  border-radius: 8px;
}

.account-input-field :deep(.van-field__control) {
  background: transparent;
}

.account-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px;
  border: 1px solid #eee;
  border-radius: 8px;
  cursor: pointer;
}

.account-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.account-desc {
  flex: 1;
}

.account-name {
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
}

.account-number {
  font-size: 12px;
  color: #999;
}



.action-section {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
  background: #fff;
  box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
}

.withdraw-btn {
  background: #e53e3e;
  border: none;
  height: 48px;
}

/* 钱包选择抽屉样式 */
.wallet-drawer {
  padding: 0;
  display: flex;
  flex-direction: column;
  height: 100%;
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid #eee;
  position: relative;
  flex-shrink: 0;
}

.drawer-cancel {
  font-size: 16px;
  color: #666;
  cursor: pointer;
  flex: 1;
  text-align: left;
}

.drawer-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
}

.drawer-confirm {
  font-size: 16px;
  color: #e53e3e;
  cursor: pointer;
  flex: 1;
  text-align: right;
}

.drawer-content-wrapper {
  position: relative;
  flex: 1;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.drawer-selection-indicator {
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  transform: translateY(-50%);
  height: 50px;
  pointer-events: none;
  z-index: 1;
  background: url('@/assets/images/backgrounds/selected.png') no-repeat center;
  background-size: 100% 100%;
}

.drawer-content {
  padding: 20px;
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 0;
  -webkit-overflow-scrolling: touch;
  position: relative;
  z-index: 0;
}

.wallet-item {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px 20px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: all 0.3s;
  width: 100%;
  max-width: 300px;
  border-radius: 8px;
  flex-shrink: 0;
  min-height: 50px;
}

.wallet-item:hover {
  opacity: 0.8;
}


.wallet-name {
  font-size: 16px;
  font-weight: 500;
  text-align: center;
}

.wallet-item:not(.active) .wallet-name {
  color: #999;
}

.wallet-item.active .wallet-name {
  color: #e53e3e;
}

.wallet-spacer {
  height: calc((50vh - 80px) / 2 - 25px);
  flex-shrink: 0;
}
</style>
