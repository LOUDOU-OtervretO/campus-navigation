# 部署指南

## 环境准备

### 系统要求

- OS: Ubuntu 20.04 LTS 或更高版本
- CPU: 4核心
- 内存: 8GB
- 磁盘: 50GB

### 依赖安装

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 安装Git
sudo apt install -y git
```

## 部署步骤

### 1. 克隆项目

```bash
cd /opt
sudo git clone https://github.com/LOUDOU-OtervretO/campus-navigation.git
cd campus-navigation
```

### 2. 环境配置

```bash
# 创建.env文件
cp .env.example .env

# 编辑环境变量
sudo vi .env
```

环境变量示例：

```bash
# 数据库
DATABASE_URL=postgresql://admin:secure_password@postgres:5432/campus_navigation
DATABASE_POOL_SIZE=10

# Redis
REDIS_URL=redis://redis:6379
REDIS_PASSWORD=redis_password

# 认证
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRATION=3600

# API密钥
MAPBOX_TOKEN=your_mapbox_token
AI_API_KEY=your_ai_api_key

# 邮件配置
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_email_password

# 应用配置
NODE_ENV=production
DEBUG=false
LOG_LEVEL=info
```

### 3. 启动服务

```bash
# 启动所有服务
docker-compose -f docker-compose.yml up -d

# 检查服务状态
docker-compose ps

# 查看日志
docker-compose logs -f backend
```

### 4. 数据库初始化

```bash
# 运行数据库迁移
docker-compose exec backend npm run migrate:latest

# 初始化种子数据
docker-compose exec backend npm run seed:campus-locations
```

### 5. 反向代理配置 (Nginx)

创建 `/etc/nginx/sites-available/campus-nav`：

```nginx
upstream backend {
    server localhost:3000;
}

upstream kong {
    server localhost:8000;
}

server {
    listen 80;
    server_name api.campus-nav.local;

    # 重定向到HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.campus-nav.local;

    # SSL证书配置
    ssl_certificate /etc/letsencrypt/live/api.campus-nav.local/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.campus-nav.local/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # 日志
    access_log /var/log/nginx/campus-nav-access.log;
    error_log /var/log/nginx/campus-nav-error.log;

    # CORS头
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization' always;

    location /api {
        proxy_pass http://kong;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location / {
        root /var/www/campus-nav-frontend;
        try_files $uri $uri/ /index.html;
    }
}
```

启用网站：

```bash
sudo ln -s /etc/nginx/sites-available/campus-nav /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 6. SSL证书配置

```bash
# 使用Let's Encrypt获取免费SSL证书
sudo apt install certbot python3-certbot-nginx

sudo certbot certonly --nginx -d api.campus-nav.local

# 自动续期
sudo systemctl enable certbot.timer
```

## 监控与维护

### 监控工具

```bash
# 查看容器日志
docker-compose logs -f backend

# 查看容器资源使用情况
docker stats

# 进入容器
docker-compose exec backend sh
```

### 备份策略

```bash
# 每天备份数据库
0 2 * * * docker-compose exec postgres pg_dump -U admin campus_navigation > /backups/campus_nav_$(date +\%Y\%m\%d).sql
```

### 日志管理

配置日志轮转 (`/etc/logrotate.d/campus-nav`)：

```
/var/log/nginx/campus-nav*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data www-data
    sharedscripts
    postrotate
        if [ -f /var/run/nginx.pid ]; then
            kill -USR1 `cat /var/run/nginx.pid`
        fi
    endscript
}
```

## 故障排查

### 常见问题

#### 1. 数据库连接失败

```bash
# 检查PostgreSQL状态
docker-compose logs postgres

# 测试连接
docker-compose exec postgres psql -U admin -d campus_navigation
```

#### 2. API响应缓慢

```bash
# 检查Redis缓存
docker-compose exec redis redis-cli INFO stats

# 清除缓存
docker-compose exec redis redis-cli FLUSHALL
```

#### 3. 磁盘空间不足

```bash
# 查看磁盘使用
df -h

# 清理Docker
docker system prune -a

# 查看日志大小
du -sh /var/log/
```

## 升级与更新

```bash
# 拉取最新代码
git pull origin main

# 构建新镜像
docker-compose build

# 升级服务（无停机升级）
docker-compose up -d

# 运行数据库迁移
docker-compose exec backend npm run migrate:latest
```
