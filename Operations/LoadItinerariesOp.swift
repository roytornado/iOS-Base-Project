import UIKit
import Flow_iOS

class LoadItinerariesOp: FlowOperation {
  override func mainLogic() {
    if let isPhotoListLoadedFromCache: Bool = getData(name: "isPhotoListLoadedFromCache", isOptional: true), isPhotoListLoadedFromCache {
      finishSuccessfully()
      return
    }
    APIClient.shared.call(api: API.ItinerariesFetch()) { api in
      if let error = api.error {
        self.finishWithError(error: error)
      } else {
        LogManager.info("[LoadPhotoListOp]: Photos Loaded From Server")
        self.setData(name: "photoList", value: api.resultArray ?? [])
        self.finishSuccessfully()
      }
    }
    startWithAsynchronous()
  }
}
