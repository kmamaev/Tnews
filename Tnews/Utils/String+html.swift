import UIKit

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        let options: [String: Any] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]

        guard let data = data(using: .unicode, allowLossyConversion: true),
            let htmlAttributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        return htmlAttributedString
    }

    func htmlConvertedString() -> String? {
        return htmlAttributedString()?.string
    }
}
