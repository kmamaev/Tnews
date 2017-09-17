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

    func loadNews()
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

        newsService.addObserver(self)
    }
    
    deinit {
        newsService.removeObserver(self)
    }
}

extension NewsListVM {
    func loadNews() {
        newsService.fetchAndSaveNews(fetchFromCache: true)
    }

    func refreshNews() {
        newsService.fetchAndSaveNews(fetchFromCache: false)
    }

    func selectNewsItem(at index: Int) {
        let newsItemVM = newsItemVMs[index]
        routingDelegate?.newsListVM(self, didStartAction: .selectNewsItem(newsItemVM.newsItem))
    }
}

extension NewsListVM: NewsServiceObserver {
    func newsServiceDidUpdateNews(_ newsService: NewsService) {
        newsItemVMs = newsService.newsItems
            .sorted(by: { $0.publicationDate > $1.publicationDate })
            .map({ NewsItemVM(newsItem: $0, dateFormatter: dateFormatter) })

        delegate?.newsListVMDidUpdateNews(self)
    }

    func newsService(_ newsService: NewsService, didFailUpdatingNewsWithError error: Error) {
        delegate?.newsListVMDidFailUpdatingNews(self)
        print(error)
    }
}
