import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

protocol NewsServiceObserver: class {
    func newsServiceDidUpdateNews(_ newsService: NewsService)
    func newsService(_ newsService: NewsService, didFailUpdatingNewsWithError error: Error)
}

class NewsService {
    fileprivate var observers: [NewsServiceObserver] = []
    
    var newsItems: [NewsItem] {
        return storageService.newsItems
    }

    fileprivate let apiService: APIService
    fileprivate let storageService: StorageService
    
    init(apiService: APIService, storageService: StorageService) {
        self.apiService = apiService
        self.storageService = storageService

        storageService.addObserver(self)
    }
    
    deinit {
        storageService.removeObserver(self)
    }
}

extension NewsService {
    func fetchAndSaveNews(fetchFromCache: Bool) {
        apiService.fetchNews { [unowned self] result in
                switch result {
                    case .success(let newsListResponse):
                        self.storageService.saveNews(newsListResponse.newsItems)
                    case .failure(let error):
                        self.notifyNewsServiceDidFailUpdatingNews(withError: error)
                }
            }

        if fetchFromCache {
            storageService.fetchNews()
        }
    }

    func getDetailsOfNewsItem(_ newsItem: NewsItem, completion: @escaping (Result<NewsItemDetails>) -> ()) {
        apiService.getDetailsOfNewsItem(withId: newsItem.id) { result in
                switch result {
                    case .success(let newsItemDetailsResponse):
                        completion(.success(newsItemDetailsResponse.newsItemDetails))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
}

extension NewsService {
    func addObserver(_ observer: NewsServiceObserver){
        observers.append(observer)
    }
    
    func removeObserver(_ observer: NewsServiceObserver) {
        if let index = observers.index(where: { observer === $0 }) {
            observers.remove(at: index)
        }
    }
}

private extension NewsService {
    func notifyNewsServiceDidUpdateNews() {
        observers.forEach { $0.newsServiceDidUpdateNews(self) }
    }
    
    func notifyNewsServiceDidFailUpdatingNews(withError error: Error) {
        observers.forEach { $0.newsService(self, didFailUpdatingNewsWithError: error) }
    }
}

extension NewsService: StorageServiceObserver {
    func storageServiceDidUpdateNews(_ storageService: StorageService) {
        notifyNewsServiceDidUpdateNews()
    }

    func storageService(_ storageService: StorageService, didFailUpdatingNewsWithError error: Error) {
        notifyNewsServiceDidFailUpdatingNews(withError: error)
    }
}
