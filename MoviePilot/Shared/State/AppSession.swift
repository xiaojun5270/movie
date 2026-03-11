import Foundation

@MainActor
final class AppSession: ObservableObject {
 typealias APIFactory = (String, String?) -> MoviePilotAPI

 @Published var serverURL: String
 @Published var currentUser: CurrentUser?
 @Published var lastError: String?
 @Published private(set) var isBootstrapping = false

 private let keychain: KeychainStore
 private let defaults: UserDefaults
 private let apiFactory: APIFactory
 private(set) var token: String?

 init(
 defaults: UserDefaults = .standard,
 keychain: KeychainStore = KeychainStore(),
 apiFactory: @escaping APIFactory = { baseURL, token in
 MoviePilotAPI(baseURL: baseURL, token: token)
 }
 ) {
 self.defaults = defaults
 self.keychain = keychain
 self.apiFactory = apiFactory
 self.serverURL = defaults.string(forKey: AppConfig.serverURLKey) ?? ""
 self.token = keychain.readString(for: AppConfig.tokenKey)
 }

 var isAuthenticated: Bool {
 let url = serverURL.normalizedServerURL
 return !url.isEmpty && !(token ?? "").isEmpty
 }

 var api: MoviePilotAPI? {
 guard let token, !serverURL.normalizedServerURL.isEmpty else { return nil }
 return apiFactory(serverURL.normalizedServerURL, token)
 }

 func bootstrap() async {
 guard !isBootstrapping else { return }
 guard isAuthenticated, currentUser == nil else { return }
 isBootstrapping = true
 defer { isBootstrapping = false }

 do {
 currentUser = try await api?.currentUser()
 } catch {
 logout(keepServer: true)
 lastError = error.displayMessage
 }
 }

 func login(serverURL: String, username: String, password: String) async throws {
 let normalized = serverURL.normalizedServerURL
 let authAPI = apiFactory(normalized, nil)
 let authToken = try await authAPI.login(username: username, password: password)

 let authedAPI = apiFactory(normalized, authToken.accessToken)
 let user = try await authedAPI.currentUser()

 self.serverURL = normalized
 self.token = authToken.accessToken
 self.currentUser = user
 self.lastError = nil
 defaults.set(normalized, forKey: AppConfig.serverURLKey)
 defaults.set(username, forKey: AppConfig.usernameKey)
 keychain.save(authToken.accessToken, for: AppConfig.tokenKey)
 }

 func logout(keepServer: Bool = true) {
 token = nil
 currentUser = nil
 lastError = nil
 keychain.deleteValue(for: AppConfig.tokenKey)
 if !keepServer {
 serverURL = ""
 defaults.removeObject(forKey: AppConfig.serverURLKey)
 }
 }

 var rememberedUsername: String {
 defaults.string(forKey: AppConfig.usernameKey) ?? ""
 }
}
