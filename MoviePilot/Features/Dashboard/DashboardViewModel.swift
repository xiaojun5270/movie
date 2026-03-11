import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
 @Published var statistic = DashboardStatistic(movieCount:0, tvCount:0, episodeCount:0, userCount:0)
 @Published var storage = StorageInfo(totalStorage:0, usedStorage:0)
 @Published var downloader = DownloaderInfo(downloadSpeed:0, uploadSpeed:0, downloadSize:0, uploadSize:0, freeSpace:0)
 @Published var isLoading = false
 @Published var errorMessage: String?

 func load(using api: MoviePilotAPI?) async {
 guard let api else { return }
 isLoading = true
 defer { isLoading = false }

 do {
 let snapshot = try await api.dashboardSnapshot()
 statistic = snapshot.statistic
 storage = snapshot.storage
 downloader = snapshot.downloader
 } catch {
 errorMessage = error.displayMessage
 }
 }
}
