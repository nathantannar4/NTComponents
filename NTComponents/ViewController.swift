//
//  ViewController.swift
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

public extension UIViewController {
    
    public func makeKeyAndVisible(animated: Bool = false)  {
        guard let vc = NTAlertViewController.topWindow()?.rootViewController else {
            Log.write(.error, "Could not find the active window")
            return
        }
        vc.present(self, animated: animated, completion: nil)
    }
    
    class func topWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindowLevelNormal && !window.isHidden && window.frame != CGRect.zero {
                return window
            }
        }
        return nil
    }
    
    public func setTitleView(title: String? = nil, subtitle: String? = nil, titleColor: UIColor? = Color.Default.Text.Title, subtitleColor: UIColor? = Color.Default.Text.Subtitle) {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = titleColor ?? Color.Default.Text.Title
        titleLabel.font = Font.Default.Title.withSize(18)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.textColor = subtitleColor ?? Color.Default.Text.Subtitle
        subtitleLabel.font = Font.Default.Subtitle.withSize(14)
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        navigationItem.titleView = titleView
        
    }
    
    public func presentViewController(_ viewController: UIViewController, from: NTPresentationDirection, completion:  (() -> Void)?) {
        viewController.view.alpha = 0.0
        viewController.modalPresentationStyle = .overCurrentContext
        guard let windowFrame = self.view.window?.frame else {
            return
        }
        let viewFrame = viewController.view.frame
        let finalFrame = viewFrame
        self.present(viewController, animated: false) { () -> Void in
            switch from {
            case .top:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: -windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .right:
                viewController.view.frame = CGRect(x: windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            case .bottom:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .left:
                viewController.view.frame = CGRect(x: -windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            }
            viewController.view.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                viewController.view.frame = finalFrame
            }, completion: { (success) -> Void in
                if success && (completion != nil) {
                    completion!()
                }
            })
        }
    }
    
    func dismissViewController(to: NTPresentationDirection, completion:  (() -> Void)?) {
        let frame = self.view.frame
        guard let windowFrame = self.view.window?.frame else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            switch to {
            case .top:
                self.view.frame = CGRect(x: frame.origin.x, y: -windowFrame.height, width: frame.width, height: frame.height)
            case .right:
                self.view.frame = CGRect(x: windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            case .bottom:
                self.view.frame = CGRect(x: frame.origin.x, y: windowFrame.height, width: frame.width, height: frame.height)
            case .left:
                self.view.frame = CGRect(x: -windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }, completion: { (success) -> Void in
            if success == true {
                self.dismiss(animated: false, completion: {
                    if completion != nil {
                        completion!()
                    }
                })
            }
        })
    }
}

