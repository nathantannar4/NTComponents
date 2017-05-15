//
//  NTViewController.swift
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
            UIApplication.shared.isStatusBarHidden = statusBarHidden
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
    
    // MARK: - Standard Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.Default.Background.ViewController
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.updateStatusBarStyle()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        statusBarHidden = false
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
