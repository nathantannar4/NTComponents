//
//  NTViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/28/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTViewController: UIViewController {
    
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
    private var statusBarView = UIView()
    private var _fadeInNavBarOnScroll: Bool = false
    open var fadeInNavBarOnScroll: Bool {
        set {
            if newValue != self._fadeInNavBarOnScroll {
                self._fadeInNavBarOnScroll = newValue
                self.commitNavigationBarChanges()
            }
        }
        get {
            return self._fadeInNavBarOnScroll
        }
    }
    
    // MARK: - Status Bar
    open var statusBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    open override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        //statusBar.backgroundColor = UIColor.clear
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.commitNavigationBarChanges()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateStatusBarStyle()
        self.setStatusBarBackgroundColor()
    }
    
    private func commitNavigationBarChanges() {
        self.navigationController?.navigationBar.backgroundColor = Color.defaultNavbarBackground.withAlphaComponent(self.fadeInNavBarOnScroll ? 0 : 1)
        self.navigationController?.navigationBar.tintColor = Color.Defaults.tint
        self.navigationController?.navigationBar.isTranslucent = self.fadeInNavBarOnScroll
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.shadowColor = Color.darkGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.navigationController?.navigationBar.layer.shadowRadius = 1
        self.navigationController?.navigationBar.layer.shadowOpacity = self.fadeInNavBarOnScroll ? 0 : 0.3
        self.setStatusBarBackgroundColor()
        UIApplication.shared.statusBarStyle = self.fadeInNavBarOnScroll ? .lightContent : .default
    }
    
    public func updateStatusBarStyle() {
        guard let color = self.navigationController?.navigationBar.backgroundColor else {
            UIApplication.shared.statusBarStyle = .default
            return
        }
        if color.isLight  {
            UIApplication.shared.statusBarStyle = .default
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    public func setStatusBarBackgroundColor() {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        guard let color = self.navigationController?.navigationBar.backgroundColor else {
            return
        }
        //statusBar.backgroundColor = color
    }
    
    public func refreshTitleView(withAlpha alpha: CGFloat) {
        if self.title != nil {
            self.setTitleView(title: self.title, subtitle: self.subtitle, titleColor: Color.defaultTitle.withAlphaComponent(alpha), subtitleColor: Color.defaultSubtitle.withAlphaComponent(alpha))
        }
    }
}
