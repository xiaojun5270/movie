import Foundation

@MainActor
final class MediaSearchViewModel: ObservableObject {
 @Published var query = ""
 @Published private(set) var items: [MediaItem] = []
 @Published private(set) var isLoading = false
 @Published var errorMessage: String?
 @Published var hasSearched = false

 private let api: MoviePilotAPI

 init(api: MoviePilotAPI) {
 self.api = api
 }

 func search() async {
 let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines)
 guard !keyword.isEmpty else {
 items = []
 errorMessage = nil
 hasSearched = false
 return
 }

 isLoading = true
 errorMessage = nil
 defer { isLoading = false }

 do {
 items = try await api.searchMedia(keyword: keyword)
 hasSearched = true
 } catch {
 items = []
 hasSearched = true
 errorMessage = error.displayMessage
 }
 }
}
