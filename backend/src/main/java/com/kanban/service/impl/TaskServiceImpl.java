package com.kanban.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kanban.entity.Task;
import com.kanban.mapper.TaskMapper;
import com.kanban.service.TaskService;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class TaskServiceImpl extends ServiceImpl<TaskMapper, Task> implements TaskService {

    @Override
    public List<Task> getTasksByStatus(String status) {
        QueryWrapper<Task> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", status).orderByAsc("position");
        return list(queryWrapper);
    }

    @Override
    public Task createTask(Task task) {
        task.setCreatedAt(LocalDateTime.now());
        task.setUpdatedAt(LocalDateTime.now());
        save(task);
        return task;
    }

    @Override
    public Task updateTask(Task task) {
        task.setUpdatedAt(LocalDateTime.now());
        updateById(task);
        return task;
    }

    @Override
    public void deleteTask(Long id) {
        removeById(id);
    }

    @Override
    public List<Task> getAllTasks() {
        QueryWrapper<Task> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc("status").orderByAsc("position");
        return list(queryWrapper);
    }
}
