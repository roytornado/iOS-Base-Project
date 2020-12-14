import UIKit
import WebKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      let value = newValue
      layer.cornerRadius = value
      layer.masksToBounds = value > 0
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    set {
      layer.borderColor = newValue?.cgColor
    }
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      else {
        return nil
      }
    }
  }
  
  func centerX(_ parent : UIView){
    self.frame.origin = CGPoint(x: parent.width / 2 - self.width / 2, y: self.frame.origin.y)
  }
  
  func centerY(_ parent : UIView){
    self.frame.origin = CGPoint(x: self.frame.origin.x, y: parent.height / 2 - self.height / 2)
  }
  
  func centerTo(_ parent : UIView){
    centerX(parent)
    centerY(parent)
  }
  
  func removeAllSubviews(){
    for view in subviews {
      view.removeFromSuperview()
    }
  }
  
  public class func loadFromNib() -> Self {
    func loadNib<T: UIView>() -> T {
      return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    return loadNib()
  }
  
  func pinToSuperView() {
    guard let parent = superview else { return }
    self.translatesAutoresizingMaskIntoConstraints = false
    self.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
    self.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    self.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
  }
}

extension UILabel {
  @IBInspectable var stringKey: String {
    get {
      return ""
    }
    set {
      var suffix = ""
      if newValue.contains(":") { suffix = ":" }
      text = "\(ResString(newValue.replacingOccurrences(of: ":", with: "")))\(suffix)"
    }
  }
}

extension UIButton {
  @IBInspectable var stringKey: String {
    get {
      return self.stringKey
    }
    set {
      setTitle(ResString(newValue), for: .normal)
      setTitle(ResString(newValue), for: .highlighted)
    }
  }
  
  func setTitleForAllStates(_ title: String?) {
    setTitle(title, for: .normal)
    setTitle(title, for: .highlighted)
  }
  
  func setTitleColorForAllStates(_ color: UIColor?) {
    setTitleColor(color, for: .normal)
    setTitleColor(color, for: .highlighted)
  }
  
  func setImageForAllStates(_ image: UIImage?) {
    setImage(image, for: .normal)
    setImage(image, for: .highlighted)
  }
}

extension UITextField {
  @IBInspectable var placeholderKey: String {
    get {
      return self.placeholder!
    }
    set {
      placeholder = newValue
      attributedPlaceholder = NSAttributedString(string: ResString(newValue), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
  }
}

extension UIViewController {
  class func initFromSb(_ sb: UIStoryboard) -> Self {
    func loadVC<T: UIViewController>(_ sb: UIStoryboard) -> T {
      return sb.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    return loadVC(sb)
  }
}

extension UIColor {
  
  static func colorFromHexString(_ src : String) -> UIColor {
    var hex = src.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    if src.contains("#") {
      hex = src.replacingOccurrences(of: "#", with: "")
    }
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      return UIColor.clear
    }
    let color = UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    return color
  }
}

extension CGRect {
  var center: CGPoint { return CGPoint(x: origin.x + width.half, y: origin.y + height.half) }
}

extension Float {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asDouble: Double { return Double(self) }
}

extension Double {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asFloat: Float { return Float(self) }
  var asInt64: Int64 { return Int64(self) }
  var asInt: Int { return Int(self) }
}

extension Int32 {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asFloat: Float { return Float(self) }
  var asDouble: Double { return Double(self) }
}

extension Int {
  var asCGFloat: CGFloat { return CGFloat(self) }
  var asFloat: Float { return Float(self) }
  var asDouble: Double { return Double(self) }
}

extension UIStackView {
  func removeAllArrangedSubviews() {
    arrangedSubviews.forEach {
      self.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }
}

extension RSButton {
  func normalMode() {
    alpha = 1.0
    isEnabled = true
  }
  
  func disableMode() {
    alpha = 0.5
    isEnabled = false
  }
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}

extension UITableView {
  func registerNibCell(_ aClass: AnyClass) {
    let name : String = "\(aClass)"
    register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
  }
  
  func registerClassCell(_ aClass: AnyClass){
    let name : String = "\(aClass)"
    register(aClass, forCellReuseIdentifier: name)
  }
}
