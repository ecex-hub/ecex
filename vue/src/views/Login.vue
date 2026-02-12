<template>
  <div class="login-page">
    <!-- 顶部背景区域 -->
    <div class="login-header">
      <div class="header-bg">     
        <div class="logo-placeholder">
          <div class="logo-image">
            <img src="@/assets/images/common/logo.png" alt="LOGO" />
          </div>
        </div>
      </div>
    </div>

    <!-- 登录表单 -->
    <div class="login-form-container">
      <form class="login-form" @submit.prevent="onSubmit">
        <div class="form-group">
          <label class="form-label">账号/手机号</label>
          <input
            v-model="form.account"
            type="text"
            class="form-input"
            placeholder="请输入账号或手机号"
            required
          />
        </div>
        <div class="form-group">
          <label class="form-label">密码</label>
          <div class="password-input-wrapper">
            <input
              v-model="form.password"
              :type="showPassword ? 'text' : 'password'"
              class="form-input"
              placeholder="请输入登录密码"
              required
            />
            <span class="password-toggle" @click="togglePassword">
              <img 
                :src="passwordIcon" 
                alt="密码显示/隐藏"
                class="password-icon"
              />
            </span>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">验证码</label>
          <div class="code-input-wrapper">
            <input
              v-model="form.code"
              type="text"
              class="form-input code-input"
              placeholder="请输入验证码"
              required
            />
            <div class="code-image" @click="refreshCode">
              <span class="code-text">{{ codeText }}</span>
            </div>
          </div>
        </div>

        <div class="form-actions">
          <button 
            type="submit"
            class="login-btn"
            :disabled="loading"
          >
            {{ loading ? '登录中...' : '登录' }}
          </button>
        </div>
      </form>
      <div class="register-actions">
        <button 
          type="button"
          class="register-btn"
          @click="$router.push('/register')"
        >
          注册
        </button>
      </div>
    </div>
    <!-- 底部背景区域 -->
    <div class="login-footer"></div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '@/composables/useAuth'
import { showLoadingToast, closeToast, showToast } from 'vant'
import eyeOpen from '@/assets/icons/png/eyeOpen.png'
import eyeClose from '@/assets/icons/png/eyeClose.png'
import btnBackground from '@/assets/images/common/btnbackground.png'

const { login } = useAuth()

const form = ref({
  account: '',
  password: '',
  code: ''
})

const showPassword = ref(false)
const codeText = ref('04922')
const loading = ref(false)

const passwordIcon = computed(() => {
  return showPassword.value ? eyeOpen : eyeClose
})

const togglePassword = () => {
  showPassword.value = !showPassword.value
}

const refreshCode = () => {
  // 生成随机验证码
  codeText.value = Math.floor(Math.random() * 100000).toString().padStart(5, '0')
}

const onSubmit = async () => {
  if (loading.value) return
  
  // 验证必填项（验证码作为前端验证，不发送到后端）
  if (!form.value.account || !form.value.password) {
    showToast('请输入账号和密码')
    return
  }
  
  // 前端验证码验证（可选，如果保留验证码功能）
  if (!form.value.code) {
    showToast('请输入验证码')
    return
  }
  
  try {
    loading.value = true
    showLoadingToast({
      message: '登录中...',
      forbidClick: true
    })
    
    // 只发送后端需要的参数：account 和 password
    await login({
      account: form.value.account,
      password: form.value.password
    })
    
    closeToast()
  } catch (error) {
    closeToast()
    // 错误信息已在 request 拦截器中通过 showToast 显示
    console.error('登录失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  height: 100vh;
  max-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f5f5;
  position: relative;
  overflow: hidden;
}

.login-header {
  height: 35vh;
  max-height: 280px;
  position: relative;
  overflow: hidden;
  flex-shrink: 0;
}

.header-bg {
  width: 100%;
  height: 100%;
  background-image: url('@/assets/images/backgrounds/registerpagehead.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.slogan {
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 30px;
  position: relative;
  z-index: 1;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.logo-placeholder {
  position: relative;
  z-index: 1;
}

.logo-image {
  width: 100px;
  height: 100px;
  border-radius: 10%;
  background: linear-gradient(135deg, #FEE2D6 0%, #FDEBCC 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.logo-image img {
  width: 81px;
  height: 81px;
  object-fit: contain;
}

.login-form-container {
  margin-top: -60px;
  padding: 0px 16px 10px;
  position: relative;
  z-index: 10;
  width: 100%;
  box-sizing: border-box;
  flex: 1;
  min-height: 0;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.login-form {
  background: #fff;
  border-radius: 12px;
  padding: 28px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  flex-shrink: 0;
}

.form-group {
  margin-bottom: 10px;
}

.form-group:last-of-type {
  margin-bottom: 0;
}

.form-label {
  display: block;
  width: 100px;
  color: #323233;
  font-size: 14px;
  font-weight: bold;
  margin-bottom: 8px;
}

.form-input {
  width: 100%;
  height: 40px;
  border: none;
  border-bottom: 1px solid #ebedf0;
  font-size: 14px;
  color: #323233;
  background: transparent;
  box-sizing: border-box;
}

.form-input:focus {
  outline: none;
  border-bottom-color: #e53e3e;
}

.form-input::placeholder {
  color: #969799;
}

.password-input-wrapper {
  position: relative;
}

.password-toggle {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.password-icon {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.code-input-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
}

.code-input {
  flex: 1;
}

.form-actions {
  margin-top: 36px;
  padding: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.register-actions { 
  padding: 40px 28px;
  display: flex;
  flex-direction: column;
  align-items: center;
  flex-shrink: 0;
}

.login-btn {
  background-image: url('@/assets/images/common/btnbackground.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border: none;
  height: 48px;
  width: 100%;
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 500;
  color: #fff;
  border-radius: 12px;
}

.register-btn {
  background: #FFF0E9;
  border: 1px solid #CE231A;
  color: #CE231A;
  height: 48px;
  width: 100%;
  font-size: 16px;
  font-weight: 500;
  border-radius: 12px;
}

.code-image {
  width: 100px;
  height: 36px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.code-image::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: repeating-linear-gradient(
    45deg,
    transparent,
    transparent 2px,
    rgba(255, 255, 255, 0.1) 2px,
    rgba(255, 255, 255, 0.1) 4px
  );
  opacity: 0.5;
}

.code-text {
  color: #fff;
  font-size: 16px;
  font-weight: bold;
  letter-spacing: 2px;
  position: relative;
  z-index: 1;
  transform: perspective(100px) rotateY(-5deg) rotateX(2deg);
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.login-footer {
  height: 100px;
  max-height: 100px;
  flex-shrink: 0;
  background-image: url('@/assets/images/backgrounds/registerpagefoot.png');
  background-size: cover;
  background-position: center top;
  background-repeat: no-repeat;
  position: relative;
}
</style>
