<template>
  <van-popup
    v-model:show="visible"
    position="center"
    :style="{ background: 'transparent' }"
    :close-on-click-overlay="closeOnClickOverlay"
    @close="handleClose"
  >
    <div class="general-prompt-popup">
      <!-- 顶部星星装饰 -->
      <div class="top-stars">
        <span class="star" v-for="i in 5" :key="i">✨</span>
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
      <div class="footer-section">
        <img :src="logoUrl" alt="二重新" class="footer-logo" />
        <div class="footer-ribbon"></div>
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
.general-prompt-popup {
  position: relative;
  width: 300px;
  max-width: 88vw;
  background: linear-gradient(180deg, #fff5e6 0%, #ffe8cc 50%, #ffd9b3 100%);
  border-radius: 8px;
  padding: 24px 20px 50px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
  position: relative;
  overflow: hidden;
}

/* 卷轴效果 - 左右卷边 */
.general-prompt-popup::before,
.general-prompt-popup::after {
  content: '';
  position: absolute;
  top: 0;
  bottom: 0;
  width: 20px;
  background: linear-gradient(180deg, #dc2626 0%, #b91c1c 50%, #dc2626 100%);
  z-index: 1;
}

.general-prompt-popup::before {
  left: 0;
  border-radius: 8px 0 0 8px;
  box-shadow: inset -2px 0 4px rgba(0, 0, 0, 0.2);
}

.general-prompt-popup::after {
  right: 0;
  border-radius: 0 8px 8px 0;
  box-shadow: inset 2px 0 4px rgba(0, 0, 0, 0.2);
}

/* 顶部星星装饰 */
.top-stars {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-bottom: 12px;
  z-index: 2;
  position: relative;
}

.top-stars .star {
  font-size: 16px;
  animation: sparkle 2s ease-in-out infinite;
}

.top-stars .star:nth-child(2n) {
  animation-delay: 0.3s;
}

.top-stars .star:nth-child(3n) {
  animation-delay: 0.6s;
}

@keyframes sparkle {
  0%, 100% { 
    opacity: 1; 
    transform: scale(1) rotate(0deg); 
  }
  50% { 
    opacity: 0.6; 
    transform: scale(1.2) rotate(180deg); 
  }
}

/* 标题 */
.popup-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  text-align: center;
  margin-bottom: 16px;
  line-height: 1.4;
  z-index: 2;
  position: relative;
  padding: 0 10px;
}

/* 内容 */
.popup-content {
  color: #333;
  font-size: 14px;
  line-height: 1.8;
  text-align: justify;
  z-index: 2;
  position: relative;
  padding: 0 10px;
  margin-bottom: 20px;
}

.popup-content p {
  margin: 0;
}

/* 底部装饰 */
.footer-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  z-index: 2;
  position: relative;
  margin-top: 20px;
}

.footer-logo {
  width: 50px;
  height: auto;
  object-fit: contain;
}

.footer-ribbon {
  width: 100px;
  height: 20px;
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  border-radius: 4px;
  position: relative;
}

.footer-ribbon::before,
.footer-ribbon::after {
  content: '';
  position: absolute;
  width: 0;
  height: 0;
  border-style: solid;
}

.footer-ribbon::before {
  left: -6px;
  top: 0;
  border-width: 10px 6px 10px 0;
  border-color: transparent #b91c1c transparent transparent;
}

.footer-ribbon::after {
  right: -6px;
  top: 0;
  border-width: 10px 0 10px 6px;
  border-color: transparent transparent transparent #b91c1c;
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