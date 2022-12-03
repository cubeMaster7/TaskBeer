//
//  MTUserDefaults.swift
//  TaskBeer
//
//  Created by Paul James on 06.11.2022.
//

import Foundation


struct MTUserDefaults {
    static var shared = MTUserDefaults()
    
    var theme: Theme {
        get{
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .light
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
