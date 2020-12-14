import Foundation
import SwiftyJSON
import CoreData

@objc(PhotoData)
public class PhotoData: NSManagedObject {
  @nonobjc public class func makeFetchRequest() -> NSFetchRequest<PhotoData> {
      return NSFetchRequest<PhotoData>(entityName: "PhotoData")
  }
  
  @NSManaged public var id: Int32
  @NSManaged public var title: String!
  @NSManaged public var url: String!
  @NSManaged public var thumbnailUrl: String!
  
  static func parse(json: JSON) -> PhotoData {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let obj = PhotoData(context: appDelegate.persistentContainer.viewContext)
    obj.id = json["id"].int32Value
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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let obj = PhotoData(context: appDelegate.persistentContainer.viewContext)
    obj.id = self.id
    obj.title = self.title
    obj.url = self.url
    obj.thumbnailUrl = self.thumbnailUrl
    return obj
  }
  
  public override var description: String {
    return title
    
  }
}
