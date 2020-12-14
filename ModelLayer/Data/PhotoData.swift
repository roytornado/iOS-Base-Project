import Foundation
import SwiftyJSON
import RealmSwift


class PhotoData: Object {
  @objc dynamic var id: Int64 = 0
  @objc dynamic var title: String!
  @objc dynamic var url: String!
  @objc dynamic var thumbnailUrl: String!
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  static func parse(json: JSON) -> PhotoData {
    let obj = PhotoData()
    obj.id = json["id"].int64Value
    obj.title = json["title"].stringValue
    obj.url = json["url"].stringValue
    obj.thumbnailUrl = json["thumbnailUrl"].stringValue
    return obj
  }
  
  static func parseArray(jsonArray: [JSON]) -> [PhotoData] {
    var array = [PhotoData]()
    for json in jsonArray {
      let obj = parse(json: json)
      array.append(obj)
    }
    return array
  }
  
  func clone() -> PhotoData {
    let obj = PhotoData()
    obj.id = self.id
    obj.title = self.title
    obj.url = self.url
    obj.thumbnailUrl = self.thumbnailUrl
    return obj
  }
  
  override var description: String {
    return "[Photo] \(id)"
  }
}
