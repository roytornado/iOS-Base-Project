import Foundation
import UIKit

class AppUtils {
  static func formattedMonthForLog() -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM"
    let time = df.string(from: Date())
    return time
  }
  
  static func formattedDateForLog() -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let time = df.string(from: Date())
    return time
  }
  
  static func formattedDate() -> String {
    let df = DateFormatter()
    df.dateFormat = "dd-MM-yyyy"
    let time = df.string(from: Date())
    return time
  }
  
  static func formattedTime() -> String {
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss"
    let time = df.string(from: Date())
    return time
  }
  
  static func formattedFullDateTime() -> String {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .medium
    let time = df.string(from: Date())
    return time
  }
}

extension Date {
  var formattedDateString: String {
    let df = DateFormatter()
    //df.locale = Locale(identifier: "en")
    df.dateFormat = "dd/MM/yyyy |ccc|"
    return df.string(from: self)
  }
  
  var formattedTimeString: String {
    let df = DateFormatter()
    //df.locale = Locale(identifier: "en")
    df.dateFormat = "HH:mm"
    return df.string(from: self)
  }
  
  var formattedDateTimeString: String {
    let df = DateFormatter()
    //df.locale = Locale(identifier: "zh_Hant_HK")
    df.dateFormat = "dd/MM/yy HH:mm"
    return df.string(from: self)
  }
  
  var formattedKeycardDateTimeString: String {
    let df = DateFormatter()
    //df.locale = Locale(identifier: "zh_Hant_HK")
    df.dateFormat = "yyyy.MM.dd |ccc| HH:mm"
    return df.string(from: self)
  }
}

extension Int64 {
  var toDate: Date {
    let seconds = self / 1000
    return Date(timeIntervalSince1970: TimeInterval(seconds))
  }
}

class KeyboardInfo {
  let endFrame: CGRect
  let duration: TimeInterval
  let animationCurve: UIView.AnimationOptions
  init(notification: Notification) {
    let userInfo = notification.userInfo!
    endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
    let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
    let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
    animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
  }
}

class Device {
  class var screenWidth: CGFloat { return UIScreen.main.bounds.size.width }
  class var screenHeight: CGFloat { return UIScreen.main.bounds.size.height }
  class var isPhone: Bool { return UIDevice.current.userInterfaceIdiom == .phone }
  class var isPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
}

extension Bundle {
  var releaseVersionNumber: String {
    return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }
  var buildVersionNumber: String {
    return infoDictionary?["CFBundleVersion"] as? String ?? ""
  }
}

extension Error {
  var formattedError: String {
    let error = self as NSError
    return "\(error.domain) [\(error.code)]"
  }
}

extension String {
  var asNSString: NSString { return self as NSString }
  var toURL: URL {
    print("toURL: \(self)")
    return URL(string: self)!
  }
  func trim() -> String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
  var isValidField: Bool { return !self.isEmpty }
  
  func inject(map: [String: String]) -> String {
    var result = self
    map.forEach { key, value in
      result = result.replacingOccurrences(of: "{\(key)}", with: value)
    }
    return result
  }
}

extension NSAttributedString {
  static func formattedHighlightMessage(fullString: String, highlightedPart: String, size: CGFloat, color: UIColor = UIColor.black) -> NSAttributedString {
    let result = NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .light)])
    result.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .bold)], range: fullString.asNSString.range(of: highlightedPart))
    return result
  }
  
  static func formattedHighlightAsBoldMessage(fullString: String, highlightedParts: [String], size: CGFloat, color: UIColor = UIColor.black) -> NSAttributedString {
    let result = NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .light)])
    highlightedParts.forEach { highlightedPart in
      result.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .bold)], range: fullString.asNSString.range(of: highlightedPart))
    }
    return result
  }
  
  static func formattedHighlightMessage2(fullString: String, highlightedParts: [String], size: CGFloat, color: UIColor = UIColor(named: "MainGreen")!) -> NSAttributedString {
    let result = NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .bold)])
    highlightedParts.forEach { highlightedPart in
      result.addAttributes([NSAttributedString.Key.foregroundColor: color], range: fullString.asNSString.range(of: highlightedPart))
    }
    return result
  }
  
  static func formattedUnderlineMessage(fullString: String, size: CGFloat, color: UIColor = UIColor.black) -> NSAttributedString {
    let result = NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .light), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    return result
  }
}
