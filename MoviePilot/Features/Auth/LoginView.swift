import SwiftUI

struct LoginView: View {
 @EnvironmentObject private var session: AppSession
 @StateObject private var viewModel = LoginViewModel()
 @FocusState private var focusedField: Field?

 private enum Field {
 case serverURL
 case username
 case password
 }

 var body: some View {
 NavigationStack {
 Form {
 Section("连接") {
 TextField(AppConfig.defaultDevelopmentServerURL, text: $viewModel.serverURL)
 .keyboardType(.URL)
 .textInputAutocapitalization(.never)
 .autocorrectionDisabled()
 .focused($focusedField, equals: .serverURL)

 TextField("用户名", text: $viewModel.username)
 .textInputAutocapitalization(.never)
 .autocorrectionDisabled()
 .focused($focusedField, equals: .username)

 SecureField("密码", text: $viewModel.password)
 .focused($focusedField, equals: .password)
 }

 Section {
 Button {
 Task { await viewModel.login(using: session) }
 } label: {
 if viewModel.isLoading {
 ProgressView()
 .frame(maxWidth: .infinity)
 } else {
 Text("登录 MoviePilot")
 .frame(maxWidth: .infinity)
 }
 }
 .disabled(viewModel.isLoading)
 } footer: {
 Text("开发联调可优先使用 `\(AppConfig.defaultDevelopmentServerURL)`，首版默认适配 `\(AppConfig.apiPathPrefix)` 接口。")
 }
 }
 .navigationTitle("MoviePilot")
 .task {
 viewModel.prepare(using: session)
 }
 .alert("登录失败", isPresented: Binding(
 get: { viewModel.errorMessage != nil },
 set: { if !$0 { viewModel.errorMessage = nil } }
 )) {
 Button("知道了", role: .cancel) { viewModel.errorMessage = nil }
 } message: {
 Text(viewModel.errorMessage ?? "")
 }
 }
 }
}
