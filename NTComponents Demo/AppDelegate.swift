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
        
        /// Set your preferred colors
        Color.Default.setPrimary(to: UIColor(hex: "31485e"))
        Color.Default.setSecondary(to: .white)
        Color.Default.setTertiary(to: UIColor(hex: "baa57b"))
        Color.Default.Background.ViewController = Color.Gray.P100
        
        /// Set a specific default
        Color.Default.Tint.Toolbar = UIColor(hex: "31485e")
        
        /// Set shadow preverence
//        Color.Default.setCleanShadow()
        
        /// Set your preferred font
        Font.Default.Title = Font.Roboto.Medium.withSize(15)
        Font.Default.Subtitle = Font.Roboto.Regular
        Font.Default.Body = Font.Roboto.Regular.withSize(13)
        Font.Default.Caption = Font.Roboto.Medium.withSize(12)
        Font.Default.Subhead = Font.Roboto.Light.withSize(14)
        Font.Default.Headline = Font.Roboto.Medium.withSize(15)
        Font.Default.Callout = Font.Roboto.Regular.withSize(15)
        Font.Default.Footnote = Font.Roboto.Light.withSize(12)
        
        
        
        
        
        /// Setting trace level to MAX
        Log.setTraceLevel(to: .debug)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        
        /// Creating a slide show controller
        var items = [NTOnboardingDataSet(image: #imageLiteral(resourceName: "NT Components Banner"), title: "NTComponents", subtitle: "Demo", body: "Here lies source code examples to demonstrate how easy it is to make beautiful apps with NTComponents")]
        
        for _ in 0...2 {
            let randomItem = NTOnboardingDataSet(image: #imageLiteral(resourceName: "NT Components Banner"), title: Lorem.words(nbWords: 3), subtitle: Lorem.sentence(), body: Lorem.paragraph())
            items.append(randomItem)
        }
        
        let root = NTOnboardingViewController(dataSource: NTOnboardingDatasource(withValues: items))
        
        /// Set completion to our login page
        root.completionViewController = NTNavigationController(rootViewController: LoginViewController())
    
        /// Skip showing slide show
        window?.rootViewController = root
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
