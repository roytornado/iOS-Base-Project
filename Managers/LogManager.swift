import Foundation

class LogManager {
  static func info(_ message: String) {
    let message = "\(AppUtils.formattedTime()) | \(message)"
    print(message)
  }
  
  static func error(_ message: String) {
    let message = "\(AppUtils.formattedTime()) | \(message)"
    print(message)
  }
}
