import Foundation
import UIKit
import SwiftyJSON
import Cleanse

class NavigationManager {
  
  static var shared: NavigationManager!
  
  lazy var storyboardMain = UIStoryboard(name: "Main", bundle: nil)
  var mainNavigationController: UINavigationController!
  var photoListViewControllerInjector: PropertyInjector<PhotoListViewController>!
  
  init(photoListViewControllerInjector: PropertyInjector<PhotoListViewController>) {
    LogManager.info("NavigationManager init")
    NavigationManager.shared = self
    self.photoListViewControllerInjector = photoListViewControllerInjector
  }
  
  func resetHome() {
    mainNavigationController.viewControllers = [storyboardMain.instantiateViewController(withIdentifier: "LandingViewController")]
  }
  
  func navigateToPhotoList() {
    let vc = storyboardMain.instantiateViewController(withIdentifier: "PhotoListViewController") as! PhotoListViewController
    photoListViewControllerInjector.injectProperties(into: vc)
    mainNavigationController.pushViewController(vc, animated: true)
  }
}
