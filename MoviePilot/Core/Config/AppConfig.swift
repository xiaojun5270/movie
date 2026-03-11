import Foundation

enum AppConfig {
 static let appName = "MoviePilot"
 static let tokenKey = "moviepilot.token"
 static let serverURLKey = "moviepilot.serverURL"
 static let usernameKey = "moviepilot.username"
 static let apiPathPrefix = "/api/v1"
 static let defaultDevelopmentServerURL = "http://127.0.0.1:3001"
}

extension String {
 var normalizedServerURL: String {
 var value = trimmingCharacters(in: .whitespacesAndNewlines)
 while value.hasSuffix("/") {
 value.removeLast()
 }
 return value
 }
}
