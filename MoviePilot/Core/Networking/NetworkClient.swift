import Foundation

final class NetworkClient {
 private let baseURL: String
 private let token: String?
 private let session: URLSession
 private let decoder: JSONDecoder

 init(baseURL: String, token: String?, session: URLSession = .shared) {
 self.baseURL = baseURL.normalizedServerURL
 self.token = token
 self.session = session
 self.decoder = JSONDecoder()
 self.decoder.keyDecodingStrategy = .convertFromSnakeCase
 }

 func send<T: Decodable>(_ requestSpec: RequestSpec, as type: T.Type) async throws -> T {
 let request = try buildRequest(from: requestSpec)

 do {
 let (data, response) = try await session.data(for: request)
 guard let httpResponse = response as? HTTPURLResponse else {
 throw APIError.invalidResponse
 }

 if httpResponse.statusCode == 401 {
 throw APIError.unauthorized
 }

 guard (200...299).contains(httpResponse.statusCode) else {
 if let envelope = try? decoder.decode(APIEnvelope<EmptyPayload>.self, from: data),
 let message = envelope.message,
 !message.isEmpty {
 throw APIError.server(message)
 }
 let raw = String(data: data, encoding: .utf8) ?? "HTTP \(httpResponse.statusCode)"
 throw APIError.server(raw)
 }

 do {
 return try decoder.decode(type, from: data)
 } catch {
 let raw = String(data: data, encoding: .utf8) ?? error.localizedDescription
 throw APIError.decoding(raw)
 }
 } catch let error as APIError {
 throw error
 } catch {
 throw APIError.network(error.localizedDescription)
 }
 }

 private func buildRequest(from spec: RequestSpec) throws -> URLRequest {
 guard var components = URLComponents(string: baseURL + spec.path) else {
 throw APIError.invalidURL
 }
 if !spec.queryItems.isEmpty {
 components.queryItems = spec.queryItems
 }
 guard let url = components.url else {
 throw APIError.invalidURL
 }

 var request = URLRequest(url: url)
 request.httpMethod = spec.method.rawValue
 request.timeoutInterval = 30
 request.httpBody = spec.body

 var headers = spec.headers
 if let token, !token.isEmpty {
 headers["Authorization"] = "Bearer \(token)"
 }
 headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
 return request
 }
}
