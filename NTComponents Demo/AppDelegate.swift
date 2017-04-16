//
//  AppDelegate.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 4/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Color.Defaults.viewControllerBackground = .white
        Color.Defaults.tabBarBackgound = .white
        Color.Defaults.navigationBarBackground = .white
        Color.Defaults.tabBarTint = UIColor(hex: "31485e")
        Color.Defaults.navigationBarTint = UIColor(hex: "31485e")
        Color.Defaults.tint = UIColor(hex: "31485e")
        Color.Defaults.buttonTint = UIColor(hex: "31485e")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let leftVC = NTViewController()
        leftVC.view.backgroundColor = Color.Defaults.tint
        let leftMenuLabel = NTLabel(type: .title)
        leftMenuLabel.textColor = .white
        leftMenuLabel.textAlignment = .center
        leftMenuLabel.text = "Left Navigation Drawer\n(A right one is available too!)"
        leftMenuLabel.numberOfLines = 0
        leftVC.view.addSubview(leftMenuLabel)
        leftMenuLabel.fillSuperview()
        
        let centerVC = NTScrollableTabBarController()
        centerVC.title = "NTComponents"
        centerVC.subtitle = "by Nathan Tannar"
        
        let tableVC = DemoTableViewController()
        centerVC.tabItems.append((tableVC, "Table View"))
        
        let colorsVC = DemoColorsCollectionView()
        centerVC.tabItems.append((colorsVC, "Colors"))
        
        let alertsVC = DemoAlertsViewController()
        centerVC.tabItems.append((alertsVC, "Alerts"))
        
        for i in 3...4 {
            let vc = NTViewController()
            vc.view.backgroundColor = .white
            centerVC.tabItems.append((vc, "Tab \(i + 1)"))
        }
        var properties = NTTabBarProperties()
        properties.tabWidth = window!.frame.width / CGFloat(centerVC.tabItems.count)
        centerVC.properties = properties
        centerVC.properties.hidesTabBarOnSwipe = true
        
        window?.rootViewController = NTNavigationContainer(centerView: centerVC, leftView: leftVC)
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

