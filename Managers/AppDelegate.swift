import UIKit
import RealmSwift
import UserNotifications
import Cleanse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var navigationManager: NavigationManager!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let propertyInjector = try! ComponentFactory.of(AppComponent.self).build(())
    propertyInjector.injectProperties(into: self)
    
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

extension AppDelegate {
  func injectProperties(navigationManager: Cleanse.Provider<NavigationManager>) {
    self.navigationManager = navigationManager.get()
  }
}
