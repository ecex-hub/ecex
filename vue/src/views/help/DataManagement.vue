<template>
  <div class="data-management-page">
    <van-nav-bar
      title=""
      left-arrow
      @click-left="$router.back()"
      class="custom-nav-bar"
    />

    <!-- 顶部头部区域 -->
    <div class="header-section">
      <div class="header-content">
        <div class="main-title">
          <img :src="titleImage" alt="资料信息管理" class="title-img" />
        </div>
        <div class="subtitle-box">
          <img :src="descbackImage" alt="描述背景" class="descback-img" />
          <div class="subtitle-text">平台保障用户信息安全,活动参与公平性</div>
        </div>      
      </div>
    </div>

    <!-- 表单区域 -->
    <div class="form-section">
      <div class="form-card">
        <div class="form-card-child">
        <!-- 姓名 -->
        <div class="form-item">
          <label class="form-label">姓名</label>
          <div class="input-wrapper">
            <van-field
              v-model="formData.name"
              placeholder="请输入姓名"
              :border="false"
            />
          </div>
        </div>

        <!-- 身份证号 -->
        <div class="form-item">
          <label class="form-label">身份证号</label>
          <div class="input-wrapper">
            <van-field
              v-model="formData.idNumber"
              placeholder="请输入有效的身份证号码"
              :border="false"
            />
          </div>
        </div>

        <!-- 曾参加的项目 -->
        <div class="form-item">
          <label class="form-label">曾参加的项目</label>
          <div class="textarea-wrapper">
            <van-field
              v-model="formData.projects"
              type="textarea"
              rows="4"
              placeholder="请填写您曾参加的项目及详细描述"
              :border="false"
              class="textarea-field"
            />
            <div class="form-note">注:至少一项,多个请用1、2、3等序号标注</div>
          </div>
        </div>

        <!-- 业绩贡献 -->
        <div class="form-item">
          <label class="form-label">业绩贡献</label>
          <div class="input-wrapper">
            <van-field
              v-model="formData.contribution"
              placeholder="该项目滞留的总资产"
              :border="false"
            />
          </div>
        </div>

        <!-- 补充说明 -->
        <div class="form-item">
          <label class="form-label">补充说明</label>
          <div class="textarea-wrapper">
            <van-field
              v-model="formData.additionalNotes"
              type="textarea"
              rows="3"
              placeholder="请填写"
              :border="false"
              class="textarea-field"
            />
          </div>
        </div>
      </div>
    </div>
    </div>

    <!-- 提交按钮 -->
    <div class="submit-section">
      <van-button
        block
        class="submit-btn"
        :loading="loading"
        @click="handleSubmit"
      >
        提交申请
      </van-button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast, showSuccessToast } from 'vant'
import { helpApi } from '@/api'
import helpImage from '@/assets/icons/png/help/help.png'
import titleImage from '@/assets/icons/png/help/title.png'
import descbackImage from '@/assets/icons/png/help/descback.png'

const router = useRouter()
const loading = ref(false)
const initializing = ref(false)

const formData = reactive({
  name: '',
  idNumber: '',
  projects: '',
  contribution: '',
  additionalNotes: ''
})

// 加载最近一次提交的数据用于回显
const loadLatestData = async () => {
  initializing.value = true
  try {
    const res = await helpApi.getLatestDataManagement()
    const data = res?.data || res
    if (!data) return

    formData.name = data.name || ''
    formData.idNumber = data.id_number || ''
    formData.projects = data.projects || ''
    formData.contribution = data.contribution !== null && data.contribution !== undefined
      ? String(data.contribution)
      : ''
    formData.additionalNotes = data.additional_notes || ''
  } catch (error) {
    // 静默失败，不影响页面使用
    console.error('加载资料信息失败', error)
  } finally {
    initializing.value = false
  }
}

const handleSubmit = async () => {
  if (initializing.value) return
  // 验证必填项
  if (!formData.name) {
    showToast('请输入姓名')
    return
  }
  if (!formData.idNumber) {
    showToast('请输入身份证号')
    return
  }
  if (!formData.projects) {
    showToast('请填写曾参加的项目')
    return
  }

  loading.value = true
  try {
    await helpApi.submitDataManagement({
      name: formData.name,
      id_number: formData.idNumber,
      projects: formData.projects,
      contribution: formData.contribution,
      additional_notes: formData.additionalNotes
    })
    showSuccessToast('提交成功')
    // 成功后返回上一页
    router.back()
  } catch (error) {
    // 错误提示已在请求拦截器中统一处理，这里无需重复提示
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadLatestData()
})
</script>

<style scoped>
.data-management-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 60px;
}

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

.data-management-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}
/* 顶部头部区域 */
.header-section {
  background: url('@/assets/icons/png/help/help.png') no-repeat center;
  background-size: 100% 100%;
  position: relative;
  overflow: hidden;
  padding: 60px 16px 40px;
  min-height: 500px;
}

.header-section::before {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 60px;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><path d="M0,20 Q25,10 50,15 T100,10 L100,20 L0,20 Z" fill="rgba(255,255,255,0.1)"/></svg>') repeat-x;
  background-size: 100px 60px;
}

.header-content {
  position: relative;
  z-index: 2;
  text-align: center;
}

.main-title {
  margin-bottom: 16px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.title-img {
  height: auto;
  max-width: 310px;
  object-fit: contain;
}

.subtitle-box {
  position: relative;
  display: inline-block;
  margin-bottom: 20px;
  max-width: 280px;
}

.descback-img {
  width: 100%;
  height: auto;
  object-fit: contain;
}

.subtitle-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 12px;
  color: #fff;
  line-height: 1.4;
  white-space: nowrap;
  padding: 0 16px;
}

.illustration {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
}

.help-illustration {
  width: 200px;
  height: auto;
  object-fit: contain;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
}

/* 表单区域 */
.form-section {
  margin: -155px 16px 20px;
  position: relative;
  z-index: 10;
}

.form-card {
  background: #fff;
  border-radius: 16px;
  padding: 10px;
}

.form-card-child {
  background: #fff;
  border-radius: 16px;
  padding: 24px 20px 40px;
  border: 1px solid #f8a72d;
}

.form-item {
  margin-bottom: 24px;
}

.form-item:last-child {
  margin-bottom: 0;
}

.form-label {
  display: block;
  font-size: 16px;
  font-weight: 500;
  color: #333;
  margin-bottom: 12px;
}

.input-wrapper {
  background: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
}

.input-wrapper :deep(.van-field) {
  background: transparent;
  padding: 14px 16px;
}

.input-wrapper :deep(.van-field__control) {
  font-size: 16px;
  color: #333;
}

.input-wrapper :deep(.van-field__control::placeholder) {
  color: #999;
  font-size: 14px;
}

.textarea-wrapper {
  background: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
  padding-bottom: 12px;
}

.textarea-field :deep(.van-field) {
  background: #f5f5f5;
  padding: 14px 16px 0;
}

.textarea-field :deep(.van-field__control) {
  font-size: 16px;
  color: #333;
  min-height: 80px;
}

.textarea-field :deep(.van-field__control::placeholder) {
  color: #999;
  font-size: 14px;
}

.form-note {
  font-size: 12px;
  color: #999;
  padding: 0 16px;
  margin-top: 8px;
  line-height: 1.4;
}

/* 提交按钮 */
.submit-section {
  padding: 0 16px 20px;
  margin-top: 20px;
}

.submit-btn {
  height: 50px;
  background: url('@/assets/images/backgrounds/btnback.png') no-repeat center;
  background-size: 100% 100%;
  border: none;
  border-radius: 25px;
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  box-shadow: 0 4px 12px rgba(229, 62, 62, 0.3);
}

.submit-btn:active {
  opacity: 0.9;
}
</style>
