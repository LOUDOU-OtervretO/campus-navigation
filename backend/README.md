# Campus Navigation Backend

## 技术栈

- **框架**: Node.js/Express 或 Python/Django
- **数据库**: PostgreSQL + PostGIS
- **缓存**: Redis
- **消息队列**: RabbitMQ
- **搜索引擎**: Elasticsearch

## 项目结构

```
backend/
├── src/
│   ├── services/
│   │   ├── auth-service/          # 认证服务
│   │   ├── user-service/          # 用户服务
│   │   ├── map-service/           # 地图与路线服务
│   │   ├── ai-guidance-service/   # AI指导服务
│   │   ├── search-service/        # 搜索服务
│   │   └── notification-service/  # 通知服务
│   ├── database/                  # 数据库配置
│   ├── middlewares/               # 中间件
│   ├── utils/                     # 工具函数
│   └── server.ts/py               # 主入口
├── migrations/                    # 数据库迁移
├── tests/                         # 测试
├── docker-compose.yml
└── package.json / requirements.txt
```

## 微服务架构

### 认证服务 (auth-service)

```bash
POST /auth/register          # 用户注册
POST /auth/login             # 用户登录
POST /auth/refresh-token     # 刷新令牌
GET  /auth/verify            # 验证令牌
```

### 用户服务 (user-service)

```bash
GET    /users/:id            # 获取用户信息
PUT    /users/:id            # 更新用户信息
GET    /users/:id/favorites  # 获取收藏
POST   /users/:id/favorites  # 添加收藏
```

### 地图与路线服务 (map-service)

```bash
GET    /map/locations        # 获取位置列表
GET    /map/locations/:id    # 获取位置详情
POST   /map/routes           # 规划路线
GET    /map/routes/:id       # 获取路线详情
GET    /map/directions       # 获取导航指令
```

### AI指导服务 (ai-guidance-service)

```bash
POST   /ai/chat              # AI对话
POST   /ai/navigation        # 语音导航
GET    /ai/suggestions       # 获取建议
POST   /ai/voice             # 语音识别与合成
```

## 安装与运行

### 安装依赖

```bash
npm install
# 或
pip install -r requirements.txt
```

### 启动开发服务器

```bash
npm run dev
# 或
python manage.py runserver
```

### 运行测试

```bash
npm test
# 或
pytest
```

### Docker部署

```bash
# 构建镜像
docker build -t campus-nav-backend .

# 启动容器
docker run -p 3000:3000 campus-nav-backend
```

## 环境配置

创建 `.env` 文件：

```bash
DATABASE_URL=postgresql://user:password@localhost:5432/campus_nav
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_secret_key
AI_API_KEY=your_ai_api_key
MAPBOX_TOKEN=your_mapbox_token
```

## API文档

详见 [docs/API.md](../docs/API.md)

## 数据库设计

详见 [docs/DATABASE.md](../docs/DATABASE.md)
