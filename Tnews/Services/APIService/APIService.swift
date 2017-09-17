import Foundation

private enum Constants {
    static let baseURLString = "https://api.tinkoff.ru"
    static let apiVersion = 1
}

class APIService {
    let requestManager: APIRequestManager

    init() {
        let baseURL = URL(string: "\(Constants.baseURLString)")!.appendingPathComponent("v\(Constants.apiVersion)")
        requestManager = APIRequestManager(baseURL: baseURL)
    }
}

// MARK: - API Requests

extension APIService {
    func fetchNews(completion: @escaping (APIRequestResult<NewsListResponse>) -> ()) -> APITask {
        let apiMethod = "news"

        var requestContext = APIRequestContext()
        requestContext.apiMethod = apiMethod

        return requestManager.performRequest(withContext: requestContext, completion: completion)
    }

    func getDetailsOfNewsItem(withId id: String, completion: @escaping (APIRequestResult<NewsItemDetailsResponse>) -> ()) -> APITask {
        let apiMethod = "news_content"

        let queryParameters: [URLQueryItem] = [URLQueryItem(name: "id", value: id)]

        var requestContext = APIRequestContext()
        requestContext.apiMethod = apiMethod
        requestContext.queryItems = queryParameters

        return requestManager.performRequest(withContext: requestContext, completion: completion)
    }
}
