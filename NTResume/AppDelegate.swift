//
//  AppDelegate.swift
//  NTResume
//
//  Created by Nathan Tannar on 6/29/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// Set your preferred colors
        Color.Default.setPrimary(to: UIColor(r: 42, g: 66, b: 102))
        Color.Default.setSecondary(to: .white)
        Color.Default.setTertiary(to: UIColor(hex: "baa57b"))
        Color.Default.Background.Button = UIColor(r: 42, g: 66, b: 102)
        Color.Default.Background.ViewController = Color.Gray.P100
        
        Font.Default.Title = Font.Roboto.Medium.withSize(15)
        Font.Default.Subtitle = Font.Roboto.Regular
        Font.Default.Body = Font.Roboto.Regular.withSize(13)
        Font.Default.Caption = Font.Roboto.Medium.withSize(12)
        Font.Default.Subhead = Font.Roboto.Light.withSize(14)
        Font.Default.Headline = Font.Roboto.Medium.withSize(15)
        Font.Default.Callout = Font.Roboto.Regular.withSize(15)
        Font.Default.Footnote = Font.Roboto.Light.withSize(12)
        
        UIApplication.shared.isStatusBarHidden = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let tabbarVC = NTScrollableTabBarController(viewControllers: [InteractiveResumeViewController().withTitle("Resume")])
        tabbarVC.tabBarItemWidth = 50
        window?.rootViewController = ContainerController(centerViewController: tabbarVC, rightViewController: RightViewController())
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

