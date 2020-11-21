import Foundation
import SwiftyJSON
import RealmSwift


class ItineraryData {
  var id: String!
  var legsKeyArray: [String]!
  var price: String!
  var agent: String!
  var agentRating: Float = 0.0
  var legs: [ItineraryLegData] = []
  
  static func parse(json: JSON) -> ItineraryData {
    let obj = ItineraryData()
    obj.id = json["id"].stringValue
    obj.legsKeyArray = json["legs"].arrayValue.map { $0.stringValue }
    obj.price = json["price"].stringValue
    obj.agent = json["agent"].stringValue
    obj.agentRating = json["agent_rating"].floatValue
    return obj
  }
  
  static func parseArray(json: JSON) -> [ItineraryData] {
    let rawLegs = json["legs"].arrayValue
    let legs = ItineraryLegData.parseArray(jsonArray: rawLegs)
    var legsDict: [String: ItineraryLegData] = [:]
    legs.forEach { leg in
      legsDict[leg.id] = leg
    }
    
    let rawItineraries = json["itineraries"].arrayValue
    var array = [ItineraryData]()
    for json in rawItineraries {
      let obj = parse(json: json)
      obj.legsKeyArray.forEach { key in
        obj.legs.append(legsDict[key]!)
      }
      array.append(obj)
    }
    return array
  }
  
  func clone() -> ItineraryData {
    let obj = ItineraryData()
    obj.id = self.id
    //obj.legs = self.legs
    obj.price = self.price
    obj.agent = self.agent
    obj.agentRating = self.agentRating
    return obj
  }
  
   var description: String {
    return "[ItineraryData] \(id!)"
  }
}

class ItineraryLegData {
  var id: String!
  var departureAirport: String!
  var arrivalAirport: String!
  var departureTimeRawString: String!
  var arrivalTimeRawString: String!
  var stops: Int = 0
  var airlineName: String!
  var airlineId: String!
  var durationMins: Int = 0
  
  var airlineThumbUrl: String { return "https://logos.skyscnr.com/images/airlines/small/\(airlineId!).png" }
  var departureTimeOnly: String { return String(departureTimeRawString.split(separator: "T").last!) }
  var arrivalTimeOnly: String { return String(arrivalTimeRawString.split(separator: "T").last!) }
  var displayTime: String { return "\(departureTimeOnly) - \(arrivalTimeOnly)" }
  var displayStops: String {
    if stops == 0 { return TXT_TRIP_Direct }
    else { return "\(stops) \(TXT_TRIP_Stops)" }
  }
  var displayDesc: String { return "\(departureAirport!)-\(arrivalAirport!), \(airlineName!)" }
  var displayDuration: String { return durationMins.formattedMinsToDuration }
  
  static func parse(json: JSON) -> ItineraryLegData {
    let obj = ItineraryLegData()
    obj.id = json["id"].stringValue
    obj.departureAirport = json["departure_airport"].stringValue
    obj.arrivalAirport = json["arrival_airport"].stringValue
    obj.departureTimeRawString = json["departure_time"].stringValue
    obj.arrivalTimeRawString = json["arrival_time"].stringValue
    obj.stops = json["stops"].intValue
    obj.airlineName = json["airline_name"].stringValue
    obj.airlineId = json["airline_id"].stringValue
    obj.durationMins = json["duration_mins"].intValue
    return obj
  }
  
  static func parseArray(jsonArray: [JSON]) -> [ItineraryLegData] {
    var array = [ItineraryLegData]()
    for json in jsonArray {
      let obj = parse(json: json)
      array.append(obj)
    }
    return array
  }
}
