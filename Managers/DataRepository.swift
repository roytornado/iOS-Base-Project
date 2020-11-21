import Foundation
import SwiftyJSON
import Flow_iOS
import RealmSwift

class DataRepository {
  
  static var shared = DataRepository()
  
  func clearPhotoCaches() {
    let realm = try! Realm()
    do {
      try realm.write {
        realm.delete(realm.objects(PhotoData.self))
        LogManager.info("[DataRepository]: Photos Caches Deleted")
      }
    } catch { }
  }
  
  func loadPhotos(completion: @escaping ((_ results: [PhotoData], _ error: Error?) -> Void)) {
    Flow()
      .add(operation: LoadCachedPhotoListOp())
      .add(operation: LoadPhotoListOp())
      .add(operation: SavePhotoListOp())
      .setDidFinishBlock(block: { flow in
        if let photoList = flow.dataBucket["photoList"] as? [PhotoData] {
          DispatchQueue.main.async { completion(photoList, nil) }
        } else {
          DispatchQueue.main.async { completion([], flow.error) }
        }
      })
      .start()
  }
  
  func addPhoto(title: String, body: String, userId: Int, completion: @escaping ((_ error: Error?) -> Void)) {
    APIClient.shared.call(api: API.PostCreate(title: title, body: body, userId: userId)) { api in
      DispatchQueue.main.async {
        completion(api.error)
      }
    }
  }
}
