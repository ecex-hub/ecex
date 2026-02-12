<template>
  <div class="realname-page">
    <!-- 顶部背景区域（包含导航栏和横幅） -->
    <div class="header-wrapper">
      <van-nav-bar
        title="实名认证"
        left-arrow
        @click-left="$router.back()"
        class="transparent-nav"
      />

      <!-- 顶部横幅 -->
      <div class="header-section">
        <div class="header-content">
          <img :src="contentImage" alt="身份认证" class="content-image" />
        </div>
        <div class="header-decoration">
          <div class="decoration-icon">
            <van-icon name="certificate" size="40" color="#fff" />
            <div class="star-rating">
              <van-icon name="star" size="12" color="#ffd700" v-for="n in 4" :key="n" />
              <van-icon name="star-o" size="12" color="#ffd700" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 认证状态卡片 -->
    <div class="content">
      <div class="status-card">
        <div class="status-left">
          <div class="status-icon">
            <img :src="rImage" alt="认证" class="r-icon" />        
          </div>
          <span class="status-text">实名认证</span>
        </div>
        <div class="status-right">
          <van-button 
            type="primary" 
            class="status-btn"
            size="small"
            :loading="loading"
            :disabled="isRealName"
            @click="handleClick"
          >
            <img :src="vImage" alt="已认证" class="v-icon" />
            {{ isRealName ? '已认证' : '去认证' }}
          </van-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { authApi } from '@/api'
import headImage from '@/assets/icons/png/realname/head.png'
import contentImage from '@/assets/icons/png/realname/content.png'
import blockImage from '@/assets/icons/png/realname/block.png'
import rImage from '@/assets/icons/png/realname/r.png'
import vImage from '@/assets/icons/png/realname/v.png'

const router = useRouter()
const loading = ref(false)
const isRealName = ref(false)

const fetchAuthStatus = async () => {
  loading.value = true
  try {
    const res = await authApi.getAuthStatus()
    const body = res?.data || res
    const data = body?.data || body
    // 后端 AuthController::actionStatus 返回：
    // is_real: 1-未认证 2-已认证
    // has_realname: boolean 是否已实名
    isRealName.value = data?.has_realname === true || data?.is_real === 2
  } catch (error) {
    console.error('获取认证状态失败', error)
    showToast('获取认证状态失败')
  } finally {
    loading.value = false
  }
}

const handleClick = () => {
  // 已实名则不再跳转
  if (isRealName.value) return
  router.push('/identity')
}

onMounted(() => {
  fetchAuthStatus()
})
</script>

<style scoped>
.realname-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 20px;
}

.realname-page :deep(.van-nav-bar[class*='van-hairline']:after) {
  border: none;
  display: none;
}

.header-wrapper {
  background-image: v-bind('"url(" + headImage + ")"');
  background-size: 100% auto;
  background-position: center top;
  background-repeat: no-repeat;
  position: relative;
  border-bottom-left-radius: 20px;
  border-bottom-right-radius: 20px;
  overflow: visible;
  z-index: 1;
}

.transparent-nav {
  background: transparent !important;
}

.transparent-nav :deep(.van-nav-bar__title) {
  color: #fff !important;
}

.transparent-nav :deep(.van-nav-bar__arrow) {
  color: #fff !important;
}

.header-section {
  padding: 30px 20px;
  color: #fff;
  position: relative;
}

.header-content {
  text-align: left;
  position: relative;
  z-index: 1;
  display: flex;
  justify-content: flex-start;
  align-items: center;
}

.content-image {
  max-width: 60%;
  height: auto;
}

.header-decoration {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 1;
}

.decoration-icon {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.star-rating {
  display: flex;
  gap: 2px;
  align-items: center;
}

.content {
  padding: 20px 16px;
  padding-top: 40px;
  position: relative;
  z-index: 2;
}

.status-card {
  background-image: v-bind('"url(" + blockImage + ")"');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border-radius: 12px;
  padding: 28px 18px;
  margin-top: -50px;
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

.status-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-icon {
  position: relative;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.r-icon {
  width: 32px;
  height: 32px;
  object-fit: contain;
}

.check-icon {
  position: absolute;
  bottom: 0;
  right: 0;
  background: #e53e3e;
  border-radius: 50%;
  padding: 2px;
}

.status-text {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.status-right {
  display: flex;
  align-items: center;
}

.status-btn {
  background: #e53e3e;
  border: none;
  border-radius: 20px;
  padding: 6px 12px;
  height: auto;
  display: flex;
  align-items: center;
  gap: 4px;
  color: #fff;
  font-size: 17px;
  line-height: 1.2;
}

.status-btn::before {
  display: none;
}

.v-icon {
  width: 1em;
  height: 1em;
  object-fit: contain;
  vertical-align: middle;
  display: inline-block;
}
</style>
