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
        
        Color.Default.setPrimary(to: .white)
        Color.Default.setSecondary(to: UIColor(hex: "31485e"))
        Color.Default.Background.Button = UIColor(hex: "31485e")
        Color.Default.setCleanShadow()
        
        Font.Default.Title = Font.Roboto.Medium.withSize(15)
        Font.Default.Subtitle = Font.Roboto.Regular
        Font.Default.Body = Font.Roboto.Regular.withSize(13)
        Font.Default.Caption = Font.Roboto.Medium.withSize(12)
        Font.Default.Subhead = Font.Roboto.Light.withSize(14)
        Font.Default.Headline = Font.Roboto.Medium.withSize(15)
        Font.Default.Callout = Font.Roboto.Regular.withSize(15)
        Font.Default.Footnote = Font.Roboto.Light.withSize(12)
        
        Log.setTraceLevel(to: .off)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let loginVC = NTLoginViewController()
        loginVC.logo = #imageLiteral(resourceName: "NT Components Banner")
        loginVC.title = "Login"
        
        let sampleVC = NTScrollableTabBarController(viewControllers: [loginVC, NTLandingViewController().withTitle("Landing")])
        sampleVC.tabBarHeight = 32
        sampleVC.tabBarPosition = .top
        sampleVC.title = "Other"
        sampleVC.tabBarItemWidth = 50
        sampleVC.viewDidLoad()
        
        let core = NTScrollableTabBarController(viewControllers: [FormViewController().withTitle("Form"), TableViewController().withTitle("TableView"), CollectionViewController().withTitle("CollectionView"), ColorsCollectionView().withTitle("Colors")])
        core.tabBarHeight = 32
        core.tabBarPosition = .top
        core.title = "Core"
        core.viewDidLoad()
        
        let tabbarVC = NTScrollableTabBarController(viewControllers: [core, AlertsViewController().withTitle("Alerts"), sampleVC])
        tabbarVC.title = "NTComponents"
        tabbarVC.subtitle = "Demo"
        tabbarVC.tabBarHeight = 44
        tabbarVC.tabBarPosition = .bottom
        tabbarVC.currentTabBarHeight = 0
        tabbarVC.viewDidLoad()
        
        let root = NTNavigationContainer(centerView: tabbarVC, leftView: NTNavigationController(rootViewController: AuthorViewController()))
        root.leftPanelWidth = 350
        
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

//class ViewController: UIViewController, NTTagListViewDelegate {
//    
//    var tagListView = NTTagListView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.addSubview(tagListView)
//        tagListView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 100)
//        
//        tagListView.enableDeleteButton = true
//        tagListView.cornerRadius = 5
//        
//        tagListView.tagDelegate = self
//        for _ in 0...20 {
//            tagListView.addTag("This is a tag")
//        }
////        tagListView.addTag("On tap will be removed").onTap = { [weak self] tagView in
////            self?.tagListView.removeTagView(tagView)
////        }
//        
//    }
//    
//    // MARK: TagListViewDelegate
//    func tagPressed(_ title: String, tagView: NTTagView, sender: NTTagListView) {
//        print("Tag pressed: \(title), \(sender)")
//        tagView.isSelected = !tagView.isSelected
//    }
//    
//    func tagDeleteButtonPressed(_ title: String, tagView: NTTagView, sender: NTTagListView) {
//        print("Tag Remove pressed: \(title), \(sender)")
//        sender.removeTagView(tagView)
//    }
//}
//
//
//
