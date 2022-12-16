//
//  LocalizationSystem.swift
//  TaskBeer
//
//  Created by Paul James on 15.12.2022.
//

import Foundation

class LocalizationSystem: NSObject {
    
    var bundle: Bundle!
    
    class var sharedInstance: LocalizationSystem {
        struct Singleton {
            static let instance: LocalizationSystem = LocalizationSystem()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        bundle = Bundle.main
    }
    
    func localizedStringForKey(key: String, comment: String) -> String {
        return bundle.localizedString(forKey: key, value: comment, table: nil)
    }
    
    func localizedImagePathForImg(imagename: String, type: String) -> String {
        guard let imagePath = bundle.path(forResource: imagename, ofType: type) else {
            return ""
        }
        return imagePath
    }
    
    //MARK: set language
    //sets the desired language of the ones you have.
    //if this function is no called it will use the default OS Language.
    //if the language does now exists y returns the defailt OS language.
    
    func setLanguage(languageCode: String) {
        var appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        appleLanguages.remove(at: 0)
        appleLanguages.insert(languageCode, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize() //needs restart
        
        if let languageDirectoryPath = Bundle.main.path(forResource: languageCode, ofType: "lproj") {
            bundle = Bundle.init(path: languageDirectoryPath)
        } else {
            resetLocalization()
        }
    }
    //MARK: resetLocalization
    //Reset localisation system, so it uses the OS defaul language.
    
    func resetLocalization() {
        bundle = Bundle.main
    }
    
    //MARK: gen language
    // Just gets the current setted up language
    
    func genLanguage() -> String {
        let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        let prefferedLanguage = appleLanguages[0]
        return prefferedLanguage
    }
}
