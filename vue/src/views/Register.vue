<template>
  <div class="register-page">
    <!-- 顶部背景区域 -->
    <div class="register-header">
      <div class="header-bg">     
        <div class="logo-placeholder">
          <div class="logo-image">
            <img src="@/assets/images/common/logo.png" alt="LOGO" />
          </div>
        </div>
      </div>
    </div>

    <!-- 注册表单 -->
    <div class="register-form-container">
      <form class="register-form" @submit.prevent="onSubmit">
        <div class="form-group">
          <label class="form-label">账号/手机号</label>
          <input
            v-model="form.phone"
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
              placeholder="请输入密码（6-20位）"
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
          <label class="form-label">交易密码</label>
          <div class="password-input-wrapper">
            <input
              v-model="form.payPassword"
              :type="showPayPassword ? 'text' : 'password'"
              class="form-input"
              placeholder="请输入交易密码（6-20位）"
              required
            />
            <span class="password-toggle" @click="togglePayPassword">
              <img 
                :src="payPasswordIcon" 
                alt="密码显示/隐藏"
                class="password-icon"
              />
            </span>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">邀请码</label>
          <input
            v-model="form.inviteCode"
            type="text"
            class="form-input"
            placeholder="请输入邀请码（必填）"
            required
          />
        </div>

        <div class="form-actions">
          <button 
            type="submit"
            class="register-btn"
            :disabled="loading"
          >
            {{ loading ? '注册中...' : '注册' }}
          </button>
        </div>
      </form>
      <div class="login-actions">
        <button 
          type="button"
          class="login-link-btn"
          @click="$router.push('/login')"
        >
          已有账号？立即登录
        </button>
      </div>
    </div>
    <!-- 底部背景区域 -->
    <div class="register-footer"></div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '@/composables/useAuth'
import { showToast, showLoadingToast, closeToast } from 'vant'
import eyeOpen from '@/assets/icons/png/eyeOpen.png'
import eyeClose from '@/assets/icons/png/eyeClose.png'
import btnBackground from '@/assets/images/common/btnbackground.png'

const { register } = useAuth()

const form = ref({
  phone: '',
  password: '',
  payPassword: '',
  inviteCode: ''
})

const showPassword = ref(false)
const showPayPassword = ref(false)
const loading = ref(false)

const passwordIcon = computed(() => {
  return showPassword.value ? eyeOpen : eyeClose
})

const payPasswordIcon = computed(() => {
  return showPayPassword.value ? eyeOpen : eyeClose
})

const togglePassword = () => {
  showPassword.value = !showPassword.value
}

const togglePayPassword = () => {
  showPayPassword.value = !showPayPassword.value
}

const onSubmit = async () => {
  if (loading.value) return
  
  // 验证必填字段
  if (!form.value.phone || !form.value.password || !form.value.payPassword || !form.value.inviteCode) {
    showToast({
      message: '请填写完整信息',
      duration: 3000
    })
    return
  }
  
  // 验证账号格式（至少3位，最多50位，允许字母、数字、下划线）
  if (form.value.phone.length < 3 || form.value.phone.length > 50) {
    showToast({
      message: '账号长度为3-50位',
      duration: 3000
    })
    return
  }
  
  if (!/^[a-zA-Z0-9_]+$/.test(form.value.phone)) {
    showToast({
      message: '账号只能包含字母、数字和下划线',
      duration: 3000
    })
    return
  }
  
  // 验证密码长度
  if (form.value.password.length < 6 || form.value.password.length > 20) {
    showToast({
      message: '密码长度为6-20位',
      duration: 3000
    })
    return
  }
  
  // 验证交易密码长度
  if (form.value.payPassword.length < 6 || form.value.payPassword.length > 20) {
    showToast({
      message: '交易密码长度为6-20位',
      duration: 3000
    })
    return
  }
  
  try {
    loading.value = true
    showLoadingToast({
      message: '注册中...',
      forbidClick: true
    })
    
    // 将前端字段名映射为后端期望的字段名
    await register({
      account: form.value.phone,
      password: form.value.password,
      payPassword: form.value.payPassword,
      invite_code: form.value.inviteCode
    })
    
    closeToast()
  } catch (error) {
    // 延迟关闭 loading，确保错误提示能正常显示
    setTimeout(() => {
      closeToast()
    }, 100)
    console.error('注册失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.register-page {
  height: 100vh;
  max-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f5f5f5;
  position: relative;
  overflow: hidden;
}

.register-header {
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

.register-form-container {
  margin-top: -60px;
  padding: 0px 16px 0px;
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

.register-form {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
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

.code-send-btn {
  width: 100px;
  height: 36px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 4px;
  color: #fff;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  flex-shrink: 0;
}

.code-send-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.form-actions {
  margin-top: 24px;
  padding: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.login-actions { 
  padding: 20px 28px;
  display: flex;
  flex-direction: column;
  align-items: center;
  flex-shrink: 0;
}

.register-btn {
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

.login-link-btn {
  background: #FFF0E9;
  border: 1px solid #CE231A;
  color: #CE231A;
  height: 48px;
  width: 100%;
  font-size: 16px;
  font-weight: 500;
  border-radius: 12px;
}

.register-footer {
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
