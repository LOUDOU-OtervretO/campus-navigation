# Campus Navigation Application

一个智能校园导航应用，集地图导航、路线规划和智能指导于一体。

## 🎯 项目概述

该应用提供以下核心功能：
- 📍 实时定位与地图显示
- 🚶‍♂️ 智能路线规划
- 🤖 AI语音导航
- 📚 校园信息查询
- 🔔 事件提醒与推荐
- 👥 社交分享功能

## 📱 技术栈

### 前端
- **跨平台框架**: React Native / Flutter
- **地图服务**: Mapbox / Amap API
- **状态管理**: Redux / MobX
- **UI框架**: React Native Paper / Material Design

### 后端
- **服务框架**: Node.js (Express) / Python (Django)
- **数据库**: PostgreSQL + PostGIS (地理数据)
- **缓存**: Redis
- **AI服务**: OpenAI / 本地LLM

### 基础设施
- **API网关**: Kong
- **容器化**: Docker
- **部署**: Kubernetes / Docker Compose

## 📂 项目结构

```
campus-navigation/
├── frontend/              # 前端应用
├── backend/              # 后端服务
├── ai-guidance/          # AI智能指导模块
├── infrastructure/       # 基础设施配置
├── docs/                 # 文档
├── scripts/              # 辅助脚本
└── docker-compose.yml    # Docker编排
```

## 🚀 快速开始

### 环境需求
- Node.js >= 16.0
- Python >= 3.9
- Docker & Docker Compose
- Git

### 本地开发

```bash
# 克隆项目
git clone https://github.com/LOUDOU-OtervretO/campus-navigation.git
cd campus-navigation

# 启动开发环境
docker-compose -f docker-compose.dev.yml up

# 前端开发
cd frontend && npm install && npm start

# 后端开发
cd backend && npm install && npm run dev
```

## 📖 详细文档

- [架构设计](./docs/ARCHITECTURE.md)
- [API文档](./docs/API.md)
- [数据库设计](./docs/DATABASE.md)
- [AI模块设计](./docs/AI_GUIDANCE.md)
- [部署指南](./docs/DEPLOYMENT.md)

## 🎨 功能特性

### 🗺️ 地图导航
- 实时GPS定位
- 校园地图展示
- POI标注
- 多种路线选项 (最短、最快、最美)

### 🤖 AI智能指导
- 自然语言对话
- 语音输入/输出
- 上下文理解
- 个性化推荐

### 📍 路线规划
- 多算法路线计算
- 实时路况更新
- 障碍物绕行
- 用户偏好学习

### 🔍 智能搜索
- 校园设施搜索
- 课程查询
- 事件发现
- 历史记录

### 📊 数据分析
- 热点区域分析
- 拥挤度预测
- 用户行为分析
- 路线优化建议

## 🔐 安全性

- JWT Token认证
- OAuth 2.0支持
- 位置数据加密
- GDPR合规
- 隐私保护设计

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 开发流程

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 代码规范

- 遵循ESLint / Pylint规范
- TypeScript严格模式
- 单元测试覆盖率>80%
- Git提交信息规范

## 📝 许可证

MIT License

## 👥 团队

- **项目负责人**: LOUDOU-OtervretO
## 📞 联系方式：18938282426

- 📧 Email: support@campus-nav.local
- 💬 Issues: [GitHub Issues](https://github.com/LOUDOU-OtervretO/campus-navigation/issues)
- 📱 微信公众号: [待补充]

## 🙏 致谢

感谢所有贡献者和用户的支持！

---

**⭐ 如果这个项目对您有帮助，请给个Star！**
