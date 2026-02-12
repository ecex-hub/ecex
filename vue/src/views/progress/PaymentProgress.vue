<template>
  <div class="payment-progress-page">
    <!-- 导航栏 -->
    <van-nav-bar
      title="款项下发进度"
      left-arrow
      @click-left="$router.back()"
      class="custom-nav-bar"
    />

    <!-- 顶部背景区域 -->
    <div class="header-section"></div>

    <!-- Banner区域 -->
    <div class="banner-section">
      <img :src="bannerImage" alt="二重二新下发款项" class="banner-img" />
    </div>

    <!-- 进度按钮区域 -->
    <div class="progress-section">
      <div class="progress-container">
        <van-button
          class="progress-btn"
          @click="handleStepClick('submit')"
        >
          提交资产对接
        </van-button>
        <van-button
          class="progress-btn"
          @click="handleStepClick('review')"
        >
          资产对接审核
        </van-button>
        <van-button
          class="progress-btn"
          @click="handleStepClick('payment')"
        >
          待下发款项打款审核
        </van-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import backImage from '@/assets/icons/png/progress/back.png'
import bannerImage from '@/assets/icons/png/progress/banner.png'

const router = useRouter()

const handleStepClick = (step) => {
  // TODO: 根据步骤执行相应操作
  showToast(`点击了：${step}`)
}
</script>

<style scoped>
.payment-progress-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}

/* 自定义导航栏 - 透明背景，白色文字 */
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
}

.custom-nav-bar :deep(.van-nav-bar__arrow) {
  color: #fff;
}

.custom-nav-bar :deep(.van-nav-bar__left) {
  padding-left: 16px;
}

.payment-progress-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}

/* 顶部背景区域 */
.header-section {
  background-image: v-bind('"url(" + backImage + ")"');
  background-size: 100% auto;
  background-position: center top;
  background-repeat: no-repeat;
  position: relative;
  overflow: visible;
  padding-top: 60px;
  /* 保持750:565的比例 */
  aspect-ratio: 750 / 565;
  width: 100%;
}

.header-content {
  position: relative;
  z-index: 2;
  text-align: center;
}

.page-title {
  font-size: 18px;
  font-weight: bold;
  color: #fff;
  margin-top: 10px;
}

/* Banner区域 */
.banner-section {
  margin-top: -166px;
  padding: 0 16px;
  display: flex;
  justify-content: center;
  position: relative;
  z-index: 10;
}

.banner-img {
  width: 100%;
  height: auto;
  display: block;
  border-radius: 12px;
}

/* 进度按钮区域 */
.progress-section {
  padding: 0 16px 20px;
  margin-top: 40px;
}

.progress-container {
  background: #fff;
  border: 1px solid #e53e3e;
  border-radius: 12px;
  padding: 30px;
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.progress-btn {
  width: 100%;
  height: 50px;
  background: #ffdbcb;
  border: 1px solid #e7a4a4;
  color: #d64545;
  border-radius: 8px;
  font-size: 16px; 
  transition: all 0.3s;
  font-weight: bold;
}

.progress-btn:active {
  background: #ffd4b8;
  opacity: 0.9;
}
</style>