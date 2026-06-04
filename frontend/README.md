# Campus Navigation Frontend

## 技术栈

- **跨平台框架**: React Native / Flutter
- **地图服务**: Mapbox GL Native / Amap SDK
- **状态管理**: Redux / MobX
- **导航**: React Navigation / GetX
- **UI框架**: React Native Paper / Material Design

## 项目结构

```
frontend/
├── src/
│   ├── screens/              # 屏幕组件
│   │   ├── MapScreen.tsx
│   │   ├── NavigationScreen.tsx
│   │   ├── SearchScreen.tsx
│   │   ├── ChatScreen.tsx
│   │   └── UserScreen.tsx
│   ├── components/           # 可复用组件
│   │   ├── MapComponent.tsx
│   │   ├── RouteCard.tsx
│   │   ├── ChatBubble.tsx
│   │   └── LocationPin.tsx
│   ├── redux/                # 状态管理
│   │   ├── slices/
│   │   ├── actions/
│   │   └── store.ts
│   ├── services/             # API服务
│   │   ├── api.ts
│   │   ├── mapService.ts
│   │   ├── aiService.ts
│   │   └── locationService.ts
│   ├── utils/                # 工具函数
│   ├── types/                # TypeScript类型
│   └── App.tsx               # 入口文件
├── package.json
├── tsconfig.json
└── README.md
```

## 核心功能模块

### 1. 地图模块 (MapScreen)

- 显示校园地图
- 实时定位
- POI标注
- 路线显示

### 2. 导航模块 (NavigationScreen)

- 路线规划
- 分步导航
- 语音导航
- 实时路况

### 3. 搜索模块 (SearchScreen)

- 位置搜索
- 设施筛选
- 搜索历史
- 热门地点

### 4. AI聊天模块 (ChatScreen)

- 文本对话
- 语音输入/输出
- 对话历史
- 快速建议

### 5. 用户模块 (UserScreen)

- 用户认证
- 个人信息
- 收藏夹
- 设置

## 安装与运行

### 安装依赖

```bash
npm install
```

### 运行iOS版本

```bash
npx react-native run-ios
```

### 运行Android版本

```bash
npx react-native run-android
```

### 使用Expo

```bash
npx expo start
```

## 开发指南

详见 [DEVELOPMENT.md](./DEVELOPMENT.md)

## 贡献指南

欢迎提交Pull Request和Issue！
