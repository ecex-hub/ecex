<template>
  <!-- 官方消息弹窗 -->
  <OfficialMessagePopup
    v-if="type === 'official'"
    v-model="modelValue"
    :title="title"
    :content="content"
    :close-on-click-overlay="closeOnClickOverlay"
  >
    <slot></slot>
  </OfficialMessagePopup>

  <!-- 通用消息弹窗 -->
  <GeneralMessagePopup
    v-else-if="type === 'general'"
    v-model="modelValue"
    :message="message"
    :close-on-click-overlay="closeOnClickOverlay"
  >
    <slot></slot>
  </GeneralMessagePopup>

  <!-- 通用提示弹窗 -->
  <GeneralPromptPopup
    v-else-if="type === 'prompt'"
    v-model="modelValue"
    :title="title"
    :content="content"
    :close-on-click-overlay="closeOnClickOverlay"
  >
    <slot></slot>
  </GeneralPromptPopup>
</template>

<script setup>
import { computed } from 'vue'
import OfficialMessagePopup from './OfficialMessagePopup.vue'
import GeneralMessagePopup from './GeneralMessagePopup.vue'
import GeneralPromptPopup from './GeneralPromptPopup.vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  type: {
    type: String,
    default: 'official',
    validator: (value) => ['official', 'general', 'prompt'].includes(value)
  },
  title: {
    type: String,
    default: ''
  },
  content: {
    type: String,
    default: ''
  },
  message: {
    type: String,
    default: ''
  },
  closeOnClickOverlay: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['update:modelValue', 'close'])

const modelValue = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const handleClose = () => {
  modelValue.value = false
  emit('close')
}
</script>