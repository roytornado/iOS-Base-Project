import Foundation

extension Int {
  var formattedMinsToDuration: String {
    let hours = self / 60
    let minutes = self % 60
    if hours > 0 { return "\(hours)\(TXT_TRIP_Hour) \(minutes)\(TXT_TRIP_Min)" }
    else { return "\(minutes)\(TXT_TRIP_Min)" }
  }
}

extension String {
  var formattedTimeForItineraryRawTime: String {
    return String(self.split(separator: "T").last!)
  }
}
