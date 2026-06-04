# Campus Navigation API 文档

## 基础信息

- **Base URL**: `https://api.campus-nav.local`
- **API版本**: v1
- **认证方式**: JWT Token
- **Content-Type**: `application/json`

## 认证

所有需要认证的API请求需在请求头中包含JWT Token：

```bash
Authorization: Bearer <token>
```

## 错误处理

标准错误响应格式：

```json
{
  "code": "ERROR_CODE",
  "message": "Error message",
  "details": {}
}
```

## API端点

### 认证相关

#### 用户注册

```bash
POST /auth/register

Request:
{
  "username": "user123",
  "email": "user@example.com",
  "password": "SecurePass123"
}

Response:
{
  "user_id": "user_123",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

#### 用户登录

```bash
POST /auth/login

Request:
{
  "email": "user@example.com",
  "password": "SecurePass123"
}

Response:
{
  "user_id": "user_123",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "...",
  "expires_in": 3600
}
```

### 位置相关

#### 获取附近位置

```bash
GET /map/locations/nearby?lat=39.905&lng=116.407&radius=500&type=restaurant

Query Parameters:
- lat: 纬度 (required)
- lng: 经度 (required)
- radius: 搜索半径（米），默认500
- type: 位置类型（可选）
- limit: 返回数量，默认10

Response:
{
  "data": [
    {
      "id": "loc_001",
      "name": "学生食堂",
      "type": "restaurant",
      "location": {"lat": 39.905, "lng": 116.407},
      "distance": 150,
      "rating": 4.5,
      "opening_hours": "07:00-21:00"
    }
  ],
  "count": 10
}
```

#### 搜索位置

```bash
GET /map/locations/search?q=图书馆&type=library

Query Parameters:
- q: 搜索关键词
- type: 位置类型
- limit: 返回数量

Response:
{
  "data": [...],
  "count": 5
}
```

#### 获取位置详情

```bash
GET /map/locations/{location_id}

Response:
{
  "id": "loc_001",
  "name": "中央图书馆",
  "type": "library",
  "description": "校园中央图书馆",
  "location": {"lat": 39.905, "lng": 116.407},
  "address": "学府路1号",
  "opening_hours": {
    "Monday": "08:00-22:00",
    "Tuesday": "08:00-22:00",
    "Wednesday": "08:00-22:00",
    "Thursday": "08:00-22:00",
    "Friday": "08:00-22:00",
    "Saturday": "10:00-20:00",
    "Sunday": "10:00-20:00"
  },
  "amenities": ["wifi", "toilet", "parking", "reading_room"],
  "accessibility": ["wheelchair", "ramp"],
  "contact_info": {
    "phone": "010-12345678",
    "email": "library@campus.edu"
  },
  "rating": 4.8,
  "reviews_count": 150
}
```

### 路线相关

#### 规划路线

```bash
POST /map/routes/plan

Request:
{
  "start_location_id": "loc_001",
  "end_location_id": "loc_002",
  "route_type": "fastest",
  "preferences": {
    "avoid_stairs": false,
    "avoid_crowds": false,
    "avoid_areas": []
  }
}

Response:
{
  "routes": [
    {
      "id": "route_001",
      "type": "fastest",
      "distance": 1250,
      "estimated_time": 900,
      "difficulty": "easy",
      "waypoints": [
        {"lat": 39.905, "lng": 116.407},
        {"lat": 39.915, "lng": 116.417}
      ],
      "steps": [
        {
          "step_number": 1,
          "instruction": "向前走50米",
          "direction": "straight",
          "distance": 50
        }
      ]
    }
  ]
}
```

#### 获取实时导航指令

```bash
GET /map/routes/{route_id}/navigation?current_lat=39.905&current_lng=116.407

Response:
{
  "current_step": 1,
  "instruction": "向前走50米，然后左转",
  "distance_to_next": 50,
  "next_instruction": "左转进入教学楼",
  "progress_percentage": 5,
  "eta_seconds": 850,
  "navigation_audio_url": "https://..."
}
```

### AI导航相关

#### 发送聊天消息

```bash
POST /ai/chat

Request:
{
  "message": "我要去图书馆",
  "context": {
    "current_location": {"lat": 39.905, "lng": 116.407},
    "current_time": "2024-01-15T10:30:00Z"
  }
}

Response:
{
  "intent": "navigate",
  "destination": "中央图书馆",
  "response_text": "我为您规划了去中央图书馆的最快路线，预计需要15分钟",
  "route": {
    "id": "route_123",
    "distance": 1250,
    "estimated_time": 900
  },
  "suggestions": [
    {
      "type": "action",
      "text": "开始导航",
      "action": "start_navigation"
    }
  ],
  "response_audio_url": "https://..."
}
```

#### 语音导航

```bash
POST /ai/navigation/voice
Content-Type: audio/wav

[Binary audio data]

Response:
{
  "text": "我要去图书馆",
  "intent": "navigate",
  "route": {...},
  "navigation_audio": "https://..."
}
```

### 用户相关

#### 获取用户信息

```bash
GET /users/profile

Response:
{
  "id": "user_123",
  "username": "user123",
  "email": "user@example.com",
  "avatar_url": "https://...",
  "preferences": {
    "language": "zh-CN",
    "theme": "dark"
  }
}
```

#### 获取收藏列表

```bash
GET /users/profile/favorites?limit=10&offset=0

Response:
{
  "data": [
    {
      "id": "fav_001",
      "location_id": "loc_001",
      "location_name": "中央图书馆",
      "saved_name": "我常去的图书馆",
      "created_at": "2024-01-10T10:00:00Z"
    }
  ],
  "count": 1
}
```

#### 添加收藏

```bash
POST /users/profile/favorites

Request:
{
  "location_id": "loc_001",
  "saved_name": "我常去的图书馆"
}

Response:
{
  "id": "fav_001",
  "location_id": "loc_001",
  "saved_name": "我常去的图书馆",
  "created_at": "2024-01-15T10:30:00Z"
}
```

## 响应状态码

- `200 OK` - 请求成功
- `201 Created` - 资源创建成功
- `400 Bad Request` - 请求参数错误
- `401 Unauthorized` - 未授权/认证失败
- `403 Forbidden` - 禁止访问
- `404 Not Found` - 资源不存在
- `429 Too Many Requests` - 请求过于频繁
- `500 Internal Server Error` - 服务器错误

## 速率限制

- 普通用户: 1000 requests/hour
- 高级用户: 5000 requests/hour
- 企业用户: 无限制
