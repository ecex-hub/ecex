<template>
  <div class="product-detail-page">
    <!-- 顶部导航栏 -->
    <van-nav-bar
      title="积分商城"
      left-arrow
      @click-left="$router.back()"
      class="custom-nav-bar"
    />

    <!-- 商品大图区域 -->
    <div class="product-image-section">
      <img :src="product.image" :alt="product.title" class="product-main-image" />
    </div>

    <!-- 积分和商品描述区域（红色横幅） -->
    <div class="points-banner" :style="{ backgroundImage: `url(${pricebackBg})` }">
      <div class="points-display">
        <span class="points-number">{{ product.points }}</span>
        <span class="points-label">积分</span>
      </div>
      <div class="product-description">
        {{ product.title }}
      </div>
    </div>

    <!-- 收货地址卡片 -->
    <div class="address-card" @click="goToAddress">
      <div class="address-content">
        <span v-if="!shippingAddress" class="address-empty">暂无收货地址，</span>
        <span v-else class="address-text">{{ shippingAddress }}</span>
        <span class="address-link">去添加收货地址</span>
      </div>
      <van-icon name="arrow" class="arrow-icon" />
    </div>

    <!-- 商品详情分隔线 -->
    <div class="detail-divider">
      <span class="divider-text">————商品详情—————</span>
    </div>

    <!-- 商品详情图片 -->
    <div class="detail-content">
      <img 
        v-for="(image, index) in detailImages" 
        :key="index"
        :src="image" 
        :alt="`商品详情图${index + 1}`"
        class="detail-image"
      />
    </div>


    <div class="points-info-section">
      <div class="points-info-content">
        <span class="points-info-label">兑换消耗积分</span>
        <span class="points-info-value">{{ product.points }}</span>
      </div>
    </div>

    <!-- 立即兑换按钮 -->
    <div class="exchange-button-container">
      <van-button 
        type="primary" 
        block 
        class="exchange-button"
        @click="handleExchange"
      >
        立即兑换
      </van-button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { showToast, showDialog } from 'vant'
import pricebackBg from '@/assets/images/backgrounds/priceback.png'
import { mallApi } from '@/api'
import request from '@/utils/request'

const route = useRoute()
const router = useRouter()

// 从路由参数获取商品ID（优先使用 id，没有则从 query.product 中解析）
const productId = computed(() => route.params.id || route.query.id)

// 商品数据
const product = ref({
  id: null,
  title: '',
  points: 0,
  image: '',
  code: ''
})

// 当前用户积分
const myPoints = ref(0)

// 收货地址（文案）和地址 ID
const shippingAddress = ref('')
const shippingAddressId = ref(null)

// 商品详情图片列表（后端暂未提供，先用主图填充）
const detailImages = ref([])

// 跳转到地址管理
const goToAddress = () => {
  // 这里可以直接跳转到你的地址管理页面路由
  // 例如：router.push('/address')
  router.push('/address')
}

// 获取当前用户积分
const fetchPoints = async () => {
  try {
    const res = await mallApi.getPointsInfo()
    myPoints.value = res.data?.points ?? 0
  } catch (e) {
    console.error('获取积分失败', e)
  }
}

// 获取默认收货地址
const fetchDefaultAddress = async () => {
  try {
    // 后端 address/list 是 POST
    const res = await request({
      url: '/address/list',
      method: 'post'
    })
    const list = res.data || []
    if (Array.isArray(list) && list.length) {
      // 优先找到 is_default === 2 的地址
      const defaultAddr = list.find((item) => item.is_default === 2) || list[0]
      shippingAddressId.value = defaultAddr.id
      // 拼接展示文案：省市区 + 详细地址
      const prefix = defaultAddr.prefix || ''
      shippingAddress.value = `${defaultAddr.name} ${defaultAddr.phone} ${prefix}${defaultAddr.address}`
    } else {
      shippingAddress.value = ''
      shippingAddressId.value = null
    }
  } catch (e) {
    console.error('获取地址列表失败', e)
  }
}

// 初始化商品数据（从列表页传过来的 product 或者 productId）
const initProduct = () => {
  if (route.query.product) {
    try {
      const productData = JSON.parse(decodeURIComponent(route.query.product))
      product.value = {
        id: productData.id,
        title: productData.title || productData.name || '',
        points: productData.points || 0,
        image: productData.image || '',
        code: productData.code || ''
      }
      // 详情图片暂时使用主图填充
      detailImages.value = [product.value.image].filter(Boolean)
      return
    } catch (e) {
      console.error('解析商品数据失败', e)
    }
  }
  // 如果没有传 product，可在这里根据 productId 调用商品详情接口（目前后端暂无，先留空）
}

// 处理立即兑换
const handleExchange = async () => {
  if (!product.value.id) {
    showToast('商品信息有误，无法兑换')
    return
  }

  // 检查积分是否足够
  if (product.value.points > myPoints.value) {
    showToast('积分不足，无法兑换')
    return
  }

  // 检查是否有收货地址
  if (!shippingAddressId.value) {
    showDialog({
      title: '提示',
      message: '请先添加收货地址',
      confirmButtonText: '去添加'
    }).then(() => {
      goToAddress()
    })
    return
  }

  try {
    const res = await mallApi.exchangeProduct({
      productId: product.value.id,
      addressId: shippingAddressId.value,
      quantity: 1
    })
    const orderId = res.data?.orderId
    showToast(orderId ? `兑换成功，订单号：${orderId}` : '兑换成功')
  } catch (e) {
    // mallApi.exchangeProduct 内部会统一处理错误提示
    console.error('兑换失败', e)
  }
}

// 加载商品详情 / 用户积分 / 地址
onMounted(() => {
  initProduct()
  fetchPoints()
  fetchDefaultAddress()
})
</script>

<style scoped>
.product-detail-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 80px;
}

/* 自定义导航栏 */
.custom-nav-bar {
  background: #fff;
  border-bottom: 1px solid #eee;
}

.product-detail-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}

.custom-nav-bar :deep(.van-nav-bar__title) {
  color: #000000;
  font-weight: bold;
}

.custom-nav-bar :deep(.van-nav-bar__arrow) {
  color: #050505;
}

.custom-nav-bar :deep(.van-nav-bar__content) {
  border-bottom: none;
}

/* 商品大图区域 */
.product-image-section {
  width: 100%;
  background: #fff;
}

.product-main-image {
  width: 100%;
  height: auto;
  display: block;
}

/* 积分和商品描述区域（红色横幅） */
.points-banner {
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  padding: 20px 16px;
  margin-top: -20px;
  position: relative;
  z-index: 4;
}

.points-display {
  display: flex;
  align-items: baseline;
  margin-bottom: 16px;
}

.points-number {
  font-size: 45px;
  font-weight: bold;
  color: #fff;
  margin-right: 8px;
}

.points-label {
  font-size: 18px;
  color: #fff;
  font-weight: 500;
}

.product-description {
  background: #fff;
  padding: 16px;
  border-radius: 8px;
  font-size: 17px;
  color: #000000;
  font-weight: bold;
  line-height: 1.5;
  min-height: 90px;
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

/* 收货地址卡片 */
.address-card {
  background: #fff;
  margin: 16px;
  padding: 16px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  cursor: pointer;
  position: relative;
  min-height: 90px;
}

.address-content {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  text-align: center;
}

.arrow-icon {
  position: absolute;
  right: 16px;
  color: #999;
  font-size: 16px;
}

.address-empty {
  color: #333;
}

.address-text {
  color: #333;
  margin-right: 8px;
}

.address-link {
  color: #e53e3e;
  text-decoration: underline;
}

.arrow-icon {
  color: #999;
  font-size: 16px;
}

/* 商品详情分隔线 */
.detail-divider {
  text-align: center;
  padding: 20px 16px;
  position: relative;
}

.detail-divider::before,
.detail-divider::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 30%;
  height: 1px;
  background: #ddd;
}

.detail-divider::before {
  left: 0;
}

.detail-divider::after {
  right: 0;
}

.divider-text {
  color: #999;
  font-size: 14px;
  background: #f5f5f5;
  padding: 0 10px;
  position: relative;
  z-index: 1;
}

/* 积分信息区域 */
.points-info-section {
  background: #fff;
  margin: 16px;
  padding: 16px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.points-info-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.points-info-label {
  font-size: 17px;
  color: #000000;
  font-weight: bold;
}

.points-info-value {
  font-size: 18px;
  font-weight: bolder;
  color: #e53e3e;
}

/* 商品详情内容 */
.detail-content {
  padding: 0 16px 20px;
}

.detail-image {
  width: 100%;
  height: auto;
  display: block;
}

.detail-image:last-child {
  margin-bottom: 0;
}

/* 立即兑换按钮 */
.exchange-button-container {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 12px 16px;
  background: #fff;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
  z-index: 100;
}

.exchange-button {
  height: 48px;
  font-size: 16px;
  font-weight: bold;
  background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
  border: none;
  border-radius: 24px;
}

.exchange-button:active {
  opacity: 0.9;
}
</style>
