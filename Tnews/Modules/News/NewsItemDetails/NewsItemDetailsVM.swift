import Foundation

protocol NewsItemDetailsVMDelegate: class {
    func newsItemsDetailsVMDidUpdateContent(_ newsItemDetailsVM: NewsItemDetailsVM)
}

protocol NewsItemDetailsVMType {
    weak var delegate: NewsItemDetailsVMDelegate? { get set }
    var title: String { get }
    var formattedDateString: String { get }
    var content: String { get }
}

class NewsItemDetailsVM: NewsItemDetailsVMType {
    let title: String
    let formattedDateString: String
    fileprivate(set) var content: String = ""

    weak var delegate: NewsItemDetailsVMDelegate?

    fileprivate let newsService: NewsService

    init(newsItem: NewsItem, newsService: NewsService, dateFormatter: DateFormatter) {
        self.newsService = newsService

        title = newsItem.text
        formattedDateString = dateFormatter.string(from: newsItem.publicationDate)

        newsService.getDetailsOfNewsItem(newsItem) { [weak self] result in
                switch result {
                    case .success(let newsItemDetails):
                        self?.handleGotNewsItemDetails(newsItemDetails)
                    case .failure(let error):
                        // TODO: add error handling
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
}
