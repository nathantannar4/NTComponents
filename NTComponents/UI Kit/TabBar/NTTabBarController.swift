//
//  NTTabBarController.swift
//  NTComponents
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 2/12/17.
//

import UIKit

open class NTTabBarController: UITabBarController, NTTabBarDelegate {
    
    override open var title: String? {
        didSet {
            self.refreshTitleView(withAlpha: 1.0)
        }
    }
    open var subtitle: String? {
        didSet {
            self.refreshTitleView(withAlpha: 1.0)
        }
    }
    
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
    
    public func refreshTitleView(withAlpha alpha: CGFloat) {
        if self.title != nil {
            self.setTitleView(title: self.title, subtitle: self.subtitle, titleColor: Color.Default.Text.Title.withAlphaComponent(alpha), subtitleColor: Color.Default.Text.Subtitle.withAlphaComponent(alpha))
        }
    }
    
    // MARK: - NTTabBarDelegate
    
    open func tabBar(_ tabBar: NTTabBar, didSelect index: Int) {
        selectedIndex = index
    }
    
    // MARK: - UITabBarControllerDelegate
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Log.write(.status, "NTTabBarController - Selected '\(viewController.title ?? "nil Title")'")
    }
    
    open func setTabBar(hidden: Bool, animated: Bool) {
        
        if self.tabBar.isHidden == hidden {
            return
        }
        
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = hidden ? height : -height
        
        UIView.animate(withDuration: 0.3) {
            self.tabBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y + offsetY, width: frame.width, height: frame.height)
        }
    }
}
