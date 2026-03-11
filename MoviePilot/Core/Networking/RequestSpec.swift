import Foundation

enum HTTPMethod: String {
 case GET
 case POST
 case PUT
 case DELETE
}

struct RequestSpec {
 let path: String
 var method: HTTPMethod = .GET
 var queryItems: [URLQueryItem] = []
 var headers: [String: String] = [:]
 var body: Data? = nil
}
