import Foundation

@MainActor
final class SubscribeListViewModel: ObservableObject {
 @Published var items: [SubscribeItem] = []
 @Published var isLoading = false
 @Published var errorMessage: String?

 func load(using api: MoviePilotAPI?) async {
 guard let api else { return }
 isLoading = true
 defer { isLoading = false }

 do {
 items = try await api.listSubscribes()
 } catch {
 errorMessage = error.displayMessage
 }
 }

 func delete(id: Int, using api: MoviePilotAPI?) async {
 guard let api else { return }
 do {
 _ = try await api.deleteSubscribe(id: id)
 items.removeAll { $0.id == id }
 } catch {
 errorMessage = error.displayMessage
 }
 }
}
