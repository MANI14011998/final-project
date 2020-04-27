//
//  AppDelegate.swift
//  Todo_with_chatbot
//
//  Created by MANINDER SINGH on 27/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import UIKit
import RealmSwift
import ApiAI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configuration = AIDefaultConfiguration()
               configuration.clientAccessToken = "27b5d4f55c4e405bbe4b4b90e5000429"
               
               let apiai = ApiAI.shared()
               apiai?.configuration = configuration
        
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        
        
        return true
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    
    
    
}

