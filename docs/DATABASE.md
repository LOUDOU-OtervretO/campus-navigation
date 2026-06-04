# 数据库设计

## 概述

使用 PostgreSQL + PostGIS 扩展来处理地理空间数据。

## 核心表结构

### 1. 用户表 (users)

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    avatar_url TEXT,
    bio TEXT,
    preferences JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);
```

### 2. 位置表 (locations)

```sql
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    type VARCHAR(50),  -- 'building', 'restaurant', 'library', etc.
    location GEOMETRY(Point, 4326),  -- PostGIS地理坐标
    address VARCHAR(300),
    opening_hours JSONB,  -- {"Monday": "08:00-22:00", ...}
    contact_info JSONB,   -- {"phone": "...", "email": "..."}
    amenities TEXT[],     -- ['wifi', 'toilet', 'parking']
    accessibility TEXT[],  -- ['wheelchair', 'ramp']
    image_url TEXT,
    rating DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_location_geom ON locations USING GIST (location)
);
```

### 3. 路线表 (routes)

```sql
CREATE TABLE routes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    start_location_id INTEGER REFERENCES locations(id),
    end_location_id INTEGER REFERENCES locations(id),
    route_type VARCHAR(20),  -- 'shortest', 'fastest', 'scenic'
    route_geometry GEOMETRY(LineString, 4326),
    distance DECIMAL(10,2),  -- 米
    estimated_time INTEGER,  -- 秒
    difficulty VARCHAR(20),  -- 'easy', 'moderate', 'hard'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_route_geom ON routes USING GIST (route_geometry)
);
```

### 4. 导航步骤表 (navigation_steps)

```sql
CREATE TABLE navigation_steps (
    id SERIAL PRIMARY KEY,
    route_id INTEGER REFERENCES routes(id),
    step_number INTEGER,
    instruction TEXT NOT NULL,
    instruction_audio BYTEA,  -- 语音指令
    location GEOMETRY(Point, 4326),
    distance DECIMAL(10,2),  -- 从上一步的距离
    direction VARCHAR(20),  -- 'straight', 'left', 'right', 'u-turn'
    poi_reference VARCHAR(200),  -- 参考POI："在XXX的左边"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. 用户收藏表 (user_favorites)

```sql
CREATE TABLE user_favorites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    location_id INTEGER REFERENCES locations(id),
    saved_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, location_id)
);
```

### 6. 聊天记录表 (chat_messages)

```sql
CREATE TABLE chat_messages (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    message_text TEXT NOT NULL,
    message_type VARCHAR(20),  -- 'text', 'voice', 'location'
    ai_response TEXT,
    intent VARCHAR(50),  -- 'navigate', 'search', 'info', etc.
    entities JSONB,  -- 提取的实体信息
    metadata JSONB,   -- 额外数据
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_time ON chat_messages(user_id, created_at DESC)
);
```

### 7. 用户轨迹表 (user_trajectories)

```sql
CREATE TABLE user_trajectories (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    location GEOMETRY(Point, 4326),
    timestamp TIMESTAMP,
    accuracy DECIMAL(10,2),  -- 定位精度（米）
    speed DECIMAL(10,2),     -- 速度（m/s）
    
    INDEX idx_trajectory_user_time ON user_trajectories(user_id, timestamp DESC),
    INDEX idx_trajectory_geom ON user_trajectories USING GIST (location)
);
```

### 8. 事件表 (events)

```sql
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    location_id INTEGER REFERENCES locations(id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    event_type VARCHAR(50),  -- 'lecture', 'activity', 'class'
    capacity INTEGER,
    registered_count INTEGER DEFAULT 0,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_events_time ON events(start_time)
);
```

## PostGIS查询示例

### 找附近的位置

```sql
-- 找距离当前位置1km以内的食堂
SELECT id, name, location, 
       ST_Distance(location, ST_GeomFromText('POINT(116.407 39.905)', 4326)::geography) as distance
FROM locations
WHERE type = 'restaurant'
  AND ST_DWithin(location, ST_GeomFromText('POINT(116.407 39.905)', 4326)::geography, 1000)
ORDER BY distance
LIMIT 10;
```

### 计算两点间距离

```sql
SELECT ST_Distance(
    ST_GeomFromText('POINT(116.407 39.905)', 4326)::geography,
    ST_GeomFromText('POINT(116.417 39.915)', 4326)::geography
) as distance_meters;
```

### 检查点是否在多边形内

```sql
SELECT * FROM locations
WHERE ST_Contains(
    ST_GeomFromText('POLYGON((...))', 4326),
    location
);
```

## 性能优化

```sql
-- 创建空间索引
CREATE INDEX idx_locations_geom ON locations USING GIST (location);
CREATE INDEX idx_routes_geom ON routes USING GIST (route_geometry);

-- 创建B-tree索引
CREATE INDEX idx_locations_type ON locations(type);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_chat_user_time ON chat_messages(user_id, created_at DESC);

-- 分析表
ANALYZE locations;
ANALYZE routes;
```

## 备份策略

```bash
# 完整备份
pg_dump -h localhost -U admin campus_navigation > backup.sql

# 恢复备份
psql -h localhost -U admin campus_navigation < backup.sql

# 增量备份
pg_dump -h localhost -U admin --data-only campus_navigation > data_backup.sql
```
