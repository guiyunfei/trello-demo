# 部署指南

## 一键启动

### 前置条件

- Docker 20.10+
- Docker Compose 2.0+

### 启动步骤

1. 克隆项目
```bash
git clone <repository-url>
cd kanban-board
```

2. 启动所有服务
```bash
docker-compose up -d
```

3. 等待服务启动（约 30-60 秒）
```bash
docker-compose ps
```

4. 访问应用
- 前端: http://localhost:5173
- 后端 API: http://localhost:8088/api

### 验证服务

```bash
# 检查前端
curl http://localhost:5173

# 检查后端
curl http://localhost:8088/api/tasks

# 查看日志
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mysql
```

## 停止服务

```bash
# 停止所有服务
docker-compose down

# 停止并删除数据
docker-compose down -v
```

## 环境配置

### 修改端口

编辑 `docker-compose.yml`:

```yaml
services:
  frontend:
    ports:
      - "8080:5173"  # 改为 8080
  backend:
    ports:
      - "9000:8088"  # 改为 9000
```

### 修改数据库密码

编辑 `docker-compose.yml`:

```yaml
services:
  mysql:
    environment:
      MYSQL_ROOT_PASSWORD: your_password
  backend:
    environment:
      SPRING_DATASOURCE_PASSWORD: your_password
```

## 生产部署

### 使用 Nginx 反向代理

```nginx
upstream backend {
    server localhost:8088;
}

upstream frontend {
    server localhost:5173;
}

server {
    listen 80;
    server_name kanban.example.com;

    location /api {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        proxy_pass http://frontend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 使用 SSL/TLS

```bash
# 使用 Let's Encrypt
certbot certonly --standalone -d kanban.example.com
```

更新 Nginx 配置:

```nginx
server {
    listen 443 ssl;
    server_name kanban.example.com;

    ssl_certificate /etc/letsencrypt/live/kanban.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/kanban.example.com/privkey.pem;

    # ... 其他配置
}
```

## 监控和日志

### 查看日志

```bash
# 所有服务
docker-compose logs

# 特定服务
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mysql

# 实时日志
docker-compose logs -f
```

### 性能监控

```bash
# 查看容器资源使用
docker stats

# 查看容器详情
docker inspect kanban-backend
```

## 备份和恢复

### 备份数据库

```bash
docker exec kanban-mysql mysqldump -u root -proot123456 kanban > backup.sql
```

### 恢复数据库

```bash
docker exec -i kanban-mysql mysql -u root -proot123456 kanban < backup.sql
```

### 备份数据卷

```bash
docker run --rm -v kanban_mysql_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/mysql_backup.tar.gz -C /data .
```

## 故障排除

### 服务无法启动

检查日志:
```bash
docker-compose logs
```

检查端口占用:
```bash
lsof -i :5173
lsof -i :8088
lsof -i :3306
```

### 数据库连接失败

检查 MySQL 健康状态:
```bash
docker-compose ps mysql
```

重启 MySQL:
```bash
docker-compose restart mysql
```

### 前端无法访问后端

检查网络:
```bash
docker network ls
docker network inspect kanban-network
```

检查防火墙:
```bash
# macOS
sudo pfctl -s nat

# Linux
sudo iptables -L
```

## 升级

### 更新镜像

```bash
# 拉取最新代码
git pull

# 重建镜像
docker-compose build --no-cache

# 重启服务
docker-compose up -d
```

## 安全建议

1. 修改默认数据库密码
2. 使用 HTTPS
3. 配置防火墙规则
4. 定期备份数据
5. 使用强密码
6. 限制 API 访问
7. 启用日志审计
