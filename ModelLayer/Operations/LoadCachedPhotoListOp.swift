import UIKit
import Flow_iOS
import RealmSwift

class LoadCachedPhotoListOp: FlowOperation {
  override func mainLogic() {
    DispatchQueue.global().async {
      let realm = try! Realm()
      let caches = Array(realm.objects(PhotoData.self))
      if caches.count > 0 {
        LogManager.info("[LoadCachedPhotoListOp]: Photos Caches Loaded")
        let cloned = caches.map { $0.clone() }
        self.setData(name: "isPhotoListLoadedFromCache", value: true)
        self.setData(name: "photoList", value: cloned)
      }
      self.finishSuccessfully()
    }
    startWithAsynchronous()
  }
}


