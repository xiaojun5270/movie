import Foundation

enum APIError: LocalizedError {
 case invalidURL
 case invalidResponse
 case unauthorized
 case server(String)
 case network(String)
 case decoding(String)

 var errorDescription: String? {
 switch self {
 case .invalidURL:
 return "服务器地址无效"
 case .invalidResponse:
 return "服务器返回了无效响应"
 case .unauthorized:
 return "登录已失效或账号密码错误"
 case .server(let message):
 return message
 case .network(let message):
 return message
 case .decoding(let message):
 return "数据解析失败：\(message)"
 }
 }
}

extension Error {
 var displayMessage: String {
 (self as? LocalizedError)?.errorDescription ?? localizedDescription
 }
}
