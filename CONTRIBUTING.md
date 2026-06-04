# 贡献指南

感谢您对Campus Navigation的贡献！

## 如何贡献

### 1. Fork 项目

点击GitHub上的 "Fork" 按钮来创建项目的副��。

### 2. 创建特性分支

```bash
git checkout -b feature/AmazingFeature
```

### 3. 提交更改

```bash
git commit -m 'Add some AmazingFeature'
```

### 4. 推送到分支

```bash
git push origin feature/AmazingFeature
```

### 5. 开启 Pull Request

在GitHub上创建Pull Request，说明您的更改。

## 代码规范

### JavaScript/TypeScript

- 使用 ESLint 进行代码检查
- 遵循 Prettier 代码格式化规范
- 使用 TypeScript 严格模式
- 单元测试覆盖率应 > 80%

### Python

- 使用 Pylint 进行代码检查
- 遵循 PEP 8 规范
- 使用类型提示
- 单元测试覆盖率应 > 80%

### Git 提交信息规范

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Type

- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码风格调整
- `refactor`: 代码重构
- `test`: 添加测试
- `chore`: 构建过程或辅助工具的变动

#### Scope

更改影响的范围（可选）

#### Subject

简洁的描述更改

#### Body

详细的描述（可选）

#### Footer

Breaking changes 或相关issue（可选）

### 示例

```
feat(navigation): add voice guidance support

Implement voice recognition and synthesis for navigation instructions.
Support Chinese and English languages.

Closes #123
```

## 报告Bug

### Bug报告应包含

- 清晰的标题和描述
- 重现步骤
- 实际行为
- 预期行为
- 截图或视频（如适用）
- 您的环境信息

## 功能请求

- 清晰的标题和描述
- 用例说明
- 可能的实现方式
- 相关的设计或原型

## Pull Request 检查清单

- [ ] 代码遵循项目的代码规范
- [ ] 已添加单元测试
- [ ] 所有测试通过
- [ ] 已更新相关文档
- [ ] 提交信息遵循规范
- [ ] 没有引入新的警告
- [ ] 更改向后兼容

## 许可

通过贡献，您同意您的贡献将在MIT许可下发布。
