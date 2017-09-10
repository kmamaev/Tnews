import Foundation

struct NewsItemVM {
    let title: String
    let text: String
}

extension NewsItemVM {
    init(newsItem: NewsItem, dateFormatter: DateFormatter) {
        title = dateFormatter.string(from: newsItem.publicationDate)
        text = newsItem.text
    }
}
