//
//  AppDelegate.swift
//  TaskBeer
//
//  Created by Paul James on 05.11.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notifications = Notifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //notification
        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        
        //настройки рилма
        let config = Realm.Configuration(
            //тут мы устанавливаем новую версию конфигурации. Меняем цифру в случае если поменяли что-то в базе
            schemaVersion: 3,
    
            migrationBlock: {migration,oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    
                }
            })
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }
    //MARK: - ориентация
    var orientationLock = UIInterfaceOrientationMask.all
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
            
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
 
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }


}

