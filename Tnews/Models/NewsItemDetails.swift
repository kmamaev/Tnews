import Foundation

struct NewsItemDetails {
    let content: String
}

extension NewsItemDetails: Mappable {
    init?(json: [String: Any]) {
        guard let content = json["content"] as? String else {
            return nil
        }

        self.content = content
    }
}

extension NewsItemDetails {
    init(coreDataObject: CDNewsItemDetails) {
        self.content = coreDataObject.content
    }
}
