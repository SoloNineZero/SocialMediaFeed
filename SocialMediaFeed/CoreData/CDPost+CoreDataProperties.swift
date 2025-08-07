import Foundation
import CoreData


extension CDPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPost> {
        return NSFetchRequest<CDPost>(entityName: "CDPost")
    }

    @NSManaged public var id: Int32
    @NSManaged public var author: String?
    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var userid: Int32
    @NSManaged public var avatar: Data?

}

extension CDPost : Identifiable {

}
