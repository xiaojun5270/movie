import Foundation

@MainActor
final class DownloadListViewModel: ObservableObject {
 enum Action {
 case start
 case stop
 case delete
 }

 @Published var items: [DownloadItem] = []
 @Published var isLoading = false
 @Published var errorMessage: String?

 func load(using api: MoviePilotAPI?) async {
 guard let api else { return }
 isLoading = true
 defer { isLoading = false }

 do {
 items = try await api.listDownloads()
 } catch {
 errorMessage = error.displayMessage
 }
 }

 func perform(_ action: Action, hash: String, using api: MoviePilotAPI?) async {
 guard let api else { return }
 do {
 switch action {
 case .start:
 _ = try await api.startDownload(hash: hash)
 case .stop:
 _ = try await api.stopDownload(hash: hash)
 case .delete:
 _ = try await api.deleteDownload(hash: hash)
 }
 await load(using: api)
 } catch {
 errorMessage = error.displayMessage
 }
 }
}
