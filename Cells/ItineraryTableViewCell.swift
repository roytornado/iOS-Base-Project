import Foundation
import UIKit
import Kingfisher

class ItineraryTableViewCell: RSTableViewCell {
  
  @IBOutlet weak var startImageView: UIImageView!
  @IBOutlet weak var startTimeLabel: UILabel!
  @IBOutlet weak var startStopsLabel: UILabel!
  @IBOutlet weak var startDescLabel: UILabel!
  @IBOutlet weak var startDurationLabel: UILabel!
  
  @IBOutlet weak var endImageView: UIImageView!
  @IBOutlet weak var endTimeLabel: UILabel!
  @IBOutlet weak var endStopsLabel: UILabel!
  @IBOutlet weak var endDescLabel: UILabel!
  @IBOutlet weak var endDurationLabel: UILabel!
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var agentLabel: UILabel!

  
  override func setContent(_ cellHolder: TableCellHolder, width: CGFloat) {
    guard let itinerary = cellHolder.obj as? ItineraryData else { return }
    backgroundView?.backgroundColor = UIColor.white
    priceLabel.text = itinerary.price
    agentLabel.text = "\(TXT_TRIP_Via) \(itinerary.agent!)"
    
    let firstLeg = itinerary.legs.first!
    setLegContent(leg: firstLeg, imageView: startImageView, timeLabel: startTimeLabel, stopsLabel: startStopsLabel, descLabel: startDescLabel, durationLabel: startDurationLabel)
    
    let lastLeg = itinerary.legs.last!
    setLegContent(leg: lastLeg, imageView: endImageView, timeLabel: endTimeLabel, stopsLabel: endStopsLabel, descLabel: endDescLabel, durationLabel: endDurationLabel)
  }
  
  func setLegContent(leg: ItineraryLegData, imageView: UIImageView, timeLabel: UILabel, stopsLabel: UILabel, descLabel: UILabel, durationLabel: UILabel) {
    imageView.kf.setImage(with: URL(string: leg.airlineThumbUrl))
    timeLabel.text = leg.displayTime
    stopsLabel.text = leg.displayStops
    descLabel.text = leg.displayDesc
    durationLabel.text = leg.displayDuration
  }
  
}

