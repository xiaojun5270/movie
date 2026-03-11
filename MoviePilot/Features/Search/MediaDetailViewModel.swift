import Foundation

@MainActor
final class MediaDetailViewModel: ObservableObject {
 @Published private(set) var detail: MediaDetail?
 @Published private(set) var isLoading = false
 @Published var errorMessage: String?

 private let api: MoviePilotAPI
 private let mediaID: Int

 init(api: MoviePilotAPI, mediaID: Int) {
 self.api = api
 self.mediaID = mediaID
 }

 func loadIfNeeded() async {
 guard detail == nil, !isLoading else { return }
 await reload()
 }

 func reload() async {
 isLoading = true
 errorMessage = nil
 defer { isLoading = false }

 do {
 detail = try await api.mediaDetail(id: mediaID)
 } catch {
 errorMessage = error.displayMessage
 }
 }
}
