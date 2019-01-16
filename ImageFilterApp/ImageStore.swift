import Realm
import RealmSwift

class ImageStore: Object {
    @objc dynamic var image = Data()
    @objc dynamic var identifier = NSUUID().uuidString
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

