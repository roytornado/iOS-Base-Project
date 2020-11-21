import Foundation
import SwiftyJSON
import Flow_iOS
import RealmSwift

class DataRepository {
  
  static var shared = DataRepository()
  
  func loadItineraries(completion: @escaping ((_ results: [ItineraryData], _ error: Error?) -> Void)) {
    Flow()
      .add(operation: LoadItinerariesOp())
      .setDidFinishBlock(block: { flow in
        if let photoList = flow.dataBucket["photoList"] as? [ItineraryData] {
          DispatchQueue.main.async { completion(photoList, nil) }
        } else {
          DispatchQueue.main.async { completion([], flow.error) }
        }
      })
      .start()
  }
}
