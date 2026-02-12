<template>
  <div class="mall-page">
    <!-- 顶部背景区域 -->
    <div class="header-section">
      <div class="header-bg" :style="{ backgroundImage: `url(${mallheadBg})` }">
        <van-nav-bar
          title="积分商城"
          left-arrow
          @click-left="$router.back()"
          class="custom-nav-bar"
        />
        
        <!-- 积分信息（左下角） -->
        <div class="points-container">
          <div class="points-label">我的积分</div>
          <div class="points-value">{{ myPoints }}</div>
        </div>
      </div>
    </div>

    <!-- 商品列表 -->
    <div class="products-section">
      <!-- 有商品时展示瀑布流列表 -->
      <div
        v-if="productList && productList.length"
        class="products-grid"
        ref="gridRef"
      >
        <div
          v-for="product in productList"
          :key="product.id"
          class="product-card"
          :style="getCardStyle(product.id)"
          @click="viewProduct(product)"
        >
          <div class="product-image">
            <img :src="product.image" :alt="product.title" @load="onImageLoad(product.id)" />
          </div>
          <div class="product-info">     
            <div class="product-title">{{ product.title }}</div>
            <div class="product-points">
              <span class="points-text-label">积分: </span>
              <span class="points-text-value">{{ product.points }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 无商品时显示空图标 -->
      <div v-else class="empty-state">
        <img :src="emptyImg" alt="暂无商品" class="empty-image" />
        <div class="empty-text">暂无可兑换商品</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import mallheadBg from '@/assets/images/backgrounds/mallhead.png'
import emptyImg from '@/assets/icons/png/empty.png'
import { mallApi } from '@/api'

const router = useRouter()

const myPoints = ref(0)
const gridRef = ref(null)
const cardPositions = ref({})
const columnHeights = ref([0, 0]) // 两列的高度
const columnCount = 2
const gap = 12

// 商品列表
const productList = ref([])

// 计算瀑布流布局
const calculateLayout = () => {
  if (!gridRef.value) return
  
  const cards = gridRef.value.querySelectorAll('.product-card')
  columnHeights.value = [0, 0]
  const newPositions = {}
  
  cards.forEach((card, index) => {
    const productId = productList.value[index]?.id
    if (!productId) return
    
    // 找到最短的列
    const shortestColumnIndex = columnHeights.value[0] <= columnHeights.value[1] ? 0 : 1
    
    // 计算卡片宽度（考虑间距）
    const containerWidth = gridRef.value.offsetWidth
    const cardWidth = (containerWidth - gap) / columnCount
    
    // 获取当前卡片高度
    const cardHeight = card.offsetHeight || 200 // 默认高度，图片未加载时使用
    
    // 设置位置
    const left = shortestColumnIndex * (cardWidth + gap)
    const top = columnHeights.value[shortestColumnIndex]
    
    newPositions[productId] = {
      left: `${left}px`,
      top: `${top}px`,
      width: `${cardWidth}px`
    }
    
    // 更新列高度
    columnHeights.value[shortestColumnIndex] += cardHeight + gap
  })
  
  cardPositions.value = newPositions
  
  // 更新容器高度
  nextTick(() => {
    if (gridRef.value) {
      const maxHeight = Math.max(...columnHeights.value)
      gridRef.value.style.height = `${maxHeight}px`
    }
  })
}

// 图片加载完成后重新计算
const onImageLoad = (productId) => {
  nextTick(() => {
    calculateLayout()
  })
}

// 获取卡片样式
const getCardStyle = (productId) => {
  const position = cardPositions.value[productId]
  if (!position) {
    return { opacity: 0 }
  }
  return {
    position: 'absolute',
    left: position.left,
    top: position.top,
    width: position.width,
    opacity: 1,
    transition: 'opacity 0.3s'
  }
}

// 窗口大小改变时重新计算
const handleResize = () => {
  calculateLayout()
}

// 从接口获取积分信息
const fetchPoints = async () => {
  try {
    const res = await mallApi.getPointsInfo()
    // 接口返回结构：{ code, message, data: { points, total_points } }
    myPoints.value = res.data?.points ?? 0
  } catch (e) {
    // 出错时不打断页面渲染，保持默认 0
    console.error('获取积分失败', e)
  }
}

// 从接口获取商品列表
const fetchProducts = async () => {
  try {
    const res = await mallApi.getProductList({
      page: 1,
      size: 20
    })
    const list = res.data?.list || []
    // 转成前端需要的字段结构
    productList.value = list.map((item) => ({
      id: item.id,
      title: item.name, // 接口里是 name，这里统一映射为 title
      points: item.points, // MallController 中已根据 price 计算 points
      image: item.image
    }))

    // 等待 DOM 渲染完再计算瀑布流布局
    await nextTick()
    setTimeout(() => {
      calculateLayout()
    }, 100)
  } catch (e) {
    console.error('获取商品列表失败', e)
  }
}

onMounted(() => {
  // 加载积分与商品数据
  fetchPoints()
  fetchProducts()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})

const viewProduct = (product) => {
  // 跳转到商品详情页
  router.push({
    path: '/mall/product-detail',
    query: {
      product: encodeURIComponent(JSON.stringify(product))
    }
  })
}
</script>

<style scoped>
.mall-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}

/* 顶部背景区域 */
.header-section {
  position: relative;
  width: 100%;
  overflow: hidden;
  margin-top: -46px;
  padding-top: 46px;
}

.header-bg {
  position: relative;
  width: 100%;
  min-height: 280px;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  padding: 20px 16px 30px;
  display: flex;
  flex-direction: column;
}

/* 自定义导航栏 */
.custom-nav-bar {
  background: transparent;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 10;
  border-bottom: none;
}
.mall-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}
.custom-nav-bar :deep(.van-nav-bar__title) {  
  font-weight: bold;
}

.custom-nav-bar :deep(.van-nav-bar__arrow) {
  color: #000000;
}

.custom-nav-bar :deep(.van-nav-bar__content) {
  border-bottom: none;
}

/* 积分容器（左下角） */
.points-container {
  position: absolute;
  bottom: 60px;
  left: 16px;
  z-index: 10;
}

.points-label {
  font-size: 18px;
  color: #e53e3e;
  margin-bottom: 8px;
  font-weight: bold;
  padding-left: 10px;
}

.points-value {
  font-size: 45px;
  font-weight: bold;
  color: #e53e3e;
  background:#FFF2EB;
  margin-top: 10px;
  padding: 10px 45px;
  border-radius: 60px;
  display: inline-block;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* 装饰元素（右侧） */
.decoration-container {
  position: absolute;
  right: 16px;
  bottom: 30px;
  z-index: 5;
}

.flower-decoration {
  font-size: 60px;
  opacity: 0.6;
  transform: rotate(-15deg);
}

.coin-decoration {
  position: absolute;
  font-size: 24px;
  color: #ffd700;
  opacity: 0.8;
}

.coin-2 {
  top: -20px;
  right: 20px;
  animation: float 2s ease-in-out infinite;
}

.coin-3 {
  top: 10px;
  right: -10px;
  animation: float 2.5s ease-in-out infinite;
  animation-delay: 0.5s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

/* 商品列表区域 */
.products-section {
  padding: 16px;
  margin-top: -20px;
  position: relative;
  z-index: 1;
}

.products-grid {
  position: relative;
  width: 100%;
}

.product-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.product-card:active {
  transform: scale(0.98);
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
}

.product-image {
  width: 100%;
  height: 180px;
  overflow: hidden;
  background: #f0f0f0;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-info {
  padding: 12px;
}

.product-title {
  font-size: 14px;
  color: #333;
  line-height: 1.5;
  margin-bottom: 10px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;  
}

.product-points {
  display: flex;
  align-items: center;
}

.points-text-label {
  font-size: 16px;
  color: #707070;
  font-weight: 500;
}
.points-text-value {
  font-size: 20px;
  color: #e53e3e;
  font-weight: bold;
}
.empty-text{
  text-align: center;
  font-size: 16px;
  color: #707070;
  font-weight: 500;
  margin-top: 20px;
}
</style>
