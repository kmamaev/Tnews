import Foundation

enum APIRequestResult<Value> {
    case success(Value)
    case failure(Error)
}

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case mappingError
    case emptyData
}

protocol Mappable {
    init?(json: [String: Any])
}

class APIRequestManager {
    fileprivate let urlSession: URLSession
    fileprivate let baseURL: URL

    init(baseURL: URL) {
        let configuration = URLSessionConfiguration.default

        self.urlSession = URLSession(configuration: configuration)
        self.baseURL = baseURL
    }
}

extension APIRequestManager {
    func performRequest<ResponseType: Mappable>(withContext requestContext: APIRequestContext,
        completion: @escaping (APIRequestResult<ResponseType>) -> ())
    {
        let urlRequest = buildURLRequest(withContext: requestContext)

        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            let result: APIRequestResult<ResponseType>
            if let error = error {
                result = .failure(error)
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                        let jsonDictionary = json as? [String: Any],
                        let value = ResponseType(json: jsonDictionary) {
                        result = .success(value)
                    } else {
                        result = .failure(APIError.mappingError)
                    }
                } else {
                    result = .failure(APIError.emptyData)
                }
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }

        dataTask.resume()
    }

    func performRequest<ResponseType: Mappable>(withContext requestContext: APIRequestContext,
        completion: @escaping (APIRequestResult<[ResponseType]>) -> ())
    {
        let urlRequest = buildURLRequest(withContext: requestContext)

        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            let result: APIRequestResult<[ResponseType]>
            if let error = error {
                result = .failure(error)
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                        let jsonArray = json as? [[String: Any]] {
                        var value: [ResponseType] = []
                        var mappingError: Error? = nil
                        for jsonItem in jsonArray {
                            if let item = ResponseType(json: jsonItem) {
                                value.append(item)
                            } else {
                                mappingError = APIError.mappingError
                                break
                            }
                        }
                        if let mappingError = mappingError {
                            result = .failure(mappingError)
                        } else {
                            result = .success(value)
                        }
                    } else {
                        result = .failure(APIError.mappingError)
                    }
                } else {
                    result = .failure(APIError.emptyData)
                }
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }

        dataTask.resume()
    }
}

private extension APIRequestManager {
    func buildURLRequest(withContext requestContext: APIRequestContext) -> URLRequest {
        var url = baseURL
        if let method = requestContext.apiMethod {
            url.appendPathComponent(method)
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = requestContext.queryItems

        var request = URLRequest(url: urlComponents.url!)
        request.httpBody = requestContext.httpBody
        request.httpMethod = requestContext.httpMethod.rawValue

        return request
    }
}
