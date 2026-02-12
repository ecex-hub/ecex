<template>
  <van-popup
    v-model:show="visible"
    position="center"
    :style="{ background: 'transparent' }"
    :close-on-click-overlay="closeOnClickOverlay"
    @close="handleClose"
  >
    <div class="general-message-popup">
      <!-- Logo -->
      <div class="popup-logo">
        <img :src="logoUrl" alt="二重新" />
      </div>

      <!-- 消息内容 -->
      <div class="popup-message">
        <slot>
          <p v-if="message">{{ message }}</p>
        </slot>
      </div>

      <!-- 装饰插图 -->
      <div class="popup-illustration">
        <div class="building">
          <div class="building-roof"></div>
          <div class="building-body">
            <div class="building-door"></div>
            <div class="building-windows">
              <span class="window"></span>
              <span class="window"></span>
            </div>
          </div>
        </div>
        <div class="sun-rays">
          <span class="ray" v-for="i in 8" :key="i"></span>
        </div>
        <div class="cloud"></div>
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
  message: {
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
.general-message-popup {
  position: relative;
  width: 280px;
  max-width: 85vw;
  background: #fff;
  border-radius: 16px;
  padding: 24px 20px 60px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  position: relative;
}

.general-message-popup::before {
  content: '';
  position: absolute;
  top: -2px;
  right: -2px;
  bottom: -2px;
  left: -2px;
  border-radius: 16px;
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 50%, #dc2626 100%);
  z-index: -1;
}

.general-message-popup::after {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  border-radius: 14px;
  background: #fff;
  z-index: -1;
}

/* Logo */
.popup-logo {
  display: flex;
  justify-content: center;
  margin-bottom: 16px;
}

.popup-logo img {
  width: 50px;
  height: auto;
  object-fit: contain;
}

/* 消息内容 */
.popup-message {
  text-align: center;
  color: #333;
  font-size: 16px;
  font-weight: 500;
  line-height: 1.5;
  margin-bottom: 20px;
  min-height: 24px;
}

.popup-message p {
  margin: 0;
}

/* 装饰插图 */
.popup-illustration {
  position: relative;
  height: 120px;
  margin-top: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 建筑 */
.building {
  position: relative;
  z-index: 2;
}

.building-roof {
  width: 80px;
  height: 0;
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-bottom: 25px solid #dc2626;
  margin: 0 auto;
  position: relative;
}

.building-roof::after {
  content: '';
  position: absolute;
  top: -5px;
  left: -15px;
  width: 110px;
  height: 0;
  border-left: 15px solid transparent;
  border-right: 15px solid transparent;
  border-bottom: 30px solid #b91c1c;
  z-index: -1;
}

.building-body {
  width: 100px;
  height: 60px;
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  margin: 0 auto;
  position: relative;
  border-radius: 0 0 4px 4px;
}

.building-door {
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 20px;
  height: 30px;
  background: #ffd700;
  border-radius: 2px 2px 0 0;
}

.building-windows {
  position: absolute;
  top: 10px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 15px;
}

.building-windows .window {
  width: 12px;
  height: 12px;
  background: #ffd700;
  border-radius: 2px;
  display: block;
}

/* 太阳光线 */
.sun-rays {
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 100px;
  height: 100px;
  z-index: 1;
}

.ray {
  position: absolute;
  width: 2px;
  height: 20px;
  background: linear-gradient(180deg, #ffd700 0%, transparent 100%);
  left: 50%;
  top: 0;
  transform-origin: 50% 50px;
}

.ray:nth-child(1) { transform: translateX(-50%) rotate(0deg); }
.ray:nth-child(2) { transform: translateX(-50%) rotate(45deg); }
.ray:nth-child(3) { transform: translateX(-50%) rotate(90deg); }
.ray:nth-child(4) { transform: translateX(-50%) rotate(135deg); }
.ray:nth-child(5) { transform: translateX(-50%) rotate(180deg); }
.ray:nth-child(6) { transform: translateX(-50%) rotate(225deg); }
.ray:nth-child(7) { transform: translateX(-50%) rotate(270deg); }
.ray:nth-child(8) { transform: translateX(-50%) rotate(315deg); }

/* 云朵 */
.cloud {
  position: absolute;
  right: 20px;
  top: 30px;
  width: 40px;
  height: 20px;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 50px;
  z-index: 3;
}

.cloud::before {
  content: '';
  position: absolute;
  left: -15px;
  top: -5px;
  width: 30px;
  height: 30px;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 50%;
}

.cloud::after {
  content: '';
  position: absolute;
  right: -10px;
  top: -3px;
  width: 25px;
  height: 25px;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 50%;
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