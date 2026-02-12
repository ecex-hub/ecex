<template>
  <div class="product-page">
    <!-- 导航栏 -->
    <van-nav-bar
      title="产品详情"
      left-arrow
      @click-left="$router.back()"
      class="custom-nav-bar"
    />

    <!-- Banner区域 -->
    <div class="banner-section">
      <img :src="productImage" alt="产品" class="banner-img" />
    </div>

    <!-- 主要内容区域 -->
    <div class="content-section">
      <!-- 产品详细信息 -->
      <div class="details-section">
        <div class="section-title">
          <span class="title-text">溢慈善助华统一基金</span>
        </div>
        
       

        <!-- 数据展示块（福利卡片） -->
        <div class="data-blocks">
          <div class="benefit-card">
            <div class="benefit-header benefit-header-1">
              <span class="benefit-title">福利一</span>
            </div>
            <div class="benefit-body">
              <div class="benefit-icon-wrap">
                <img :src="cIcon" alt="福利一" class="benefit-icon" />
              </div>
              <div class="benefit-text">
                福利说明介绍文案福利说明介绍文案
              </div>
            </div>
          </div>

          <div class="benefit-card">
            <div class="benefit-header benefit-header-2">
              <span class="benefit-title">福利二</span>
            </div>
            <div class="benefit-body">
              <div class="benefit-icon-wrap">
                <img :src="tIcon" alt="福利二" class="benefit-icon" />
              </div>
              <div class="benefit-text">
                福利说明介绍文案福利说明介绍文案
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 说明部分 -->
      <div class="explanation-section">
        <div class="explanation-title">
          <img :src="starIcon" alt="说明" class="explanation-icon" />
          <span class="explanation-title-text">说明</span>
        </div>

        <div class="description-text">
          <p>当前国家推动经济高质量发展重要政策组合, 旨在通过扩大有效投资和激发内需潜力, 为经济增长注入新动能。</p>
          <p>"两重"政策聚焦于国家重大战略实施和重点领域安全能力建设;</p>
          <p>"两新"政策涵盖大规模设备更新和消费品以旧换新, 直接拉动投资与消费增长。</p>
        </div>
      </div>
    </div>

    <!-- 底部按钮 -->
    <div class="action-buttons">
      <van-button 
        class="verify-btn"
        @click="handleView"
      >
        查看证书
      </van-button>
      <van-button 
        class="submit-btn"
        @click="handlePurchase"
      >
        爱华捐助
      </van-button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import productImage from '@/assets/images/助华专区01.png'
import titleBack from '@/assets/icons/png/common/titleback.png'
import barImage from '@/assets/icons/png/common/bar.png'
import cIcon from '@/assets/icons/png/common/list.png'
import tIcon from '@/assets/icons/png/common/vip.png'
import wIcon from '@/assets/icons/png/common/w.png'
import descBack from '@/assets/icons/png/common/descback.png'
import starIcon from '@/assets/icons/png/common/star.png'

const router = useRouter()

const handleView = () => {
  showToast('查看详情')
  // TODO: 实现查看详情逻辑
}

const handlePurchase = () => {
  showToast('立即购买')
  // TODO: 实现立即购买逻辑
}
</script>

<style scoped>
.product-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 100px;
}

/* 导航栏样式 */
.custom-nav-bar {
  background: transparent;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
}

.custom-nav-bar :deep(.van-nav-bar__title) {
  color: #000;
  font-weight: bold;
  font-size: 18px;
}

.custom-nav-bar :deep(.van-nav-bar__arrow) {
  color: #000;
}

.custom-nav-bar :deep(.van-nav-bar__left) {
  padding-left: 16px;
}

.product-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}

/* Banner区域 */
.banner-section {
  padding: 60px 16px 16px;
  position: relative;
  z-index: 1;
}

.banner-img {
  width: 100%;
  height: auto;
  display: block;
  border-radius: 12px;
}

/* 主要内容区域 */
.content-section {
  padding: 0 16px;
  margin-top: 16px;
}

/* 详细信息区域 */
.details-section {
  background: #fff;
  border: 1px solid #f0e76c;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 16px;
}

.section-title {
  background-image: v-bind('"url(" + titleBack + ")"');
  background-size: 100% 100%;
  background-repeat: no-repeat;
  background-position: center;
  margin-top: -28px;
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 18px;
  text-align: center;
}

.title-text {
  font-size: 20px;
  font-weight: bold;
  color: #912525;
}

.description-text {
  margin-bottom: 20px;
}

.description-text p {
  font-size: 16px;
  color: #070707; 
  line-height: 1.6;
  margin-bottom: 12px;
}

.description-text p:last-child {
  margin-bottom: 0;
}

/* 数据展示块 */
.data-blocks {
  display: flex;
  gap: 12px;
  margin-top: 30px;
}

.data-block {
  background-image: v-bind('"url(" + barImage + ")"');
  background-size: 100% 100%;
  background-repeat: no-repeat;
  background-position: center;
  border-radius: 8px;
  padding: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border: 1px solid rgba(255, 255, 255, 0.3);
  position: relative;
}

.block-left {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.data-icon {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

.block-label {
  font-size: 16px;
  color: #fff;
  font-weight: bold;
}

.block-right {
  border-left: 1px solid rgba(255, 255, 255, 0.3);
  padding-left: 16px;
  margin-left: 16px;
}

.block-value {
  font-size: 22px;
  font-weight: bold;
  color: #b92424;
  text-align: right;
  margin-right: 10px;
}

/* 福利卡片样式 */
.benefit-card {
  flex: 1;
  background: linear-gradient(to left bottom, #ffe9cc 0%, #f7ca81 100%);
  border-radius: 12px;
  padding: 20px 12px 16px;
  box-sizing: border-box;
  position: relative;
}

.benefit-header {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 6px 18px;
  border-radius: 18px;
  font-size: 14px;
  font-weight: 600;
  color: #ffffff;
  position: absolute;
  top: -14px;
  left: 50%;
  transform: translateX(-50%);
 
}

.benefit-header-1 {
  background: linear-gradient(90deg, #f36b2f 0%, #a5574b 100%);
}

.benefit-header-2 {
  background: linear-gradient(90deg, #f36b2f 0%, #a5574b 100%);
}

.benefit-title {
  line-height: 1;
}

.benefit-body {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 8px;
}

.benefit-icon-wrap {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(to left bottom, #ffe9cc 0%, #f7ca81 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 4px;
}

.benefit-icon {
  width: 60px;
  height: 60px;
  object-fit: contain;
  margin-top: 10px;
}

.benefit-text {
    margin-top: 10px;
  font-size: 13px;
  color: #895a16;
  line-height: 1.4;
}

/* 说明部分 */
.explanation-section {
  background: #fff;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  padding: 16px;
}

.explanation-title {
  background-image: v-bind('"url(" + descBack + ")"');
  background-size: 50% 100%;
  background-repeat: no-repeat;
  padding: 12px 16px 16px 16px;
  border-radius: 8px;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.explanation-icon {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.explanation-title-text {
  font-size: 17px;
  font-weight: bold;
  color: #fff;
}

.explanation-text {
  font-size: 16px;
  color: #333;
  font-weight: bold;
  line-height: 1.6;
}

/* 底部按钮 */
.action-buttons {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
  background: #fff;
  display: flex;
  gap: 12px;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
  z-index: 50;
}

.verify-btn {
  flex: 1;
  height: 48px;
  background: #EE2C221A;
  border: 1px solid #e53e3e;
  color: #e53e3e;
  border-radius: 8px;
  font-size: 16px;
  font-weight: bold;
}

.submit-btn {
  flex: 1;
  height: 48px;
  background: #e53e3e;
  border: none;
  color: #fff;
  border-radius: 8px;
  font-size: 16px;
  font-weight: bold;
}

.verify-btn:active {
  background: #fff5f5;
}

.submit-btn:active {
  background: #c53030;
  opacity: 0.9;
}

.block-value-unit {
  font-size: 14px;
  color: #b92424;
  margin-left: 4px;
  font-weight: bold;
}
</style>
