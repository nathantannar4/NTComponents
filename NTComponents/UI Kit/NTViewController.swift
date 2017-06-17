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

open class NTViewController: UIViewController {
    
    
    /// Calls setTitleView after being set to refresh the titleView with the .title NTPreferredFontStyle
    override open var title: String? {
        didSet {
            if shouldAutoUpdateTitleView {
                setTitleView(title: self.title, subtitle: self.subtitle, titleColor: Color.Default.Text.Title, subtitleColor: Color.Default.Text.Subtitle)
            }
        }
    }
    
    /// Calls setTitleView after being set to refresh the titleView with the .subtitle NTPreferredFontStyle
    open var subtitle: String? {
        didSet {
            if shouldAutoUpdateTitleView {
                setTitleView(title: self.title, subtitle: self.subtitle, titleColor: Color.Default.Text.Title, subtitleColor: Color.Default.Text.Subtitle)
            }
        }
    }
    
    open var shouldAutoUpdateTitleView: Bool = true
    
    // MARK: - Status Bar
    
    /// Modifies UIApplication.shared.isStatusBarHidden when set and animates the appearance update
    open var statusBarHidden: Bool = false {
        didSet {
            UIApplication.shared.isStatusBarHidden = statusBarHidden
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    
    /// The appearance update animation used when setting the status bar
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    /// Returns statusBarHidden to allow for easy appearance updates to teh status bar
    open override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    // MARK: - Standard Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.Default.Background.ViewController
    }
}
