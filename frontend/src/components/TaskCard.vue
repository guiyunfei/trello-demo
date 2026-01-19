<template>
  <div
    draggable="true"
    @dragstart="$emit('dragstart', task)"
    @dragend="$emit('dragend')"
    class="bg-white rounded-lg p-4 shadow hover:shadow-md transition-shadow cursor-move border-l-4 border-purple-500 hover:border-purple-600"
  >
    <div class="flex justify-between items-start gap-2">
      <div class="flex-1 min-w-0">
        <h3 class="font-semibold text-gray-800 break-words">{{ task.title }}</h3>
        <p v-if="task.description" class="text-sm text-gray-600 mt-1 break-words">
          {{ task.description }}
        </p>
        <p class="text-xs text-gray-400 mt-2">
          {{ formatDate(task.createdAt) }}
        </p>
      </div>
      <button
        @click="$emit('delete', task.id)"
        class="flex-shrink-0 text-gray-400 hover:text-red-500 transition-colors p-1"
        title="删除任务"
      >
        ✕
      </button>
    </div>

    <!-- Edit Mode -->
    <div v-if="isEditing" class="mt-3 space-y-2">
      <input
        v-model="editTitle"
        type="text"
        class="w-full px-2 py-1 border border-gray-300 rounded text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
      />
      <textarea
        v-model="editDescription"
        class="w-full px-2 py-1 border border-gray-300 rounded text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
        rows="2"
        placeholder="添加描述..."
      ></textarea>
      <div class="flex gap-2">
        <button
          @click="saveEdit"
          class="flex-1 px-2 py-1 bg-green-500 text-white rounded text-sm hover:bg-green-600 transition-colors"
        >
          保存
        </button>
        <button
          @click="cancelEdit"
          class="flex-1 px-2 py-1 bg-gray-300 text-gray-700 rounded text-sm hover:bg-gray-400 transition-colors"
        >
          取消
        </button>
      </div>
    </div>

    <!-- View Mode -->
    <div v-else class="mt-2">
      <button
        @click="startEdit"
        class="text-xs text-purple-600 hover:text-purple-700 transition-colors"
      >
        编辑
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  task: {
    type: Object,
    required: true,
  },
})

const emit = defineEmits(['delete', 'update', 'dragstart', 'dragend'])

const isEditing = ref(false)
const editTitle = ref(props.task.title)
const editDescription = ref(props.task.description || '')

const startEdit = () => {
  isEditing.value = true
  editTitle.value = props.task.title
  editDescription.value = props.task.description || ''
}

const saveEdit = () => {
  emit('update', {
    ...props.task,
    title: editTitle.value,
    description: editDescription.value,
  })
  isEditing.value = false
}

const cancelEdit = () => {
  isEditing.value = false
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}
</script>
