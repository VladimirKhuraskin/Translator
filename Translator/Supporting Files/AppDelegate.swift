//
//  AppDelegate.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 20.08.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.5713245763, green: 0.7592576958, blue: 1, alpha: 1)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
    
}

