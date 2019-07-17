//
//  AppDelegate.swift
//  Todoey
//
//  Created by Syeds on 13/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }catch{
            print("Error initializing new realm \(error)")
        }
        
        // this is to print the path where the persistant data is stored together with app id and NS id and device id
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        return true
    }


}

