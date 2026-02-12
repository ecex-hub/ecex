<template>
  <div class="realname-page">
    <!-- 顶部背景区域 -->
    <div class="header-section">
      <div class="header-bg">
        <img :src="realnameBg" alt="背景" class="bg-image" />
        <div class="header-content">
          <!-- 返回按钮 -->
          <div class="back-button" @click="$router.back()">
            <van-icon name="arrow-left" color="#fff" size="20" />
          </div>
          
          <!-- 标题 -->
          <div class="page-title">实名认证</div>
          
          <!-- 主要内容 -->
          <div class="main-content">
            <div class="content-text">
              <div class="main-title">即刻进入身份认证</div>
              <div class="sub-title">·为您的合法权益保驾护航·</div>
            </div>
            <div class="illustration">
              <!-- 3D文档堆叠效果 -->
              <div class="doc-stack">
                <div class="doc doc-1">
                  <div class="doc-icon">👤</div>
                  <div class="doc-star">⭐</div>
                </div>
                <div class="doc doc-2"></div>
                <div class="doc doc-3"></div>
                <div class="doc doc-4"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部白色卡片 -->
    <div class="card-section">
      <div class="status-card">
        <div class="card-left">
          <div class="status-icon">
            <van-icon name="passed" color="#e53e3e" size="24" />
          </div>
          <span class="status-text">实名认证</span>
        </div>
        <div class="card-right">
          <van-button 
            round 
            class="verified-btn"
            :disabled="true"
          >
            <van-icon name="success" color="#fff" size="16" />
            <span>已认证</span>
          </van-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import realnameBg from '@/assets/images/backgrounds/realname.png'

const router = useRouter()
</script>

<style scoped>
.realname-page {
  min-height: 100vh;
  background: #f5f5f5;
  position: relative;
}

/* 顶部背景区域 */
.header-section {
  position: relative;
  width: 100%;
  overflow: hidden;
}

.header-bg {
  position: relative;
  width: 100%;
  min-height: 450px;
}

.bg-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center top;
  position: absolute;
  top: 0;
  left: 0;
  z-index: 1;
}

.header-content {
  position: relative;
  z-index: 2;
  padding: 20px 16px 50px;
  min-height: 450px;
  display: flex;
  flex-direction: column;
}

/* 返回按钮 */
.back-button {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  margin-bottom: 20px;
}

/* 页面标题 */
.page-title {
  font-size: 18px;
  font-weight: bold;
  color: #ffffff;
  text-align: center;
  margin-bottom: 40px;
}

/* 主要内容区域 */
.main-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex: 1;
  margin-top: 20px;
}

.content-text {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.main-title {
  font-size: 28px;
  font-weight: bold;
  color: #ffffff;
  line-height: 1.3;
}

.sub-title {
  font-size: 14px;
  color: #ffffff;
  opacity: 0.95;
}

/* 3D文档堆叠插图 */
.illustration {
  flex-shrink: 0;
  width: 140px;
  height: 160px;
  position: relative;
  margin-right: 10px;
}

.doc-stack {
  position: relative;
  width: 100%;
  height: 100%;
}

.doc {
  position: absolute;
  width: 90px;
  height: 110px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 10px;
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: transform 0.3s ease;
}

.doc-1 {
  top: 0;
  left: 25px;
  z-index: 4;
  background: linear-gradient(135deg, #ffffff 0%, #f8f8f8 100%);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
}

.doc-icon {
  font-size: 36px;
  margin-bottom: 10px;
  line-height: 1;
}

.doc-star {
  font-size: 24px;
  color: #ffd700;
  line-height: 1;
}

.doc-2 {
  top: 10px;
  left: 15px;
  z-index: 3;
  opacity: 0.85;
  transform: rotate(-3deg);
  background: rgba(255, 255, 255, 0.9);
}

.doc-3 {
  top: 20px;
  left: 5px;
  z-index: 2;
  opacity: 0.7;
  transform: rotate(-5deg);
  background: rgba(255, 255, 255, 0.85);
}

.doc-4 {
  top: 30px;
  left: -5px;
  z-index: 1;
  opacity: 0.55;
  transform: rotate(-7deg);
  background: rgba(255, 255, 255, 0.8);
}

/* 底部卡片区域 */
.card-section {
  margin: -30px 16px 20px;
  position: relative;
  z-index: 10;
}

.status-card {
  background: #ffffff;
  border-radius: 16px 16px 0 0;
  padding: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 -2px 12px rgba(0, 0, 0, 0.08);
}

.card-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-icon {
  width: 44px;
  height: 44px;
  background: #fff5f5;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid #ffe5e5;
}

.status-text {
  font-size: 16px;
  font-weight: 500;
  color: #333333;
}

.card-right {
  flex-shrink: 0;
}

.verified-btn {
  background: #e53e3e;
  border: none;
  color: #ffffff;
  padding: 10px 20px;
  height: 40px;
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 500;
}

.verified-btn:disabled {
  background: #e53e3e;
  opacity: 1;
}

.verified-btn span {
  color: #ffffff;
}
</style>
