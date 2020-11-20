import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    RSButton.instanceTransformer = { button in
      button.touchAnimationMainFactor = 1.05
      button.touchAnimationParams.staringDuration = 0.8
      button.touchAnimationParams.endingDuration = 0.4
      button.touchAnimationParams.dampingRatio = 0.4
      button.touchAnimationParams.minFractionComplete = 0.1
    }
    Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    LogManager.info("App Start")
    return true
  }
}
