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
            let publicationDateInt = publicationDateDictionary["milliseconds"] else {
            return nil
        }

        self.id = id
        self.text = text
        self.publicationDate = Date(timeIntervalSince1970: TimeInterval(publicationDateInt))
    }
}
