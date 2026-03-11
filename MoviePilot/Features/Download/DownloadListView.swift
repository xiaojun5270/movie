import SwiftUI

struct DownloadListView: View {
 @EnvironmentObject private var session: AppSession
 @StateObject private var viewModel = DownloadListViewModel()

 var body: some View {
 List {
 ForEach(viewModel.items) { item in
 VStack(alignment: .leading, spacing:8) {
 Text(item.title ?? item.name ?? "未命名任务")
 .font(.headline)
 HStack(spacing:10) {
 Text(item.state ?? "-")
 if let progress = item.progress {
 Text(String(format: "%.1f%%", progress))
 }
 if let leftTime = item.leftTime, !leftTime.isEmpty {
 Text(leftTime)
 }
 }
 .font(.subheadline)
 .foregroundStyle(.secondary)

 if let progress = item.progress {
 ProgressView(value: min(max(progress /100.0,0),1))
 }

 HStack(spacing:12) {
 Label(item.dlspeed ?? "-", systemImage: "arrow.down")
 Label(item.upspeed ?? "-", systemImage: "arrow.up")
 Text(item.downloader ?? "未知下载器")
 }
 .font(.footnote)
 .foregroundStyle(.secondary)
 }
 .padding(.vertical,4)
 .swipeActions(edge: .trailing, allowsFullSwipe: false) {
 if let hash = item.hash {
 Button(role: .destructive) {
 Task { await viewModel.perform(.delete, hash: hash, using: session.api) }
 } label: {
 Label("删除", systemImage: "trash")
 }

 Button {
 Task { await viewModel.perform(.stop, hash: hash, using: session.api) }
 } label: {
 Label("暂停", systemImage: "pause")
 }
 .tint(.orange)

 Button {
 Task { await viewModel.perform(.start, hash: hash, using: session.api) }
 } label: {
 Label("开始", systemImage: "play")
 }
 .tint(.green)
 }
 }
 }

 if viewModel.items.isEmpty && !viewModel.isLoading {
 ContentUnavailableView("暂无下载任务", systemImage: "tray", description: Text("下个阶段补新增下载和搜索能力。"))
 }
 }
 .navigationTitle("下载")
 .overlay {
 if viewModel.isLoading {
 ProgressView("加载下载任务中…")
 }
 }
 .refreshable {
 await viewModel.load(using: session.api)
 }
 .task {
 await viewModel.load(using: session.api)
 }
 .alert("操作失败", isPresented: Binding(
 get: { viewModel.errorMessage != nil },
 set: { if !$0 { viewModel.errorMessage = nil } }
 )) {
 Button("知道了", role: .cancel) { viewModel.errorMessage = nil }
 } message: {
 Text(viewModel.errorMessage ?? "")
 }
 }
}
