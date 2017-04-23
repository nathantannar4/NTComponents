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

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.Default.Background.ViewController
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateStatusBarStyle()
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
    
    public func refreshTitleView(withAlpha alpha: CGFloat) {
        if self.title != nil {
            self.setTitleView(title: self.title, subtitle: self.subtitle, titleColor: Color.Default.Text.Title.withAlphaComponent(alpha), subtitleColor: Color.Default.Text.Subtitle.withAlphaComponent(alpha))
        }
    }
}
