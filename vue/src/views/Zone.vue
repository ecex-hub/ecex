<template>
  <div class="zone-page">
    <!-- 顶部横幅图片 -->
    <div class="zone-header">
      <img src="@/assets/images/backgrounds/zonehead.png" alt="助华专区" class="header-image" />
    </div>
    
    <!-- 助华专区卡片列表 -->
    <div class="zone-cards">
      <div class="zone-card" @click="handleEnterProduct">
        <img src="@/assets/images/zone-card-01.png" alt="助华专区01" class="card-image" />
        <button class="enter-button">点击进入></button>
      </div>
      <div class="zone-card" @click="handleEnterProduct">
        <img src="@/assets/images/zone-card-02.png" alt="助华专区02" class="card-image" />
        <button class="enter-button">点击进入></button>
      </div>
      <div class="zone-card" @click="handleEnterProduct">
        <img src="@/assets/images/zone-card-03.png" alt="助华专区03" class="card-image" />
        <button class="enter-button">点击进入></button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const handleEnterProduct = () => {
  router.push('/product')
}
</script>

<style scoped>
.zone-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}

.zone-header {
  width: 100%;
  overflow: hidden;
}

.header-image {
  width: 100%;
  height: auto;
  display: block;
  object-fit: cover;
}

.zone-cards {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 16px;
}

.zone-card {
  width: 100%;
  overflow: hidden;
  position: relative;
  border-radius: 12px;
}

.card-image {
  width: 100%;
  height: auto;
  display: block;
  object-fit: cover;
  border-radius: 12px;
}

.enter-button {
  position: absolute;
  bottom: 50px;
  left: 28px;
  color: #fff;
  border: none;
  border-radius: 20px;
  padding: 5px 16px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  transition: all 0.3s;
  background: linear-gradient(to bottom, #BC1E28, #E5333C, #CB1719);
}

.enter-button:active {
  transform: scale(0.95);
  opacity: 0.9;
}
</style>
