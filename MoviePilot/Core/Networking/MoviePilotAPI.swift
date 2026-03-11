import Foundation

struct APIEnvelope<T: Decodable>: Decodable {
 let success: Bool
 let message: String?
 let data: T?
}

struct EmptyPayload: Codable {}

struct DashboardSnapshot {
 let statistic: DashboardStatistic
 let storage: StorageInfo
 let downloader: DownloaderInfo
}

class MoviePilotAPI {
 private let client: NetworkClient
 private let apiPrefix = AppConfig.apiPathPrefix

 init(baseURL: String, token: String?) {
 self.client = NetworkClient(baseURL: baseURL, token: token)
 }

 init(client: NetworkClient) {
 self.client = client
 }

 func login(username: String, password: String) async throws -> AuthToken {
 let body = [
 URLQueryItem(name: "username", value: username),
 URLQueryItem(name: "password", value: password)
 ]
 .map { "\($0.name)=\(($0.value ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
 .joined(separator: "&")

 let spec = RequestSpec(
 path: path("/login/access-token"),
 method: .POST,
 headers: ["Content-Type": "application/x-www-form-urlencoded"],
 body: body.data(using: .utf8)
 )
 return try await client.send(spec, as: AuthToken.self)
 }

 func currentUser() async throws -> CurrentUser {
 try await client.send(RequestSpec(path: path("/user/current")), as: CurrentUser.self)
 }

 func dashboardSnapshot() async throws -> DashboardSnapshot {
 async let statistic = client.send(RequestSpec(path: path("/dashboard/statistic")), as: DashboardStatistic.self)
 async let storage = client.send(RequestSpec(path: path("/dashboard/storage")), as: StorageInfo.self)
 async let downloader = client.send(RequestSpec(path: path("/dashboard/downloader")), as: DownloaderInfo.self)
 return try await DashboardSnapshot(
 statistic: statistic,
 storage: storage,
 downloader: downloader
 )
 }

 func listSubscribes() async throws -> [SubscribeItem] {
 try await client.send(RequestSpec(path: path("/subscribe/")), as: [SubscribeItem].self)
 }

 @discardableResult
 func deleteSubscribe(id: Int) async throws -> APIEnvelope<EmptyPayload> {
 try await client.send(RequestSpec(path: path("/subscribe/\(id)"), method: .DELETE), as: APIEnvelope<EmptyPayload>.self)
 }

 func listDownloads() async throws -> [DownloadItem] {
 try await client.send(RequestSpec(path: path("/download/")), as: [DownloadItem].self)
 }

 func searchMedia(keyword: String, page: Int = 1) async throws -> [MediaItem] {
 let candidates: [RequestSpec] = [
 RequestSpec(
 path: path("/media/search"),
 queryItems: [
 URLQueryItem(name: "keyword", value: keyword),
 URLQueryItem(name: "page", value: String(page))
 ]
 ),
 RequestSpec(
 path: path("/search/media"),
 queryItems: [
 URLQueryItem(name: "keyword", value: keyword),
 URLQueryItem(name: "page", value: String(page))
 ]
 ),
 RequestSpec(
 path: path("/media"),
 queryItems: [
 URLQueryItem(name: "keyword", value: keyword),
 URLQueryItem(name: "page", value: String(page))
 ]
 )
 ]

 var lastError: Error?

 for spec in candidates {
 do {
 if let envelope = try? await client.send(spec, as: APIEnvelope<[MediaItem]>.self), let data = envelope.data {
 return data
 }
 if let response = try? await client.send(spec, as: MediaSearchResponse.self) {
 return response.items
 }
 return try await client.send(spec, as: [MediaItem].self)
 } catch {
 lastError = error
 continue
 }
 }

 if let lastError {
 throw APIError.server(lastError.displayMessage)
 }
 throw APIError.server("未找到可用的媒体搜索接口")
 }

 func mediaDetail(id: Int) async throws -> MediaDetail {
 let candidates: [RequestSpec] = [
 RequestSpec(path: path("/media/\(id)")),
 RequestSpec(path: path("/media/detail/\(id)")),
 RequestSpec(path: path("/medias/\(id)"))
 ]

 var lastError: Error?

 for spec in candidates {
 do {
 if let envelope = try? await client.send(spec, as: APIEnvelope<MediaDetail>.self), let data = envelope.data {
 return data
 }
 return try await client.send(spec, as: MediaDetail.self)
 } catch {
 lastError = error
 continue
 }
 }

 if let lastError {
 throw APIError.server(lastError.displayMessage)
 }
 throw APIError.server("未找到可用的媒体详情接口")
 }

 @discardableResult
 func startDownload(hash: String) async throws -> APIEnvelope<EmptyPayload> {
 try await client.send(RequestSpec(path: path("/download/start/\(hash)")), as: APIEnvelope<EmptyPayload>.self)
 }

 @discardableResult
 func stopDownload(hash: String) async throws -> APIEnvelope<EmptyPayload> {
 try await client.send(RequestSpec(path: path("/download/stop/\(hash)")), as: APIEnvelope<EmptyPayload>.self)
 }

 @discardableResult
 func deleteDownload(hash: String) async throws -> APIEnvelope<EmptyPayload> {
 try await client.send(RequestSpec(path: path("/download/\(hash)"), method: .DELETE), as: APIEnvelope<EmptyPayload>.self)
 }

 private func path(_ suffix: String) -> String {
 "\(apiPrefix)\(suffix)"
 }
}
