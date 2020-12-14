import UIKit
import RSLoadingView

class RSTableView: UITableView {
  
  // MARK: Callbacks
  var reloadingBlock: (() -> Void)?
  var loadMoreBlock: (() -> Void)?
  
  private var contentOffsetContext: UInt8 = 1
  var pullToRefreshControl: UIRefreshControl!
  var loadingView: RSLoadingView!
  var bgView = UIImageView()
  
  deinit {
    removeObserver(self, forKeyPath: "contentOffset")
  }
  
  override func awakeFromNib() {
    setup()
  }
  
  func setup() {
    backgroundColor = UIColor.clear
    separatorStyle = .none
    estimatedRowHeight = 44
    bgView.contentMode = .scaleAspectFill
    addSubview(bgView)
    alwaysBounceVertical = true
    pullToRefreshControl = UIRefreshControl()
    pullToRefreshControl.tintColor = UIColor.white
    pullToRefreshControl.addTarget(self, action: #selector(reloadTriggered), for: .valueChanged)
    loadingView = RSLoadingView(effectType: .spinAlone)
    loadingView.shouldDimBackground = false
    loadingView.mainColor = UIColor.white
    loadingView.lifeSpanFactor = 0.6
    loadingView.spreadingFactor = 4.5
    loadingView.sizeFactor = 1.0
    loadingView.speedFactor = 3.0
    loadingView.sizeInContainer = CGSize(width: 60, height: 60)
    addObserver(self, forKeyPath: "contentOffset", options: .new, context: &contentOffsetContext)
    hideLoading()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    sendSubviewToBack(bgView)
    bgView.frame = bounds
  }
  
  func setPullToRefresh(enabled: Bool) {
    pullToRefreshControl.removeFromSuperview()
    if enabled {
      addSubview(pullToRefreshControl)
    }
  }
  
  func showLoadingForFirstPage() {
    if !pullToRefreshControl.isRefreshing {
      loadingView.show(on: self)
    }
  }
  
  func showLoadingForOthersPage() {
    showLoadingForFirstPage()
  }
  
  func hideLoading() {
    loadingView.hide()
    pullToRefreshControl.endRefreshing()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if context == &contentOffsetContext {
      let offsetForLastCell = contentSize.height - height + contentInset.top + contentInset.bottom
      if (contentOffset.y - offsetForLastCell) >= 0 {
        loadMoreTriggered()
      }
    }
  }
  
  @objc fileprivate func reloadTriggered() {
    reloadingBlock?()
  }
  
  @objc fileprivate func loadMoreTriggered() {
    loadMoreBlock?()
  }
}
