import Foundation

typealias StringsDict = [String:String]

@objc open class RSMultiLanguage : NSObject {
    
    let levels = ["base", "sync", "project"]
    
    var languageLocaleList: [String]    
    var languageDict: [String:StringsDict] = [String:StringsDict]()
    var bundle: Bundle
    
    open var locale: String
    
    convenience public init(locales : String...) {
        self.init(bundle: Bundle.main, locale: Locale.current, locales: locales)
    }
    
    convenience public init(bundle: Bundle, locales : String...) {
        self.init(bundle: bundle, locale: Locale.current, locales: locales)
    }
    
    convenience public init(locale: Locale, locales : [String]) {
        self.init(bundle: Bundle.main, locale: locale, locales: locales)
    }
    
    convenience public init(bundle: Bundle, locale: Locale, locales : String...) {
        self.init(bundle: bundle, locale: locale, locales: locales)
    }
    
    public init(bundle: Bundle, locale: Locale, locales : [String]) {
        self.bundle = bundle
        self.languageLocaleList = locales
        self.locale = self.languageLocaleList[0]
        
        let language = locale.identifier
        print(language)
        if languageLocaleList.contains(language) {
            self.locale = language
        } 
        super.init()
        buildLanguageData()
    }

    open func getString(_ key: String) -> String {
        let wordings = languageDict[self.locale]
        if let w = wordings {
            if w.keys.contains(key) {
                return w[key]!
            }
        }
        NSException(name: NSExceptionName(rawValue: "KeyNotFoundException"),
            reason: "Key - \(key) not found in language [zh-Hant]",
            userInfo: nil).raise()
        return ""
    }

    func buildLanguageData(){
        languageDict.removeAll()
        
        for locale in languageLocaleList {
            var stringsDict : StringsDict = StringsDict()
            languageDict[locale] = stringsDict

            for level in levels {
                let fileName = locale + "." + level
                let filePath = self.bundle.path(forResource: fileName, ofType: "strings")
                if filePath == nil {
                    printLog(fileName + " is not available")
                    continue
                }
                
                let rawStringDict = NSDictionary(contentsOfFile: filePath!)
                if let dict = rawStringDict {
                    for (rawStringKey, rawStringValue) in dict {
                        stringsDict[rawStringKey as! String] = rawStringValue as? String
                    }
                } else {
                    printLog(fileName + " is not available")
                    continue
                }
            }
            languageDict[locale] = stringsDict
        }
    }

    func printLog(_ log : String){
         print("[RSMultiLanguage] " + log)
    }

}
