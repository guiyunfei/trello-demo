<template>
  <div class="min-h-screen bg-gradient-to-br from-purple-600 to-blue-600 py-8 px-4">
    <div class="max-w-7xl mx-auto">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-4xl font-bold text-white mb-2">📋 Kanban Board</h1>
        <p class="text-purple-100">任务管理系统 - 拖拽任务来改变状态</p>
      </div>

      <!-- Add Task Form -->
      <div class="bg-white rounded-lg shadow-lg p-6 mb-8">
        <div class="flex gap-2">
          <input
            v-model="newTaskTitle"
            @keyup.enter="addTask"
            type="text"
            placeholder="输入新任务..."
            class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
          />
          <button
            @click="addTask"
            class="px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors font-medium"
          >
            添加任务
          </button>
        </div>
      </div>

      <!-- Kanban Board -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <KanbanColumn
          v-for="status in statuses"
          :key="status.value"
          :status="status"
          :tasks="getTasksByStatus(status.value)"
          @update-task="updateTask"
          @delete-task="deleteTask"
          @drop="handleDrop"
        />
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
        <div class="bg-white rounded-lg p-8">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-purple-600"></div>
          <p class="mt-4 text-gray-600">加载中...</p>
        </div>
      </div>

      <!-- Error Message -->
      <div v-if="error" class="fixed top-4 right-4 bg-red-500 text-white px-6 py-3 rounded-lg shadow-lg">
        {{ error }}
        <button @click="error = ''" class="ml-4 font-bold">✕</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { taskApi } from './api/taskApi'
import KanbanColumn from './components/KanbanColumn.vue'

const tasks = ref([])
const newTaskTitle = ref('')
const loading = ref(false)
const error = ref('')

const statuses = [
  { value: 'TODO', label: '待做', color: 'bg-blue-100', borderColor: 'border-blue-300' },
  { value: 'DOING', label: '进行中', color: 'bg-yellow-100', borderColor: 'border-yellow-300' },
  { value: 'DONE', label: '已完成', color: 'bg-green-100', borderColor: 'border-green-300' },
]

const getTasksByStatus = (status) => {
  if (!Array.isArray(tasks.value)) return []
  return tasks.value.filter(task => task.status === status)
}

const loadTasks = async () => {
  loading.value = true
  try {
    const response = await taskApi.getAllTasks()
    // 处理可能的数据格式：response.data 可能是数组或对象
    tasks.value = Array.isArray(response.data) ? response.data : (response.data.data || [])
  } catch (err) {
    error.value = '加载任务失败'
    console.error(err)
    tasks.value = []
  } finally {
    loading.value = false
  }
}

const addTask = async () => {
  if (!newTaskTitle.value.trim()) return

  try {
    const response = await taskApi.createTask({
      title: newTaskTitle.value,
      status: 'TODO',
      description: '',
    })
    tasks.value.push(response.data)
    newTaskTitle.value = ''
  } catch (err) {
    error.value = '添加任务失败'
    console.error(err)
  }
}

const updateTask = async (task) => {
  try {
    await taskApi.updateTask(task.id, task)
    const index = tasks.value.findIndex(t => t.id === task.id)
    if (index !== -1) {
      tasks.value[index] = task
    }
  } catch (err) {
    error.value = '更新任务失败'
    console.error(err)
  }
}

const deleteTask = async (id) => {
  try {
    await taskApi.deleteTask(id)
    tasks.value = tasks.value.filter(t => t.id !== id)
  } catch (err) {
    error.value = '删除任务失败'
    console.error(err)
  }
}

const handleDrop = async (task, newStatus) => {
  task.status = newStatus
  await updateTask(task)
}

onMounted(() => {
  loadTasks()
})
</script>
