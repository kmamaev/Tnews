import Foundation

protocol NewsItemDetailsVMType {

}

class NewsItemDetailsVM: NewsItemDetailsVMType {
    fileprivate let newsService: NewsService
    fileprivate let dateFormatter: DateFormatter

    init(newsService: NewsService, dateFormatter: DateFormatter) {
        self.newsService = newsService
        self.dateFormatter = dateFormatter
    }
}
