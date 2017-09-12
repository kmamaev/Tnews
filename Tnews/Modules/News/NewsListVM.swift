import Foundation

protocol NewsListVMDelegate: class {
    func newsListVMDidUpdateNews(_ newsListVM: NewsListVM)
    func newsListVMDidFailUpdatingNews(_ newsListVM: NewsListVM)
}

protocol NewsListVMType {
    weak var delegate: NewsListVMDelegate? { get set }
    var news: [NewsItemVM] { get }

    func refreshNews()
}

class NewsListVM: NewsListVMType {
    weak var delegate: NewsListVMDelegate?

    fileprivate(set) var news: [NewsItemVM] = []

    fileprivate let newsService: NewsService
    fileprivate let dateFormatter: DateFormatter

    init(newsService: NewsService, dateFormatter: DateFormatter) {
        self.newsService = newsService
        self.dateFormatter = dateFormatter

        loadNews()
    }

    func refreshNews() {
        loadNews()
    }
}

private extension NewsListVM {
    func loadNews() {
        newsService.getNews { [weak self] result in
            switch result {
            case .success(let newsItems):
                self?.handleGotNews(newsItems)
            case .failure(let error):
                // TODO: add error handling
                print(error)
            }
        }
    }

    func handleGotNews(_ newsItems: [NewsItem]) {
        news = newsItems
            .sorted(by: { $0.publicationDate > $1.publicationDate })
            .map({ NewsItemVM(newsItem: $0, dateFormatter: dateFormatter) })

        delegate?.newsListVMDidUpdateNews(self)
    }
}
