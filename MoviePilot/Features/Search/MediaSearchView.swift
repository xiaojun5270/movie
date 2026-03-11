import SwiftUI

struct MediaSearchView: View {
 @StateObject private var viewModel: MediaSearchViewModel
 private let api: MoviePilotAPI

 init(api: MoviePilotAPI) {
 self.api = api
 _viewModel = StateObject(wrappedValue: MediaSearchViewModel(api: api))
 }

 var body: some View {
 NavigationStack {
 Group {
 if viewModel.isLoading && viewModel.items.isEmpty {
 ProgressView("搜索中…")
 .frame(maxWidth: .infinity, maxHeight: .infinity)
 } else if let errorMessage = viewModel.errorMessage, viewModel.items.isEmpty {
 ContentUnavailableView("搜索失败", systemImage: "exclamationmark.triangle", description: Text(errorMessage))
 } else if viewModel.hasSearched && viewModel.items.isEmpty {
 ContentUnavailableView("未找到结果", systemImage: "magnifyingglass", description: Text("换个关键词试试"))
 } else {
 List(viewModel.items, id: \.stableID) { item in
 NavigationLink {
 if (item.id ?? item.tmdbId ?? 0) > 0 {
 MediaDetailView(api: api, item: item)
 } else {
 MediaFallbackDetailView(item: item)
 }
 } label: {
 VStack(alignment: .leading, spacing: 6) {
 Text(item.displayTitle)
 .font(.headline)

 if !item.subtitleLine.isEmpty {
 Text(item.subtitleLine)
 .font(.subheadline)
 .foregroundStyle(.secondary)
 }

 if let overview = item.overview, !overview.isEmpty {
 Text(overview)
 .font(.footnote)
 .foregroundStyle(.secondary)
 .lineLimit(2)
 }
 }
 .padding(.vertical, 4)
 }
 }
 .listStyle(.plain)
 }
 }
 .navigationTitle("媒体搜索")
 .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "输入电影 / 剧集 / 动漫")
 .toolbar {
 ToolbarItem(placement: .topBarTrailing) {
 Button("搜索") {
 Task { await viewModel.search() }
 }
 .disabled(viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
 }
 }
 .onSubmit(of: .search) {
 Task { await viewModel.search() }
 }
 }

}

private struct MediaFallbackDetailView: View {
 let item: MediaItem

 var body: some View {
 ScrollView {
 VStack(alignment: .leading, spacing: 16) {
 Text(item.displayTitle)
 .font(.title2.bold())

 HStack(spacing: 8) {
 badge(item.mediaKind)
 if !item.yearText.isEmpty { badge(item.yearText) }
 if let rating = item.ratingText { badge("评分 \(rating)") }
 }

 if let overview = item.overview, !overview.isEmpty {
 VStack(alignment: .leading, spacing: 6) {
 Text("简介")
 .font(.headline)
 Text(overview)
 .foregroundStyle(.secondary)
 }
 }

 if let tmdbId = item.tmdbId {
 infoRow("TMDB", String(tmdbId))
 }
 if let doubanId = item.doubanId, !doubanId.isEmpty {
 infoRow("豆瓣", doubanId)
 }
 if let imdbId = item.imdbId, !imdbId.isEmpty {
 infoRow("IMDb", imdbId)
 }
 }
 .padding()
 }
 .navigationTitle("媒体详情")
 .navigationBarTitleDisplayMode(.inline)
 }

 private func infoRow(_ title: String, _ value: String) -> some View {
 VStack(alignment: .leading, spacing: 4) {
 Text(title)
 .font(.caption)
 .foregroundStyle(.secondary)
 Text(value)
 }
 .frame(maxWidth: .infinity, alignment: .leading)
 }

 private func badge(_ text: String) -> some View {
 Text(text)
 .font(.caption)
 .padding(.horizontal, 10)
 .padding(.vertical, 6)
 .background(Color.accentColor.opacity(0.12))
 .clipShape(Capsule())
 }
}
