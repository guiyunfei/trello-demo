# Kanban Board 任务管理系统

一个类似 Trello 的任务拖拽管理系统，支持 Todo/Doing/Done 三个状态，前后端分离架构。

## 技术栈

- **前端**: Vue 3 + TypeScript + Tailwind CSS + Shadcn/ui
- **后端**: Spring Boot 3 + MyBatis-Plus + MySQL 8
- **容器化**: Docker + Docker Compose
- **CI/CD**: GitHub Actions

## 快速开始

### 一键启动

```bash
docker-compose up -d
```

启动后访问: http://localhost:5173

后端 API: http://localhost:8088

### 本地开发

#### 后端启动
```bash
cd backend
./mvnw spring-boot:run
```

#### 前端启动
```bash
cd frontend
npm install
npm run dev
```

## 项目结构

```
.
├── backend/              # Spring Boot 后端
├── frontend/             # Vue 3 前端
├── docker-compose.yml    # Docker 编排文件
└── README.md
```

## 功能特性

- ✅ 任务拖拽管理（Todo/Doing/Done）
- ✅ 实时数据同步
- ✅ 响应式设计
- ✅ 数据持久化
- ✅ GitHub Actions CI/CD

## API 文档

### 获取所有任务
```
GET /api/tasks
```

### 创建任务
```
POST /api/tasks
Body: { "title": "任务标题", "status": "TODO" }
```

### 更新任务状态
```
PUT /api/tasks/{id}
Body: { "status": "DOING" }
```

### 删除任务
```
DELETE /api/tasks/{id}
```

## 数据库

MySQL 8.0，自动初始化脚本在 `backend/src/main/resources/db/schema.sql`

## 许可证

MIT
