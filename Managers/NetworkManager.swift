import Foundation
import Alamofire
import SwiftyJSON

@objc class NetworkResult : NSObject {
  var isSuccess = false
  var error: Error?
  var json : JSON?
  var extra : Dictionary<String, Any>?
  var sourceUrl : String?
  
  override var description: String{
    return "Url: \(String(describing: sourceUrl ?? "nil")) Error: \(String(describing: error)) Success: \(isSuccess)"
  }
}

class NetworkManager{
  static let shared = NetworkManager()
  
  func processResponse(_ response: AFDataResponse<Any>, request: DataRequest, parameters: [String: Any]?) -> NetworkResult {
    let result = NetworkResult()
    if let sourceUrl = response.response?.url?.absoluteString {
      result.sourceUrl = sourceUrl
    }
    switch response.result {
      case let .success(json):
        let statusCode = response.response!.statusCode
        if statusCode == 200 {
          result.isSuccess = true
          result.json = JSON(json)
        } else {
          result.isSuccess = false
          result.error = NSError(domain: "Network Error", code: statusCode, userInfo: nil)
        }
      case let .failure(error):
        result.isSuccess = false
        result.error = error
    }
    LogManager.info("[NetworkManager] >======")
    LogManager.info("[NetworkManager] \(request))")
    //LogManager.info("[NetworkManager] \(String(describing: result.json ?? "No Response"))")
    LogManager.info("[NetworkManager] <======")
    return result
  }
  
  @discardableResult func get(_ URLString: URLConvertible, parameters: [String: Any]? = nil, headers: [String: String], completionHandler: @escaping (NetworkResult) -> Void) -> Request {
    let request = AF.request(URLString, method: .get, parameters: parameters, headers: HTTPHeaders(headers))
    request.responseJSON { response in
      let result = self.processResponse(response, request: request, parameters: parameters)
      completionHandler(result)
    }
    return request
  }
  
  @discardableResult func post(_ URLString: URLConvertible, parameters: [String: Any]? = nil, headers: [String: String], completionHandler: @escaping (NetworkResult) -> Void) -> Request {
    let request = AF.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
    request.responseJSON { response in
      let result = self.processResponse(response, request: request, parameters: parameters)
      completionHandler(result)
    }
    return request
  }
}
