//
//  AppDelegate.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 4/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents


class ContainerView: UIViewController {
    
    var topView: UIViewController
    var bottomView: UIViewController
    
    init(topView: UIViewController, bottomView: UIViewController) {
        self.topView = topView
        self.bottomView = bottomView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods -
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(topView)
        view.addSubview(topView.view)
        topView.didMove(toParentViewController: self)
        
        addChildViewController(bottomView)
        view.addSubview(bottomView.view)
        bottomView.didMove(toParentViewController: self)
        
        topView.view.anchor(view.topAnchor, left: view.leftAnchor, bottom: bottomView.view.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomView.view.anchor(topView.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        topView.view.anchorHeightToItem(bottomView.view)
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Color.Default.setPrimary(to: .white)
        Color.Default.setSecondary(to: UIColor(hex: "31485e"))
        Color.Default.Background.Button = UIColor(hex: "31485e")
        Color.Default.Text.Title = .black
        Color.Default.Text.Subtitle = Color.Gray.P700
        Color.Default.Tint.Inactive = Color.Gray.P500
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let leftVC = NTViewController()
        leftVC.view.backgroundColor = UIColor(hex: "31485e")
        let leftMenuLabel = NTLabel(style: .title)
        leftMenuLabel.textColor = .white
        leftMenuLabel.textAlignment = .center
        leftMenuLabel.text = "Left Navigation Drawer\n(A right one is available too!)"
        leftMenuLabel.numberOfLines = 0
        leftVC.view.addSubview(leftMenuLabel)
        leftMenuLabel.fillSuperview()
        
        
        
        let tableVC = TableViewController()
        
        let alertsVC = AlertsViewController()
        
        var tabVCs = [UIViewController]()
        for i in 0...2 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.groupTableViewBackground.darker(by: CGFloat(i * 5))
            vc.title = "Title"
            vc.tabBarItem.image = Icon.google
            tabVCs.append(vc)
        }
    
        let mapVC = MapViewController()
        mapVC.title = "MapView"
        
        let loginVC = NTLoginViewController()
        loginVC.logo = #imageLiteral(resourceName: "BANNER")
        loginVC.title = "Login"
        
        let profileVC = NTProfileViewController()
        profileVC.title = "Profile"
        
        let centerVC = NTScrollableTabBarController(viewControllers: [tableVC, alertsVC, profileVC, loginVC])
        centerVC.title = "NTComponents"
        centerVC.subtitle = "by Nathan Tannar"
        centerVC.currentTabBarHeight = 2.5
        centerVC.tabBarHeight = 25
        centerVC.tabBarPosition = .top
        
        let root = NTNavigationContainer(centerView: centerVC, leftView: leftVC)
        
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

