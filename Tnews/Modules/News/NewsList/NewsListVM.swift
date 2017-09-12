import Foundation

protocol NewsListVMDelegate: class {
    func newsListVMDidUpdateNews(_ newsListVM: NewsListVM)
    func newsListVMDidFailUpdatingNews(_ newsListVM: NewsListVM)
}

protocol NewsListVMRoutingDelegate: class {
    func newsListVM(_ newsListVM: NewsListVM, didStartAction action: NewsListVM.Action)
}

protocol NewsListVMType {
    weak var delegate: NewsListVMDelegate? { get set }
    weak var routingDelegate: NewsListVMRoutingDelegate? { get set }
    var news: [NewsItemVMType] { get }

    func refreshNews()
    func selectNewsItem(at index: Int)
}

class NewsListVM: NewsListVMType {
    enum Action {
        case selectNewsItem(NewsItem)
    }

    weak var delegate: NewsListVMDelegate?
    weak var routingDelegate: NewsListVMRoutingDelegate?

    var news: [NewsItemVMType] {
        return newsItemVMs.map({ $0 })
    }
    fileprivate var newsItemVMs: [NewsItemVM] = []

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

    func selectNewsItem(at index: Int) {
        let newsItemVM = newsItemVMs[index]
        routingDelegate?.newsListVM(self, didStartAction: .selectNewsItem(newsItemVM.newsItem))
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
        newsItemVMs = newsItems
            .sorted(by: { $0.publicationDate > $1.publicationDate })
            .map({ NewsItemVM(newsItem: $0, dateFormatter: dateFormatter) })

        delegate?.newsListVMDidUpdateNews(self)
    }
}
