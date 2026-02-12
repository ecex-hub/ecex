<template>
  <div class="recharge-page">
    <van-nav-bar
      title="充值"
      left-arrow
      @click-left="$router.back()"
      @click-right="showService"
    >
      <template #right>
        <img :src="recordIcon" alt="客服" class="service-icon" @click="showService" />
      </template>
    </van-nav-bar>

    <div class="section-header2">
        <img :src="coinIcon" alt="充值金额" class="coin-icon" />
        <span class="section-title">充值金额</span>
    </div>

    <div class="content">
      <!-- 充值金额 -->
      <div class="amount-section" :style="{ backgroundImage: `url(${rechargeBoxBg})` }">   
        
        <van-field
          v-model="amount"
          type="number"
          placeholder="请输入充值金额"
          class="amount-input"
        >
          <template #left-icon>
            <span class="currency">¥</span>
          </template>
        </van-field>

        <div class="amount-buttons">
          <div 
            v-for="item in amountOptions" 
            :key="item"
            class="amount-btn"
            :class="{ active: selectedAmount === item }"
            @click="selectAmount(item)"
          >
            <span>¥{{ item }}</span>
            <van-icon v-if="selectedAmount === item" name="success" color="#e53e3e" />
          </div>
        </div>
      </div>

      <!-- 支付渠道 -->
      <div class="payment-section">
        <div class="section-header">
          <div class="red-bar"></div>
          <span class="section-title">支付渠道</span>
        </div>

        <div class="payment-item" @click="openPaymentDrawer('wechat')">
          <div class="payment-info">
            <div class="payment-icon">
              <img :src="wechatIcon" alt="微信" class="pay-icon" />
            </div>
            <div class="payment-desc">
              <div class="payment-name">微信</div>
              <div class="payment-text">微信支付, 轻松完成付款</div>
            </div>
          </div>
          <van-icon name="arrow" class="arrow-icon" />
        </div>

        <div class="payment-item" @click="openPaymentDrawer('alipay')">
          <div class="payment-info">
            <div class="payment-icon">
              <img :src="alipayIcon" alt="支付宝" class="pay-icon" />
            </div>
            <div class="payment-desc">
              <div class="payment-name">支付宝</div>
              <div class="payment-text">支付宝支付, 快捷又安全</div>
            </div>
          </div>
          <van-icon name="arrow" class="arrow-icon" />
        </div>

        <div class="payment-item" @click="openPaymentDrawer('unionpay')">
          <div class="payment-info">
            <div class="payment-icon">
              <img :src="unionpayIcon" alt="银联" class="pay-icon" />
            </div>
            <div class="payment-desc">
              <div class="payment-name">银联支付</div>
              <div class="payment-text">银联支付, 享银行级安全保护</div>
            </div>
          </div>
          <van-icon name="arrow" class="arrow-icon" />
        </div>
      </div>
    </div>

    <!-- 立即充值按钮 -->
    <div class="action-section">
        <van-button 
          round 
          block 
          type="primary" 
          class="recharge-btn"
          :disabled="!amount || !paymentMethod || loading"
          :loading="loading"
          @click="handleRecharge"
        >
          立即充值
        </van-button>
    </div>

    <!-- 支付通道选择抽屉 -->
    <van-popup
      v-model:show="showPaymentDrawer"
      position="bottom"
      :style="{ height: '60%' }"
      round
      class="payment-drawer"
    >
      <div class="drawer-header">
        <div class="drawer-title">{{ drawerTitle }}</div>
        <van-icon name="cross" class="close-icon" @click="showPaymentDrawer = false" />
      </div>
      
      <div class="drawer-content">
        <van-radio-group v-model="selectedChannelId">
          <div 
            v-for="channel in paymentChannels" 
            :key="channel.id"
            class="channel-item"
            @click="selectChannel(channel)"
          >
            <div class="channel-info">
              <div class="channel-icon">
                <img :src="channel.icon" alt="" class="channel-icon-img" />
              </div>
              <div class="channel-desc">
                <div class="channel-name">{{ channel.name }}</div>
                <div class="channel-limit">{{ channel.limit }}</div>
              </div>
            </div>
            <van-radio :name="channel.id" />
          </div>
        </van-radio-group>
      </div>

      <div class="drawer-footer">
        <van-button 
          round 
          block 
          type="primary" 
          class="confirm-btn"
          @click="confirmChannel"
        >
          立即充值
        </van-button>
      </div>
    </van-popup>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useWallet } from '@/composables/useWallet'
import { showToast, showDialog, showLoadingToast, closeToast } from 'vant'
import { walletApi } from '@/api'
import recordIcon from '@/assets/icons/png/record.png'
import coinIcon from '@/assets/icons/png/coin.png'
import rechargeBoxBg from '@/assets/images/backgrounds/rechargebox.png'
import wechatIcon from '@/assets/icons/png/pay/wepay.png'
import alipayIcon from '@/assets/icons/png/pay/alipay.png'
import unionpayIcon from '@/assets/icons/png/pay/unionpay.png'


const { recharge } = useWallet()

const amount = ref('')
const selectedAmount = ref(100)
const paymentMethod = ref('wechat')
const loading = ref(false)
const showPaymentDrawer = ref(false)
const currentPaymentType = ref('wechat') // 当前打开的支付方式类型
const selectedChannelId = ref(1)

// 所有支付通道列表，按支付方式分类（从后台接口获取）
const allPaymentChannels = ref({
  wechat: [],
  alipay: [],
  unionpay: []
})

// 当前显示的支付通道列表
const paymentChannels = computed(() => {
  const map = allPaymentChannels.value || {}
  return map[currentPaymentType.value] || []
})

// 当前选择的通道信息
const selectedChannel = computed(() => {
  const map = allPaymentChannels.value || {}
  const channels = map[paymentMethod.value] || []
  return channels.find(c => c.id === selectedChannelId.value) || channels[0]
})

// 根据金额和支付方式从后台获取通道列表
const fetchPaymentChannels = async (type) => {
  const payType = type || currentPaymentType.value || 'wechat'

  const money = parseFloat(amount.value || selectedAmount.value || 0)
  if (!money) {
    showToast('请先输入或选择充值金额')
    return
  }

  try {
    const res = await walletApi.getPaymentChannels({
      amount: money,
      paymentMethod: payType
    })

    if (res.code === 200) {
      const list = (res.data || []).map(item => {
        let icon = wechatIcon
        if (payType === 'alipay') icon = alipayIcon
        if (payType === 'unionpay') icon = unionpayIcon

        return {
          id: item.id,
          name: item.name,
          icon,
          method: payType,
          limit: item.limitText || `单笔交易限额${item.minMoney}~${item.maxMoney}`
        }
      })

      allPaymentChannels.value[payType] = list
    } else {
      showToast(res.message || '获取支付通道失败')
    }
  } catch (error) {
    console.error('获取支付通道失败:', error)
    showToast('获取支付通道失败')
  }
}

// 抽屉标题
const drawerTitle = computed(() => {
  const titleMap = {
    wechat: '选择微信支付',
    alipay: '选择支付宝',
    unionpay: '选择银联支付'
  }
  return titleMap[currentPaymentType.value] || '选择支付方式'
})

// 打开支付方式抽屉
const openPaymentDrawer = async (type) => {
  currentPaymentType.value = type

  // 先从后台拉取最新通道列表
  await fetchPaymentChannels(type)

  // 如果当前选择的通道属于该支付方式，保持选中；否则选中第一个
  const map = allPaymentChannels.value || {}
  const channels = map[type] || []
  if (channels.length > 0) {
    const currentChannel = channels.find(c => c.id === selectedChannelId.value)
    if (!currentChannel) {
      selectedChannelId.value = channels[0].id
    }
  }
  showPaymentDrawer.value = true
}

const selectChannel = (channel) => {
  selectedChannelId.value = channel.id
  paymentMethod.value = channel.method
}

const confirmChannel = () => {
  showPaymentDrawer.value = false
}

const amountOptions = [100, 200, 500, 1000, 5000, 10000]

const selectAmount = (value) => {
  selectedAmount.value = value
  amount.value = value.toString()
}

const showService = () => {
  showToast('联系客服')
}

const handleRecharge = async () => {
  if (loading.value) return
  
  if (!amount.value) {
    showToast('请输入充值金额')
    return
  }
  if (!paymentMethod.value) {
    showToast('请选择支付方式')
    return
  }
  
  try {
    await showDialog({
      title: '确认充值',
      message: `充值金额：¥${amount.value}\n支付方式：${getPaymentName(paymentMethod.value)}`,
    })
    
    loading.value = true
    showLoadingToast({
      message: '处理中...',
      forbidClick: true
    })
    
    const res = await recharge({
      amount: parseFloat(amount.value),
      paymentMethod: paymentMethod.value
    })

    closeToast()

    if (res && res.code === 200 && res.data && res.data.url) {
      showToast('正在跳转到支付页面')
      // 跳转到第三方支付页面
      window.location.href = res.data.url
    } else {
      showToast(res?.message || '创建充值订单失败')
    }
  } catch (error) {
    closeToast()
    if (error !== 'cancel') {
      console.error('充值失败:', error)
    }
  } finally {
    loading.value = false
  }
}

const getPaymentName = (method) => {
  const map = {
    wechat: '微信支付',
    alipay: '支付宝',
    unionpay: '银联支付'
  }
  return map[method] || ''
}
</script>

<style scoped>
.recharge-page {
  min-height: 100vh;
  background: #f5f5f5 url('@/assets/images/backgrounds/rechargehead.png') no-repeat top center;
  background-size: 100% auto;
  background-attachment: fixed;
  padding-bottom: 80px;
}

.recharge-page :deep(.van-nav-bar) {
  position: relative;
  z-index: 10;
  background: transparent;
}

.recharge-page :deep(.van-nav-bar__title) {
  color: #333;
  font-weight: bold;
}

.recharge-page :deep(.van-nav-bar__text) {
  color: #333;
}

.recharge-page :deep(.van-nav-bar__arrow) {
  color: #333;
}

.service-icon {
  width: 22px;
  height: 22px;
  cursor: pointer;
  display: block;
}

.coin-icon {
  width: 20px;
  height: 20px;
  display: block;
}

.content {
  padding: 16px;
}

.amount-section {
  background: #fff;
  background-size: 100% 100%;
  background-repeat: no-repeat;
  background-position: center;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 16px;
  margin-top: 2px;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
}


.section-header2 {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 88px;
  padding-left: 16px;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.red-bar {
  width: 4px;
  height: 16px;
  background: #e53e3e;
  border-radius: 2px;
}

.amount-input {
  margin-bottom: 16px;
  border-radius: 6px;
  border: 1px solid #89423e59;
  background: #FFF8F6;
}

.currency {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.amount-buttons {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.amount-btn {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 12px;
  text-align: center;
  font-size: 14px;
  color: #333;
  position: relative;
  cursor: pointer;
  transition: all 0.3s;
}

.amount-btn.active {
  border-color: #e53e3e;
  background: #fff5f5;
}

.amount-btn.active span {
  color: #e53e3e;
  font-weight: bold;
}

.amount-btn .van-icon {
  position: absolute;
  bottom: 4px;
  right: 4px;
}

.payment-section {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
}

.payment-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 0;
  border-bottom: 1px solid #eee;
  cursor: pointer;
}

.payment-item:last-child {
  border-bottom: none;
}

.payment-info {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
}

.payment-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.pay-icon{
  width: 43px;
  height: 43px; 
  display: flex;
  align-items: center;
  justify-content: center;
}


.alipay-text, .unionpay-text {
  color: #fff;
  font-size: 16px;
  font-weight: bold;
}

.payment-desc {
  flex: 1;
}

.payment-name {
  font-size: 16px;
  font-weight: 500;
  color: #333;
  margin-bottom: 4px;
}

.payment-text {
  font-size: 12px;
  color: #999;
}

.arrow-icon {
  color: #999;
  font-size: 16px;
}

/* 支付通道抽屉样式 */
.payment-drawer {
  padding: 0;
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 16px;
  border-bottom: 1px solid #eee;
}

.drawer-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.close-icon {
  font-size: 20px;
  color: #333;
  cursor: pointer;
}

.drawer-content {
  padding: 16px;
  max-height: calc(60vh - 140px);
  overflow-y: auto;
}

.channel-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 0;
  border-bottom: 1px solid #eee;
  cursor: pointer;
}

.channel-item:last-child {
  border-bottom: none;
}

.channel-info {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
}

.channel-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.channel-icon-img {
  width: 40px;
  height: 40px;
}

.channel-desc {
  flex: 1;
}

.channel-name {
  font-size: 16px;
  font-weight: 500;
  color: #333;
  margin-bottom: 4px;
}

.channel-limit {
  font-size: 12px;
  color: #999;
}

.drawer-footer {
  padding: 16px;
  border-top: 1px solid #eee;
}

.confirm-btn {
  background: #e53e3e;
  border: none;
  height: 48px;
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

.recharge-btn {
  background: #e53e3e;
  border: none;
  height: 48px;
}
</style>
