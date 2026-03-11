# MoviePilot 开发对接说明

本文档用于把当前 iOS 客户端开发方式对齐到官方 MoviePilot 文档和官方仓库的开发基线。

官方参考来源：

- 官方文档主页：`https://wiki.movie-pilot.org/`
- 官方仓库：`https://github.com/jxxghp/MoviePilot`
- 官方仓库 README：`https://github.com/jxxghp/MoviePilot/blob/main/README.md`

## 官方开发基线

- 后端：`Python 3.12`
- 前端：`Node 20.12.1`
- 后端本地服务：`http://localhost:3001`
- 前端开发服务：`http://localhost:5173`
- 后端 API 文档：`http://localhost:3001/docs`

## iOS 客户端对接约定

当前 iOS 仓库按“直连后端 API”方式开发，而不是连接前端页面服务。

- 登录页默认开发地址：`http://127.0.0.1:3001`
- API 前缀：`/api/v1`
- 登录接口：`/api/v1/login/access-token`

## 联调方式

### iOS 模拟器

如果 MoviePilot 后端运行在同一台 Mac 上，直接使用：

`http://127.0.0.1:3001`

### iPhone 真机

如果使用真机调试，请改成运行后端那台 Mac 的局域网 IP，例如：

`http://192.168.1.10:3001`

## 推荐联调流程

1. 按官方文档启动 MoviePilot 后端开发环境
2. 打开 `http://localhost:3001/docs` 确认 API 可访问
3. 生成当前 iOS 工程并启动 App
4. 在登录页填入后端地址进行联调
5. 优先验证登录、仪表盘、订阅、下载、搜索和详情链路

## 当前仓库已对齐的点

- 登录页 Debug 默认值指向 `http://127.0.0.1:3001`
- 客户端默认按 `/api/v1` 前缀组装接口
- README 已补充官方开发环境对接说明

## 仍需继续对齐的方向

- 用官方 API 文档逐项校验搜索、详情、订阅和下载接口字段
- 继续增加 `AppSession` 与网络层的可注入测试
- 视官方文档演进收敛 ATS 与错误处理策略
