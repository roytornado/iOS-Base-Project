import UIKit

class LandingViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NavigationManager.shared.mainNavigationController = navigationController
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction func changeToEn() {
    LanguageManager.shared.updateLanguage(locale: .english)
    NavigationManager.shared.resetHome()
  }
  
  @IBAction func changeToHant() {
    LanguageManager.shared.updateLanguage(locale: .traditionalChinese)
    NavigationManager.shared.resetHome()
  }
  
  @IBAction func actionStart() {
    NavigationManager.shared.navigateToPhotoList()
  }
}
