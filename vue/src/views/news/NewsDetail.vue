<template>
  <div class="news-detail-page">
    <!-- 顶部导航栏 -->
    <van-nav-bar
      :title="newsDetail.title || '新闻详情'"
      left-arrow
      @click-left="$router.back()"
      class="custom-nav-bar"
    />

    <!-- 加载中 -->
    <div v-if="loading" class="loading-container">
      <van-loading type="spinner" color="#e53e3e">加载中...</van-loading>
    </div>

    <!-- 新闻详情内容 -->
    <div v-else-if="newsDetail.id">     
        
      <!-- 纯图新闻 -->
      <div v-if="newsDetail.type == 3" class="news-cover">
        <div class="news-body" v-html="newsDetail.content"></div>       
      </div>
      <!-- 富文本新闻 --> 
      <div v-else  class="news-detail-content">
        <!-- 标题 -->
      <div class="news-title">{{ newsDetail.title }}</div>
      
      <!-- 副标题 -->
      <div v-if="newsDetail.subtitle" class="news-subtitle">{{ newsDetail.subtitle }}</div>
      
      <!-- 作者和时间 -->
      <div class="news-meta">
        <span v-if="newsDetail.author" class="news-author">作者：{{ newsDetail.author }}</span>
        <span class="news-date">{{ formatDate(newsDetail.itime) }}</span>
      </div>

      <!-- 封面图片 
      <div v-if="newsDetail.coverUrl" class="news-cover">
        <img :src="newsDetail.coverUrl" :alt="newsDetail.title" class="cover-image" />
      </div>
        -->
      <!-- 新闻内容（富文本） -->
        <div class="news-body" v-html="newsDetail.content"></div>
      </div>
    </div>

    <!-- 错误提示 -->
    <div v-else class="error-container">
      <van-empty description="新闻不存在或已删除" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { newsApi } from '@/api'

const route = useRoute()
const newsDetail = ref({})
const loading = ref(true)

// 格式化时间戳为 YYYY-MM-DD HH:mm:ss
const formatDate = (timestamp) => {
  if (!timestamp) return ''
  const date = new Date(timestamp * 1000)
  const y = date.getFullYear()
  const m = String(date.getMonth() + 1).padStart(2, '0')
  const d = String(date.getDate()).padStart(2, '0')
  const h = String(date.getHours()).padStart(2, '0')
  const min = String(date.getMinutes()).padStart(2, '0')
  const s = String(date.getSeconds()).padStart(2, '0')
  return `${y}-${m}-${d} ${h}:${min}:${s}`
}

// 加载新闻详情
const loadNewsDetail = async () => {
  const newsId = route.params.id || route.query.id
  if (!newsId) {
    loading.value = false
    return
  }

  try {
    loading.value = true
    const res = await newsApi.getNewsDetail(newsId)
    // 后端返回格式可能是 { data: {...} } 或直接是 {...}
    newsDetail.value = res?.data || res || {}
  } catch (e) {
    console.error('获取新闻详情失败', e)
    newsDetail.value = {}
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadNewsDetail()
})
</script>

<style scoped>
.news-detail-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 20px;
}

.custom-nav-bar {
  background: #fff;
}

.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
}

.error-container {
  padding: 40px 20px;
}

.news-detail-content {
  background: #fff;
  margin: 16px;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.news-title {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  line-height: 1.5;
  margin-bottom: 12px;
}

.news-subtitle {
  font-size: 16px;
  color: #666;
  line-height: 1.5;
  margin-bottom: 12px;
}

.news-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid #eee;
  margin-bottom: 16px;
  font-size: 12px;
  color: #999;
}

.news-author {
  margin-right: 12px;
}

.news-date {
  flex-shrink: 0;
}

.news-cover {
  width: 100%;
  margin-bottom: 16px;
  border-radius: 8px;
  overflow: hidden;
}

.cover-image {
  width: 100%;
  height: auto;
  display: block;
  object-fit: cover;
}

.news-body {
  font-size: 16px;
  color: #333;
  line-height: 1.8;
  word-wrap: break-word;
}

/* 富文本内容样式 */
.news-body :deep(img) {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 12px 0;
  border-radius: 4px;
}

.news-body :deep(p) {
  margin: 12px 0;
  line-height: 1.8;
}

.news-body :deep(h1),
.news-body :deep(h2),
.news-body :deep(h3),
.news-body :deep(h4),
.news-body :deep(h5),
.news-body :deep(h6) {
  margin: 16px 0 12px;
  font-weight: bold;
  color: #333;
}

.news-body :deep(ul),
.news-body :deep(ol) {
  margin: 12px 0;
  padding-left: 24px;
}

.news-body :deep(li) {
  margin: 8px 0;
  line-height: 1.8;
}

.news-body :deep(a) {
  color: #e53e3e;
  text-decoration: none;
}

.news-body :deep(a:hover) {
  text-decoration: underline;
}

.news-body :deep(blockquote) {
  border-left: 4px solid #e53e3e;
  padding-left: 16px;
  margin: 12px 0;
  color: #666;
  font-style: italic;
}

.news-body :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 12px 0;
}

.news-body :deep(table th),
.news-body :deep(table td) {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

.news-body :deep(table th) {
  background-color: #f5f5f5;
  font-weight: bold;
}
</style>
