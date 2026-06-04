#!/bin/bash

# Campus Navigation Setup Script

set -e

echo "🚀 Campus Navigation - Setup Script"
echo "===================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

echo "✅ Docker is installed"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker Compose is installed"

# Copy .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please update .env file with your configuration"
else
    echo "✅ .env file already exists"
fi

# Build Docker images
echo "🔨 Building Docker images..."
docker-compose build

# Start services
echo "🎯 Starting services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Initialize database
echo "💾 Initializing database..."
docker-compose exec -T postgres pg_isready -U admin

echo ""
echo "✅ Setup complete!"
echo ""
echo "Services are running at:"
echo "  - Backend API: http://localhost:3000"
echo "  - Kong Admin: http://localhost:8001"
echo "  - PostgreSQL: localhost:5432"
echo "  - Redis: localhost:6379"
echo "  - RabbitMQ: http://localhost:15672"
echo "  - Elasticsearch: http://localhost:9200"
echo "  - Kibana: http://localhost:5601"
echo ""
echo "📚 Documentation:"
echo "  - Architecture: docs/ARCHITECTURE.md"
echo "  - API: docs/API.md"
echo "  - Database: docs/DATABASE.md"
echo "  - AI: docs/AI_GUIDANCE.md"
echo "  - Deployment: docs/DEPLOYMENT.md"
