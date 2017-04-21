//
//  NTTabBarController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/12/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTTabBarController: UITabBarController, NTTabBarDelegate {
    
    open var animatedTabBar: NTTabBar = {
        let tabBar = NTTabBar()
        return tabBar
    }()
    
    open override var viewControllers: [UIViewController]? {
        didSet {
            guard let viewControllers = viewControllers else { return }
            
            animatedTabBar.setItems(
                viewControllers.map({ (vc) -> NTTabBarItem in
                    let item = NTTabBarItem()
                    item.title = vc.title
                    item.image = vc.tabBarItem.image
                    item.selectedImage = vc.tabBarItem.selectedImage
                    return item
                }))
            
        }
    }
    
    // MARK: - Initialization
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        tabBar.removeFromSuperview()
        animatedTabBar.delegate = self
        view.addSubview(animatedTabBar)
        animatedTabBar.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
        
    }
    
    public convenience init(viewControllers: [UIViewController]) {
        self.init()
        self.viewControllers = viewControllers
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - NTTabBarDelegate
    
    open func tabBar(_ tabBar: NTTabBar, didSelect index: Int) {
        selectedIndex = index
    }
    
    // MARK: - UITabBarControllerDelegate
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Log.write(.status, "NTTabBarController - Selected '\(viewController.title ?? "nil Title")'")
    }
    
//    open override func viewWillLayoutSubviews() {
//        var tabFrame = self.tabBar.frame
//        tabFrame.size.height = 44
//        tabFrame.origin.y = self.view.frame.size.height - 44
//        self.tabBar.frame = tabFrame
//    }
    
    open func setTabBar(hidden: Bool, animated: Bool) {
        
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
