# 书库软件 (PDF阅读)

一款基于Web的书籍管理软件，支持本地存储和云存储同步，内置PDF阅读器。

## 功能特性

- 📚 **书籍管理**：导入、分类、标签管理
- ☁️ **云存储同步**：支持WebDAV服务
- 🔍 **书籍搜索**：本地搜索功能
- 📖 **内置阅读器**：支持PDF格式阅读
- 📱 **响应式设计**：适配桌面端和移动端
- 💾 **本地存储**：使用IndexedDB存储数据

## 技术栈

- **前端框架**：React + TypeScript
- **构建工具**：Vite
- **样式方案**：Tailwind CSS
- **本地存储**：IndexedDB (Dexie.js)
- **PDF阅读**：PDF.js
- **HTTP客户端**：Axios

## 部署方案

### 1. GitHub Pages部署

本项目配置了GitHub Actions自动部署流程，只需按照以下步骤操作：

1. **Fork本仓库**到你的GitHub账户
2. **开启GitHub Pages**：
   - 进入仓库设置 → Pages
   - 选择 `gh-pages` 分支作为源
   - 点击保存
3. **推送代码**到 `main` 分支
   - GitHub Actions会自动构建并部署到GitHub Pages
   - 部署完成后，访问 `https://<your-username>.github.io/<repository-name>` 即可

### 2. 其他静态网站托管服务

也可以部署到其他静态网站托管服务，如Vercel、Netlify等：

1. **构建项目**：
   ```bash
   npm install
   npm run build
   ```
2. **部署构建产物**：
   - 上传 `dist` 目录到你的托管服务
   - 按照托管服务的指引完成部署

### 3. 本地运行

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 预览生产构建
npm run preview
```

## 使用指南

### 导入书籍
1. 点击导航栏的「导入」按钮
2. 选择「从本地导入」
3. 选择PDF等格式的书籍文件
4. 系统会自动提取书籍信息并保存到本地

### 阅读书籍
1. 在书库页面点击书籍封面
2. 进入阅读器页面，支持翻页、查看页码
3. 阅读进度会自动保存

### 搜索书籍
1. 点击导航栏的「搜索」按钮
2. 输入书名、作者或ISBN进行搜索
3. 搜索结果会实时显示

### 云存储设置
1. 点击导航栏的「设置」按钮
2. 在「云存储服务」部分添加WebDAV服务
3. 输入服务名称、URL、用户名和密码
4. 保存后即可使用云存储功能

## 项目结构

```
pdfyuedu/
├── src/
│   ├── components/    # 组件目录
│   ├── pages/         # 页面目录
│   │   ├── LibraryPage.tsx     # 书库页面
│   │   ├── ImportPage.tsx      # 导入页面
│   │   ├── SearchPage.tsx      # 搜索页面
│   │   ├── SettingsPage.tsx    # 设置页面
│   │   └── ReaderPage.tsx      # 阅读器页面
│   ├── services/      # 服务目录
│   │   ├── databaseService.ts     # 数据库服务
│   │   ├── cloudStorageService.ts # 云存储服务
│   │   ├── bookInfoService.ts     # 书籍信息服务
│   │   └── readerService.ts       # 阅读器服务
│   ├── types/         # 类型定义
│   └── utils/         # 工具函数
├── dist/              # 构建产物
├── .github/           # GitHub Actions配置
└── package.json       # 项目配置
```

## 注意事项

- 本项目使用浏览器的IndexedDB存储数据，数据仅存储在本地浏览器中
- 云存储功能目前仅支持WebDAV协议
- 阅读器仅支持PDF格式，其他格式（如EPUB、MOBI）仅作为文件存储，无法直接阅读
- 由于浏览器安全限制，本地文件导入使用URL.createObjectURL，刷新页面后需要重新导入

## 许可证

MIT License
