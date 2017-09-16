import Foundation
import CoreData

class CDNewsItem: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNewsItem> {
        return NSFetchRequest<CDNewsItem>(entityName: "CDNewsItem")
    }

    @NSManaged public var id: String
    @NSManaged public var text: String
    @NSManaged public var publicationDate: NSDate

    @NSManaged public var details: CDNewsItemDetails?
}
