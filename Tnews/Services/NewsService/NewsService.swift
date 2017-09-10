import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

class NewsService {
    let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getNews(completion: @escaping (Result<[NewsItem]>) -> ()) {
        apiService.fetchNews { result in
            switch result {
                case .success(let newsListResponse):
                    completion(.success(newsListResponse.newsItems))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
