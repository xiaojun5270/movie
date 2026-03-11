# Project Summary

## project.yml
1: name: MoviePilot
15: targets:
18:     platform: iOS
19:     deploymentTarget: "16.0"
20:     sources:
21:       - path: MoviePilot
25:       path: MoviePilot/Support/Info.plist
35:       testTargets:
38:   MoviePilotTests:

## README.md
1: # MoviePilot iOS
2: 
3: 自用版 MoviePilot iOS 客户端骨架，面向内网 / 自签安装场景。
4: 
5: ## 当前已落地
6: 
7: - SwiftUI 应用骨架
8: - 登录鉴权（`/api/v1/login/access-token`）
9: - 启动时自动恢复登录态
10: - 仪表盘（媒体统计 / 存储 / 下载器概览）
11: - 订阅列表
12: - 下载列表
13: - 下载任务基础操作（开始 / 暂停 / 删除）
14: - 订阅删除
15: - 媒体搜索与详情页
16: - GitHub Actions 无证书构建 unsigned IPA
17: - 本地 Keychain 保存 Token
16: 
17: ## 技术栈
18: 
19: - SwiftUI
20: - async/await
21: - XcodeGen
22: - 无第三方依赖（首版先压复杂度）
23: 
24: ## 目录结构
25: 
26: ```text
27: moviepilot-ios/
28: ├── .github/workflows/ios-unsigned.yml
29: ├── project.yml
30: └── MoviePilot/
31:     ├── App/
32:     ├── Core/
33:     ├── Features/
34:     ├── Shared/
35:     └── Support/
36: ```
37: 
38: ## 运行方式
39: 
40: ### 本地生成 Xcode 工程
50: ### 对接官方 MoviePilot 开发环境
64: `DEVELOPMENT.md`
48: ### 运行单元测试

## MoviePilot/App/AppView.swift
3: struct AppView: View {
6: var body: some View {
9: MainTabView()
30: private struct MainTabView: View {
33: var body: some View {
34: TabView {
35: NavigationStack {
37: .toolbar {
49: NavigationStack {
56: NavigationStack {
63: NavigationStack {

## MoviePilot/App/MoviePilotApp.swift
3: @main
4: struct MoviePilotApp: App {
7: var body: some Scene {

## MoviePilot/Core/Networking/MoviePilotAPI.swift
3: struct APIEnvelope<T: Decodable>: Decodable {
9: struct EmptyPayload: Codable {}
11: struct DashboardSnapshot {
24: func login(username: String, password: String) async throws -> AuthToken {
41: func currentUser() async throws -> CurrentUser {
45: func dashboardSnapshot() async throws -> DashboardSnapshot {
56: func listSubscribes() async throws -> [SubscribeItem] {
61: func deleteSubscribe(id: Int) async throws -> APIEnvelope<EmptyPayload> {
65: func listDownloads() async throws -> [DownloadItem] {
70: func startDownload(hash: String) async throws -> APIEnvelope<EmptyPayload> {
75: func stopDownload(hash: String) async throws -> APIEnvelope<EmptyPayload> {
80: func deleteDownload(hash: String) async throws -> APIEnvelope<EmptyPayload> {

## MoviePilot/Core/Networking/NetworkClient.swift
17: func send<T: Decodable>(_ requestSpec: RequestSpec, as type: T.Type) async throws -> T {

## MoviePilot/Core/Config/AppConfig.swift
3: enum AppConfig {
7: static let apiPathPrefix = "/api/v1"
8: static let defaultDevelopmentServerURL = "http://127.0.0.1:3001"

## DEVELOPMENT.md
1: # MoviePilot 开发对接说明
5: ## 官方开发基线
13: ## iOS 客户端对接约定

## MoviePilot/Shared/State/AppSession.swift
3: @MainActor
29: func bootstrap() async {
43: func login(serverURL: String, username: String, password: String) async throws {
59: func logout(keepServer: Bool = true) {

## MoviePilot/Features/Auth/LoginView.swift
3: struct LoginView: View {
9: case serverURL
10: case username
11: case password
14: var body: some View {
15: NavigationStack {

## MoviePilot/Features/Auth/LoginViewModel.swift
3: @MainActor
11: func prepare(using session: AppSession) {
20: func login(using session: AppSession) async {

## MoviePilot/Features/Dashboard/DashboardView.swift
3: struct DashboardView: View {
7: var body: some View {

## MoviePilot/Features/Dashboard/DashboardViewModel.swift
3: @MainActor
11: func load(using api: MoviePilotAPI?) async {

## MoviePilot/Features/Subscribe/SubscribeListView.swift
3: struct SubscribeListView: View {
7: var body: some View {

## MoviePilot/Features/Subscribe/SubscribeListViewModel.swift
3: @MainActor
9: func load(using api: MoviePilotAPI?) async {
21: func delete(id: Int, using api: MoviePilotAPI?) async {

## MoviePilot/Features/Download/DownloadListView.swift
3: struct DownloadListView: View {
7: var body: some View {

## MoviePilot/Features/Download/DownloadListViewModel.swift
3: @MainActor
5: enum Action {
6: case start
7: case stop
8: case delete
15: func load(using api: MoviePilotAPI?) async {
27: func perform(_ action: Action, hash: String, using api: MoviePilotAPI?) async {
31: case .start:
33: case .stop:
35: case .delete:

## MoviePilot/Features/Settings/SettingsView.swift
3: struct SettingsView: View {
6: var body: some View {

## Model Files
### AuthModels.swift
3: struct AuthToken: Codable {
13: struct CurrentUser: Codable, Identifiable {
### DashboardModels.swift
3: struct DashboardStatistic: Codable {
10: struct StorageInfo: Codable {
20: struct DownloaderInfo: Codable {
### DownloadModels.swift
3: struct DownloadItem: Codable, Identifiable {
### SubscribeModels.swift
3: struct SubscribeItem: Codable, Identifiable {
