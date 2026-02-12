<template>
  <div class="team-page">
    <!-- 顶部背景区域 -->
    <div class="header-section">
      <div class="header-bg">
        <img :src="backImage" alt="背景" class="bg-image" />
        <div class="header-content">
          <!-- 导航栏 -->
          <div class="nav-bar">
            <van-icon name="arrow-left" size="20" color="#000" @click="$router.back()" />
            <span class="nav-title">我的团队</span>
          </div>
        </div>
      </div>
      <!-- 头像跨边框显示 -->
      <div class="avatar-overlap">
        <van-image
          :src="userInfo.avatar"
          round
          width="68"
          height="68"
          fit="cover"
        />
      </div>
      <!-- 用户信息 -->
      <div class="user-info">
        <div class="info-right">
          <div class="invite-code">
            <span>邀请码: {{ userInfo.inviteCode }}</span>
            <img :src="copyIcon" alt="复制" class="copy-icon" @click="copyInviteCode" />
          </div>
          <div class="team-name">{{ userInfo.teamName }}</div>
        </div>
      </div>
    </div>


    <div class="content-wrapper">
    <div class="content">
      <!-- 统计数据网格 -->
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-value">{{ teamStats.realNameCount }}</div>
          <div class="stat-label">团队实名人数 </div>
          <div class="stat-label"> (人)</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ teamStats.directRealNameCount }}</div>
          <div class="stat-label">直推实名人数 </div>
          <div class="stat-label"> (人)</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ teamStats.directAttendCount }}</div>
          <div class="stat-label">直推参会人数 </div>
          <div class="stat-label"> (人)</div>
        </div>

        <!-- 分割线 -->
        <div class="stat-divider"></div>

        <div class="stat-item">
          <div class="stat-value">{{ teamStats.teamAttendCount }}</div>
          <div class="stat-label">团队参会人数 </div>
          <div class="stat-label"> (人)</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ teamStats.teamAvgAttend }}</div>
          <div class="stat-label">团队平均参会 </div>
          <div class="stat-label"> (人)</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ teamStats.teamWithdraw.toFixed(2) }}</div>
          <div class="stat-label">团队提现 </div>
          <div class="stat-label"> (元)</div>
        </div>

        <!-- 分割线 -->
        <div class="stat-divider"></div>

        <div class="stat-item">
          <div class="stat-value">{{ teamStats.teamDonorCount }}</div>
          <div class="stat-label">团队捐助人数 </div>
          <div class="stat-label"> (人)</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ teamStats.directDonorCount }}</div>
          <div class="stat-label">直推捐助人数 </div>
          <div class="stat-label"> (人)</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ teamStats.teamPerformance.toFixed(2) }}</div>
          <div class="stat-label">团队业绩 </div>
          <div class="stat-label"> (元)</div>
        </div>
      </div>
    </div>

      <div class="">
      <!-- 团队成员列表 -->
      <div class="team-list">
        <div class="list-header">
          <img :src="icoIcon" alt="团队成员" class="team-icon" />
          <span>团队成员</span>
        </div>

        <!-- 有成员时显示列表 -->
        <div v-if="memberList && memberList.length" class="member-list">
          <div 
            v-for="member in memberList" 
            :key="member.id"
            class="member-item"
          >
            <van-image
              :src="member.avatar"
              round
              width="50"
              height="50"
              fit="cover"
              class="member-avatar"
            />
            <div class="member-info">
              <div class="member-name-row">
                <span class="member-name">{{ member.name }}</span>
                <span 
                  :class="member.isRealName ? 'realname-tag verified' : 'realname-tag unverified'"
                >
                  {{ member.isRealName ? '已实名' : '未实名' }}
                </span>
              </div>
              <div class="member-phone">{{ member.phone }}</div>           
            </div>


            <div class="member-info">         
              <div class="member-performance" style="margin-bottom: 12px;">
                <span class="performance-value">{{ formatNumber(member.performance) }}</span>               
              </div>
              <div class="member-performance">                
                <span class="performance-label">业绩 (元)</span>
              </div>
            </div>

            <div class="member-action">
              <span 
                v-if="member.actionType === 'activate'"
                class="action-status activate-status"
              >
                激活
              </span>
              <span 
                v-else
                class="action-status no-status"
              >
                无
              </span>
            </div>
          </div>
        </div>

        <!-- 无成员时显示空状态 -->
        <div v-else class="empty-state">
          <img :src="emptyImage" alt="暂无团队成员" class="empty-image" />
          <div class="empty-text">暂无团队成员</div>
        </div>

        <!-- 分页 -->
        <div class="pagination">
          <van-button 
            type="default" 
            size="small"
            style="height: 45px; font-size: 18px;background: #F3F3F3;"           
            :disabled="currentPage === 1"
            @click="prevPage"
          >
            上一页
          </van-button>
          <van-button 
            type="danger" 
            size="small"
            style="height: 45px; font-size: 18px;background: #FFF0EF;"    
            plain
            :disabled="currentPage >= totalPages"
            @click="nextPage"
          >
            下一页
          </van-button>
        </div>
      </div>
    </div>
  </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { showToast, showSuccessToast } from 'vant'
import { useUserStore } from '@/stores/user'
import { teamApi } from '@/api'
import backImage from '@/assets/icons/png/team/back.png'
import copyIcon from '@/assets/icons/png/team/copy.png'
import icoIcon from '@/assets/icons/png/team/ico.png'
import avatarImage from '@/assets/icons/png/team/avatar.png'
import emptyImage from '@/assets/icons/png/empty.png'

const userStore = useUserStore()

// 头像仍然使用本地占位，邀请码和团队名称从用户信息里取
const userInfo = computed(() => {
  const info = userStore.userInfo || {}
  const nickname = info.nickname || ''

  return {
    avatar: avatarImage,
    inviteCode: info.invite_code || info.inviteCode || '——',
    teamName: nickname ? `${nickname}的团队` : '我的团队'
  }
})

const teamStats = ref({
  realNameCount: 0,
  directRealNameCount: 0,
  directAttendCount: 0,
  teamAttendCount: 0,
  teamAvgAttend: 0,
  teamWithdraw: 0,
  teamDonorCount: 0,
  directDonorCount: 0,
  teamPerformance: 0
})

const memberList = ref([
])

const currentPage = ref(1)
const totalPages = ref(1)
const pageSize = ref(10)

const copyInviteCode = async () => {
  const text = userInfo.value.inviteCode || ''
  if (!text) {
    showToast('暂无邀请码可复制')
    return
  }

  // 兼容部分环境不支持 navigator.clipboard 的情况
  const fallbackCopy = () => {
    const textarea = document.createElement('textarea')
    textarea.value = text
    textarea.readOnly = true
    textarea.style.position = 'absolute'
    textarea.style.left = '-9999px'
    document.body.appendChild(textarea)
    textarea.select()
    const ok = document.execCommand('copy')
    document.body.removeChild(textarea)
    if (!ok) {
      throw new Error('execCommand copy failed')
    }
  }

  try {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      await navigator.clipboard.writeText(text)
    } else {
      fallbackCopy()
    }
    showSuccessToast('邀请码已复制到剪贴板')
  } catch (error) {
    // 再尝试一次 fallback，防止部分浏览器限制
    try {
      fallbackCopy()
      showSuccessToast('邀请码已复制到剪贴板')
    } catch (e) {
      console.error('复制邀请码失败:', error, e)
      showToast('复制失败，请长按邀请码手动复制')
    }
  }
}

const formatNumber = (num) => {
  const n = Number(num || 0)
  if (Number.isNaN(n)) return '0'
  return n.toLocaleString()
}

// 从后台获取团队统计数据
const fetchTeamStats = async () => {
  try {
    const res = await teamApi.getTeamStats()
    const data = res?.data || {}

    teamStats.value = {
      realNameCount: Number(data.realNameCount ?? data.real_name_count ?? 0),
      directRealNameCount: Number(data.directRealNameCount ?? data.direct_real_name_count ?? 0),
      directAttendCount: Number(data.directAttendCount ?? data.direct_attend_count ?? 0),
      teamAttendCount: Number(data.teamAttendCount ?? data.team_attend_count ?? 0),
      teamAvgAttend: Number(data.teamAvgAttend ?? data.team_avg_attend ?? 0),
      teamWithdraw: Number(data.teamWithdraw ?? data.team_withdraw ?? 0),
      teamDonorCount: Number(data.teamDonorCount ?? data.team_donor_count ?? 0),
      directDonorCount: Number(data.directDonorCount ?? data.direct_donor_count ?? 0),
      teamPerformance: Number(data.teamPerformance ?? data.team_performance ?? 0)
    }
  } catch (error) {
    console.error('获取团队统计失败:', error)
    showToast('获取团队统计失败，请稍后重试')
  }
}

// 从后台获取团队成员列表
const fetchTeamList = async () => {
  try {
    const res = await teamApi.getTeamList({
      page: currentPage.value,
      pageSize: pageSize.value
    })

    const data = res?.data || {}
    // 兼容 data 为数组 或 { list, total, pageSize } 两种格式
    const list = Array.isArray(data) ? data : (data.list || data.items || [])
    const total = Number(data.total ?? list.length ?? 0)
    const size = Number(data.pageSize ?? data.per_page ?? pageSize.value)

    if (Array.isArray(list)) {
      memberList.value = list.map((item, index) => {
        const isReal = item.isRealName ?? item.is_real ?? item.realname ?? false
        const performance = item.performance ?? item.total_performance ?? item.amount ?? 0

        let actionType = 'none'
        if (item.actionType) {
          actionType = item.actionType
        } else if (item.can_activate || item.need_activate) {
          actionType = 'activate'
        }

        return {
          id: item.id ?? item.uid ?? index,
          name: item.name || item.nickname || item.real_name || '成员',
          avatar: item.avatar || avatarImage,
          phone: item.phone || item.mobile || item.tel || '',
          isRealName: !!isReal,
          performance: Number(performance || 0),
          actionType
        }
      })
    } else {
      memberList.value = []
    }

    if (size > 0) {
      pageSize.value = size
      totalPages.value = Math.max(1, Math.ceil(total / size))
    }
  } catch (error) {
    console.error('获取团队成员列表失败:', error)
    showToast('获取团队成员失败，请稍后重试')
    memberList.value = []
  }
}

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    fetchTeamList()
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    fetchTeamList()
  }
}

// 页面初始化时加载数据
onMounted(async () => {
  // 如果已登录但还没有用户信息，先拉取一次
  if (userStore.loggedIn && !userStore.userInfo) {
    try {
      await userStore.fetchUserInfo()
    } catch (error) {
      console.error('获取用户信息失败:', error)
    }
  }

  await Promise.all([
    fetchTeamStats(),
    fetchTeamList()
  ])
})
</script>

<style scoped>
.team-page {
  min-height: 100vh;
  background: #f5f5f5;
}

.header-section {
  position: relative;
  width: 100%;
}

.header-bg {
  position: relative;
  width: 100%;
  overflow: hidden;
}

.bg-image {
  width: 100%;
  height: auto;
  display: block;
}

.header-content {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  padding: 16px;
  color: #fff;
}

.nav-bar {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 20px;
  position: relative;
}

.nav-bar .van-icon {
  position: absolute;
  left: 0;
}

.nav-title {
  font-size: 18px;
  font-weight: bold;
  color: #000000;
  text-align: center;
}

.user-info {
  position: absolute;
  bottom: -20px;
  left: 126px;
  z-index: 10;
  display: flex;
  align-items: center;
}

.info-right {
  flex: 1;
}

.avatar-overlap {
  position: absolute;
  bottom: -30px;
  left: 40px;
  z-index: 10;
}

.invite-code {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  margin-bottom: 18px; 
}

.invite-code span {
  color: #6e6e6e;
}

.copy-icon {
  width: 16px;
  height: 16px;
  margin-left: 10px;
  cursor: pointer;
}

.team-name {
  font-size: 20px;
  font-weight: bold;
  color: #000000;
}

.content { 
  margin-top: 15px;
  position: relative;
  z-index: 1;
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2);
  border-radius: 12px;
  overflow: hidden;
}

.stats-grid {
  background: #fff;
  border-radius: 12px;
  padding: 16px 0;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 16px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 12px;
  color: #999;
  line-height: 1.4;
}

.stat-divider {
  grid-column: 1 / -1;
  height: 1px;
  background: #eee;
  margin: 8px 0;
}

.team-list {
  margin-top: 16px;
  background: #fff;
  border-radius: 12px;
  padding:  16px 0;
}

.list-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 16px;
}

.team-icon {
  width: 25px;
  height: 25px;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 16px 24px;
}

.empty-image {
  width: 160px;
  height: 160px;
  object-fit: contain;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 14px;
  color: #999;
}

.member-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 16px;
}

.member-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
}

.member-avatar {
  flex-shrink: 0;
}

.member-info {
  flex: 1;
  min-width: 0;
}

.member-name-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}

.member-name {
  font-size: 17px;
  font-weight: bold;
  color: #333;
}

.realname-tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.realname-tag.verified {
  background: #ffeef0;
  color: #ee0a24;
}

.realname-tag.unverified {
  background: #d4d3d3;
  color: #ffffff;
}

.member-phone {
  font-size: 14px;
  color: #999;
  margin-bottom: 4px;
}

.member-performance {
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: 4px;
}

.performance-value {
  font-size: 18px;
  font-weight: bold;
  color: #ee0a24;
}

.performance-label {
  font-size: 12px;
  color: #999;
}

.member-action {
  flex-shrink: 0;
}

.action-status {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  text-align: center;
  min-width: 41px;
}

.activate-status {
  background: #ee0a24;
  color: #fff;
}

.no-status {
  background: #d4d3d3;
  color: #ffffff;
}

.pagination {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  padding-top: 16px;
  border-top: 1px solid #eee;
}

.pagination .van-button {
  flex: 1;
}

.content-wrapper {
  padding: 16px 16px;
  padding-top: 46px;
  background: #fff;
  border-radius: 15px;
  margin-top: -15px;
  position: relative;
  z-index: 1;
}
</style>
