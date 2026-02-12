<template>
  <van-popup
    v-model:show="visible"
    position="center"
    :style="{ background: 'transparent' }"
    :close-on-click-overlay="closeOnClickOverlay"
    @close="handleClose"
  >
    <div class="official-message-popup">
      <!-- 顶部横幅 -->
      <div class="header-banner">
        <div class="banner-content">
          <span class="banner-text">官方消息</span>
          <img :src="logoUrl" alt="二重新" class="banner-logo" />
        </div>
        <div class="banner-decorations">
          <span class="star" v-for="i in 5" :key="i">★</span>
        </div>
      </div>

      <!-- 标题 -->
      <div class="popup-title" v-if="title">{{ title }}</div>

      <!-- 内容 -->
      <div class="popup-content">
        <slot>
          <p v-if="content">{{ content }}</p>
        </slot>
      </div>

      <!-- 底部装饰 -->
      <div class="footer-decoration">
        <div class="ribbon">
          <span class="star">★</span>
        </div>
      </div>

      <!-- 关闭按钮 -->
      <div class="close-button" @click="handleClose">
        <span class="close-icon">×</span>
      </div>
    </div>
  </van-popup>
</template>

<script setup>
import { computed } from 'vue'
import logoUrl from '@/assets/icons/png/news/logo.png'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: ''
  },
  content: {
    type: String,
    default: ''
  },
  closeOnClickOverlay: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['update:modelValue', 'close'])

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const handleClose = () => {
  visible.value = false
  emit('close')
}
</script>

<style scoped>
.official-message-popup {
  position: relative;
  width: 320px;
  max-width: 90vw;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

/* 顶部横幅 */
.header-banner {
  position: relative;
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 50%, #dc2626 100%);
  padding: 16px 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  overflow: hidden;
}

.header-banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(180deg, rgba(255, 215, 0, 0.3) 0%, transparent 50%);
  pointer-events: none;
}

.banner-content {
  display: flex;
  align-items: center;
  gap: 12px;
  z-index: 1;
}

.banner-text {
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.banner-logo {
  width: 60px;
  height: auto;
  object-fit: contain;
}

.banner-decorations {
  display: flex;
  gap: 4px;
  z-index: 1;
}

.banner-decorations .star {
  color: #ffd700;
  font-size: 14px;
  text-shadow: 0 0 4px rgba(255, 215, 0, 0.8);
  animation: twinkle 2s ease-in-out infinite;
}

.banner-decorations .star:nth-child(2n) {
  animation-delay: 0.3s;
}

.banner-decorations .star:nth-child(3n) {
  animation-delay: 0.6s;
}

@keyframes twinkle {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.6; transform: scale(0.9); }
}

/* 标题 */
.popup-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  text-align: center;
  padding: 20px 20px 12px;
  line-height: 1.4;
}

/* 内容 */
.popup-content {
  padding: 0 20px 20px;
  color: #333;
  font-size: 14px;
  line-height: 1.8;
  text-align: justify;
}

.popup-content p {
  margin: 0;
}

/* 底部装饰 */
.footer-decoration {
  padding: 12px 0;
  display: flex;
  justify-content: center;
}

.ribbon {
  position: relative;
  width: 120px;
  height: 30px;
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.ribbon::before,
.ribbon::after {
  content: '';
  position: absolute;
  width: 0;
  height: 0;
  border-style: solid;
}

.ribbon::before {
  left: -8px;
  top: 0;
  border-width: 15px 8px 15px 0;
  border-color: transparent #b91c1c transparent transparent;
}

.ribbon::after {
  right: -8px;
  top: 0;
  border-width: 15px 0 15px 8px;
  border-color: transparent transparent transparent #b91c1c;
}

.ribbon .star {
  color: #ffd700;
  font-size: 18px;
  text-shadow: 0 0 4px rgba(255, 215, 0, 0.8);
}

/* 关闭按钮 */
.close-button {
  position: absolute;
  bottom: -20px;
  left: 50%;
  transform: translateX(-50%);
  width: 40px;
  height: 40px;
  background: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  z-index: 10;
  transition: all 0.3s;
}

.close-button:active {
  transform: translateX(-50%) scale(0.95);
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.2);
}

.close-icon {
  font-size: 28px;
  color: #666;
  line-height: 1;
  font-weight: 300;
}
</style>