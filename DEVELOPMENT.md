# 开发指南

## 项目结构

```
.
├── backend/                          # Spring Boot 后端
│   ├── src/main/java/com/kanban/
│   │   ├── KanbanApplication.java    # 应用入口
│   │   ├── controller/               # 控制器层
│   │   ├── service/                  # 业务逻辑层
│   │   ├── mapper/                   # 数据访问层
│   │   ├── entity/                   # 实体类
│   │   └── dto/                      # 数据传输对象
│   ├── src/main/resources/
│   │   ├── application.yml           # 应用配置
│   │   └── db/                       # 数据库脚本
│   ├── pom.xml                       # Maven 配置
│   └── Dockerfile                    # Docker 镜像配置
│
├── frontend/                         # Vue 3 前端
│   ├── src/
│   │   ├── main.js                   # 应用入口
│   │   ├── App.vue                   # 根组件
│   │   ├── components/               # 组件
│   │   ├── api/                      # API 调用
│   │   └── style.css                 # 全局样式
│   ├── index.html                    # HTML 模板
│   ├── package.json                  # NPM 配置
│   ├── vite.config.js                # Vite 配置
│   ├── tailwind.config.js            # Tailwind 配置
│   └── Dockerfile                    # Docker 镜像配置
│
├── docker-compose.yml                # Docker 编排
├── .github/workflows/ci.yml          # GitHub Actions
└── README.md                         # 项目说明
```

## 本地开发

### 前置条件

- Java 17+
- Node.js 20+
- MySQL 8.0+
- Docker & Docker Compose (可选)

### 后端开发

```bash
cd backend

# 使用 Maven wrapper
./mvnw spring-boot:run

# 或使用本地 Maven
mvn spring-boot:run
```

后端运行在 http://localhost:8088

### 前端开发

```bash
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build
```

前端运行在 http://localhost:5173

### 数据库

使用 Docker 启动 MySQL:

```bash
docker run -d \
  --name kanban-mysql \
  -e MYSQL_ROOT_PASSWORD=root123456 \
  -e MYSQL_DATABASE=kanban \
  -p 3306:3306 \
  mysql:8.0
```

## API 端点

### 任务管理

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/api/tasks` | 获取所有任务 |
| GET | `/api/tasks/status/{status}` | 按状态获取任务 |
| POST | `/api/tasks` | 创建新任务 |
| PUT | `/api/tasks/{id}` | 更新任务 |
| DELETE | `/api/tasks/{id}` | 删除任务 |

### 请求示例

创建任务:
```bash
curl -X POST http://localhost:8088/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "新任务",
    "description": "任务描述",
    "status": "TODO"
  }'
```

更新任务:
```bash
curl -X PUT http://localhost:8088/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "更新的任务",
    "status": "DOING"
  }'
```

## 代码规范

### 后端

- 使用 Java 17 特性
- 遵循 Spring Boot 最佳实践
- 使用 Lombok 减少样板代码
- 使用 MyBatis-Plus 简化数据访问

### 前端

- 使用 Vue 3 Composition API
- 使用 Tailwind CSS 进行样式设计
- 遵循 ESLint 规则
- 组件命名使用 PascalCase

## 测试

### 后端测试

```bash
cd backend
./mvnw test
```

### 前端测试

```bash
cd frontend
npm run lint
```

## 部署

### Docker Compose 部署

```bash
docker-compose up -d
```

访问应用:
- 前端: http://localhost:5173
- 后端 API: http://localhost:8088/api

### 停止服务

```bash
docker-compose down
```

## 故障排除

### 后端无法连接数据库

检查 MySQL 是否运行:
```bash
docker ps | grep mysql
```

检查数据库连接配置:
```bash
# backend/src/main/resources/application.yml
```

### 前端无法访问后端 API

检查后端是否运行:
```bash
curl http://localhost:8088/api/tasks
```

检查 CORS 配置是否正确。

### Docker 构建失败

清理 Docker 缓存:
```bash
docker system prune -a
docker-compose build --no-cache
```

## 常见问题

**Q: 如何修改数据库密码?**
A: 修改 `docker-compose.yml` 中的 `MYSQL_ROOT_PASSWORD` 和 `application.yml` 中的数据库配置。

**Q: 如何添加新的任务字段?**
A: 
1. 修改 `Task` 实体类
2. 更新数据库 schema
3. 更新 TaskDTO
4. 更新前端组件

**Q: 如何自定义样式?**
A: 修改 `frontend/tailwind.config.js` 和 `frontend/src/style.css`
