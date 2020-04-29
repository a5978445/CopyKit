//
//  CopyBundleProvider.swift
//  SampleApp
//
//  Created by 李腾芳 on 2020/4/29.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Foundation


let kLanguageCode = "languageCode"
let languageChangedNotification = Notification.Name(rawValue: "languageChangedNotification")


enum LanguageCode: String {
    case en = "en"
    case zhHans = "zh-Hans"
}

final class CopyBundleProvider: NSObject {
    static let shared: CopyBundleProvider = CopyBundleProvider()
    // 防止频繁初始化bundle， 影响性能
    lazy var bundle: Bundle = updateBundle()
    
    var languageCode: LanguageCode? {
        didSet {
            UserDefaults.standard.setValue(languageCode?.rawValue, forKey: kLanguageCode)
        }
        
        
    }
    
    func updateBundle() -> Bundle {
        
        let language = languageCode?.rawValue ?? Locale.current.localLanguage
        guard var path = Bundle.main.path(forResource: "HK", ofType: "bundle") else {
            fatalError("not found HK.bundle")
        }
        
        
        path += "/\(language).lproj"
        
        
        guard let localizedStringBundle = Bundle.init(path: path) else {
            fatalError("not found \(path)")
        }
        
        return localizedStringBundle
    }
    
    
    
    override init() {
        if let code = UserDefaults.standard.string(forKey: kLanguageCode) {
            languageCode = LanguageCode(rawValue: code)
        }
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: languageChangedNotification, object: nil)
    }
    
    @objc func languageChanged() {
        
        if let code = UserDefaults.standard.string(forKey: kLanguageCode) {
             languageCode = LanguageCode(rawValue: code)
         }
        
        bundle = updateBundle()
    }
    
    
}


extension CopyBundleProvider: CopyBundleCovertible {
    
    
    func asBundle() -> Bundle {
        
        
        
      
            
          
        print(bundle.localizedString(forKey: "age", value: nil, table: "Root"))
        
        return bundle
    }
    
    
}


extension Locale {
    var localLanguage: String {
        return identifier.components(separatedBy: "_").first ?? "en"
    }
    
    func asLanguageCode() -> LanguageCode? {
        return LanguageCode(rawValue: localLanguage)
    }
}
