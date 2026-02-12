<template>
  <div class="invite-page">
    <!-- 顶部背景 -->
    <div class="header-section">
      <img :src="backImage" alt="邀请背景" class="bg-image" />
      <img :src="titleImage" alt="标题" class="title-image" />
      <div class="header-content">
        <div class="nav-bar">
          <van-icon name="arrow-left" size="20" color="#000" @click="$router.back()" />
          <span class="nav-title">好友分享</span>
        </div>
      </div>
    </div>

    <div class="content-wrapper">
      <!-- 中间分享按钮 -->
      <div class="share-btn-wrapper">
        <button class="share-btn" @click="shareToFriend">
          <span>立即分享给好友</span>
        </button>
      </div>

      <!-- 邀请信息 -->
      <div class="info-card">
        <div class="info-header">
          <img :src="inviteIcon" alt="邀请码" class="info-icon" />
          <span class="info-title">专属邀请码</span>
        </div>
        <div class="info-body">
          <span class="info-value">{{ inviteCode }}</span>
          <img
            :src="linkIcon"
            alt="复制"
            class="copy-icon"
            @click="copyText(inviteCode, '邀请码已复制')"
          />
        </div>
      </div>

      <div class="info-card">
        <div class="info-header">
          <img :src="qrIcon" alt="二维码" class="info-icon" />
          <span class="info-title">邀请链接</span>
        </div>
        <div class="info-body">
          <span class="info-value link-text">{{ inviteLink }}</span>
          <img
            :src="linkIcon"
            alt="复制"
            class="copy-icon"
            @click="copyText(inviteLink, '邀请链接已复制')"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { showToast, showSuccessToast } from 'vant'
import backImage from '@/assets/icons/png/invite/back.png'
import titleImage from '@/assets/icons/png/invite/title.png'
import btnBack2 from '@/assets/icons/png/invite/btnback2.png'
import back4 from '@/assets/icons/png/invite/back4.png'
import back3 from '@/assets/icons/png/invite/back3.png'
import linkIcon from '@/assets/icons/png/copy.png'
import inviteIcon from '@/assets/icons/png/invite/link.png'
import qrIcon from '@/assets/icons/png/invite/qr.png'

// TODO: 后续可从用户信息或接口中获取
const inviteCode = ref('13464654564314sfws')
const inviteLink = ref('https://RDhjksdnkjahs.com')

const copyText = async (text, successMsg) => {
  try {
    await navigator.clipboard.writeText(text)
    showSuccessToast(successMsg)
  } catch (error) {
    console.error('复制失败:', error)
    showToast('复制失败，请稍后重试')
  }
}

const shareToFriend = () => {
  // 目前先简单提示，后续可接入系统分享能力或自定义分享弹窗
  showToast('请复制邀请码或链接进行分享')
}
</script>

<style scoped>
.invite-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #fa7d39 0%, #fc3b00 100%);
}

.header-section {
  position: relative;
  width: 100%;
  border-bottom-left-radius: 60px;
  border-bottom-right-radius: 60px;
  overflow: hidden;
}

.bg-image {
  width: 100%;
  height: auto;
  display: block;
}

.title-image {
  position: absolute;
  top: 116px;
  left: 50%;
  transform: translateX(-50%);
  width: 298px;
  height: auto;
}

.header-content {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  padding: 10px 12px;
}

.nav-bar {
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}

.nav-bar .van-icon {
  position: absolute;
  left: 0;
}

.nav-title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.content-wrapper {
  padding: 0 16px 24px;
  margin-top: -40px;
  z-index: 2;
  position: relative;
}

.share-btn-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 24px;
}

.share-btn {
  width: 66%;
  max-width: 300px;
  aspect-ratio: 463 / 123;
  border: none;
  outline: none;
  border-radius: 12px;
  background-image: v-bind('"url(" + btnBack2 + ")"');
  background-size: 100% 100%;
  background-repeat: no-repeat;
  background-position: center;
  color: #ffffff;
  font-size: 18px;
  font-weight: 600;
}

.info-card {
  background-image: v-bind('"url(" + back4 + ")"');
  background-repeat: no-repeat;
  background-size: 100% 100%;
  background-position: center; 
  padding:2px 10px 16px 2px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 18px;
}

.info-header {
  display: flex;
  align-items: center;
  gap: 6px;
}

.info-icon {
  width: 40px;
  height: 40px;
}

.info-title {
  font-size: 17px;
  font-weight: bold;
  color: #f24b39;
}

.info-body {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-top: 10px;
}

.info-value {
  display: inline-block;
  padding: 12px 12px;
  background-image: v-bind('"url(" + back3 + ")"');
  background-repeat: no-repeat;
  background-size: 100% 100%;
  background-position: center;
  font-size: 16px;
  color: #333333;
  width: 80%;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.link-text {
  font-size: 16px;
}

.copy-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}
</style>

