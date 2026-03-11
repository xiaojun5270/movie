# MoviePilot iOS

自用版 MoviePilot iOS 客户端骨架，面向内网 / 自签安装场景。

## 当前已落地

- SwiftUI 应用骨架
- 登录鉴权（`/api/v1/login/access-token`）
- 启动时自动恢复登录态
- 仪表盘（媒体统计 / 存储 / 下载器概览）
- 订阅列表
- 下载列表
- 下载任务基础操作（开始 / 暂停 / 删除）
- 订阅删除
- 媒体搜索与详情页
- GitHub Actions 无证书构建 unsigned IPA
- 本地 Keychain 保存 Token

## 技术栈

- SwiftUI
- async/await
- XcodeGen
- 无第三方依赖（首版先压复杂度）

## 目录结构

```text
moviepilot-ios/
├── .github/workflows/ios-unsigned.yml
├── project.yml
└── MoviePilot/
    ├── App/
    ├── Core/
    ├── Features/
    ├── Shared/
    └── Support/
```

## 运行方式

### 本地生成 Xcode 工程

```bash
brew install xcodegen
cd moviepilot-ios
xcodegen generate
open MoviePilot.xcodeproj
```

### 对接官方 MoviePilot 开发环境

- 后端开发基线：按官方文档使用 `Python 3.12`
- 前端开发基线：按官方文档使用 `Node 20.12.1`
- 后端本地默认端口：`3001`
- 前端开发默认端口：`5173`
- 本地 API 文档：`http://localhost:3001/docs`

当前 iOS 客户端开发默认按官方后端 API 服务对接：

- 模拟器联调：`http://127.0.0.1:3001`
- 真机联调：`http://你的 Mac 局域网 IP:3001`
- 当前接口前缀：`/api/v1`
- 测试环境已覆盖网络层请求构造与官方登录路径校验

更完整的官方联调说明见 `DEVELOPMENT.md`。

### 运行单元测试

生成工程后，可在 Xcode 中运行 `MoviePilotTests`，当前已覆盖：

- 服务器地址规范化
- 存储占用比例计算
- 媒体搜索响应解码
- 媒体模型计算属性
- 统一错误文案
- 网络层请求构造与 MoviePilot API 基础路径
- 会话恢复、登录持久化与登出流程
- 弱类型接口字段的兼容解码
- 媒体搜索/详情字段的容错解码

### GitHub Actions 无证书打包

工作流会：

1. 安装 XcodeGen
2. 生成 `MoviePilot.xcodeproj`
3. 使用 `CODE_SIGNING_ALLOWED=NO` 构建 `iphoneos` Release
4. 将 `.app` 封装为 `unsigned.ipa`
5. 上传构建产物

## 后续自签安装

可用以下任一方式：

- Xcode
- Sideloadly
- AltStore
- 其他本地重签工具

## 说明

- 当前 `Info.plist` 对自用场景放宽了 ATS，便于内网 / HTTP / 自签证书接入
- 如果后续要转为更正式分发，再收紧网络策略
- 当前环境未安装 Xcode，代码已按可继续开发/生成工程的方向落地，编译校验需在 macOS + Xcode 环境完成
- 当前仓库中的开发默认值已按官方文档对齐到本地 API 服务 `3001` 端口

## 下一阶段建议

- 新增订阅创建/编辑
- 新增设置页中的服务器健康检查
- 加入日志 / 消息 SSE 能力
- 增加 API / Session 级测试、UI 组件与错误提示完善
