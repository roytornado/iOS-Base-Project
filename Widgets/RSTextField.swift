import Foundation
import UIKit

class RSTextField: UITextField, UITextFieldDelegate {
  
  @IBInspectable var charset: String = ""
  @IBInspectable var limit: Int = 0
  
  var textChangedCallback: ((String) -> Void)?
  var textFieldReturnedCallback: ((UITextField) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    cornerRadius = 2
    borderColor = UIColor.colorFromHexString("332a2a2a")
    borderWidth = 1.5
    font = UIFont.systemFont(ofSize: 24)
    textColor = UIColor.black
    tintColor = UIColor.black
    backgroundColor = UIColor.white
    delegate = self
    addTarget(self, action: #selector(textChanged), for: .editingChanged)
    inactiveStyle()
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 21, dy: 15)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 21, dy: 15)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    if charset.isValidField {
      guard NSCharacterSet(charactersIn: charset).isSuperset(of: CharacterSet(charactersIn: string)) else { return false }
    }
    let newLength = text.count + string.count - range.length
    return limit == 0 || newLength <= limit
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textFieldReturnedCallback?(self)
    return true
  }
  
  @objc func textChanged() {
    undoManager?.removeAllActions()
    if let text = text, text.isValidField { normalStyle() }
    else { inactiveStyle() }
    textChangedCallback?(text ?? "")
  }
  
  func normalStyle() {
    borderColor = UIColor(named: "MainGreen")!
  }
  
  func inactiveStyle() {
    borderColor = UIColor.colorFromHexString("332a2a2a")
  }
}

