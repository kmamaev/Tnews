import Foundation

struct NewsItem {
    let id: String
    let text: String
    let publicationDate: Date
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
