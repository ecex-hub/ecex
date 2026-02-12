<template>
  <div class="reset-password-page">
    <!-- 页面标题栏 -->
    <van-nav-bar
      title="更改登录密码"
      left-arrow
      @click-left="$router.back()"
    />
    
    <!-- 顶部内容区域 -->
    <div class="content">
      <div class="header-content">
        <!-- 主要内容 -->
        <div class="main-content">
          <div class="content-text">
            <div class="main-title">重置密码</div>
            <div class="sub-title">定期修改密码,保护您的账号安全</div>
          </div>
          <div class="illustration">
            <!-- 锁图标 -->
            <div class="lock-key-container">
              <img :src="lockIcon" alt="锁" class="lock-icon" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部表单区域 -->
    <div class="form-section">
      <div class="form-card">
        <!-- 旧密码 -->
        <div class="form-item">
          <label class="form-label">旧密码</label>
          <div class="input-wrapper">
            <van-field
              v-model="formData.oldPassword"
              :type="showPassword.oldPassword ? 'text' : 'password'"
              placeholder="请输入您的当前密码"
              :class="{ 'password-field': true }"
              :border="false"
            />
            <div class="eye-icon" @click="togglePasswordVisibility('oldPassword')">
              <van-icon 
                :name="showPassword.oldPassword ? 'eye-o' : 'closed-eye'" 
                size="20" 
                color="#999" 
              />
            </div>
          </div>
        </div>

        <!-- 新密码 -->
        <div class="form-item">
          <label class="form-label">新密码</label>
          <div class="input-wrapper">
            <van-field
              v-model="formData.newPassword"
              :type="showPassword.newPassword ? 'text' : 'password'"
              placeholder="请输入您的新密码"
              :class="{ 'password-field': true }"
              :border="false"
            />
            <div class="eye-icon" @click="togglePasswordVisibility('newPassword')">
              <van-icon 
                :name="showPassword.newPassword ? 'eye-o' : 'closed-eye'" 
                size="20" 
                color="#999" 
              />
            </div>
          </div>
        </div>

        <!-- 确认新密码 -->
        <div class="form-item">
          <label class="form-label">确认新密码</label>
          <div class="input-wrapper">
            <van-field
              v-model="formData.confirmPassword"
              :type="showPassword.confirmPassword ? 'text' : 'password'"
              placeholder="请再次确认新密码"
              :class="{ 'password-field': true }"
              :border="false"
            />
            <div class="eye-icon" @click="togglePasswordVisibility('confirmPassword')">
              <van-icon 
                :name="showPassword.confirmPassword ? 'eye-o' : 'closed-eye'" 
                size="20" 
                color="#999" 
              />
            </div>
          </div>
        </div>

        <!-- 确认修改按钮 -->
        <div class="submit-section">
          <van-button             
            block
            class="submit-btn"
            :loading="loading"
            @click="handleSubmit"
          >
            确认修改
          </van-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { showSuccessToast, showFailToast } from 'vant'
import { userApi } from '@/api'
import lockIcon from '@/assets/icons/png/lock.png'

const router = useRouter()

// 表单数据
const formData = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 密码显示/隐藏状态
const showPassword = reactive({
  oldPassword: false,
  newPassword: false,
  confirmPassword: false
})

// 加载状态
const loading = ref(false)

// 切换密码显示/隐藏
const togglePasswordVisibility = (field) => {
  showPassword[field] = !showPassword[field]
}

// 表单验证
const validateForm = () => {
  if (!formData.oldPassword) {
    showFailToast('请输入旧密码')
    return false
  }
  
  if (!formData.newPassword) {
    showFailToast('请输入新密码')
    return false
  }
  
  if (formData.newPassword.length < 6) {
    showFailToast('新密码长度至少6位')
    return false
  }
  
  if (formData.newPassword === formData.oldPassword) {
    showFailToast('新密码不能与旧密码相同')
    return false
  }
  
  if (!formData.confirmPassword) {
    showFailToast('请确认新密码')
    return false
  }
  
  if (formData.newPassword !== formData.confirmPassword) {
    showFailToast('两次输入的新密码不一致')
    return false
  }
  
  return true
}

// 提交表单
const handleSubmit = async () => {
  if (!validateForm()) {
    return
  }
  
  loading.value = true
  
  try {
    await userApi.changePassword({
      // 与后端 /user/password 接口保持一致的参数名
      oldPassword: formData.oldPassword,
      newPassword: formData.newPassword
    })
    
    showSuccessToast('密码修改成功')
    
    // 延迟返回上一页
    setTimeout(() => {
      router.back()
    }, 1500)
  } catch (error) {
    console.error('修改密码失败:', error)
    showFailToast(error?.message || '修改密码失败，请重试')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.reset-password-page {
  min-height: 100vh;
  background: #ffffff url('@/assets/images/backgrounds/resetpass.png') no-repeat top center;
  background-size: 100% auto;
  background-attachment: fixed;
  padding-bottom: 80px;
}

.reset-password-page :deep(.van-nav-bar) {
  position: relative;
  z-index: 10;
  background: transparent;
}

.reset-password-page :deep(.van-nav-bar[class*="van-hairline"]:after) {
  border: none;
  display: none;
}

.reset-password-page :deep(.van-nav-bar__title) {
  color: #000000;
  font-weight: bold;
}

.reset-password-page :deep(.van-nav-bar__text) {
  color: #000000;
}

.reset-password-page :deep(.van-nav-bar__arrow) {
  color: #000000;
}

.content {
  padding: 16px; 
}

.header-content {
  position: relative;
  z-index: 2;
  padding: 0 16px 10px; 
  display: flex;
  flex-direction: column;
}

/* 主要内容区域 */
.main-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex: 1; 
  padding: 0 10px;
}

.content-text {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.main-title {
  font-size: 28px;
  font-weight: bold;
  color: #050505;
  line-height: 1.3;
}

.sub-title {
  font-size: 14px;
  color: #8d8d8d;
  opacity: 0.95;
}

/* 锁和钥匙图标 */
.illustration {
  flex-shrink: 0;
  width: 140px;
  height: 160px;
  position: relative; 
  display: flex;
  align-items: center;
  justify-content: center;
}

.lock-key-container {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.lock-icon {
  width: 100%;
  height: 100%;
  object-fit: contain;
  position: relative;
  z-index: 2;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
}

/* 底部表单区域 */
.form-section {
  margin: 0 16px 20px;
  position: relative;
  z-index: 10;
}

.form-card {  
  padding: 0 20px 40px;
}

.form-item {
  margin-bottom: 24px;
}

.form-label {
  display: block;
  font-size: 16px;
  font-weight: 500;
  color: #333333;
  margin-bottom: 12px;
}

.input-wrapper {
  position: relative;
  background: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
}

.input-wrapper :deep(.van-field) {
  background: transparent;
  padding: 14px 50px 14px 16px;
}

.input-wrapper :deep(.van-field__control) {
  font-size: 16px;
  color: #333;
}

.input-wrapper :deep(.van-field__control::placeholder) {
  color: #999;
  font-size: 14px;
}

.eye-icon {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 10;
}

/* 提交按钮区域 */
.submit-section {
  margin-top: 60px;
}

.submit-btn {
  height: 50px;
  background: url('@/assets/images/backgrounds/btnback.png') no-repeat center;
  background-size: 100% 100%;
  border: none;
  color: #ffffff;
  font-size: 16px;
  font-weight: bold;
  box-shadow: 0 4px 12px rgba(229, 62, 62, 0.3);
}

.submit-btn:active {
  opacity: 0.9;
}
</style>