import Foundation
import UIKit
import SwiftyJSON

class NavigationManager {
  
  static var shared = NavigationManager()
  
  lazy var storyboardMain = UIStoryboard(name: "Main", bundle: nil)
  var mainNavigationController: UINavigationController!
  
  func resetHome() {
    mainNavigationController.viewControllers = [storyboardMain.instantiateViewController(withIdentifier: "LandingViewController")]
  }
}
