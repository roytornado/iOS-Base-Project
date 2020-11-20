import UIKit

enum LanguageLocale: String {
  case english = "en"
  case traditionalChinese = "zh-Hant"
}

func ResString(_ key : String) -> String{
  if !key.starts(with: "TXT_") { return key }
  var string = LanguageManager.shared.stringManager.getString(key)
  string = string.replacingOccurrences(of: "&amp;", with: "&")
  return string
}

class LanguageManager {
  
  static var shared = LanguageManager()
  fileprivate let stringManager = RSMultiLanguage(locales: LanguageLocale.english.rawValue, LanguageLocale.traditionalChinese.rawValue)
  
  var currentLanguageLocale: LanguageLocale { return LanguageLocale(rawValue: stringManager.locale)! }
  var currentLanguageForServer: String {
    switch LanguageManager.shared.currentLanguageLocale {
    case .english:
      return "en"
    case .traditionalChinese:
      return "zh_hant"
    }
  }
  
  init() {
    if let storedLang = UserDefaults.standard.string(forKey: UserDefaultLang) {
      stringManager.locale = storedLang
    } else {
      if let language = Locale.preferredLanguages.first, language.contains("en") {
        stringManager.locale = LanguageLocale.english.rawValue
      } else {
        stringManager.locale = LanguageLocale.traditionalChinese.rawValue
      }
      UserDefaults.standard.set(stringManager.locale, forKey: UserDefaultLang)
    }
  }
  
  func updateLanguage(locale: LanguageLocale) {
    stringManager.locale = locale.rawValue
    UserDefaults.standard.set(locale.rawValue, forKey: UserDefaultLang)
  }
}
