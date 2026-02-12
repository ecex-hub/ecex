<template>
  <div class="main-layout">
    <router-view />
    <div class="bottom-tabbar">
      <div 
        class="tab-item" 
        :class="{ active: activeIndex === 0 }"
        @click="navigateTo('/home')"
      >
        <div class="tab-icon">
          <img :src="indexIcon" alt="首页" />
        </div>
        <div class="tab-text">首页</div>
      </div>
      <div 
        class="tab-item tab-item-center" 
        :class="{ active: activeIndex === 1 }"
        @click="navigateTo('/zone')"
      >
        <div class="tab-icon tab-icon-center">
          <img :src="zoneIcon" alt="助华专区" />
        </div>
        <div class="tab-text">助华专区</div>
      </div>
      <div 
        class="tab-item" 
        :class="{ active: activeIndex === 2 }"
        @click="navigateTo('/profile')"
      >
        <div class="tab-icon">
          <img :src="profileIcon" alt="我的" />
        </div>
        <div class="tab-text">我的</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import indexIcon from '@/assets/icons/png/tab/index1.png'
import zoneIcon from '@/assets/icons/png/tab/h0.png'
import profileIcon from '@/assets/icons/png/tab/me0.png'

const route = useRoute()
const router = useRouter()
const activeIndex = ref(0)

watch(() => route.path, (path) => {
  if (path === '/home') activeIndex.value = 0
  else if (path === '/zone') activeIndex.value = 1
  else if (path === '/profile') activeIndex.value = 2
}, { immediate: true })

const navigateTo = (path) => {
  if (route.path !== path) {
    router.push(path)
  }
}
</script>

<style scoped>
.main-layout {
  min-height: 100vh;
  padding-bottom: 50px;
}

/* 底部 tab 栏样式 - 纯 HTML 实现，参考设计图 */
.bottom-tabbar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 50px;
  background-color: #fafafa;
  box-shadow: 0 -1px 4px rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  justify-content: space-around;
  z-index: 100;
  padding-bottom: env(safe-area-inset-bottom);
  overflow: visible;
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  padding: 4px 0;
  transition: color 0.2s;
}

.tab-icon {
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 2px;
}

.tab-icon img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  transition: filter 0.2s;
}

/* 未激活状态：保持原色 */
.tab-item .tab-icon img {
  filter: none; 
}

/* 激活状态：将图片变为红色（只对首页和我的生效，不对助华专区生效） */
.tab-item.active:not(.tab-item-center) .tab-icon img {
  filter: brightness(0) saturate(100%) invert(27%) sepia(51%) saturate(2878%) hue-rotate(346deg) brightness(104%) contrast(97%);
  opacity: 1;
}

.tab-text {
  font-size: 12px;
  color: #333;
  transition: color 0.2s;
}

.tab-item.active .tab-text {
  color: #e53e3e;
}

/* 中间tab特殊样式 - 图标变大并向上突起 */
.tab-item-center {
  position: relative;
}

.tab-icon-center {
  width: 50px;
  height: 50px;
  position: absolute;
  top: -25px;
  left: 50%;
  transform: translateX(-50%);
  background-color: #cccccc;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
  z-index: 101;
  transition: background-color 0.2s;
}

/* 激活状态：背景变为红色 */
.tab-item-center.active .tab-icon-center {
  background-color: #e53e3e;
}

.tab-icon-center img {
  width: 32px;
  height: 32px;
  object-fit: contain;
}

/* 中间tab的文字位置调整 */
.tab-item-center .tab-text {
  margin-top: 28px;
}

/* 确保底部有足够空间 */
.main-layout {
  padding-bottom: calc(50px + env(safe-area-inset-bottom));
}
</style>
