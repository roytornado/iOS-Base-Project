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
  class UpdateDevice: APICommand {
    var method: APIMethod { return .post }
    var path: String { return "/api/devices" }
    var parameters: [String: Any] = [String: Any]()
    var error: Error? = nil
    init(deviceName: String, deviceId: String, deviceMode: String, deviceLocation: String) {
      parameters["name"] = deviceName
      parameters["id"] = deviceId
      parameters["mode"] = deviceMode
      parameters["building"] = deviceLocation
    }
    func handleResult(networkResult: NetworkResult) {
      if let networkError = networkResult.error { error = networkError; return }
      if let json = networkResult.json, networkResult.isSuccess {
      } else {
        error = Constants.errorLoadData
      }
    }
  }
  class DemoGet: APICommand {
    var method: APIMethod { return .get }
    var path: String { return "/photos" }
    var parameters: [String: Any] = [String: Any]()
    var error: Error? = nil
    var resultArray: [PhotoData]! = [PhotoData]()
    func handleResult(networkResult: NetworkResult) {
      if let networkError = networkResult.error { error = networkError; return }
      if let json = networkResult.json, networkResult.isSuccess {
        resultArray = PhotoData.parseArray(jsonArray: json.arrayValue)
      } else {
        error = Constants.errorLoadData
      }
    }
  }
}
