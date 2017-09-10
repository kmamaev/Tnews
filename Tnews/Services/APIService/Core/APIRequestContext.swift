import Foundation

struct APIRequestContext {
    var apiMethod: String?
    var httpMethod: HTTPRequestMethod = .get
    var httpBody: Data?
    var queryItems: [URLQueryItem]?
}
