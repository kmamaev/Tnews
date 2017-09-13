struct NewsItemDetailsResponse {
    let newsItemDetails: NewsItemDetails
}

extension NewsItemDetailsResponse: Mappable {
    init?(json: [String: Any]) {
        guard let newsItemDetailsJson = json["payload"] as? [String: Any],
            let newsItemDetails = NewsItemDetails(json: newsItemDetailsJson) else {
            return nil
        }

        self.newsItemDetails = newsItemDetails
    }
}
