#!/bin/bash

set -e

echo "🚀 Kanban Board 快速启动"
echo "========================"

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装"
    exit 1
fi

echo "✅ Docker 已安装"

# 启动 MySQL
echo ""
echo "📦 启动 MySQL..."
docker run -d \
  --name kanban-mysql \
  -e MYSQL_ROOT_PASSWORD=root123456 \
  -e MYSQL_DATABASE=kanban \
  -p 3306:3306 \
  -v "$(pwd)/backend/src/main/resources/db/schema.sql:/docker-entrypoint-initdb.d/01-schema.sql" \
  -v "$(pwd)/backend/src/main/resources/db/data.sql:/docker-entrypoint-initdb.d/02-data.sql" \
  mysql:8.0.35 2>/dev/null || echo "MySQL 已运行"

echo "⏳ 等待 MySQL 启动..."
sleep 15

# 启动后端
echo ""
echo "📦 启动后端..."
docker run -d \
  --name kanban-backend \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://kanban-mysql:3306/kanban?useSSL=false\&serverTimezone=UTC\&allowPublicKeyRetrieval=true \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=root123456 \
  -p 8088:8088 \
  --link kanban-mysql:mysql \
  openjdk:17-jdk-slim \
  java -jar /app/app.jar 2>/dev/null || echo "后端已运行"

echo "⏳ 等待后端启动..."
sleep 10

# 启动前端
echo ""
echo "📦 启动前端..."
docker run -d \
  --name kanban-frontend \
  -p 5173:5173 \
  -v "$(pwd)/frontend:/app" \
  node:16-slim \
  sh -c "cd /app && npm install && npm run build && npx serve -s dist -l 5173" 2>/dev/null || echo "前端已运行"

echo ""
echo "========================"
echo "✨ 启动完成！"
echo ""
echo "📱 访问应用:"
echo "   前端: http://localhost:5173"
echo "   后端 API: http://localhost:8088/api"
echo ""
echo "🛑 停止服务:"
echo "   docker stop kanban-frontend kanban-backend kanban-mysql"
echo "   docker rm kanban-frontend kanban-backend kanban-mysql"
echo ""
