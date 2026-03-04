<template>
  <div class="profile-page">
    <!-- 顶部用户信息 -->
    <div class="profile-header">
      <!-- head.png 背景层 -->
    
      <div class="header-bg">
        <div class="user-info">
          <div class="service-icon" @click="showService">
            <van-icon name="service-o" size="24" color="#fff" />
          </div>
          <div class="avatar-section">
            <van-image
              :src="headImage"
              round
              width="80"
              height="80"
              fit="cover"
            />
            <div class="level-badge">
              <van-icon name="star" color="#ffd700" />
              <span>{{ userLevel }}</span>
            </div>
          </div>
          <div class="user-details">
            <div class="nickname">{{ nickname }}</div>
            <div class="user-id">
              {{ displayUserId }}
              <img :src="copyIcon" alt="复制" class="copy-icon" @click="copyId" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 我的钱包 -->
    <div class="wallet-section">
      <div class="wallet-header">
        <img :src="waIcon" alt="钱包" class="wallet-icon" />
        <span class="wallet-title">我的钱包</span>
      </div>
      <div class="wallet-balance">
        <div class="balance-item">         
          <div class="balance-value">¥{{ safeBalance.toFixed(2) }}</div>
          <div class="balance-label">余额钱包</div>
        </div>
        <div class="balance-item">          
          <div class="balance-value">¥{{ safeRechargeBalance.toFixed(2) }}</div>
          <div class="balance-label">充值钱包</div>
        </div>
        <div class="balance-item">          
          <div class="balance-value">¥{{ safePendingAmount.toFixed(2) }}</div>
          <div class="balance-label">待审核金额</div>
        </div>
      </div>
      <div class="wallet-actions">
        <van-button 
          round 
          class="action-btn recharge-btn"
          @click="$router.push('/recharge')"
        >
          充值
        </van-button>
        <van-button 
          round 
          class="action-btn withdraw-btn"
          @click="$router.push('/withdraw')"
        >
          提现
        </van-button>
      </div>
    </div>

    <!-- 服务横幅 -->
    <div class="banner-section" @click="$router.push('/exchange/asset-redemption')">
      <img :src="sureImage" alt="资产确权兑付" class="sure-banner" />
    </div>

    <!-- 两个图片横向排列 -->
    <div class="tabs-section">
      <div class="tab-item" @click="$router.push('/payment-progress')">
        <img :src="tab1Image" alt="tab1" class="tab-image" />
        <div class="tab-text">
          <div class="tab-line1 back1">款项进度服务</div>
          <div class="tab-line2">立即查看 ></div>
        </div>
      </div>
      <div class="tab-item">
        <img :src="tab2Image" alt="tab2" class="tab-image" />
        <div class="tab-text">
          <div class="tab-line1 back2">退费办理窗口</div>
          <div class="tab-line2">立即查看 ></div>
        </div>
      </div>
    </div>

    <!-- 我的工具 -->
    <div class="tools-section">
      <div class="section-title">
        <div class="red-bar"></div>
        <span>我的工具</span>
      </div>
      <van-grid :column-num="4" :border="false">
        <van-grid-item 
          v-for="tool in tools" 
          :key="tool.id"
          @click="handleTool(tool)"
        >
          <div class="tool-item">
            <img :src="tool.icon" :alt="tool.name" class="tool-icon-img" />
            <div class="tool-label">{{ tool.name }}</div>
          </div>
        </van-grid-item>
      </van-grid>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useWallet } from '@/composables/useWallet'
import { showToast } from 'vant'
import { formatPhone, formatIdCard } from '@/utils'
import { config, STORAGE_KEYS } from '@/config'
import profileBg from '@/assets/images/backgrounds/profile.png'
import headImage from '@/assets/images/backgrounds/head.png'
import copyIcon from '@/assets/icons/png/copy.png'
import sureImage from '@/assets/images/backgrounds/sure.png'
import walletBack from '@/assets/images/backgrounds/walletback.png'
import waIcon from '@/assets/images/backgrounds/wa.png'
import tab1Image from '@/assets/images/backgrounds/tab1.png'
import tab2Image from '@/assets/images/backgrounds/tab2.png'
import icon1 from '@/assets/icons/png/my/1.png'
import icon2 from '@/assets/icons/png/my/2.png'
import icon3 from '@/assets/icons/png/my/3.png'
import icon4 from '@/assets/icons/png/my/4.png'
import icon5 from '@/assets/icons/png/my/5.png'
import icon6 from '@/assets/icons/png/my/6.png'
import icon7 from '@/assets/icons/png/my/7.png'
import icon8 from '@/assets/icons/png/my/8.png'
import icon9 from '@/assets/icons/png/my/9.png'
import icon10 from '@/assets/icons/png/my/10.png'

const router = useRouter()
const userStore = useUserStore()
const { balance, rechargeBalance, pendingAmount, fetchWalletInfo } = useWallet()

// 确保钱包余额有默认值，避免调用 toFixed 时出错
const safeBalance = computed(() => balance.value ?? 0)
const safeRechargeBalance = computed(() => rechargeBalance.value ?? 0)
const safePendingAmount = computed(() => pendingAmount.value ?? 0)

// 用户信息
const userInfo = computed(() => userStore.userInfo)
const nickname = computed(() => userInfo.value?.nickname || '用户昵称')
const userId = computed(() => userInfo.value?.id || '')
const userLevel = computed(() => userInfo.value?.level || '二级会员')

// 基础配置信息（如客服链接、群聊图片等，从首页缓存 /home/index 获取）
const baseInfo = ref({})

// 格式化用户ID显示
const displayUserId = computed(() => {
  if (userId.value) {
    // 确保转换为字符串
    const userIdStr = String(userId.value)
    // 如果长度足够，使用格式化函数
    if (userIdStr.length >= 7) {
      const formatted = formatIdCard(userIdStr)
      if (formatted && formatted !== userIdStr) {
        return `ID: ${formatted}`
      }
    }
    // 否则使用简单的隐藏方式
    if (userIdStr.length > 7) {
      return `ID: ${userIdStr.slice(0, 3)}****${userIdStr.slice(-4)}`
    }
    return `ID: ${userIdStr}`
  }
  return 'ID: 139****2864'
})

// 初始化用户信息 & 基础配置
onMounted(async () => {
  if (userStore.loggedIn && !userInfo.value) {
    try {
      await userStore.fetchUserInfo()
    } catch (error) {
      console.error('获取用户信息失败:', error)
    }
  }
  // 获取钱包信息
 //await fetchWalletInfo()
  // 从本地缓存中读取首页基础配置信息（在 Home.vue 中已请求并写入）
  try {
    const cacheStr = localStorage.getItem(STORAGE_KEYS.HOME_INDEX_DATA)
    if (cacheStr) {
      const cache = JSON.parse(cacheStr)
      if (cache && typeof cache === 'object') {
        baseInfo.value = cache
      }
    }
  } catch (error) {
    console.error('读取基础配置信息缓存失败:', error)
  }
})

const toolIcons = [icon1, icon2, icon3, icon4, icon5, icon6, icon7, icon8, icon9, icon10]

const tools = ref([
  { id: 1, name: '款项进度', icon: icon1, color: '#e53e3e', route: '/payment-progress' },
  { id: 2, name: '实名认证', icon: icon2, color: '#ff9800', route: '/realname' },
  { id: 3, name: '提现账户', icon: icon3, color: '#9c27b0', route: '/payment-accounts' },
  { id: 4, name: '修改密码', icon: icon4, color: '#4caf50', route: '/reset-password' },
  { id: 5, name: '联系客服', icon: icon5, color: '#9c27b0', action: 'customer_service' },
  { id: 6, name: '我的团队', icon: icon6, color: '#e53e3e', route: '/team' },
  { id: 7, name: '邀请好友', icon: icon7, color: '#2196f3', route: '/team/invite' },
  { id: 8, name: '资金明细', icon: icon8, color: '#ff9800', route: '/finance/fund-detail' },
  { id: 9, name: '官方群聊', icon: icon9, color: '#ff9800', route: '/kefu' },
  { id: 10, name: '安全退出', icon: icon10, color: '#e53e3e', route: '', action: 'logout' }
])

const copyId = () => {
  showToast('ID已复制')
}

// 打开客服外部链接（来自 localStorage.homeIndexData.customer_service）
const openCustomerService = () => {
  let url = ''
  try {
    const cacheStr = localStorage.getItem(STORAGE_KEYS.HOME_INDEX_DATA)
    if (cacheStr) {
      const cache = JSON.parse(cacheStr)
      url = cache?.customer_service || ''
    }
    // 兜底：如果已经在本页通过 baseInfo 读到了数据，也一起用上
    if (!url && baseInfo.value && typeof baseInfo.value === 'object') {
      url = baseInfo.value.customer_service || ''
    }
  } catch (error) {
    console.error('读取客服链接失败:', error)
  }

  if (!url) {
    showToast('客服链接未配置')
    return
  }

  // 处理为前端可访问的完整地址
  if (url.startsWith('/')) {
    // 相对路径（如 /uploads/xxx），拼接后端域名
    url = config.baseURL.replace(/\/+$/, '') + url
  } else if (!url.startsWith('http://') && !url.startsWith('https://')) {
    // 纯域名或其他，补全协议
    url = 'https://' + url
  }

  window.open(url, '_blank')
}

const showService = () => {
  openCustomerService()
}

const viewProgress = () => {
  showToast('查看款项进度')
}

const viewRefund = () => {
  showToast('查看退费窗口')
}

const handleTool = async (tool) => {
  if (tool.action === 'logout') {
    try {
      await userStore.logout()
      showToast('已退出登录')
      router.push('/login')
    } catch (error) {
      console.error('退出登录失败:', error)
    }
  } else if (tool.action === 'customer_service') {
    openCustomerService()
  } else if (tool.route) {
    router.push(tool.route)
  } else {
    showToast(tool.name)
  }
}
</script>

<style scoped>
.profile-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}

.profile-header {
  background-image: v-bind('"url(" + profileBg + ")"');
  background-size: 100% auto;
  background-position: center top;
  background-repeat: no-repeat;
  padding: 20px 16px 30px;
  position: relative;
  overflow: visible;
  min-height: 268px;
}



.header-bg {
  position: relative;
  width: 100%;
  height: 100%;
  z-index: 2;
}

.user-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  position: relative;
  z-index: 3;
  padding-top: 188px;
}

.avatar-section {
  position: relative;
  z-index: 4;
  margin-top: -40px;
}

.level-badge {
  position: absolute;
  bottom: -8px;
  left: 50%;
  transform: translateX(-50%);
  background: #e53e3e;
  color: #fff;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 10px;
  white-space: nowrap;
  display: flex;
  align-items: center;
  gap: 2px;
}

.user-details {
  display: flex;
  flex-direction: column;
  align-items: center;  
  margin-top: 8px;
}

.nickname {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 8px;
  color: #000000;
  text-align: center;
}

.user-id {
  font-size: 14px;
  opacity: 0.9;
  display: flex;
  align-items: center;
  gap: 4px;
  color: #727272;
  text-align: center;
}

.copy-icon {
  width: 16px;
  height: 16px;
  cursor: pointer;
  vertical-align: middle;
}

.service-icon {
  position: absolute;
  top: 20px;
  right: 16px;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: rgba(255,255,255,0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 5;
}

.wallet-section {
  margin: -20px 16px 16px;
  background: #fff;
  background-image: v-bind('"url(" + walletBack + ")"');
  background-position: center top;
  background-repeat: no-repeat;
  background-size: 60% auto;
  border-radius: 12px;
  padding: 12px 20px 20px 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  position: relative;
  z-index: 10;
}

.wallet-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 23px;
  justify-content: center;
}

.wallet-icon {
  width: 26px;
  height: 28px;
  object-fit: contain;
}

.wallet-title {
  font-size: 18px;
  font-weight: bold;
  color: #ffffff;
  margin-bottom: 5px;
  margin-left: 5px;
}

.wallet-balance {
  display: flex;
  justify-content: space-around;
  margin-bottom: 16px;
}

.balance-item {
  text-align: center;
}

.balance-label {
  font-size: 12px;
  color: #999;
  margin-top: 8px;
  margin-bottom: 8px;
}

.balance-value {
  margin-top: 10px;
  font-size: 20px;
  font-weight: bold;
  color: #161616;
}

.wallet-actions {
  display: flex;
  gap: 35px;
}

.action-btn {
  flex: 1;
  height: 40px;
}

.recharge-btn {
  background: #FFF0E9;
  color: #CE231A;
  border: 1px solid #CE231A;
  font-weight: bold;
  font-size: 16px;
  height: 45px;
}

.withdraw-btn {
  background: #FFF0E9;
  color: #CE231A;
  border: 1px solid #CE231A;
  font-weight: bold;
  font-size: 16px;   
  height: 45px;
}

.banner-section {
  padding: 0 16px 16px;
  cursor: pointer;
}

.sure-banner {
  width: 100%;
  height: auto;
  display: block;
  border-radius: 12px;
}

.tabs-section {
  display: flex;
  gap: 12px;
  padding: 0 16px 16px;
}

.tab-item {
  flex: 1;
  position: relative;
}

.tab-image {
  width: 100%;
  height: auto;
  display: block;
  border-radius: 8px;
}

.tab-text {
  position: absolute;
  top: 50%;
  right: 16px;
  transform: translateY(-50%);
  text-align: right;
 
}

.tab-line1 {
  font-size: 14px;
  font-weight: bolder;
  margin-bottom: 4px;
  color: #514b4b;
  padding: 3px 6px;
  border-radius: 3px;
}

.back1{
  background: #FBDCC7;
}
.back2{
  background: #EEE3BD;
}

.tab-line2 {
  font-size: 12px;
  opacity: 0.9;
  color: #746f6f;
  margin-top: 10px;
}

.main-banner {
  background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
  border-radius: 12px;
  padding: 20px;
  color: #fff;
  margin-bottom: 12px;
}

.banner-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 8px;
}

.banner-desc {
  font-size: 14px;
  opacity: 0.9;
}

.service-banners {
  display: flex;
  gap: 12px;
}

.service-item {
  flex: 1;
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.service-icon {
  font-size: 32px;
}

.service-text {
  flex: 1;
}

.service-name {
  font-size: 14px;
  color: #333;
  margin-bottom: 4px;
}

.service-action {
  font-size: 12px;
  color: #e53e3e;
}

.tools-section {
  background: #fff;
  margin: 16px;
  border-radius: 12px;
  padding: 20px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
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

.tool-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.tool-icon-img {
  width: 50px;
  height: 50px;
  object-fit: contain;
}

.tool-label {
  font-size: 12px;
  color: #333;
}
</style>
