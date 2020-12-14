import Foundation
import UIKit
import Kingfisher

class PhotoTableViewCell: RSTableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var photoImageView: UIImageView!
  
  override func setContent(_ cellHolder: TableCellHolder, width: CGFloat) {
    guard let photo = cellHolder.obj as? PhotoData else { return }
    titleLabel.text = "\(photo.description)\n\(photo.title!)"
    photoImageView.kf.setImage(with: URL(string: photo.thumbnailUrl))
  }
  
}

