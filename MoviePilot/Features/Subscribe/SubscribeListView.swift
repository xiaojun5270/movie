import SwiftUI

struct SubscribeListView: View {
 @EnvironmentObject private var session: AppSession
 @StateObject private var viewModel = SubscribeListViewModel()

 var body: some View {
 List {
 ForEach(viewModel.items) { item in
 VStack(alignment: .leading, spacing:8) {
 Text(item.name ?? "未命名订阅")
 .font(.headline)
 HStack(spacing:10) {
 Text(item.type ?? "未知类型")
 if let year = item.year, !year.isEmpty {
 Text(year)
 }
 if let season = item.season, season > 0 {
 Text("S\(season)")
 }
 }
 .font(.subheadline)
 .foregroundStyle(.secondary)

 HStack(spacing:12) {
 Label("总集 \(item.totalEpisode ?? 0)", systemImage: "square.stack.3d.up")
 Label("缺失 \(item.lackEpisode ?? 0)", systemImage: "exclamationmark.circle")
 Label(item.state ?? "-", systemImage: "waveform.path.ecg")
 }
 .font(.footnote)
 .foregroundStyle(.secondary)
 }
 .padding(.vertical,4)
 .swipeActions(edge: .trailing, allowsFullSwipe: false) {
 Button(role: .destructive) {
 Task { await viewModel.delete(id: item.id, using: session.api) }
 } label: {
 Label("删除", systemImage: "trash")
 }
 }
 }

 if viewModel.items.isEmpty && !viewModel.isLoading {
 ContentUnavailableView("暂无订阅", systemImage: "bookmark.slash", description: Text("下个阶段补新增/编辑订阅能力。"))
 }
 }
 .navigationTitle("订阅")
 .overlay {
 if viewModel.isLoading {
 ProgressView("加载订阅中…")
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
