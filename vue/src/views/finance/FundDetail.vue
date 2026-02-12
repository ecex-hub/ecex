<template>
  <div class="fund-detail-page">
    <!-- 导航栏 -->
    <van-nav-bar
      title="资金明细"
      left-arrow
      @click-left="$router.back()"
      class="custom-nav-bar"
    />

    <!-- 顶部背景 -->
    <div class="top-bg">
      <img :src="backImage" alt="背景" class="top-bg-img" />
      <img :src="back2Image" alt="装饰" class="top-bg-decor" />
    </div>

    <!-- 顶部总览卡片 -->
    <div class="overview-wrapper">
      <div class="overview-card">
        <!-- 内容 -->
        <div class="overview-content">
         
              <!-- 标题图片 -->
          <div class="title-image-wrapper">
            <img :src="titleImage" alt="财富总览" class="title-img" />
          </div>
         
          <div class="overview-header">
            <div class="header-left">
              <div class="header-top-row">
                <img :src="icoImage" alt="图标" class="header-icon" />
                <div class="header-subtitle">{{ currentWalletName }}</div>
                <button class="change-wallet-btn" @click="openWalletDrawer">切换</button>
              </div>
              <div class="amount-value">{{ totalAmount.toLocaleString() }}</div>
            </div>
            <div class="header-divider"></div>
            <div class="header-right" @click="openMonthDrawer">             
              <!-- 时间选择 -->
              <div class="month-selector">
                <span class="month-label">时间</span>
                <img :src="dImage" alt="说明" class="month-icon" />
              </div>
              <div class="month-selector">                 
                <div class="month-value">
                  <span>{{ currentMonth }}</span>                   
                </div>
              </div>
            </div>
          </div>

        

         
        </div>
      </div>
    </div>

    <!-- 列表 -->
    <div class="list-section">
      <div class="month-title">{{ currentMonthLabel }}</div>

      <!-- 有数据时展示列表 -->
      <div v-if="records.length > 0">
        <div
          v-for="item in records"
          :key="item.id"
          class="record-item"
        >
          <div class="record-main">
            <div class="record-left">
              <div class="record-name">钱包-资金变化名称</div>
              <div class="record-time">{{ item.date }} {{ item.time }}</div>
            </div>
            <div
              class="record-amount"
              :class="item.amount > 0 ? 'income' : 'expense'"
            >
              {{ item.amount > 0 ? '+' : '' }}{{ item.amount.toFixed(2) }}

              <div class="record-footer">
                <van-tag
                  v-if="item.status === 'success'"
                  type="success"
                  class="status-tag"
                >
                  已完成
                </van-tag>
                <van-tag
                  v-else-if="item.status === 'cancel'"
                  type="primary"
                  plain
                  class="status-tag"
                >
                  已取消
                </van-tag>
                <van-tag
                  v-else-if="item.status === 'review'"
                  type="warning"
                  class="status-tag"
                >
                  审核中
                </van-tag>
                <van-tag
                  v-else-if="item.status === 'failed'"
                  type="danger"
                  class="status-tag"
                >
                  已失败
                </van-tag>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 无数据时展示空状态 -->
      <div v-else class="empty-section">
        <img :src="emptyImage" alt="暂无数据" class="empty-image" />
        <div class="empty-text">暂无资金明细</div>
      </div>
    </div>

    <!-- 钱包切换抽屉（样式参考 Withdraw.vue） -->
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
        <div
          class="drawer-content"
          ref="drawerContentRef"
          @scroll="handleScroll"
          @touchstart="handleTouchStart"
          @touchend="handleTouchEnd"
        >
          <div class="wallet-spacer"></div>
          <div
            v-for="wallet in walletList"
            :key="wallet.id"
            class="wallet-item"
            :class="{ active: selectedWalletId === wallet.id }"
            :ref="el => setWalletItemRef(el, wallet.id)"
            @click="selectedWalletId = wallet.id"
          >
            <div class="wallet-name">{{ wallet.name }}</div>
          </div>
          <div class="wallet-spacer"></div>
        </div>
      </div>
    </van-popup>

    <!-- 月份选择抽屉（左年右月，两列选择） -->
    <van-popup
      v-model:show="showMonthDrawer"
      position="bottom"
      :style="{ height: '50%' }"
      round
      class="wallet-drawer"
    >
      <div class="drawer-header">
        <div class="drawer-cancel" @click="showMonthDrawer = false">取消</div>
        <div class="drawer-title">选择月份</div>
        <div class="drawer-confirm" @click="confirmMonth">确定</div>
      </div>

      <div class="month-drawer-body">
        <!-- 年份列 -->
        <div class="drawer-content-wrapper" ref="yearWrapperRef">
          <div class="drawer-selection-indicator"></div>
          <div
            class="drawer-content"
            ref="yearContentRef"
            @scroll="handleYearScroll"
            @touchstart="handleYearTouchStart"
            @touchend="handleYearTouchEnd"
          >
            <div class="wallet-spacer"></div>
            <div
              v-for="year in yearList"
              :key="year"
              class="wallet-item"
              :class="{ active: year === selectedYear.value }"
              :ref="el => setYearItemRef(el, year)"
              @click="selectedYear.value = year"
            >
              <div class="wallet-name">{{ year }}</div>
            </div>
            <div class="wallet-spacer"></div>
          </div>
        </div>

        <!-- 月份列 -->
        <div class="drawer-content-wrapper" ref="monthWrapperRef">
          <div class="drawer-selection-indicator"></div>
          <div
            class="drawer-content"
            ref="monthContentRef"
            @scroll="handleMonthScroll"
            @touchstart="handleMonthTouchStart"
            @touchend="handleMonthTouchEnd"
          >
            <div class="wallet-spacer"></div>
            <div
              v-for="m in monthList"
              :key="m"
              class="wallet-item"
              :class="{ active: m === selectedMonth.value }"
              :ref="el => setMonthItemRef(el, m)"
              @click="selectedMonth.value = m"
            >
              <div class="wallet-name">{{ m }}月</div>
            </div>
            <div class="wallet-spacer"></div>
          </div>
        </div>
      </div>
    </van-popup>
  </div>
</template>

<script setup>
import { ref, computed, nextTick, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { showToast } from 'vant'
import backImage from '@/assets/icons/png/finance/back.png'
import back2Image from '@/assets/icons/png/finance/back2.png'
import titleImage from '@/assets/icons/png/finance/title.png'
import icoImage from '@/assets/icons/png/finance/ico.png'
import dImage from '@/assets/icons/png/finance/d.png'
import emptyImage from '@/assets/icons/png/empty.png'
import { useWallet } from '@/composables/useWallet'
import { useWalletStore } from '@/stores/wallet'

// 钱包相关（余额信息）
const { balance, rechargeBalance, pendingAmount, totalBalance } = useWallet()

// 钱包明细相关（使用 Pinia store 调接口）
const walletStore = useWalletStore()
const { transactionList } = storeToRefs(walletStore)
const listLoading = ref(false)

// 根据当前选中的钱包计算显示金额
const selectedWalletId = ref(1)
const totalAmount = computed(() => {
  switch (selectedWalletId.value) {
    case 1:
      return balance.value || 0
    case 2:
      return rechargeBalance.value || 0
    case 3:
      return pendingAmount.value || 0
    default:
      return totalBalance.value || 0
  }
})

const currentMonth = ref('2026-01')
const currentMonthLabel = computed(() => `${currentMonth.value}月`)

// 钱包切换
const showWalletDrawer = ref(false)
const currentWalletName = ref('余额钱包')
const walletList = ref([
  { id: 1, name: '余额钱包' },
  { id: 2, name: '充值钱包' },
  { id: 3, name: '待审核钱包' }
])

// 月份选择
const showMonthDrawer = ref(false)
const yearList = ref([2024, 2025, 2026, 2027, 2028])
const monthList = ref([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
const selectedYear = ref(2026)
const selectedMonth = ref(1)

// 抽屉滚动相关
const drawerContentRef = ref(null)
const drawerWrapperRef = ref(null)
const walletItemRefs = ref({})
let isScrolling = false
let touchStartY = 0
let isTouching = false
let scrollTimer = null
let isUserScrolling = false

const setWalletItemRef = (el, id) => {
  if (el) {
    walletItemRefs.value[id] = el
  }
}

const updateSelectedItem = () => {
  const container = drawerContentRef.value
  const wrapper = drawerWrapperRef.value
  if (!container || !wrapper) return

  const wrapperRect = wrapper.getBoundingClientRect()
  const wrapperCenter = wrapperRect.top + wrapperRect.height / 2

  let closestItem = null
  let closestDistance = Infinity

  walletList.value.forEach((wallet) => {
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
  }
}

const scrollToCenter = () => {
  const selectedItem = walletItemRefs.value[selectedWalletId.value]
  const container = drawerContentRef.value
  const wrapper = drawerWrapperRef.value
  if (!selectedItem || !container || !wrapper) return

  const wrapperRect = wrapper.getBoundingClientRect()
  const itemOffsetTop = selectedItem.offsetTop
  const itemHeight = selectedItem.offsetHeight
  const itemCenter = itemOffsetTop + itemHeight / 2

  const wrapperCenter = wrapperRect.height / 2
  const visibleCenter = container.scrollTop + wrapperCenter
  const scrollOffset = itemCenter - visibleCenter

  if (Math.abs(scrollOffset) > 1) {
    container.scrollTop += scrollOffset
  }
}

const handleTouchStart = (e) => {
  touchStartY = e.touches[0].clientY
  isTouching = true
  isUserScrolling = true
}

const handleTouchEnd = () => {
  isTouching = false
  setTimeout(() => {
    if (!isTouching) {
      scrollToCenter()
    }
  }, 100)
}

const handleScroll = () => {
  if (isScrolling) return

  isUserScrolling = true

  if (scrollTimer) {
    clearTimeout(scrollTimer)
  }

  updateSelectedItem()

  scrollTimer = setTimeout(() => {
    isUserScrolling = false
    scrollToCenter()
  }, 120)
}

const openWalletDrawer = () => {
  const currentWallet = walletList.value.find((w) => w.name === currentWalletName.value)
  if (currentWallet) {
    selectedWalletId.value = currentWallet.id
  }
  showWalletDrawer.value = true
  nextTick(() => {
    scrollToCenter()
  })
}

const confirmWallet = () => {
  const wallet = walletList.value.find((w) => w.id === selectedWalletId.value)
  if (wallet) {
    currentWalletName.value = wallet.name
  }
  showWalletDrawer.value = false
  // 切换钱包后刷新资金明细
  fetchTransactionList()
}

// ===== 年月列抽屉滚动控制 =====
const yearContentRef = ref(null)
const yearWrapperRef = ref(null)
const yearItemRefs = ref({})
let yearScrollTimer = null

const monthContentRef = ref(null)
const monthWrapperRef = ref(null)
const monthItemRefs = ref({})
let monthScrollTimer = null

const setYearItemRef = (el, year) => {
  if (el) {
    yearItemRefs.value[year] = el
  }
}

const setMonthItemRef = (el, month) => {
  if (el) {
    monthItemRefs.value[month] = el
  }
}

const scrollListToCenter = (container, wrapper, item) => {
  if (!container || !wrapper || !item) return

  const wrapperRect = wrapper.getBoundingClientRect()
  const itemOffsetTop = item.offsetTop
  const itemHeight = item.offsetHeight
  const itemCenter = itemOffsetTop + itemHeight / 2

  const wrapperCenter = wrapperRect.height / 2
  const visibleCenter = container.scrollTop + wrapperCenter
  const scrollOffset = itemCenter - visibleCenter

  if (Math.abs(scrollOffset) > 1) {
    container.scrollTop += scrollOffset
  }
}

const updateSelectedFromList = (list, itemRefs, wrapper, setSelected) => {
  if (!wrapper) return
  const wrapperRect = wrapper.getBoundingClientRect()
  const wrapperCenter = wrapperRect.top + wrapperRect.height / 2

  let closestValue = null
  let closestDistance = Infinity

  list.value.forEach((val) => {
    const item = itemRefs.value[val]
    if (item) {
      const rect = item.getBoundingClientRect()
      const center = rect.top + rect.height / 2
      const distance = Math.abs(center - wrapperCenter)
      if (distance < closestDistance) {
        closestDistance = distance
        closestValue = val
      }
    }
  })

  if (closestValue != null) {
    setSelected(closestValue)
  }
}

const handleYearScroll = () => {
  const container = yearContentRef.value
  const wrapper = yearWrapperRef.value
  if (!container || !wrapper) return

  if (yearScrollTimer) clearTimeout(yearScrollTimer)

  yearScrollTimer = setTimeout(() => {
    updateSelectedFromList(yearList, yearItemRefs, wrapper, (val) => {
      selectedYear.value = val
      const item = yearItemRefs.value[val]
      scrollListToCenter(container, wrapper, item)
    })
  }, 100)
}

const handleYearTouchStart = () => {}

const handleYearTouchEnd = () => {
  handleYearScroll()
}

const handleMonthScroll = () => {
  const container = monthContentRef.value
  const wrapper = monthWrapperRef.value
  if (!container || !wrapper) return

  if (monthScrollTimer) clearTimeout(monthScrollTimer)

  monthScrollTimer = setTimeout(() => {
    updateSelectedFromList(monthList, monthItemRefs, wrapper, (val) => {
      selectedMonth.value = val
      const item = monthItemRefs.value[val]
      scrollListToCenter(container, wrapper, item)
    })
  }, 100)
}

const handleMonthTouchStart = () => {}

const handleMonthTouchEnd = () => {
  handleMonthScroll()
}

const openMonthDrawer = () => {
  // 根据 currentMonth 初始化选中值
  const [y, m] = currentMonth.value.split('-')
  const yearNum = Number(y)
  const monthNum = Number(m)
  if (yearList.value.includes(yearNum)) {
    selectedYear.value = yearNum
  }
  if (monthList.value.includes(monthNum)) {
    selectedMonth.value = monthNum
  }

  showMonthDrawer.value = true

  nextTick(() => {
    const yItem = yearItemRefs.value[selectedYear.value]
    scrollListToCenter(yearContentRef.value, yearWrapperRef.value, yItem)

    const mItem = monthItemRefs.value[selectedMonth.value]
    scrollListToCenter(monthContentRef.value, monthWrapperRef.value, mItem)
  })
}

const confirmMonth = () => {
  const y = selectedYear.value
  const m = selectedMonth.value
  const mm = m < 10 ? `0${m}` : String(m)
  currentMonth.value = `${y}-${mm}`
  showMonthDrawer.value = false
  // 切换月份后刷新资金明细
  fetchTransactionList()
}

// ===== 资金明细列表接口 =====
const records = ref([])

const normalizeRecords = (list = []) => {
  return list.map((item, index) => {
    // 兼容后端不同字段命名：优先使用已有字段，否则尝试从 create_time 拆分
    let date = item.date || ''
    let time = item.time || ''

    if ((!date || !time) && item.create_time) {
      const parts = String(item.create_time).split(' ')
      date = date || parts[0] || ''
      time = time || parts[1] || ''
    }

    return {
      id: item.id ?? index + 1,
      amount: Number(item.amount ?? 0),
      status: item.status ?? 'success',
      date,
      time,
      // 保留原始字段，方便后续扩展
      ...item
    }
  })
}

const fetchTransactionList = async () => {
  if (listLoading.value) return
  listLoading.value = true
  try {
    const [year, month] = currentMonth.value.split('-')
    const params = {
      year,
      month,
      wallet_type: selectedWalletId.value
    }

    const res = await walletStore.fetchTransactionList(params)
    const list = res?.data?.list || transactionList.value || []
    records.value = normalizeRecords(list)
  } catch (error) {
    console.error('获取资金明细失败:', error)
    showToast('获取资金明细失败')
  } finally {
    listLoading.value = false
  }
}

onMounted(() => {
  // 页面初始化时加载一次资金明细
  fetchTransactionList()
})
</script>

<style scoped>
.fund-detail-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 24px;
  position: relative;
}

.custom-nav-bar {
  background: transparent;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
}

.custom-nav-bar :deep(.van-nav-bar__title) {
  color: #fff;
  font-weight: bold;
  font-size: 18px;
}

.custom-nav-bar :deep(.van-nav-bar__arrow) {
  color: #fff;
}

.custom-nav-bar :deep(.van-nav-bar__left) {
  padding-left: 8px;
}

.fund-detail-page :deep(.van-nav-bar[class*='van-hairline']:after) {
  border: none;
  display: none;
}

.top-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0; 
  overflow: hidden;
  z-index: 1;
}

.top-bg-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.top-bg-decor {
  position: absolute;
  left: 50%;
  bottom: 38px;
  transform: translateX(-50%);
  width: 94%;
  height: 200px;
}

.overview-wrapper {
  padding: 60px 16px 0;
}

.overview-card {
  position: relative;
  overflow: hidden;
  z-index: 2;
}

.overview-content {
  position: relative;
  z-index: 2;
  padding: 20px 16px 16px;
  color: #fff;
}

.overview-header {
  display: flex;
  justify-content: space-between;
  align-items: center; 
  margin-top: 50px;
  color: #000;
}

.header-left {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 4px;
  flex: 1.5;
}

.header-icon {
  width: 30px;
  height: 30px;
}

.header-title {
  font-size: 18px;
  font-weight: 700;
}

.header-subtitle {
  font-size: 16px;
  opacity: 0.9;
  color: #000;
}

.header-right {
  text-align: right;
  padding-top: 20px;
  margin-right: 20px;
  flex: 0.5;
}

.header-divider {
  width: 1px;
  height: 36px;
  background-color: #e0e0e0;
  margin-top: 40px;
}

.amount-label {
  font-size: 12px;
  opacity: 0.9;
}

.amount-value {
  margin-top: 10px;
  font-size: 26px;
  font-weight: 700;
}

.title-image-wrapper {
  margin-top: 12px;
  display: flex;
  justify-content: flex-start;
}

.title-img {
  height: 44px;
  width: auto;
}

.month-selector {
  margin-top: 12px;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #000;
}

.month-label {
  opacity: 0.9;
  color: #5a5858;
}

.month-icon {
  height:8px;
  margin-left: 3px;
}

.month-value {
  display: inline-flex;
  align-items: center;
  color: #000;
  font-size: 16px;
  font-weight: 700;
}

.change-wallet-btn {
  margin-left: 8px;
  padding: 2px 10px;
  font-size: 12px;
  color: #e53e3e;
  background-color: #ffeae5;
  border: 1px solid #f5b2a4;
  border-radius: 12px;
}

.change-wallet-btn:active {
  opacity: 0.8;
}

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

.month-drawer-body {
  flex: 1;
  display: flex;
  min-height: 0;
}

.month-drawer-body .drawer-content-wrapper {
  flex: 1;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.list-section {
  padding: 16px 16px 0;
}

.month-title {
  font-size: 14px;
  color: #999;
  margin-bottom: 8px;
}

.record-item {  
  padding: 12px 16px;
  margin-bottom: 9px;
}

.record-main {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.record-left {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.record-name {
  font-size: 17px;
  color: #161616;
  font-weight: bold;
}

.record-time {
  font-size: 15px;
  color: #9c9999;
  margin-top: 10px;
}

.record-amount {
  font-size: 20px;
  margin-top: 10px;
  font-weight: bold;
}

.record-amount.income {
  color: #ff4b3a;
}

.record-amount.expense {
  color: #00a96b;
}

.record-footer {
  margin-top: 2px;
}

.status-tag {
  font-size: 11px;
  border-radius: 20px;
  padding: 2px 8px;
}

.header-top-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.empty-text{
  text-align: center;
  font-size: 16px;
  color: #707070;
  font-weight: 500;
  margin-top: 20px;
}
</style>

