import UIKit
import RSLoadingView
import RxSwift

@objc protocol ViewControllerResultDelegate {
  func onResultFromViewController(action: String, obj: Any?)
}
  
class BaseViewController: UIViewController, ViewControllerResultDelegate {
  let disposeBag = DisposeBag()
  weak var delegate : ViewControllerResultDelegate?
  var chainedInputs = [UITextField]()
  var chainedInputsEndpoint: Selector!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    log("*****Life Cycle***** viewDidLoad")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    log("*****Life Cycle***** viewWillAppear 🟢")
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    log("*****Life Cycle***** viewWillDisappear 🔴")
    NotificationCenter.default.removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    LogManager.info("didReceiveMemoryWarning")
  }
  
  @objc func keyboardWillShow(notification:Notification) {
  }
  
  @objc func keyboardWillHide(notification:Notification) {
  }
  
  @objc func applicationDidBecomeActive(notification:Notification) {
  }
  
  @IBAction func back() {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func dismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  func log(_ message: String) {
    let string = "[\(String(describing: type(of: self)))] \(message)".replacingOccurrences(of: "ViewController", with: "")
    LogManager.info(string)
  }
  
  func showBlockLoading() {
    let loadingView = RSLoadingView(effectType: .twins)
    loadingView.mainColor = UIColor.white
    loadingView.lifeSpanFactor = 1.0
    loadingView.spreadingFactor = 2.5
    loadingView.sizeFactor = 0.7
    loadingView.speedFactor = 0.7
    loadingView.sizeInContainer = CGSize(width: 130, height: 130)
    loadingView.showOnKeyWindow()
  }
  
  func hideBlockLoading() {
    RSLoadingView.hideFromKeyWindow()
  }
  
  func showAlert(text: String, handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: TXT_ACT_OK, style: .default, handler: handler))
    present(alert, animated: true, completion: nil)
  }
  
  func hideKb() {
    view.endEditing(true)
  }
  
  func onResultFromViewController(action: String, obj: Any?) {
  }
  
  func chainInputs(textFields: [RSTextField], endPoint: Selector) {
    chainedInputsEndpoint = endPoint
    chainedInputs.removeAll()
    textFields.forEach {
      $0.textFieldReturnedCallback = { [weak self] textField in self?.textFieldReturned(textField) }
      chainedInputs.append($0)
    }
  }
  
  func textFieldReturned(_ textField: UITextField) {
    guard let index = chainedInputs.firstIndex(of: textField) else { return }
    if index == chainedInputs.count - 1 {
      textField.resignFirstResponder()
      perform(chainedInputsEndpoint)
    } else {
      chainedInputs[index+1].becomeFirstResponder()
    }
  }
}
