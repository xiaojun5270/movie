import SwiftUI

struct MediaDetailView: View {
 @StateObject private var viewModel: MediaDetailViewModel
 private let item: MediaItem

 init(api: MoviePilotAPI, item: MediaItem) {
 self.item = item
 _viewModel = StateObject(wrappedValue: MediaDetailViewModel(api: api, mediaID: item.id ?? item.tmdbId ?? 0))
 }

 var body: some View {
 ScrollView {
 VStack(alignment: .leading, spacing: 16) {
 header

 if viewModel.isLoading {
 ProgressView("加载详情中…")
 .frame(maxWidth: .infinity, alignment: .center)
 } else if let detail = viewModel.detail {
 detailContent(detail)
 } else if let errorMessage = viewModel.errorMessage {
 UnavailableStateView(title: "详情加载失败", systemImage: "exclamationmark.triangle", description: errorMessage)
 } else {
 UnavailableStateView(title: "暂无详情", systemImage: "film")
 }
 }
 .padding()
 }
 .navigationTitle(item.displayTitle)
 .navigationBarTitleDisplayMode(.inline)
 .task {
 guard (item.id ?? item.tmdbId ?? 0) > 0 else { return }
 await viewModel.loadIfNeeded()
 }
 }

 private var header: some View {
 VStack(alignment: .leading, spacing: 8) {
 Text(item.displayTitle)
 .font(.title2.bold())

 HStack(spacing: 8) {
 badge(item.mediaKind)
 if !item.yearText.isEmpty { badge(item.yearText) }
 if let rating = item.ratingText { badge("评分 \(rating)") }
 }

 if let overview = item.overview, !overview.isEmpty {
 Text(overview)
 .font(.body)
 .foregroundStyle(.secondary)
 }
 }
 .frame(maxWidth: .infinity, alignment: .leading)
 }

 @ViewBuilder
 private func detailContent(_ detail: MediaDetail) -> some View {
 VStack(alignment: .leading, spacing: 12) {
 infoRow("类型", detail.mediaKind)
 if !detail.yearText.isEmpty { infoRow("年份", detail.yearText) }
 if let rating = detail.ratingText { infoRow("评分", rating) }
 if let tmdbId = detail.tmdbId { infoRow("TMDB", String(tmdbId)) }
 if let doubanId = detail.doubanId, !doubanId.isEmpty { infoRow("豆瓣", doubanId) }
 if let imdbId = detail.imdbId, !imdbId.isEmpty { infoRow("IMDb", imdbId) }
 if let season = detail.season { infoRow("季数", String(season)) }
 if let episodes = detail.episodes { infoRow("集数", String(episodes)) }
 if let genres = detail.genres, !genres.isEmpty { infoRow("题材", genres.joined(separator: " / ")) }
 if let countries = detail.countries, !countries.isEmpty { infoRow("地区", countries.joined(separator: " / ")) }
 if let directors = detail.directors, !directors.isEmpty { infoRow("导演", directors.joined(separator: " / ")) }
 if let actors = detail.actors, !actors.isEmpty { infoRow("演员", actors.joined(separator: " / ")) }

 if let overview = detail.overview, !overview.isEmpty {
 VStack(alignment: .leading, spacing: 6) {
 Text("简介")
 .font(.headline)
 Text(overview)
 .foregroundStyle(.secondary)
 }
 .padding(.top, 8)
 }
 }
 .frame(maxWidth: .infinity, alignment: .leading)
 }

 private func infoRow(_ title: String, _ value: String) -> some View {
 VStack(alignment: .leading, spacing: 4) {
 Text(title)
 .font(.caption)
 .foregroundStyle(.secondary)
 Text(value)
 .font(.body)
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
