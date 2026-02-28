<template>
  <div class="news-page">
    <!-- 顶部头部区域 -->
    <div class="news-header">
      <van-nav-bar
        title="新闻资讯"
        left-arrow
        @click-left="$router.back()"
        class="custom-nav-bar"
      />
      
      <div class="header-content">
        <div class="left-decoration">
          <img src="@/assets/icons/png/news/logo.png" alt="二重新" class="cake-icon" />            
        </div>
        <div class="right-content">
          <div class="main-title">
            <img :src="readIcon" alt="今日必读" class="read-icon" />
          </div>
          <div class="sub-title">·聚焦您最关注的资讯专题·</div>
        </div>
      </div>
      
    </div>

    <div>
      <!-- 平台资讯 -->
      <div class="platform-section">
        <div class="section-header">
          <img src="@/assets/icons/png/news/fire.png" alt="平台资讯" class="section-icon" />
          <span class="section-title">平台资讯</span>
        </div>
        <div class="platform-grid">
          <div class="platform-card" v-for="(item, index) in platformItems" :key="index" @click="handleNewsClick(item)">
            <img :src="item.icon" :alt="item.title" class="card-icon" />
            <div class="card-right">
              <img :src="item.titleicon" :alt="item.title" class="title-icon" />
              <div class="card-action">立即查看 ></div>
            </div>
          </div>
        </div>
      </div>

      <!-- 宣传栏目 -->
      <div class="promotion-section">
        <div class="section-header">
          <img src="@/assets/icons/png/news/film.png" alt="宣传栏目" class="section-icon" />
          <span class="section-title">宣传栏目</span>
        </div>
        <div class="promotion-list">
          <div 
            v-for="(item, index) in promotionList" 
            :key="index" 
            class="promotion-item"
            @click="handleVideoClick(item)"
          >
            <div class="promotion-thumb">
              <img :src="item.thumb" :alt="item.title" class="thumb-image" />
            </div>
            <div class="promotion-content">
              <div class="promotion-text">{{ item.title }}</div>
              <div class="promotion-footer">
                <img src="@/assets/icons/png/news/play.png" alt="播放" class="play-icon" />
                <span class="promotion-time">{{ item.time }}</span>
              </div>
            </div>
          </div>
          <div v-if="!promotionList.length" class="empty-text">
            <img :src="emptyImg" alt="暂无宣传栏目" class="empty-image" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import icon1 from '@/assets/icons/png/news/1.png'
import icon2 from '@/assets/icons/png/news/2.png'
import icon3 from '@/assets/icons/png/news/3.png'
import icon4 from '@/assets/icons/png/news/4.png'
import icon5 from '@/assets/icons/png/news/5.png'
import icon6 from '@/assets/icons/png/news/6.png'
import thumb1 from '@/assets/icons/png/news/n1.png'
import thumb2 from '@/assets/icons/png/news/n2.png'
import readIcon from '@/assets/icons/png/news/read.png'
import emptyImg from '@/assets/icons/png/empty.png'
import { useRouter } from 'vue-router'
import { newsApi, videoApi } from '@/api'
import { showLoadingToast, closeToast, showToast } from 'vant'
import titleicon1 from '@/assets/icons/png/news/11.png'
import titleicon2 from '@/assets/icons/png/news/22.png'
import titleicon3 from '@/assets/icons/png/news/33.png'
import titleicon4 from '@/assets/icons/png/news/44.png'
import titleicon5 from '@/assets/icons/png/news/55.png'
import titleicon6 from '@/assets/icons/png/news/66.png'

const router = useRouter()

const platformItems = ref([
  { title: '项目说明', icon: icon1,titleicon: titleicon1,id: 1 },
  { title: '发展前景', icon: icon2,titleicon: titleicon2,id: 2 },
  { title: '资金合规', icon: icon3,titleicon: titleicon3,id: 3 },
  { title: '法律文件', icon: icon4,titleicon: titleicon4,id: 4 },
  { title: '政企合作', icon: icon5,titleicon: titleicon5,id: 5 },
  { title: '公益慈善', icon: icon6,titleicon: titleicon6,id: 6 }
])

const promotionList = ref([])

// 将秒数转换为时间格式（如 "13:56"）
const formatDuration = (seconds) => {
  if (!seconds || seconds <= 0) {
    return '00:00'
  }
  const minutes = Math.floor(seconds / 60)
  const secs = seconds % 60
  return `${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`
}

// 加载视频列表
const loadVideoList = async () => {
  try {
    const res = await videoApi.getVideoList({
      page: 1,
      size: 10
    })
    const videoList = res?.data?.list || []
    
    // 转换为前端需要的格式
    promotionList.value = videoList.map(item => ({
      id: item.id,
      title: item.title || '',
      thumb: item.coverUrl || thumb1, // 使用封面图
      time: formatDuration(item.video_duration || 0),
      videoUrl: item.videoUrl || '',
      video_duration: item.video_duration || 0
    }))
  } catch (e) {
    console.error('获取视频列表失败', e)
    // 如果接口失败，使用默认数据
    promotionList.value = [
      {
        title: '优化实施"两新"政策"两重"项目——国家发展改革委解...',
        thumb: thumb1,
        time: '13:56'
      },
      {
        title: '优化实施"两新"政策"两重"项目——国家发展改革委解...',
        thumb: thumb2,
        time: '13:56'
      }
    ]
  }
}

// 组件挂载时加载视频列表
onMounted(() => {
  loadVideoList()
})



// 处理视频点击事件
const handleVideoClick = (item) => {
  if (item.id) {
    // 跳转到视频播放页面
    router.push(`/news/video/${item.id}`)
  } else {
    showToast('视频信息不完整')
  }
}

// 处理新闻点击事件
const handleNewsClick = async (item) => {
  // 如果没有 id，直接返回
  if (!item.id) {
    return
  }

  try {
    // 显示加载提示
    showLoadingToast({
      message: '加载中...',
      forbidClick: true,
      duration: 0
    })

    // 先获取新闻详情
    const res = await newsApi.getNewsDetail(item.id)
    // 后端返回格式可能是 { data: {...} } 或直接是 {...}
    const newsDetail = res?.data || res || {}
    
    // 关闭加载提示
    closeToast()

    // 根据详情中的 type 决定跳转方式
    // type=2 表示外部新闻，跳转到外部 URL
    // type=1 表示内部新闻，跳转到新闻详情页
    // 注意：后端返回的字段可能是 type 或 new_type
    const newsType = newsDetail.type || newsDetail.new_type

    if (newsType == 2 || newsType == '2') {
      // 外部新闻，跳转到外部 URL
      if (newsDetail.url) {
        // 检查 URL 是否包含协议，如果没有则添加 https://
        let url = newsDetail.url
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = 'https://' + url
        }
        window.open(url, '_blank')
      }
    } else {
      // 内部新闻，跳转到新闻详情页
      router.push(`/news/detail/${item.id}`)
    }
  } catch (e) {
    // 关闭加载提示
    closeToast()
    console.error('获取新闻详情失败', e)
    // 如果获取详情失败，默认跳转到详情页
    router.push(`/news/detail/${item.id}`)
  }
}


</script>

<style scoped>
.news-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}

.news-header :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}

/* 顶部头部区域 */
.news-header {
  background: url('@/assets/icons/png/news/back.png') no-repeat center;
  background-size: contain;
  position: relative;
  overflow: hidden;
  padding: 0 0 97px;
  min-height: 300px;
}

.news-header::before {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 60px;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><path d="M0,20 Q25,10 50,15 T100,10 L100,20 L0,20 Z" fill="rgba(255,255,255,0.1)"/></svg>') repeat-x;
  background-size: 100px 60px;
}

.custom-nav-bar {
  background: transparent;
}

.custom-nav-bar :deep(.van-nav-bar__title) {
  color: #fff;
  font-weight: bold;
}

.custom-nav-bar :deep(.van-nav-bar__arrow) {
  color: #fff;
}

.custom-nav-bar :deep(.van-nav-bar__left) {
  padding-left: 16px;
}

.header-content {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 2;
  display: flex;
  align-items: center;
  gap: 16px;
  width: calc(100% - 32px);
  padding: 0 16px;
}

.left-decoration {
  flex-shrink: 0;
  display: flex;
  align-items: center;
}

.cake-icon {
  width: 100px;
  height: 100px;
  object-fit: contain;
}

.right-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.main-title {
  margin-bottom: 8px;
  display: flex;
  justify-content: flex-start;
  align-items: center;
}

.read-icon {
  height: auto;
  max-width: 200px;
  object-fit: contain;
}

.sub-title {
  font-size: 14px;
  color: #fff;
  opacity: 0.9;
  margin-bottom: 20px;
  background: url('@/assets/icons/png/news/titleback.png') no-repeat center;
  background-size: contain;
  padding: 8px 16px;
  display: inline-block;
}



/* 平台资讯部分 */
.platform-section {
  background: #fff;
  border-radius: 14px;
  padding: 16px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
}

.section-icon {
  width: 28px;
  height: 28px;
  object-fit: contain;
  margin-right: 8px;
}

.section-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.platform-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.platform-card {
  background: url('@/assets/icons/png/news/blockback.png') no-repeat center;
  background-size: cover;
  border-radius: 8px;
  padding: 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.platform-card:active {
  opacity: 0.9;
}

.card-icon {
  width: 50px;
  height: 50px;
  object-fit: contain;
  flex-shrink: 0;
}

.card-right {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 8px;
}

.title-icon {
  width: auto;
  height: auto;
  max-width: 100%;
  object-fit: contain;
}

.card-action {
  font-size: 12px;
  color: #666;
}

/* 宣传栏目部分 */
.promotion-section {
  background: #fff;
  border-radius: 14px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.promotion-list {
  display: flex;
  flex-direction: column;
}

.promotion-item {
  display: flex;
  gap: 12px;
  padding-bottom: 16px;
  cursor: pointer;
}

.promotion-item:not(:last-child) {
  border-bottom: 1px solid #eee;
  margin-bottom: 16px;
}

.promotion-item:first-child {
  padding-top: 0;
  margin-top: 0;
  border-top: none;
}

.promotion-thumb {
  width: 116px;
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

.promotion-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.promotion-text {
  font-size: 14px;
  color: #333;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 8px;
}

.promotion-footer {
  display: flex;
  align-items: center;
  gap: 6px;
}

.play-icon {
  width: 16px;
  height: 16px;
  object-fit: contain;
}

.promotion-time {
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
