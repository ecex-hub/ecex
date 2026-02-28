<template>
  <div class="video-player-page">
    <!-- 顶部导航栏 -->
    <van-nav-bar
      title="视频播放"
      left-arrow
      @click-left="goBack"
      class="custom-nav-bar"
    />


    <!-- 页头 -->
    <div class="page-header">
      <div>
        <img src="@/assets/images/common/gh.png" alt="logo" class="header-logo"/>
      </div>
      <div class="header-text">
        <h1 class="header-title">中华人民共和国中央人民政府</h1>
        <p class="header-subtitle">www.<font color="red">gov</font>.cn</p>
      </div>
    </div>

    <!-- 视频信息区域 -->
    <div class="video-info" v-if="videoInfo.title">
      <h1 class="video-title">{{ videoInfo.title }}</h1>
      <div class="video-meta">
        <span class="video-duration">
          <van-icon name="clock-o" />
          {{ videoInfo.itime ? formatAddtime(videoInfo.itime) : '未知时长' }}
        </span>       
      </div>
    </div>

    <!-- 视频播放区域 -->
    <div class="video-container">
      <div class="video-wrapper" v-if="videoInfo.videoUrl">
        <video
          ref="videoRef"
          :src="videoInfo.videoUrl"
          :poster="videoInfo.thumb"
          controls
          playsinline
          webkit-playsinline
          x5-playsinline
          x5-video-player-type="h5"
          x5-video-player-fullscreen="true"
          class="video-element"
          @loadedmetadata="onVideoLoaded"
          @play="onVideoPlay"
          @pause="onVideoPause"
          @ended="onVideoEnded"
          @error="onVideoError"
        >
          您的浏览器不支持视频播放
        </video>
      </div>
      
      <!-- 视频加载占位符 -->
      <div class="video-placeholder" v-else>
        <van-loading size="40px" vertical>视频加载中...</van-loading>
      </div>
    </div>


    <!-- 空状态 -->
    <div class="empty-state" v-if="!videoInfo.videoUrl && !loading">
      <van-empty description="视频信息加载失败" />
      <van-button type="primary" @click="goBack" class="back-btn">
        返回上一页
      </van-button>
    </div>


    <!--页脚版权-->
    <div class="footer">
      <div class="footer-content">
        <div class="footer-logo">
          <img src="@/assets/images/common/red.png" alt="logo"/>
        </div>
        <div class="footer-text">
          <p>主办单位：国务院办公厅　版权所有：中国政府网</p>
          <p>网站标识码：bm01000001</p>
          <p>京ICP备05070218号 京公网安备11010202000001号</p>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { videoApi } from '@/api'
import { showToast, showLoadingToast, closeToast } from 'vant'

const route = useRoute()
const router = useRouter()

// 视频引用
const videoRef = ref(null)

// 视频信息
const videoInfo = ref({
  id: '',
  title: '',
  thumb: '',
  videoUrl: '',
  time: '',
  views: 0
})

// 加载状态
const loading = ref(false)

// 返回上一页
const goBack = () => {
  router.go(-1)
}

// 获取视频详情
const fetchVideoDetail = async (videoId) => {
  if (!videoId) return
  
  loading.value = true
  
  const res = await videoApi.getVideoDetail(videoId)
    
    const video = res?.data?.data || {}
    videoInfo.value = video
    
    
}

// 格式化时间戳为正常日期时间格式
const formatAddtime = (timestamp) => {
  if (!timestamp || timestamp <= 0) {
    return '未知时间'
  }
  
  // 如果是时间戳（秒），转换为毫秒
  const date = new Date(timestamp * 1000)
  
  // 格式化为 YYYY-MM-DD HH:mm:ss
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

// 视频事件处理
const onVideoLoaded = () => {
  console.log('视频加载完成')
}

const onVideoPlay = () => {
  console.log('视频开始播放')
}

const onVideoPause = () => {
  console.log('视频暂停')
}

const onVideoEnded = () => {
  console.log('视频播放结束')
  showToast('视频播放完毕')
}

const onVideoError = (e) => {
  console.error('视频播放错误:', e)
  showToast('视频播放出错')
}

// 组件挂载
onMounted(() => {
  const videoId = route.params.id
  if (videoId) {
    fetchVideoDetail(videoId)
  } else {
    showToast('缺少视频ID参数')
    setTimeout(() => {
      goBack()
    }, 1500)
  }
})

// 组件卸载时清理
onUnmounted(() => {
  if (videoRef.value) {
    videoRef.value.pause()
  }
})
</script>

<style scoped>
.video-player-page {
  min-height: 100vh; 
}

/* 页面头部 */
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px;
  background: #fff;
  border-bottom: 1px solid #eee;
}

.header-logo {
  width: 40px;
  height: 40px;
  flex-shrink: 0;
}

.header-text {
  flex: 1;
  margin-left: 12px;
  text-align: left;
}

.header-title {
  font-size: 17px;
  font-weight: bolder;
  color: #ff0000;
  margin: 0;
}

.header-subtitle {
  font-size: 14px;
  color: #666;
  margin: 0;
}

/* 视频容器 */
.video-container {
  position: relative;
  width: 100%;
  height: 220px;
  background: #000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.video-wrapper {
  width: 100%;
  height: 100%;
}

.video-element {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.video-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #fff;
}

/* 视频信息 */
.video-info {
  padding: 20px 16px;
  background: #fff;
  color: #333;
}

.video-title {
  font-size: 19px;
  font-weight: bold;
  margin: 0 0 12px 0;
  line-height: 1.4;
  text-align: center;
}

.video-meta {  
  gap: 16px;
  font-size: 14px;
  color: #999; 
  text-align: center;
}

.video-meta :deep(.van-icon) {
  margin-right: 4px;
}

/* 空状态 */
.empty-state {
  padding: 60px 20px;
  text-align: center;
  background: #fff;
  margin-top: 12px;
}

.back-btn {
  margin-top: 20px;
}

/* 响应式调整 */
@media (max-width: 375px) {
  .video-container {
    height: 180px;
  }
}

/* 底部版权信息 */
.footer {
  background: #e4e4e4; /* 灰色背景 */
  padding: 16px;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 100;
}

.footer-content {
  display: flex;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
}

.footer-logo {
  flex-shrink: 0;
  margin-right: 12px;
}

.footer-logo img {
  width: 50px;
  height: 50px;
  display: block;
}

.footer-text {
  flex: 1;
  text-align: left;
  color: #070707;
  font-size: 12px;
  line-height: 1.5;
}

.footer-text p {
  margin: 0 0 4px 0;
}

.footer-text p:last-child {
  margin-bottom: 0;
}
</style>
