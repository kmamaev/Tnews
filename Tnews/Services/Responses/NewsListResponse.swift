struct NewsListResponse {
    let newsItems: [NewsItem]
}

extension NewsListResponse: Mappable {
    init?(json: [String: Any]) {
        guard let newsItemsJsons = json["payload"] as? [Any] else {
            return nil
        }

        var newsItems: [NewsItem] = []
        for newsItemJson in newsItemsJsons {
            if let newsItemJson = newsItemJson as? [String: Any],
                let newsItem = NewsItem(json: newsItemJson)
            {
                newsItems.append(newsItem)
            } else {
                return nil
            }
        }
        self.newsItems = newsItems
    }
}
