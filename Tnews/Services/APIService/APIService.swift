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
    func fetchNews(completion: @escaping (APIRequestResult<NewsListResponse>) -> ()) {
        let apiMethod = "news"

        var requestContext = APIRequestContext()
        requestContext.apiMethod = apiMethod

        requestManager.performRequest(withContext: requestContext, completion: completion)
    }
}
