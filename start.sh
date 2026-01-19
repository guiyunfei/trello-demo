#!/bin/bash

set -e

echo "🚀 Kanban Board 启动脚本"
echo "========================"

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

# 检查 Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

echo "✅ Docker 和 Docker Compose 已安装"

# 启动服务
echo ""
echo "📦 启动服务..."
docker-compose up -d

# 等待服务启动
echo ""
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo ""
echo "🔍 检查服务状态..."
docker-compose ps

# 检查后端
echo ""
echo "🔗 检查后端 API..."
if curl -s http://localhost:8088/api/tasks > /dev/null; then
    echo "✅ 后端 API 正常"
else
    echo "⚠️  后端 API 未响应，请稍候..."
    sleep 10
fi

# 检查前端
echo ""
echo "🔗 检查前端..."
if curl -s http://localhost:5173 > /dev/null; then
    echo "✅ 前端正常"
else
    echo "⚠️  前端未响应，请稍候..."
    sleep 10
fi

echo ""
echo "========================"
echo "✨ 启动完成！"
echo ""
echo "📱 访问应用:"
echo "   前端: http://localhost:5173"
echo "   后端 API: http://localhost:8088/api"
echo ""
echo "📋 查看日志:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 停止服务:"
echo "   docker-compose down"
echo ""
