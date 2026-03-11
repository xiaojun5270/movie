import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
 @Published var serverURL: String = ""
 @Published var username: String = ""
 @Published var password: String = ""
 @Published var isLoading = false
 @Published var errorMessage: String?

 func prepare(using session: AppSession) {
 if serverURL.isEmpty {
 serverURL = session.serverURL
 #if DEBUG
 if serverURL.isEmpty {
 serverURL = AppConfig.defaultDevelopmentServerURL
 }
 #endif
 }
 if username.isEmpty {
 username = session.rememberedUsername
 }
 }

 func login(using session: AppSession) async {
 guard !serverURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
 errorMessage = "先填服务器地址"
 return
 }
 guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
 errorMessage = "先填用户名"
 return
 }
 guard !password.isEmpty else {
 errorMessage = "先填密码"
 return
 }

 isLoading = true
 defer { isLoading = false }

 do {
 try await session.login(serverURL: serverURL, username: username, password: password)
 password = ""
 } catch {
 errorMessage = error.displayMessage
 }
 }
}
