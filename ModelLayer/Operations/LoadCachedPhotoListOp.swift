import UIKit
import Flow_iOS

class LoadCachedPhotoListOp: FlowOperation {
  override func mainLogic() {
    DispatchQueue.main.async {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      do {
        let caches = try appDelegate.persistentContainer.viewContext.fetch(PhotoData.makeFetchRequest())
        if caches.count > 0 {
          LogManager.info("[LoadCachedPhotoListOp]: Photos Caches Loaded")
          self.setData(name: "isPhotoListLoadedFromCache", value: true)
          self.setData(name: "photoList", value: caches)
        }
      } catch {
      }
      self.finishSuccessfully()
    }
    startWithAsynchronous()
  }
}


