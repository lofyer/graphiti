#!/bin/bash

# Graphiti统一镜像构建脚本
# 构建包含Graphiti核心库、Graph服务和MCP服务的统一Docker镜像

set -e

# 设置镜像名称和标签
IMAGE_NAME="graphiti"
IMAGE_TAG="latest"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "开始构建Graphiti统一镜像..."
echo "镜像名称: ${FULL_IMAGE_NAME}"
echo ""

# 构建Docker镜像
echo "正在构建Docker镜像..."
docker build -t "${FULL_IMAGE_NAME}" . -f Dockerfile.abm

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 镜像构建成功！"
    echo "镜像名称: ${FULL_IMAGE_NAME}"
    echo ""
    echo "镜像信息:"
    docker images "${IMAGE_NAME}" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"
    echo ""
    echo "现在可以使用以下命令启动服务:"
    echo "  docker-compose -f docker-compose-abm.yml up -d"
    echo ""
    echo "或者单独运行服务:"
    echo "  Graph服务: docker run -p 8000:8000 ${FULL_IMAGE_NAME}"
    echo "  MCP服务:   docker run -p 8001:8000 ${FULL_IMAGE_NAME} python mcp_server/graphiti_mcp_server2.py --transport sse --host 0.0.0.0"
    echo ""
    echo "注意: 镜像已包含graphiti-core和所有依赖，使用pip安装，无需uv"
else
    echo ""
    echo "❌ 镜像构建失败！"
    exit 1
fi
