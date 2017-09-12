import Foundation

protocol NewsListVMDelegate: class {
    func newsListVMDidUpdateNews(_ newsListVM: NewsListVM)
}

class NewsListVM {
    weak var delegate: NewsListVMDelegate?

    fileprivate(set) var news: [NewsItemVM] = []
    fileprivate let dateFormatter: DateFormatter

    init(newsService: NewsService, dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter

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
}

extension NewsListVM {

}

private extension NewsListVM {
    func handleGotNews(_ newsItems: [NewsItem]) {
        news = newsItems
            .sorted(by: { $0.publicationDate > $1.publicationDate })
            .map({ NewsItemVM(newsItem: $0, dateFormatter: dateFormatter) })

        delegate?.newsListVMDidUpdateNews(self)
    }
}
