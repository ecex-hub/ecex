<template>
  <div class="signin-page">
    <!-- 顶部导航栏 -->
    <div class="header-wrapper">
      <van-nav-bar
        title="每日签到"
        left-arrow
        @click-left="$router.back()"
        class="signin-nav"
      />
    </div>

    <!-- 主要内容区域 -->
    <div class="signin-content">
      <!-- 签到统计卡片 -->
      <div class="stats-section">
     
        <div class="stats-card">
          <div class="stats-text">
            已坚持签到 <span class="stats-number">{{ signInDays }}</span> 天
          </div>
          <div class="motivational-text">
            每天坚持一点,好礼加倍精彩
          </div>
        </div>
        <div class="signin-button" @click="handleSignIn" :class="{ disabled: isSignedToday }">
          {{ isSignedToday ? '今日已签到' : '立即签到' }}
        </div>
      </div>

      <!-- 日历组件 -->
      <div class="calendar-section-wrapper">
      <div class="calendar-section">
        <div class="calendar-header">
          <div class="calendar-nav" @click="prevMonth">
            <van-icon name="arrow-left" />
          </div>
          <div class="calendar-title">
            {{ currentYear }}年{{ String(currentMonth).padStart(2, '0') }}月
          </div>
          <div class="calendar-nav" @click="nextMonth">
            <van-icon name="arrow" />
          </div>
        </div>
        <div class="calendar-weekdays">
          <div class="weekday" v-for="day in weekdays" :key="day">{{ day }}</div>
        </div>
        <div class="calendar-days">
          <div
            v-for="(day, index) in calendarDays"
            :key="index"
            class="calendar-day"
            :class="{
              'signed': isSignedDate(day),
              'today': isToday(day),
              'other-month': day.month !== currentMonth
            }"
          >
            {{ day.date }}
          </div>
        </div>
      </div>
    </div>
      <!-- 签到说明 -->
      <div class="instructions-section">
        <div class="instructions-card">
          <div class="instructions-title">签到说明</div>
          <div class="instructions-content">
            <div
              class="instruction-item"
              v-for="(rule, index) in signRules"
              :key="index"
            >
              <span class="instruction-text">
                {{ rule }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { showToast } from 'vant'
import { signApi } from '@/api'
import headImage from '@/assets/icons/png/sign/head.png'
import bImage from '@/assets/icons/png/sign/b.png'
import btnbackImage from '@/assets/icons/png/sign/btnback.png'
import dImage from '@/assets/icons/png/sign/d.png'
import bannerImage from '@/assets/icons/png/sign/banner.png'
import mImage from '@/assets/icons/png/sign/m.png'
import pagebackImage from '@/assets/icons/png/sign/pageback.png'
import titlebackImage from '@/assets/icons/png/sign/titleback.png'

const signInDays = ref(0) // 已签到天数
const isSignedToday = ref(false) // 今日是否已签到

// 初始化当前年月
const today = new Date()
const currentYear = ref(today.getFullYear())
const currentMonth = ref(today.getMonth() + 1) // 1-12

const weekdays = ['日', '一', '二', '三', '四', '五', '六']

// 已签到的日期列表（接口数据）
const signedDates = ref([])

// 签到说明（接口数据）
const signRules = ref([])

// 计算日历天数
const calendarDays = computed(() => {
  const year = currentYear.value
  const month = currentMonth.value
  const firstDay = new Date(year, month - 1, 1)
  const lastDay = new Date(year, month, 0)
  const daysInMonth = lastDay.getDate()
  const startWeekday = firstDay.getDay()
  
  const days = []
  
  // 添加上个月的末尾几天
  const prevMonthLastDay = new Date(year, month - 1, 0).getDate()
  for (let i = startWeekday - 1; i >= 0; i--) {
    days.push({
      date: prevMonthLastDay - i,
      month: month - 1,
      year: month === 1 ? year - 1 : year
    })
  }
  
  // 添加当月的所有日期
  for (let i = 1; i <= daysInMonth; i++) {
    days.push({
      date: i,
      month: month,
      year: year
    })
  }
  
  // 添加下个月的开头几天，使日历完整
  // 固定6行（42天）
  const remainingDays = 42 - days.length
  for (let i = 1; i <= remainingDays; i++) {
    days.push({
      date: i,
      month: month + 1,
      year: month === 12 ? year + 1 : year
    })
  }
  
  return days
})

// 判断某个日期是否已签到
const isSignedDate = (day) => {
  if (day.month !== currentMonth.value) return false
  const dateStr = `${day.year}-${String(day.month).padStart(2, '0')}-${String(day.date).padStart(2, '0')}`
  return signedDates.value.includes(dateStr)
}

// 判断是否是今天
const isToday = (day) => {
  const today = new Date()
  return day.year === today.getFullYear() &&
         day.month === today.getMonth() + 1 &&
         day.date === today.getDate()
}

// 检查今日是否已签到
const checkTodaySignIn = () => {
  const today = new Date()
  const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
  isSignedToday.value = signedDates.value.includes(todayStr)
}

// 处理签到
const handleSignIn = async () => {
  if (isSignedToday.value) {
    showToast('今日已签到')
    return
  }

  try {
    await signApi.receive()
    showToast.success('签到成功！获得积分50+基金补贴10000')
    await loadSignDetail()
  } catch (error) {
    showToast('签到失败，请稍后重试')
  }
}

// 上一个月
const prevMonth = () => {
  if (currentMonth.value === 1) {
    currentMonth.value = 12
    currentYear.value--
  } else {
    currentMonth.value--
  }
}

// 下一个月
const nextMonth = () => {
  if (currentMonth.value === 12) {
    currentMonth.value = 1
    currentYear.value++
  } else {
    currentMonth.value++
  }
}

// 加载签到详情
const loadSignDetail = async () => {
  try {
    const res = await signApi.getSignDetail()
    const data = res?.data || {}
    signInDays.value = data.sign_in_days || 0
    isSignedToday.value = !!data.is_signed_today
    signedDates.value = data.signed_dates || []
    signRules.value = data.rules || []
    // 兜底再次校验今日是否已签到
    checkTodaySignIn()
  } catch (error) {
    showToast('获取签到信息失败，请稍后重试')
  }
}

onMounted(() => {
  loadSignDetail()
})
</script>

<style scoped>
.signin-page {
  min-height: 100vh;
  background-image: v-bind('"url(" + pagebackImage + ")"');
  background-size: 120% auto;
  background-position: center top;
  background-repeat: no-repeat;
  background-color: #e53e3e;
  padding-bottom: 20px;
}
.signin-page :deep(.van-nav-bar[class*='van-hairline']:after) {
  border: none;
  display: none;
}

.header-wrapper {
  background-image: v-bind('"url(" + headImage + ")"');
  background-size: 100% auto;
  background-position: center top;
  background-repeat: no-repeat;
  position: relative;
  width: 100%;
  min-height: 200px;
  border-bottom-left-radius: 20px;
  border-bottom-right-radius: 20px;
  overflow: visible;
  z-index: 1;
}

.signin-nav {
  background: transparent;
}

.signin-nav :deep(.van-nav-bar__title) {
  color: #fff;
}

.signin-nav :deep(.van-nav-bar__arrow) {
  color: #fff;
}

.signin-content {
  padding: 0;
  margin-top: -160px;
}

/* 签到统计区域 */
.stats-section {
  position: relative;
  padding: 20px 0 30px;
  overflow: hidden;
  background-image: v-bind('"url(" + bImage + ")"');
  background-size: 100% auto;
  background-position: center top;
  background-repeat: no-repeat;
  margin-top: 50px;
}

.stats-section::after {
  content: '';
  position: absolute;
  top: 16px;
  bottom: 0;  
  left: 0;
  right: 0;
  width: 100%; 
  height: 190px;
  background-image: v-bind('"url(" + bannerImage + ")"');
  background-size: 100% auto;
  background-position: center bottom;
  background-repeat: no-repeat; 
  pointer-events: none;
  z-index: 0;
}

.decoration-airplane {
  position: absolute;
  top: 10px;
  right: 20px;
  font-size: 32px;
  z-index: 2;
  animation: float 3s ease-in-out infinite;
}

.decoration-calendar {
  position: absolute;
  top: 50px;
  right: 20px;
  font-size: 24px;
  z-index: 2;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.stats-card {  
  border-radius: 16px;
  padding: 2px 30px;
  margin-bottom: 20px;  
  margin-top: 10px;
}

.stats-text {
  font-size: 20px;
  color: #884040;
  text-align: left;
  margin-bottom: 12px;
  font-weight: bold;
}

.stats-number {
  color: #e53e3e;
  font-size: 30px;
  font-weight: bold;
}

.motivational-text {
  font-size: 14px;
  color: #666;
  text-align: left;
}

.signin-button {
  width: 100%;
  height: 55px;
  z-index: 111;
  background-image: v-bind('"url(" + btnbackImage + ")"');
  background-size: 50% 100%;
  background-position: center;
  background-repeat: no-repeat;
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 16px;
  font-weight: bold; 
  cursor: pointer;
  transition: all 0.3s;
  border: none;
  position: relative;
  margin-top: 76px;
}

.signin-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: v-bind('"url(" + dImage + ")"');
  background-size:75% 43%;
  background-position: center;
  background-repeat: no-repeat;
  border-radius: 24px;
  z-index: 1;
  pointer-events: none;
}

.signin-button > * {
  position: relative;
  z-index: 2;
}

.signin-button:active {
  transform: scale(0.98);
}

.signin-button.disabled {  
  box-shadow: none;
  cursor: not-allowed;
}

.calendar-section-wrapper {
    padding: 50px 20px;
    background-image: v-bind('"url(" + mImage + ")"');
    background-size: 110% auto;
    background-position: center top;
    background-repeat: no-repeat;
    margin-top: -55px;
    
}

/* 日历区域 */
.calendar-section {
    background: #fff;  
  border-radius: 16px;
  padding:0 0 12px 0;
  margin-bottom: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.calendar-header {
    border-radius: 16px 16px 0 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
  padding: 9px 20px;
  background: #e53e3e;
}

.calendar-nav {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #ffffff;
}

.calendar-title {
  font-size: 16px;
  font-weight: bold;
  color: #ffffff; 
}

.calendar-weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 8px;
  margin-bottom: 4px;
  padding: 0 8px;
}

.weekday {
  text-align: center;
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.calendar-days {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 4px;
  padding: 0 8px;
}

.calendar-day {
  aspect-ratio: 1.3;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  color: #333;
  border-radius: 6px;
  position: relative;
}

.calendar-day.other-month {
  color: #ccc;
}

.calendar-day.signed {
  color: #e53e3e;
  font-weight: bold;
  position: relative;
  z-index: 0;
}

.calendar-day.signed::before {
  content: '';
  position: absolute;
  width: 28px;
  height: 28px;
  border: 2px solid #e53e3e;
  border-radius: 50%;
  box-sizing: border-box;
  z-index: 1;
}

.calendar-day.today {
  background: #fff5f5;
  font-weight: bold;
}

/* 签到说明区域 */
.instructions-section {
  border-radius: 16px;
  padding: 10px;
  margin-top: -60px;
}

.instructions-card {
  border-radius: 12px;
  padding: 20px;
}

.instructions-title {
  font-size: 16px;
  font-weight: bold;
  color: #ca4747;
  margin-bottom: 16px;
  background-image: v-bind('"url(" + titlebackImage + ")"');
  background-size: 100% 100%;
  background-position: center;
  background-repeat: no-repeat;
  padding: 8px 16px;
  text-align: center;
}

.instructions-content {
  display: flex;
  flex-direction: column;
  gap: 12px; 
}

.instruction-item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
}

.instruction-text {
  font-size: 14px;
  color: #fff;
  line-height: 1.8;
  flex: 1;
}
</style>