//
//  NTTabBarController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/12/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTTabBarController: UITabBarController {
    
    // MARK: - Initialization
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(viewControllers: [UIViewController]) {
        self.init()
        self.viewControllers = viewControllers
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 44
        tabFrame.origin.y = self.view.frame.size.height - 44
        self.tabBar.frame = tabFrame
        
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.shadowColor = Color.darkGray.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowOpacity = 0.3
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = Color.Defaults.navigationBarTint
        self.tabBar.backgroundColor = Color.Defaults.navigationBarBackground
    }
    
    public func setTabBar(hidden: Bool, animated: Bool) {
        
        if self.tabBar.isHidden == hidden {
            return
        }
        
        guard let frame = self.tabBarController?.tabBar.frame else {
            return
        }
        let height = frame.size.height
        let offsetY = hidden ? height : -height
        
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y + offsetY, width: frame.width, height: frame.height)
        }
    }
}
