import SwiftUI

struct DashboardView: View {
 @EnvironmentObject private var session: AppSession
 @StateObject private var viewModel = DashboardViewModel()

 var body: some View {
 ScrollView {
 VStack(alignment: .leading, spacing:16) {
 if let user = session.currentUser {
 VStack(alignment: .leading, spacing:6) {
 Text("你好，\(user.name)")
 .font(.title.bold())
 Text(session.serverURL)
 .font(.footnote)
 .foregroundStyle(.secondary)
 }
 }

 LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing:12) {
 MetricCardView(title: "电影", value: "\(viewModel.statistic.movieCount ??0)", icon: "film", tint: .blue)
 MetricCardView(title: "剧集", value: "\(viewModel.statistic.tvCount ??0)", icon: "tv", tint: .purple)
 MetricCardView(title: "集数", value: "\(viewModel.statistic.episodeCount ??0)", icon: "list.number", tint: .orange)
 MetricCardView(title: "用户", value: "\(viewModel.statistic.userCount ??0)", icon: "person.2", tint: .green)
 }

 GroupBox("存储") {
 VStack(alignment: .leading, spacing:12) {
 ProgressView(value: viewModel.storage.usageRatio)
 HStack {
 Text("已用")
 Spacer()
 Text(Self.bytesString(viewModel.storage.usedStorage))
 }
 HStack {
 Text("总量")
 Spacer()
 Text(Self.bytesString(viewModel.storage.totalStorage))
 }
 }
 .font(.subheadline)
 }

 GroupBox("下载器") {
 VStack(alignment: .leading, spacing:10) {
 row("下载速度", value: Self.speedString(viewModel.downloader.downloadSpeed))
 row("上传速度", value: Self.speedString(viewModel.downloader.uploadSpeed))
 row("累计下载", value: Self.bytesString(viewModel.downloader.downloadSize))
 row("累计上传", value: Self.bytesString(viewModel.downloader.uploadSize))
 row("剩余空间", value: Self.bytesString(viewModel.downloader.freeSpace))
 }
 .font(.subheadline)
 }
 }
 .padding()
 }
 .overlay {
 if viewModel.isLoading {
 ProgressView("加载中…")
 }
 }
 .navigationTitle("概览")
 .refreshable {
 await viewModel.load(using: session.api)
 }
 .task {
 await viewModel.load(using: session.api)
 }
 .alert("加载失败", isPresented: Binding(
 get: { viewModel.errorMessage != nil },
 set: { if !$0 { viewModel.errorMessage = nil } }
 )) {
 Button("知道了", role: .cancel) { viewModel.errorMessage = nil }
 } message: {
 Text(viewModel.errorMessage ?? "")
 }
 }

 @ViewBuilder
 private func row(_ title: String, value: String) -> some View {
 HStack {
 Text(title)
 Spacer()
 Text(value)
 .foregroundStyle(.secondary)
 }
 }

 private static func bytesString(_ value: Double?) -> String {
 let formatter = ByteCountFormatter()
 formatter.allowedUnits = [.useGB, .useMB, .useTB]
 formatter.countStyle = .binary
 return formatter.string(fromByteCount: Int64(value ?? 0))
 }

 private static func speedString(_ value: Double?) -> String {
 "\(bytesString(value))/s"
 }
}
