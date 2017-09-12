import Foundation

protocol NewsItemVMType {
    var title: String { get }
    var text: String { get }
}

struct NewsItemVM: NewsItemVMType {
    let title: String
    let text: String
    let newsItem: NewsItem
}

extension NewsItemVM {
    init(newsItem: NewsItem, dateFormatter: DateFormatter) {
        self.newsItem = newsItem
        title = dateFormatter.string(from: newsItem.publicationDate)
        text = newsItem.text
    }
}
