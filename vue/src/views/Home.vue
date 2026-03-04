<template>
  <div class="home-page">

    <div class="top-content">
      <!-- 顶部横幅 -->
      <div class="header-banner">
        <img
          src="@/assets/images/backgrounds/indexpageback.png"
          alt="首页背景"
          class="banner-image"
        />
      </div>

      <!-- 主横幅轮播图 -->
      <div class="main-banner">
        <van-swipe 
          :autoplay="3000" 
          indicator-color="white"
          class="banner-swipe"
        >
          <van-swipe-item 
            v-for="banner in bannerList" 
            :key="banner.id"
            @click="handleBannerClick(banner)"
          >
            <img 
              :src="banner.picUrl" 
              :alt="banner.title" 
              class="banner-slide-image"
            />         
          </van-swipe-item>
          
          <!-- 空状态 -->
          <van-swipe-item v-if="!bannerList.length">
            <img
              src="@/assets/images/backgrounds/banner.png"
              alt="默认横幅"
              class="banner-slide-image"
            />
          </van-swipe-item>
        </van-swipe>
      </div>

      <!-- 快捷导航 -->
      <div class="quick-nav">
        <div class="nav-item" @click="$router.push('/signin')">
          <div class="nav-icon">
            <img :src="signIcon" alt="每日签到" />
          </div>
          <div class="nav-label">每日签到</div>
        </div>
        <div class="nav-item" @click="$router.push('/news')">
          <div class="nav-icon">
            <img :src="newsIcon" alt="新闻资讯" />
          </div>
          <div class="nav-label">新闻资讯</div>
        </div>
        <div class="nav-item" @click="$router.push('/help/data-management')">
          <div class="nav-icon">
            <img :src="helpIcon" alt="慈善帮扶" />
          </div>
          <div class="nav-label">慈善帮扶</div>
        </div>
        <div class="nav-item">
          <div class="nav-icon">
            <img :src="rewardIcon" alt="奖励抽取" />
          </div>
          <div class="nav-label">奖励抽取</div>
        </div>
        <div class="nav-item" @click="$router.push('/mall')">
          <div class="nav-icon">
            <img :src="mallIcon" alt="积分商城" />
          </div>
          <div class="nav-label">积分商城</div>
        </div>
      </div>
    </div>

    <!-- 新闻中心 -->
    <div class="news-section">
      <div class="section-header">
        <img
          src="@/assets/icons/png/news.png"
          alt="新闻中心"
          class="news-title-icon"
        />
        <span class="section-title">新闻中心</span>
      </div>
      <div class="news-list">
        <div
          v-for="item in newsList"
          :key="item.id"
          class="news-item"
          @click="handleNewsClick(item)"
        >
          <div class="news-thumb">
            <img :src="item.coverUrl || newsImg" alt="新闻图片" class="thumb-image" />
          </div>
          <div class="news-content">
            <div class="news-text">
              {{ item.title }}
            </div>
            <div class="news-footer">
              <div class="news-tag">
               二重二新
              </div>
              <div class="news-date">
                {{ formatDate(item.itime) }}
              </div>
            </div>
          </div>
        </div>
        <div v-if="!newsList.length" class="empty-text">
          <img :src="emptyImg" alt="暂无新闻" class="empty-image" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showFailToast } from 'vant'
import signIcon from '@/assets/icons/png/menu/sign.png'
import newsIcon from '@/assets/icons/png/menu/news.png'
import helpIcon from '@/assets/icons/png/menu/help.png'
import rewardIcon from '@/assets/icons/png/menu/reward.png'
import mallIcon from '@/assets/icons/png/menu/m.png'
import newsImg from '@/assets/icons/png/newsimg.png'
import emptyImg from '@/assets/icons/png/empty.png'
import { newsApi, homeApi } from '@/api'
import { STORAGE_KEYS } from '@/config'

const router = useRouter()

const newsList = ref([])
const bannerList = ref([])

// 格式化时间戳为 YYYY-MM-DD
const formatDate = (timestamp) => {
  if (!timestamp) return ''
  const date = new Date(timestamp * 1000)
  const y = date.getFullYear()
  const m = String(date.getMonth() + 1).padStart(2, '0')
  const d = String(date.getDate()).padStart(2, '0')
  return `${y}-${m}-${d}`
}

// 解析并使用统一首页数据
const applyHomeIndexData = (data) => {
  if (!data) return

  // 处理轮播图数据
  const banners = data.carousel || data.carousel || []
  bannerList.value = banners.map(item => ({
    id: item.id,
    title: item.title || '',
    picUrl: item.picUrl || '',
    linkUrl: item.link_url || item.linkUrl || '',
    targetType: item.target_type || item.targetType || 'internal'
  }))

  // 处理新闻数据
  const news = data.news || data.newsList || []
  newsList.value = news.slice(0, 3) // 只取前3条
}

// 加载首页所有数据（带本地缓存）
const loadHomeData = async () => {
  try {
    // 1. 先尝试从本地缓存读取
    const cacheStr = localStorage.getItem(STORAGE_KEYS.HOME_INDEX_DATA)
    if (cacheStr) {
      try {
        const cache = JSON.parse(cacheStr)
        applyHomeIndexData(cache)
      } catch (e) {
        console.error('解析本地首页缓存失败:', e)
      }
    }

    // 2. 再请求最新数据（不管有没有缓存，都可以静默刷新一遍）
    const res = await homeApi.getIndexData()
    if (res?.data) {
      // 写入本地缓存
      try {
        localStorage.setItem(STORAGE_KEYS.HOME_INDEX_DATA, JSON.stringify(res.data))
      } catch (e) {
        console.error('写入本地首页缓存失败:', e)
      }
      // 更新页面显示
      applyHomeIndexData(res.data)
    }
  } catch (error) {
    console.error('获取首页数据失败:', error)
    // 降级处理：单独获取各部分数据
    await loadFallbackData()
  }
}

// 原始加载函数保留逻辑（已在上面拆分、并通过 applyHomeIndexData 复用）
/*
const loadHomeData = async () => {
  try {
    const res = await homeApi.getIndexData()
    
    // 处理轮播图数据
    const banners = res?.data?.carousel || res?.data?.carousel || []
    bannerList.value = banners.map(item => ({
      id: item.id,
      title: item.title || '',
      picUrl: item.picUrl || '',
      linkUrl: item.link_url || item.linkUrl || '',
      targetType: item.target_type || item.targetType || 'internal'
    }))
    
    // 处理新闻数据
    const news = res?.data?.news || res?.data?.newsList || []
    newsList.value = news.slice(0, 3) // 只取前3条
    
  } catch (error) {
    console.error('获取首页数据失败:', error)
    // 降级处理：单独获取各部分数据
    await loadFallbackData()
  }
}
*/

// 降级数据加载（当统一接口失败时使用）
const loadFallbackData = async () => {
  try {
    // 并行加载轮播图和新闻
    const [bannerRes, newsRes] = await Promise.allSettled([
      homeApi.getBannerList?.({ position: 'home_main', status: 1 }) || Promise.resolve({ data: [] }),
      newsApi.getNewsList({ page: 1, size: 3 })
    ])
    
    // 处理轮播图数据
    if (bannerRes.status === 'fulfilled') {
      const bannerData = bannerRes.value?.data?.list || bannerRes.value?.data || []
      bannerList.value = bannerData.map(item => ({
        id: item.id,
        title: item.title || '',
        imageUrl: item.image_url || item.imageUrl || '',
        linkUrl: item.link_url || item.linkUrl || '',
        targetType: item.target_type || item.targetType || 'internal'
      }))
    }
    
    // 处理新闻数据
    if (newsRes.status === 'fulfilled') {
      const newsData = newsRes.value?.data?.list || newsRes.value?.data?.data?.list || []
      newsList.value = newsData
    }
  } catch (error) {
    console.error('降级数据加载失败:', error)
  }
}

// 处理新闻点击事件
const handleNewsClick = (item) => {
  // type=2 表示外部新闻，跳转到外部 URL
  // type=1 表示内部新闻，跳转到新闻详情页
  // 注意：后端返回的字段可能是 type 或 new_type
  const newsType = item.type || item.new_type
  
  if (newsType == 2 || newsType == '2') {
    // 外部新闻，跳转到外部 URL
    if (item.url) {
      // 检查 URL 是否包含协议，如果没有则添加 https://
      let url = item.url
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://' + url
      }
      window.open(url, '_blank')
    }
  } else {
    // 内部新闻，跳转到新闻详情页
    router.push(`/news/detail/${item.id}`)
  }
}

// 处理轮播图点击事件
const handleBannerClick = (banner) => {
  if (!banner.linkUrl) return
  
  try {
    if (banner.targetType === 'external') {
      // 外部链接，新窗口打开
      let url = banner.linkUrl
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://' + url
      }
      window.open(url, '_blank')
    } else {
      // 内部链接，路由跳转
      router.push(banner.linkUrl)
    }
  } catch (error) {
    console.error('轮播图跳转失败:', error)
    showFailToast('跳转失败')
  }
}

onMounted(() => {
  loadHomeData()
})
</script>

<style scoped>
.home-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}
.top-content {
  background: #fff;
  border-radius: 14px; 
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}
.header-banner {
  width: 100%;
  position: relative;
  overflow: hidden;
  z-index: 1;
}

.banner-image {
  width: 100%;
  height: auto;
  display: block;
  aspect-ratio: 750 / 440;
  object-fit: cover;
}

.title {
  font-size: 32px;
  font-weight: bold;
  color: #ffd700;
  margin-bottom: 8px;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
}

.subtitle {
  font-size: 14px;
  color: #fff;
  opacity: 0.9;
}

.main-banner {
  position: relative;
  z-index: 2;
  margin-top: -80px;
  padding: 16px;
  width: 100%;
  
} 

.main-banner-image {
  width: 100%;
  height: auto;
  display: block;
  object-fit: cover;
}

.banner-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  background: linear-gradient(135deg, #fff 0%, #fff5f5 100%);
  border: 2px solid #e53e3e;
}

.banner-text {
  font-size: 20px;
  font-weight: bold;
  color: #e53e3e;
  text-align: center;
  margin-bottom: 8px;
}

.banner-subtext {
  font-size: 12px;
  color: #999;
  text-align: center;
}

.quick-nav {
  display: flex;
  justify-content: space-around;
  padding: 20px 2px;  
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
}

.nav-icon {
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
}

.nav-icon img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.nav-label {
  font-size: 12px;
  color: #333;
}

.news-section {
  margin: 20px 0;
  background: #fff;
  border-radius: 14px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px; 
}

.news-title-icon {
  width: 50px;
  height: 25px;
  object-fit: contain;
  margin-right: 6px;
}

.section-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.news-list {
  display: flex;
  flex-direction: column;
}

.news-item {
  display: flex;
  gap: 12px;
  cursor: pointer;
  padding-bottom: 16px;
}

.news-item:first-child {
  padding-top: 0;
  margin-top: 0;
  border-top: none;
}

.news-item:not(:last-child) {
  border-bottom: 1px solid #eee;
  margin-bottom: 16px;
}

.news-thumb {
  width: 100px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.thumb-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.news-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.news-text {
  font-size: 14px;
  color: #333;
  line-height: 1.5;
  font-weight: bold;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 8px;
}

.news-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.news-tag {
  position: relative;
  display: inline-block;
  background: #e53e3e;
  color: #fff;
  font-size: 12px;
  line-height: 1.4;
  padding: 4px 10px;
  width: fit-content;
  box-sizing: border-box;
}

.news-tag::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  transform: translate(-100%, 0);
  width: 0;
  height: 0;
  border-top: 10px solid transparent;
  border-right: 14px solid #e53e3e;
}

.news-date {
  font-size: 12px;
  color: #999;
}

.empty-text {
  text-align: center;
  padding: 16px 0;
}

.empty-image {
  width: 120px;
  height: auto;
  opacity: 0.6;
}

/* 主横幅轮播图样式 */

.banner-swipe {
  width: 100%;
  height: 180px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.banner-slide-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

/* 确保 van-swipe 正确显示 */
:deep(.van-swipe) {
  width: 100%;
  height: 180px;
  position: relative;
}

:deep(.van-swipe__track) {
  height: 100%;
}

:deep(.van-swipe-item) {
  width: 100%;
  height: 100%;
  display: block;
  flex-shrink: 0;
}

/* 轮播图指示器样式 */
:deep(.van-swipe__indicators) {
  bottom: 12px;
}

:deep(.van-swipe__indicator) {
  background: rgba(255,255,255,0.5);
  width: 8px;
  height: 8px;
}

:deep(.van-swipe__indicator--active) {
  background: white;
}
</style>
