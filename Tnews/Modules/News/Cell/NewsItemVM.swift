protocol NewsItemVM {
    var title: String { get }
    var content: String { get }
}

extension NewsItem: NewsItemVM {
}
