import axios from 'axios'

const API_BASE_URL = '/api'

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
})

export const taskApi = {
  getAllTasks() {
    return api.get('/tasks')
  },

  getTasksByStatus(status) {
    return api.get(`/tasks/status/${status}`)
  },

  createTask(task) {
    return api.post('/tasks', task)
  },

  updateTask(id, task) {
    return api.put(`/tasks/${id}`, task)
  },

  deleteTask(id) {
    return api.delete(`/tasks/${id}`)
  },
}

export default api
