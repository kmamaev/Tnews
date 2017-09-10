import Foundation

class NewsListVM {
    var news: [NewsItemVM] = []
    
    init() {
        // TODO: remove hardcode after debug
        news = [1, 2, 3].map { NewsItem(title: "title\($0)", content: "content") }
    }
}
