import UIKit

open class RSButton: UIButton {
  
  public static var instanceTransformer: ((RSButton) -> Void)! = {
    orginal in
    
  }
  
  public var metaObj : Any?
  @IBInspectable public var metaKey: String = ""
  @IBInspectable public var metaStyleKey: String = ""
  
  // MARK: >>> Layout
  public enum LayoutType: String {
    case imageAndText_LeftOfText
    case imageAndText_RightOfText
    case imageAndText_UpOfText
    case imageAndText_DownOfText
    case imageAndText_TextCenterImageLeft
    case imageAndText_TextCenterImageRight
    case imageAndText_LeftOfTextLeftAligned
    case imageAndText_RightOfTextLeftAligned
  }
  @IBInspectable var layoutKey: String = ""
  @IBInspectable var paddingImageAndText: CGFloat = 8
  @IBInspectable var paddingEdge: CGFloat = 16
  @IBInspectable var imageFixedSize: CGFloat = 0
  @IBInspectable var textMultiline: Bool = false
  // MARK: <<< Layout
  
  // MARK: >>> Decorations
  public let gradientLayer = CAGradientLayer()
  @IBInspectable var gradientBackground: Bool = false
  @IBInspectable var gradientColor1: UIColor = UIColor(red: 34.0/255.0, green: 211.0/255.0, blue: 198.0/255.0, alpha: 1.0)
  @IBInspectable var gradientColor2: UIColor = UIColor(red: 145.0/255.0, green: 72.0/255.0, blue: 203.0/255.0, alpha: 1.0)
  // 0 = Left to Right ; 1 = Top to Bottom ; 3 = Right to Left ; 4 = Bottom to Top
  // 5 = TopLeft to BottomRight ; 6 = TopRight to BottomLeft ; 7 = BottomRight to TopLeft ; 8 = BottomLeft to TopRight
  @IBInspectable var gradientDirection: Int = 0
  
  public let outlineLayer = CAShapeLayer()
  public enum OutlineType: String {
    case rect
    case rounded
    case flag
    case file_top
    case file_bottom
    case triangle
    case pentagon
    case hexagon
    case octagon
    case rhombus
    case parallelogram
    case trapezoid
  }
  @IBInspectable var outlineKey: String = "rect"
  @IBInspectable var outlineParam1: CGFloat = 0.25
  @IBInspectable var outlineColor: UIColor = UIColor.clear
  @IBInspectable var outlineWidth: CGFloat = 0
  
  @IBInspectable var roundedRadius: CGFloat = 0
  @IBInspectable var roundedAll: Bool = true
  @IBInspectable var roundedTopLeft: Bool = false
  @IBInspectable var roundedTopRight: Bool = false
  @IBInspectable var roundedBottomLeft: Bool = false
  @IBInspectable var roundedBottomRight: Bool = false
  
  @IBInspectable var shadowRadius: CGFloat = 0
  @IBInspectable var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.7)
  // MARK: <<< Decoration
  
  // MARK: >>> Animations
  public class TouchAnimationParams {
    open var staringDuration: Double = 0.8
    open var endingDuration: Double = 0.6
    open var dampingRatio: CGFloat = 0.4
    open var minFractionComplete: CGFloat = 0.1
  }
  
  open var touchAnimationParams = TouchAnimationParams()
  private var touchAnimator: UIViewPropertyAnimator?
  private var currentHandledHighlighted = false
  
  @IBInspectable var touchAnimationTypeKey: String = "fade"
  @IBInspectable var touchAnimationMainFactor: CGFloat = 1.0
  
  public enum TouchAnimationType: String {
    case none = ""
    case scaleUp
    case scaleDown
    case fade
  }
  
  public class TouchAnimationTypeScaleUpParams {
    open var scale: CGFloat = 1.05
  }
  public var touchAnimationTypeScaleUpParams = TouchAnimationTypeScaleUpParams()
  
  public class TouchAnimationTypeScaleDownParams {
    open var scale: CGFloat = 0.95
  }
  public var touchAnimationTypeScaleDownParams = TouchAnimationTypeScaleDownParams()
  
  public class TouchAnimationTypeFadeParams {
    open var fadeOutAlpha: CGFloat = 0.5
  }
  public var touchAnimationTypeFadeParams = TouchAnimationTypeFadeParams()
  // MARK: >>> Animations
  
  // MARK: <<< Badge
  public enum BadgeOutlineType: String {
    case topRight
    case right
    case textTopRight
    case textRight
  }
  public enum BadgeAnimation: String {
    case flip
    case right
    case textTopRight
    case textRight
  }
  public let badgeView = UILabel()
  @IBInspectable public var badgeColor: UIColor = UIColor.red
  @IBInspectable public var badgeTextColor: UIColor = UIColor.white
  @IBInspectable public var badgeValue: Int = 0 // <0 -> badge without number; 0 -> hidden
  @IBInspectable public var badgeSize: CGFloat = 16 // Font size for numbered badge; Diameter for circle badge
  @IBInspectable public var badgeOffset: CGFloat = 8
  @IBInspectable public var badgeLayoutKey: String = "topRight"
  // MARK: >>> Badge
  
  // MARK: <<< Loading
  
  // MARK: >>> Loading
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  func setup() {
    adjustsImageWhenHighlighted = false
    badgeView.backgroundColor = badgeColor
    badgeView.textColor = badgeTextColor
    badgeView.textAlignment = .center
    addSubview(badgeView)
    configTouchAnimation()
    RSButton.instanceTransformer(self)
  }
  
  override open func layoutSubviews() {
    // Prevent layout wrongly when transform is NOT identity
    if transform != CGAffineTransform.identity { return }
    super.layoutSubviews()
    layer.insertSublayer(gradientLayer, at: 0)
    layer.addSublayer(outlineLayer)
    layoutForType(layoutKey: layoutKey)
    configForGradient()
    configForOutline()
    configForBadge()
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = shadowRadius
    layer.shadowOpacity = shadowRadius > 0 ? 0.9 : 0.0
  }
  
  open func configForBadge() {
    bringSubviewToFront(badgeView)
    
    func layout(size: CGSize) {
      if let layout = BadgeOutlineType(rawValue: badgeLayoutKey) {
        if layout == .topRight {
          badgeView.frame = CGRect(x: width - badgeOffset - size.width, y: badgeOffset, width: size.width, height: size.height)
        }
        if layout == .right {
          badgeView.frame = CGRect(x: width - badgeOffset - size.width, y: height.half - size.height.half, width: size.width, height: size.height)
        }
        if layout == .textTopRight {
          if let titleLabel = titleLabel {
            badgeView.frame = CGRect(x: titleLabel.ending.x + badgeOffset, y: titleLabel.frame.origin.y + badgeOffset - size.height, width: size.width, height: size.height)
          }
        }
        if layout == .textRight {
          if let titleLabel = titleLabel {
            badgeView.frame = CGRect(x: titleLabel.ending.x + badgeOffset, y: height.half - size.height.half, width: size.width, height: size.height)
          }
        }
      }
    }
    
    if badgeValue == 0 {
      badgeView.isHidden = true
    } else if badgeValue < 0 {
      badgeView.isHidden = false
      badgeView.text = ""
      badgeView.layer.cornerRadius = badgeSize.half
      badgeView.clipsToBounds = true
      badgeView.frame = CGRect(x: width - badgeOffset - badgeSize, y: badgeOffset, width: badgeSize, height: badgeSize)
      layout(size: CGSize(width: badgeSize, height: badgeSize))
    } else {
      badgeView.isHidden = false
      badgeView.font = UIFont.systemFont(ofSize: badgeSize)
      badgeView.text = "\(badgeValue)"
      var size = badgeView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
      size.width = size.width + 16
      badgeView.layer.cornerRadius = size.height.half
      badgeView.clipsToBounds = true
      badgeView.frame = CGRect(x: width - badgeOffset - size.width, y: badgeOffset, width: size.width, height: size.height)
      layout(size: size)
    }
  }
  
  open func configForOutline() {
    outlineLayer.frame = bounds
    outlineLayer.strokeColor = outlineColor.cgColor
    outlineLayer.fillColor = UIColor.clear.cgColor
    outlineLayer.lineWidth = outlineWidth
    
    if let outline = OutlineType(rawValue: outlineKey) {
      if outline == .rect {
        applyPathForOutline(path: UIBezierPath(rect: bounds))
      }
      if outline == .rounded {
        var path: UIBezierPath!
        if roundedAll {
          path = UIBezierPath(roundedRect: bounds, cornerRadius: roundedRadius)
        } else {
          var corners = [UIRectCorner]()
          if roundedTopLeft { corners.append(.topLeft) }
          if roundedTopRight { corners.append(.topRight) }
          if roundedBottomLeft { corners.append(.bottomLeft) }
          if roundedBottomRight { corners.append(.bottomRight) }
          path = UIBezierPath(roundedRect: bounds, byRoundingCorners: UIRectCorner(corners), cornerRadii: CGSize(width: roundedRadius, height: roundedRadius))
        }
        applyPathForOutline(path: path)
      }
      if outline == .flag {
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: width, y: 0))
        let flagPoint = CGPoint(x: width * (1 - outlineParam1), y: height.half)
        path.addLine(to: flagPoint)
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .file_top {
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        let length = min(width * outlineParam1, height * outlineParam1)
        path.addLine(to: CGPoint(x: width - length, y: 0))
        path.addLine(to: CGPoint(x: width, y: length))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .file_bottom {
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: width, y: 0))
        let length = min(width * outlineParam1, height * outlineParam1)
        path.addLine(to: CGPoint(x: width, y: height - length))
        path.addLine(to: CGPoint(x: width - length, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .triangle {
        let path = UIBezierPath()
        let points = polygonPoints(sides: 3, origin: CGPoint(x: width.half, y: height.half), radius: height.half, adjustment: 90)
        for (index, point) in points.enumerated() {
          let point = CGPoint(x: point.x, y: point.y + height.half * 0.1)
          if index == 0 { path.move(to: point)}
          else { path.addLine(to: point) }
        }
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .pentagon {
        let path = UIBezierPath()
        let points = polygonPoints(sides: 5, origin: CGPoint(x: width.half, y: height.half), radius: height.half, adjustment: 90)
        for (index, point) in points.enumerated() {
          if index == 0 { path.move(to: point)}
          else { path.addLine(to: point) }
        }
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .hexagon {
        let path = UIBezierPath()
        let points = polygonPoints(sides: 6, origin: CGPoint(x: width.half, y: height.half), radius: height.half, adjustment: 0)
        for (index, point) in points.enumerated() {
          if index == 0 { path.move(to: point)}
          else { path.addLine(to: point) }
        }
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .octagon {
        let path = UIBezierPath()
        let points = polygonPoints(sides: 8, origin: CGPoint(x: width.half, y: height.half), radius: height.half, adjustment: 0)
        for (index, point) in points.enumerated() {
          if index == 0 { path.move(to: point)}
          else { path.addLine(to: point) }
        }
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .rhombus {
        let path = UIBezierPath()
        let points = polygonPoints(sides: 4, origin: CGPoint(x: width.half, y: height.half), radius: height.half, adjustment: 0)
        for (index, point) in points.enumerated() {
          if index == 0 { path.move(to: point)}
          else { path.addLine(to: point) }
        }
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .parallelogram {
        let length = min(width * outlineParam1, height * outlineParam1)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: length, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width - length, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        applyPathForOutline(path: path)
      }
      if outline == .trapezoid {
        let length = min(width * outlineParam1, height * outlineParam1)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: length, y: 0))
        path.addLine(to: CGPoint(x: width - length, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        applyPathForOutline(path: path)
      }
    } else {
      outlineLayer.path = nil
      gradientLayer.mask = nil
      layer.shadowPath = nil
    }
  }
  
  public func applyPathForOutline(path: UIBezierPath) {
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    outlineLayer.path = path.cgPath
    gradientLayer.mask = maskLayer
    layer.shadowPath = path.cgPath
  }
  
  open func configForGradient() {
    gradientLayer.frame = bounds
    if let color = backgroundColor {
      gradientLayer.backgroundColor = color.cgColor
      backgroundColor = nil
    }
    if gradientBackground {
      backgroundColor = UIColor.clear
      gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
      
      // 0 = Left to Right ; 1 = Top to Bottom ; 2 = Right to Left ; 3 = Bottom to Top
      // 4 = TopLeft to BottomRight ; 5 = TopRight to BottomLeft ; 6 = BottomRight to TopLeft ; 7 = BottomLeft to TopRight
      // 8 = Radial
      gradientLayer.type = .axial
      if gradientDirection == 0 {
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
      }
      if gradientDirection == 1 {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
      }
      if gradientDirection == 2 {
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
      }
      if gradientDirection == 3 {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
      }
      if gradientDirection == 4 {
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
      }
      if gradientDirection == 5 {
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
      }
      if gradientDirection == 6 {
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
      }
      if gradientDirection == 7 {
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
      }
      if gradientDirection == 8 {
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
      }
      gradientLayer.colors = gradientColors()
    }
  }
  
  open func gradientColors() -> [CGColor] {
    return [gradientColor1.cgColor, gradientColor2.cgColor]
  }
  
  open func layoutForType(layoutKey: String) {
    if let layout = LayoutType(rawValue: layoutKey) {
      if let titleLabel = titleLabel {
        titleLabel.numberOfLines = textMultiline ? 0 : 1
      }
      if layout == .imageAndText_LeftOfText {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        let startX = width.half - totalWidth.half
        if let imageView = imageView, let titleLabel = titleLabel {
          imageView.frame = CGRect(x: startX, y: height.half - imageSize.height.half, width: imageSize.width, height: imageSize.height)
          titleLabel.frame = CGRect(x: imageView.ending.x + paddingImageAndText, y: height.half - textSize.height.half, width: textSize.width, height: textSize.height)
        }
      }
      if layout == .imageAndText_RightOfText {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        let startX = width.half - totalWidth.half
        if let imageView = imageView, let titleLabel = titleLabel {
          titleLabel.frame = CGRect(x: startX, y: height.half - textSize.height.half, width: textSize.width, height: textSize.height)
          imageView.frame = CGRect(x: titleLabel.ending.x + paddingImageAndText, y: height.half - imageSize.height.half, width: imageSize.width, height: imageSize.height)
        }
      }
      if layout == .imageAndText_UpOfText {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        let totalHeight = sizeForLabel.height + paddingImageAndText + sizeForImage.height
        let startY = height.half - totalHeight.half
        if let imageView = imageView, let titleLabel = titleLabel {
          imageView.frame = CGRect(x: width.half - imageSize.width.half, y: startY, width: imageSize.width, height: imageSize.height)
          titleLabel.frame = CGRect(x: width.half - textSize.width.half, y: imageView.ending.y + paddingImageAndText, width: textSize.width, height: textSize.height)
        }
      }
      if layout == .imageAndText_DownOfText {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        let totalHeight = sizeForLabel.height + paddingImageAndText + sizeForImage.height
        let startY = height.half - totalHeight.half
        if let imageView = imageView, let titleLabel = titleLabel {
          titleLabel.frame = CGRect(x: width.half - textSize.width.half, y: startY, width: textSize.width, height: textSize.height)
          imageView.frame = CGRect(x: width.half - imageSize.width.half, y: titleLabel.ending.y + paddingImageAndText, width: imageSize.width, height: imageSize.height)
        }
      }
      if layout == .imageAndText_TextCenterImageLeft {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        if let imageView = imageView, let titleLabel = titleLabel {
          imageView.frame = CGRect(x: paddingEdge, y: height.half - imageSize.height.half, width: imageSize.width, height: imageSize.height)
          titleLabel.frame = CGRect(x: width.half - textSize.width.half, y: height.half - textSize.height.half, width: textSize.width, height: textSize.height)
        }
      }
      if layout == .imageAndText_TextCenterImageRight {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        if let imageView = imageView, let titleLabel = titleLabel {
          imageView.frame = CGRect(x: width - paddingEdge - imageSize.width, y: height.half - imageSize.height.half, width: imageSize.width, height: imageSize.height)
          titleLabel.frame = CGRect(x: width.half - textSize.width.half, y: height.half - textSize.height.half, width: textSize.width, height: textSize.height)
        }
      }
      if layout == .imageAndText_LeftOfTextLeftAligned {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        let startX = paddingEdge
        if let imageView = imageView, let titleLabel = titleLabel {
          imageView.frame = CGRect(x: startX, y: height.half - imageSize.height.half, width: imageSize.width, height: imageSize.height)
          titleLabel.frame = CGRect(x: imageView.ending.x + paddingImageAndText, y: height.half - textSize.height.half, width: textSize.width, height: textSize.height)
        }
      }
      if layout == .imageAndText_RightOfTextLeftAligned {
        let textSize = sizeForLabel
        let imageSize = sizeForImage
        let startX = paddingEdge
        if let imageView = imageView, let titleLabel = titleLabel {
          titleLabel.frame = CGRect(x: startX, y: height.half - textSize.height.half, width: textSize.width, height: textSize.height)
          imageView.frame = CGRect(x: titleLabel.ending.x + paddingImageAndText, y: height.half - imageSize.height.half, width: imageSize.width, height: imageSize.height)
        }
      }
    }
  }

  override open var isHighlighted: Bool {
    didSet {
      if isHighlighted && !currentHandledHighlighted {
        currentHandledHighlighted = isHighlighted
        runTouchAnimation(duration: touchAnimationParams.staringDuration, animations: touchStartingAnimations, completion: touchStartingEnded)
      } else if !isHighlighted && currentHandledHighlighted {
        currentHandledHighlighted = isHighlighted
        runTouchAnimationAfterFractionCompleted(duration: touchAnimationParams.endingDuration, fractionComplete: touchAnimationParams.minFractionComplete, animations: touchEndingAnimations)
      }
    }
  }
  
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    //print("touchesBegan")
  }
  
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    //print("touchesEnded")
  }
  
  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    //print("touchesCancelled")
  }
  
  func configTouchAnimation() {
    if let type = TouchAnimationType(rawValue: touchAnimationTypeKey) {
      if type == .scaleUp {
      }
      if type == .scaleDown {
      }
      if type == .fade {
        touchAnimationParams.staringDuration = 0.2
        touchAnimationParams.endingDuration = 0.2
        touchAnimationParams.dampingRatio = 1.0
        touchAnimationParams.minFractionComplete = 1.0
      }
    }
  }
  
  func runTouchAnimationAfterFractionCompleted(duration: Double, fractionComplete: CGFloat, animations: @escaping (() -> Void)) {
    if let touchAnimator = touchAnimator, touchAnimator.isRunning, touchAnimator.fractionComplete < fractionComplete {
      let remainingDuration = Double(fractionComplete - touchAnimator.fractionComplete) * touchAnimator.duration
      //print("touchAnimator remainingDuration \(remainingDuration)")
      DispatchQueue.main.asyncAfter(deadline: .now() + remainingDuration) { self.runTouchAnimation(duration: duration, animations: animations) }
    } else {
      runTouchAnimation(duration: duration, animations: animations)
    }
  }
  
  func runTouchAnimation(duration: Double, animations: @escaping (() -> Void), completion: (() -> Void)? = nil) {
    if let touchAnimator = touchAnimator {
      //print("touchAnimator fractionComplete \(touchAnimator.fractionComplete)")
      if touchAnimator.isRunning { touchAnimator.stopAnimation(true) }
      self.touchAnimator = nil
    }
    touchAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: touchAnimationParams.dampingRatio, animations: animations)
    touchAnimator?.addCompletion { position in
      //print("touchAnimator addCompletion \(self.touchAnimator?.fractionComplete) \(position.rawValue)")
      if position == UIViewAnimatingPosition.end {
        self.touchAnimator = nil
        completion?()
      }
    }
    touchAnimator?.startAnimation()
  }
  
  func stopTouchAnimation() {
    if let touchAnimator = touchAnimator {
      if touchAnimator.isRunning { touchAnimator.stopAnimation(true) }
      self.touchAnimator = nil
    }
  }
  
  func touchStartingEnded() {
    //print("[RSButton] touchStartingEnded")
  }
  
  func touchStartingAnimations() {
    if let type = TouchAnimationType(rawValue: touchAnimationTypeKey) {
      if type == .scaleUp {
        let scale = touchAnimationTypeScaleUpParams.scale * touchAnimationMainFactor
        transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
      }
      if type == .scaleDown {
        let scale = touchAnimationTypeScaleDownParams.scale * touchAnimationMainFactor
        transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
      }
      if type == .fade {
        alpha = touchAnimationTypeFadeParams.fadeOutAlpha * touchAnimationMainFactor
      }
    }
  }
  
  func touchEndingAnimations() {
    if let type = TouchAnimationType(rawValue: touchAnimationTypeKey) {
      if type == .scaleUp {
        transform = CGAffineTransform.identity
      }
      if type == .scaleDown {
        transform = CGAffineTransform.identity
      }
      if type == .fade {
        alpha = 1.0
      }
    }
  }
  
  public func changeBadge(value: Int, transition: UIView.AnimationOptions = .transitionFlipFromTop) {
    badgeValue = value
    configForBadge()
    UIView.transition(with: badgeView, duration: 0.6, options: transition, animations: nil, completion: nil)
  }
}


extension UIView {
  var starting : (CGPoint) {
    return CGPoint(x: self.frame.origin.x , y: self.frame.origin.y)
  }
  var ending : (CGPoint) {
    return CGPoint(x: self.frame.origin.x + self.frame.width , y: self.frame.origin.y + self.frame.height)
  }
  var width : (CGFloat) {
    return self.bounds.width
  }
  var height : (CGFloat) {
    return self.bounds.height
  }
}

extension RSButton {
  var sizeForLabel: CGSize {
    if let titleLabel = titleLabel {
      return titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }
    return CGSize.zero
  }
  
  var sizeForImage: CGSize {
    if let image = imageView?.image {
      if imageFixedSize > 0 {
        return CGSize(width: imageFixedSize, height: imageFixedSize)
      }
      return image.size
    }
    return CGSize.zero
  }
  
  func sizeForLabel(width: CGFloat) -> CGSize {
    if let titleLabel = titleLabel {
      titleLabel.numberOfLines = 0
      return titleLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    return CGSize.zero
  }
  
  var totalWidth: CGFloat {
    return sizeForLabel.width + paddingImageAndText + sizeForImage.width
  }
  
  func polygonPoints(sides: Int, origin: CGPoint, radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
    let angle = (360 / CGFloat(sides)).degreesToRadians
    var points = [CGPoint]()
    for i in 0..<sides {
      let xpo = origin.x - radius * cos(angle * CGFloat(i) + adjustment.degreesToRadians)
      let ypo = origin.y - radius * sin(angle * CGFloat(i) + adjustment.degreesToRadians)
      points.append(CGPoint(x: xpo, y: ypo))
    }
    return points
  }
}

extension CGFloat {
  var double: CGFloat { return self * 2 }
  var half: CGFloat { return self / 2 }
  var asFloat: Float { return Float(self) }
  var asDouble: Double { return Double(self) }
  var asInt: Int { return Int(self) }
}

extension BinaryInteger {
  var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
  var degreesToRadians: Self { return self * .pi / 180 }
  var radiansToDegrees: Self { return self * 180 / .pi }
}
