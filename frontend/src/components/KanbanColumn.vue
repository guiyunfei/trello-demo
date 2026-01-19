<template>
  <div :class="['rounded-lg shadow-lg overflow-hidden', status.color]">
    <!-- Column Header -->
    <div :class="['p-4 border-b-2', status.borderColor, 'bg-white']">
      <h2 class="text-lg font-bold text-gray-800">{{ status.label }}</h2>
      <p class="text-sm text-gray-500">{{ tasks.length }} 个任务</p>
    </div>

    <!-- Tasks Container -->
    <div
      @dragover.prevent
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

const draggedTask = ref(null)

const handleDragStart = (task) => {
  draggedTask.value = task
}

const handleDragEnd = () => {
  draggedTask.value = null
}

const handleDrop = () => {
  if (draggedTask.value) {
    emit('drop', draggedTask.value, props.status)
    draggedTask.value = null
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
