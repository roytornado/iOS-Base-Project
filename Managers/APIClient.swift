import Foundation
import SwiftyJSON
import Alamofire

class APIClient {
  static let shared = APIClient()
  var baseURL: String { return Constants.host }
  
  
  func call<T: APICommand>(api: T, completion: @escaping ((T) -> Void)) {
    let fullPath = api.path.hasPrefix("http") ? api.path : baseURL + api.path
    let completionHandler: (NetworkResult) -> Void = {
      networkResult in
      api.handleResult(networkResult: networkResult)
      completion(api)
    }
    var headers = [String: String]()
    headers["Authorization"] = "FAKE_TOKEN"
    let parameters = api.parameters
    switch api.method {
    case .get:
      let _ = NetworkManager.shared.get(fullPath, parameters: api.parameters, headers: headers, completionHandler: completionHandler)
    case .post:
      let _ = NetworkManager.shared.post(fullPath, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
  }
}

enum APIMethod {
  case get, post
}

protocol APICommand {
  var method: APIMethod { get }
  var path: String { get }
  var parameters: [String: Any] { get set }
  var error: Error? { get set }
  func handleResult(networkResult: NetworkResult)
}

enum API {
  class PostCreate: APICommand {
    var method: APIMethod { return .post }
    var path: String { return "/posts" }
    var parameters: [String: Any] = [String: Any]()
    var error: Error? = nil
    init(title: String, body: String, userId: Int) {
      parameters["title"] = title
      parameters["body"] = body
      parameters["userId"] = userId
    }
    func handleResult(networkResult: NetworkResult) {
      if let networkError = networkResult.error { error = networkError; return }
      if let json = networkResult.json, networkResult.isSuccess {
        LogManager.info("\(json)")
      } else {
        error = Constants.errorLoadData
      }
    }
  }
  class ItinerariesFetch: APICommand {
    var method: APIMethod { return .get }
    var path: String { return "/skyscanner-prod-takehome-test/flights.json" }
    var parameters: [String: Any] = [String: Any]()
    var error: Error? = nil
    var resultArray: [ItineraryData]! = [ItineraryData]()
    func handleResult(networkResult: NetworkResult) {
      if let networkError = networkResult.error { error = networkError; return }
      if let json = networkResult.json, networkResult.isSuccess {
        resultArray = ItineraryData.parseArray(json: json)
      } else {
        error = Constants.errorLoadData
      }
    }
  }
}
