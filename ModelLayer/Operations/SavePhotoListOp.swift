import UIKit
import Flow_iOS

class SavePhotoListOp: FlowOperation {
  override func mainLogic() {
    if let isPhotoListLoadedFromCache: Bool = getData(name: "isPhotoListLoadedFromCache", isOptional: true), isPhotoListLoadedFromCache {
      finishSuccessfully()
      return
    }
    guard let photoList: [PhotoData] = getData(name: "photoList") else { return }
    
    DispatchQueue.main.async {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      do {
        if photoList.count > 0 && appDelegate.persistentContainer.viewContext.hasChanges {
          try appDelegate.persistentContainer.viewContext.save()
        }
        self.finishSuccessfully()
      } catch {
        self.finishWithError(error: Constants.errorLoadData)
      }
    }
    startWithAsynchronous()
  }
}

