<template>
  <div class="kefu-page">
    <!-- 导航栏 -->
    <van-nav-bar
      title="官方群聊"
      left-arrow
      @click-left="$router.back()"
      class="custom-nav-bar"
    />

    <!-- 整页背景 -->
    <div class="bg"></div>

    <!-- 内容区域 -->
    <div class="content">
      <!-- 群聊二维码（来自首页缓存 group_chat_qrcode），优先显示处理后的完整地址 -->
      <img :src="groupChatQrUrl || scan" alt="group-chat-qrcode" class="scan-image" />
      <div class="cover-wrapper">
        <img :src="cover" alt="cover" class="cover-image" />
        <img :src="cover2" alt="cover2" class="cover2-image" />
      </div>
      
      <!-- 保存二维码按钮 -->
      <button class="save-btn" @click="saveQRCode">
        保存二维码
      </button>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { showToast, showSuccessToast } from 'vant'
import { config, STORAGE_KEYS } from '@/config'
import back from '@/assets/icons/png/kf/back.png'
import cover from '@/assets/icons/png/kf/cover.png'
import cover2 from '@/assets/icons/png/kf/cover2.png'
import scan from '@/assets/icons/png/kf/scan.png'
import btnBack from '@/assets/icons/png/invite/btnback.png'

// 群聊二维码图片地址（从 localStorage.homeIndexData.group_chat_qrcode 读取）
const groupChatQr = ref('')

// 处理为前端可访问的完整图片地址
const groupChatQrUrl = computed(() => {
  let url = groupChatQr.value
  if (!url) return ''

  if (url.startsWith('/')) {
    // 相对路径（如 /uploads/xxx），拼接后端域名
    url = config.baseURL.replace(/\/+$/, '') + url
  } else if (!url.startsWith('http://') && !url.startsWith('https://')) {
    // 纯域名或其他，补全协议
    url = 'https://' + url
  }
  return url
})

onMounted(() => {
  try {
    const cacheStr = localStorage.getItem(STORAGE_KEYS.HOME_INDEX_DATA)
    if (cacheStr) {
      const cache = JSON.parse(cacheStr)
      groupChatQr.value = cache?.group_chat_qrcode || ''
    }
  } catch (error) {
    console.error('读取群聊二维码失败:', error)
  }
})

const saveQRCode = () => {
  // TODO: 实现保存二维码功能
  showToast('保存二维码功能待实现')
}
</script>

<style scoped>
.kefu-page {
  position: relative;
  min-height: 100vh;
  overflow: hidden;
}

.bg {
  position: absolute;
  inset: 0;
  background-image: v-bind('"url(" + back + ")"');
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center;
  z-index: 0;
}

.content {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 80px;
}

.cover-wrapper {
  position: relative;
  width: 100%;
  margin-top: -170px;
}

.scan-image {
  width: 70%;
  max-width: 300px;
  margin-top: 24px;
  display: block;
}
.cover-image {
  width: 100%;  
  display: block;
  margin: 0 auto; /* 让第 10 行这张图片左右居中 */
}

.cover2-image {
  position: absolute;
  top: 205px;
  right: 18px;
  width: 30%;
}

.save-btn {
  width: 66%;
  max-width: 300px;
  aspect-ratio: 500 / 123;
  border: none;
  outline: none;
  border-radius: 12px;
  background-image: v-bind('"url(" + btnBack + ")"');
  background-size: 100% 100%;
  background-repeat: no-repeat;
  background-position: center;
  color: #ffffff;
  font-size: 18px;
  font-weight: 600;
  margin-top: -100px;
  cursor: pointer;
}

.save-btn:active {
  opacity: 0.9;
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

.kefu-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}

</style>

