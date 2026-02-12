<template>
  <div class="identity-page">
    <!-- 顶部背景区域（包含导航栏和横幅） -->
    <div class="header-wrapper">
      <van-nav-bar
        title="身份认证"
        left-arrow
        @click-left="$router.back()"
        class="transparent-nav"
      />

      <!-- 顶部横幅 -->
      <div class="header-section">
        <div class="header-content">
          <img :src="contentImage" alt="身份认证" class="content-image" />
        </div>
        <div class="header-decoration">
          <div class="decoration-icon">
            <van-icon name="certificate" size="40" color="#fff" />
            <div class="star-rating">
              <van-icon name="star" size="12" color="#ffd700" v-for="n in 4" :key="n" />
              <van-icon name="star-o" size="12" color="#ffd700" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 表单区域 -->
    <div class="form-section">
      <!-- 上传证件照片 -->
      <div class="section">
        <div class="section-divider">
          <span class="divider-text">上传证件照片</span>
        </div>
        
        <div class="upload-group">
          <div class="upload-item">
            <div class="upload-box upload-box-z" @click="uploadIdFront">
              <img v-if="!idFrontImage" :src="cImage" alt="上传" class="upload-placeholder" />
              <img v-else :src="idFrontImage" class="uploaded-image" />             
            </div>
            <!-- 隐藏的身份证正面选择器 -->
            <input
              ref="idFrontInput"
              type="file"
              accept="image/*"
              class="file-input-hidden"
              @change="onIdFrontChange"
            />
            <div class="upload-label">上传身份证头像面</div>
          </div>
          <div class="upload-item">
            <div class="upload-box upload-box-f" @click="uploadIdBack">
              <img v-if="!idBackImage" :src="cImage" alt="上传" class="upload-placeholder" />
              <img v-else :src="idBackImage" class="uploaded-image" />             
            </div>
            <!-- 隐藏的身份证反面选择器 -->
            <input
              ref="idBackInput"
              type="file"
              accept="image/*"
              class="file-input-hidden"
              @change="onIdBackChange"
            />
            <div class="upload-label">上传身份证国徽面</div>
          </div>
        </div>
      </div>

      <!-- 填写身份信息 -->
      <div class="section">
        <div class="section-divider">        
          <span class="divider-text">填写身份信息</span>         
        </div>

        <van-form @submit="onSubmit">
          <van-cell-group inset>
            <van-field
              v-model="form.name"
              name="name"
              label="姓名*"
              placeholder="请输入您的真实姓名"
              :rules="[{ required: true, message: '请输入真实姓名' }]"
            />
            <van-field
              v-model="form.idCard"
              name="idCard"
              label="身份证号码*"
              placeholder="请输入您的身份证号码"
              :rules="[
                { required: true, message: '请输入身份证号码' },
                { pattern: /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[\dXx]$/, message: '请输入正确的身份证号码' }
              ]"
            />
          </van-cell-group>
        </van-form>
      </div>
    </div>

    <!-- 提交按钮 -->
    <div class="submit-section">
      <van-button 
        block 
        type="primary" 
        class="submit-btn"
        @click="onSubmit"
      >
        提交审核
      </van-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast, showLoadingToast, closeToast } from 'vant'
import { authApi, uploadApi } from '@/api'
import headImage from '@/assets/icons/png/realname/head.png'
import contentImage from '@/assets/icons/png/realname/content.png'
import barImage from '@/assets/icons/png/realname/bar.png'
import zImage from '@/assets/icons/png/realname/z.png'
import fImage from '@/assets/icons/png/realname/f.png'
import cImage from '@/assets/icons/png/realname/c.png'
import bImage from '@/assets/icons/png/realname/b.png'

const router = useRouter()

const form = ref({
  name: '',
  idCard: ''
})

const idFrontImage = ref('')
const idBackImage = ref('')
const idFrontInput = ref(null)
const idBackInput = ref(null)

// 初始化：回显已认证信息
const initAuthInfo = async () => {
  try {
    const res = await authApi.getAuthStatus()
    const body = res?.data || res
    const data = body?.data || body

    if (!data) return

    // 回显姓名和身份证号
    if (data.realName) {
      form.value.name = data.realName
    }
    if (data.IDCard) {
      form.value.idCard = data.IDCard
    }

    // 如果后端扩展返回了图片地址，也一并回显
    if (data.IDFrontUrl) {
      idFrontImage.value = data.IDFrontUrl
    }
    if (data.IDOppositeUrl) {
      idBackImage.value = data.IDOppositeUrl
    }
  } catch (error) {
    console.error('获取认证信息失败', error)
    // 回显失败不影响用户重新填写，这里不打扰用户
  }
}

const uploadIdFront = () => {
  if (idFrontInput.value) {
    idFrontInput.value.click()
  }
}

const uploadIdBack = () => {
  if (idBackInput.value) {
    idBackInput.value.click()
  }
}

const onIdFrontChange = async (event) => {
  const file = event.target.files?.[0]
  if (!file) return

  try {
    showLoadingToast({
      message: '上传中...',
      forbidClick: true,
      duration: 0
    })

    const res = await uploadApi.uploadFile(file)
    const data = res?.data || res

    // 假设后端返回 { url: '图片地址' } 或 data.url
    const url = data?.url || data?.data?.url
    if (!url) {
      closeToast()
      showToast('上传失败，请稍后重试')
      return
    }

    idFrontImage.value = url
    closeToast()
    showToast('身份证正面上传成功')
  } catch (error) {
    console.error('身份证正面上传失败', error)
    closeToast()
    showToast('上传失败，请检查网络')
  } finally {
    // 清空 input 的值，避免同一文件无法重复选择
    if (idFrontInput.value) {
      idFrontInput.value.value = ''
    }
  }
}

const onIdBackChange = async (event) => {
  const file = event.target.files?.[0]
  if (!file) return

  try {
    showLoadingToast({
      message: '上传中...',
      forbidClick: true,
      duration: 0
    })

    const res = await uploadApi.uploadFile(file)
    const data = res?.data || res

    const url = data?.url || data?.data?.url
    if (!url) {
      closeToast()
      showToast('上传失败，请稍后重试')
      return
    }

    idBackImage.value = url
    closeToast()
    showToast('身份证反面上传成功')
  } catch (error) {
    console.error('身份证反面上传失败', error)
    closeToast()
    showToast('上传失败，请检查网络')
  } finally {
    if (idBackInput.value) {
      idBackInput.value.value = ''
    }
  }
}

const onSubmit = async () => {
  if (!idFrontImage.value || !idBackImage.value) {
    showToast('请上传身份证照片')
    return
  }
  if (!form.value.name || !form.value.idCard) {
    showToast('请填写完整信息')
    return
  }

  try {
    showLoadingToast({
      message: '提交中...',
      forbidClick: true,
      duration: 0
    })

    const payload = {
      // 后端 AuthController::actionIdentity 要求的字段
      realName: form.value.name,
      IDCard: form.value.idCard,
      IDFrontUrl: idFrontImage.value,
      IDOppositeUrl: idBackImage.value
    }

    const res = await authApi.identityAuth(payload)
    const data = res?.data || res

    // 后端统一返回 code=200 表示成功
    const success = data?.code === 200

    closeToast()

    if (success) {
      showToast('提交成功，等待审核')
      // 成功后可按需跳转，如返回上一页或跳到实名结果页
      setTimeout(() => {
        router.back()
      }, 800)
    } else {
      showToast(data?.message || '提交失败，请稍后重试')
    }
  } catch (error) {
    console.error('身份认证提交失败', error)
    closeToast()
    showToast('提交失败，请检查网络或稍后重试')
  }
}

onMounted(() => {
  initAuthInfo()
})
</script>

<style scoped>
.identity-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 80px;
}

.identity-page :deep(.van-nav-bar[class*='van-hairline']:after) {
  border: none;
  display: none;
}

.header-wrapper {
  background-image: v-bind('"url(" + headImage + ")"');
  background-size: 100% auto;
  background-position: center top;
  background-repeat: no-repeat;
  position: relative;
  border-bottom-left-radius: 20px;
  border-bottom-right-radius: 20px;
  overflow: visible;
  z-index: 1;
}

.transparent-nav {
  background: transparent !important;
}

.transparent-nav :deep(.van-nav-bar__title) {
  color: #fff !important;
}

.transparent-nav :deep(.van-nav-bar__arrow) {
  color: #fff !important;
}

.header-section {
  padding: 30px 20px;
  color: #fff;
  position: relative;
}

.header-content {
  text-align: left;
  position: relative;
  z-index: 1;
  display: flex;
  justify-content: flex-start;
  align-items: center;
}

.content-image {
  max-width: 60%;
  height: auto;
}

.header-decoration {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 1;
}

.decoration-icon {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.star-rating {
  display: flex;
  gap: 2px;
  align-items: center;
}

.form-section {
  padding: 20px 16px;
}

.section {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
}

.section-divider {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  background-image: v-bind('"url(" + barImage + ")"');
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  min-height: 40px;
  padding: 8px 0;
}

.divider-text {
  font-size: 16px;
  font-weight: bold;
  color: #9e3131;
}

.upload-group {
  display: flex;
  gap: 16px;
}

.upload-item {
  flex: 1;
}

.upload-box {  
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border: none;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
  aspect-ratio: 320 / 192;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.upload-box-z {
  background-image: v-bind('"url(" + zImage + ")"');
}
.upload-box-f {
  background-image: v-bind('"url(" + fImage + ")"');
}

.upload-box:active {
  opacity: 0.9;
}

.upload-placeholder {
  width: 40px;
  height: 40px;
  object-fit: contain;
  margin-bottom: 8px;
}

.uploaded-image {
  width: 100%;
  height: 120px;
  object-fit: cover;
  border-radius: 4px;
  margin-bottom: 8px;
}

.upload-label {
  font-size: 12px;
  color: #666;
  margin-top: 8px;
  font-weight: bold;
  text-align: center;
  width: 100%;
}

.file-input-hidden {
  display: none;
}

.submit-section {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
}

.submit-btn {
  background-image: v-bind('"url(" + bImage + ")"');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  border: none;
  height: 50px;
  font-size: 16px;
}
</style>
