import UIKit

class RSStackView: UIStackView {
  @IBInspectable var bgColor: UIColor = UIColor.clear
  @IBInspectable var bgCornerRadius: CGFloat = 0
  
  func createBackgroundView() -> UIView {
    let view = UIView()
    view.backgroundColor = bgColor
    view.layer.cornerRadius = bgCornerRadius
    return view
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    pinBackground(createBackgroundView())
  }
  
  private func pinBackground(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    insertSubview(view, at: 0)
    view.pinToSuperView()
  }
  
}


