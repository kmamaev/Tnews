import Foundation

protocol NewsItemDetailsVMDelegate: class {
    func newsItemsDetailsVMDidUpdateContent(_ newsItemDetailsVM: NewsItemDetailsVM)
    func newsItemsDetailsVMDidFailUpdatingContent(_ newsItemDetailsVM: NewsItemDetailsVM)
}

protocol NewsItemDetailsVMType {
    weak var delegate: NewsItemDetailsVMDelegate? { get set }
    var title: String { get }
    var formattedDateString: String { get }
    var content: String { get }

    func loadDetails()
}

class NewsItemDetailsVM: NewsItemDetailsVMType {
    let title: String
    let formattedDateString: String
    fileprivate(set) var content: String = ""

    weak var delegate: NewsItemDetailsVMDelegate?

    fileprivate let newsService: NewsService
    fileprivate let newsItem: NewsItem

    init(newsItem: NewsItem, newsService: NewsService, dateFormatter: DateFormatter) {
        self.newsService = newsService
        self.newsItem = newsItem

        title = newsItem.text
        formattedDateString = dateFormatter.string(from: newsItem.publicationDate)
    }

    func loadDetails() {
        newsService.getDetailsOfNewsItem(newsItem) { [weak self] result in
                switch result {
                    case .success(let newsItemDetails):
                        self?.handleGotNewsItemDetails(newsItemDetails)
                    case .failure(let error):
                        self?.handleFailUpdatingContent()
                        print(error)
                }
            }
    }
}

private extension NewsItemDetailsVM {
    func handleGotNewsItemDetails(_ newsItemDetails: NewsItemDetails) {
        content = newsItemDetails.content
        delegate?.newsItemsDetailsVMDidUpdateContent(self)
    }

    func handleFailUpdatingContent() {
        delegate?.newsItemsDetailsVMDidFailUpdatingContent(self)
    }
}
