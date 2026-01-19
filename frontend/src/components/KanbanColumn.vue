<template>
  <div :class="['rounded-lg shadow-lg overflow-hidden', status.color]">
    <!-- Column Header -->
    <div :class="['p-4 border-b-2', status.borderColor, 'bg-white']">
      <h2 class="text-lg font-bold text-gray-800">{{ status.label }}</h2>
      <p class="text-sm text-gray-500">{{ tasks.length }} 个任务</p>
    </div>

    <!-- Tasks Container -->
    <div
      @dragover.prevent="handleDragOver"
      @drop="handleDrop"
      class="p-4 min-h-96 bg-gray-50"
    >
      <transition-group name="list" tag="div" class="space-y-3">
        <TaskCard
          v-for="task in tasks"
          :key="task.id"
          :task="task"
          @delete="$emit('delete-task', task.id)"
          @update="$emit('update-task', $event)"
          @dragstart="handleDragStart"
          @dragend="handleDragEnd"
        />
      </transition-group>

      <!-- Empty State -->
      <div v-if="tasks.length === 0" class="text-center py-8 text-gray-400">
        <p class="text-sm">暂无任务</p>
        <p class="text-xs mt-1">拖拽任务到此处</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import TaskCard from './TaskCard.vue'

const props = defineProps({
  status: {
    type: Object,
    required: true,
  },
  tasks: {
    type: Array,
    required: true,
  },
})

const emit = defineEmits(['update-task', 'delete-task', 'drop'])

const handleDragOver = (e) => {
  e.preventDefault()
  e.dataTransfer.dropEffect = 'move'
}

const handleDragStart = (task, e) => {
  e.dataTransfer.effectAllowed = 'move'
  e.dataTransfer.setData('application/json', JSON.stringify(task))
  console.log('Drag started:', task)
}

const handleDragEnd = () => {
  console.log('Drag ended')
}

const handleDrop = (e) => {
  e.preventDefault()
  e.stopPropagation()
  try {
    const taskData = e.dataTransfer.getData('application/json')
    if (taskData) {
      const draggedTask = JSON.parse(taskData)
      console.log('Drop event triggered, draggedTask:', draggedTask, 'newStatus:', props.status.value)
      emit('drop', draggedTask, props.status.value)
    }
  } catch (err) {
    console.error('Drop error:', err)
  }
}
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}

.list-enter-from {
  opacity: 0;
  transform: translateX(-30px);
}

.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>
