package com.kanban.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kanban.entity.Task;
import java.util.List;

public interface TaskService extends IService<Task> {
    List<Task> getTasksByStatus(String status);
    Task createTask(Task task);
    Task updateTask(Task task);
    void deleteTask(Long id);
    List<Task> getAllTasks();
}
