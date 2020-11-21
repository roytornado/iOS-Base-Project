import UIKit
import Flow_iOS
import RealmSwift

class SavePhotoListOp: FlowOperation {
  override func mainLogic() {
    if let isPhotoListLoadedFromCache: Bool = getData(name: "isPhotoListLoadedFromCache", isOptional: true), isPhotoListLoadedFromCache {
      finishSuccessfully()
      return
    }
    /*
    guard let photoList: [ItineraryData] = getData(name: "photoList") else { return }
    let clonedPhotoList = photoList.map { $0.clone() }
    let realm = try! Realm()
    do {
      try realm.write {
        //realm.delete(realm.objects(ItineraryData.self))
        //realm.add(clonedPhotoList)
        LogManager.info("[SavePhotoListOp]: Photos Cached")
      }
      finishSuccessfully()
    } catch {
      finishWithError(error: Constants.errorLoadData)
    }*/
  }
}

