import Foundation

struct NewsItem: Hashable {
    let id: String
    let text: String
    let publicationDate: Date
    
    var hashValue: Int {
        return id.hashValue
    }
}

func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
    return lhs.id == rhs.id
}

extension NewsItem: Mappable {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let text = json["text"] as? String,
            let publicationDateDictionary = json["publicationDate"] as? [String: Int],
            let publicationDateMilliseconds = publicationDateDictionary["milliseconds"] else {
            return nil
        }

        self.id = id
        self.text = text
        self.publicationDate = Date(timeIntervalSince1970: TimeInterval(publicationDateMilliseconds / 1000))
    }
}

extension NewsItem {
    init(coreDataObject: CDNewsItem) {
        self.id = coreDataObject.id
        self.text = coreDataObject.text
        self.publicationDate = coreDataObject.publicationDate as Date
    }
}
