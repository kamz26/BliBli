//
//  AppDelegate.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        presentInitialVc()
        return true
    }
    
    
    func presentInitialVc(){
        let vc = ProductSearchBaseVc.initFromNib()
        self.window?.rootViewController = vc
        
        self.window?.makeKeyAndVisible()
    }
}




