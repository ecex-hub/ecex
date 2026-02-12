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

      <!-- 主横幅 -->
      <div class="main-banner">
        <img
          src="@/assets/images/backgrounds/banner.png"
          alt="主横幅"
          class="main-banner-image"
        />
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
          @click="$router.push('/news')"
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
                {{ item.is_new ? '最新' : '新闻' }}
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
import signIcon from '@/assets/icons/png/menu/sign.png'
import newsIcon from '@/assets/icons/png/menu/news.png'
import helpIcon from '@/assets/icons/png/menu/help.png'
import rewardIcon from '@/assets/icons/png/menu/reward.png'
import mallIcon from '@/assets/icons/png/menu/m.png'
import newsImg from '@/assets/icons/png/newsimg.png'
import emptyImg from '@/assets/icons/png/empty.png'
import { newsApi } from '@/api'

const newsList = ref([])

// 格式化时间戳为 YYYY-MM-DD
const formatDate = (timestamp) => {
  if (!timestamp) return ''
  const date = new Date(timestamp * 1000)
  const y = date.getFullYear()
  const m = String(date.getMonth() + 1).padStart(2, '0')
  const d = String(date.getDate()).padStart(2, '0')
  return `${y}-${m}-${d}`
}

const loadNews = async () => {
  try {
    const res = await newsApi.getNewsList({
      page: 1,
      size: 3
    })
    // 后端有可能是 { data: { list: [...] } } 或 { list: [...] }
    const list = res?.data?.list || res?.data?.data?.list || []
    newsList.value = list
  } catch (e) {
    console.error('获取新闻列表失败', e)
  }
}

onMounted(() => {
  loadNews()
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
</style>