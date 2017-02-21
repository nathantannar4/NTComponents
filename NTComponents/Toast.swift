//
//  Toast.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/4/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

public class Toast: NTToolbar {
    
    private var currentState: NTViewState = .hidden
    public var dismissOnTap: Bool = false
    
    internal func didTap(_ recognizer: UITapGestureRecognizer) {
        if self.dismissOnTap {
            self.dismiss()
        }
    }
    
    public func show(_ view: UIView? = Toast.topWindow(), duration: TimeInterval? = nil) {
        if self.currentState != .hidden {
            return
        }
        guard let view = view else {
            return
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(Toast.didTap(_:))))
        self.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: self.frame.height)
        view.addSubview(self)
        self.currentState = .transitioning
        UIView.transition(with: self, duration: 0.3, options: .curveLinear, animations: {() -> Void in
            self.frame = CGRect(x: 0, y: view.frame.height - self.frame.height, width: view.frame.width, height: self.frame.height)
        }, completion: { finished in
            self.currentState = .visible
            guard let duration = duration else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(1000.0 * duration))) {
                self.dismiss()
            }
        })
    }
    
    public func dismiss() {
        if self.currentState != .visible {
            return
        }
        self.currentState = .transitioning
        UIView.transition(with: self, duration: 0.3, options: .curveLinear, animations: {() -> Void in
            self.alpha = 0
        }, completion: { finished in
            self.currentState = .hidden
            self.removeFromSuperview()
        })
    }
    
    class func topWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindowLevelNormal && !window.isHidden && window.frame != CGRect.zero {
                return window
            }
        }
        return nil
    }
    
    public class func genericErrorMessage() {
        let toast = Toast(text: "Sorry, an error occurred", button: nil, color: Color.darkGray, height: 44)
        toast.dismissOnTap = true
        toast.show(duration: 1.5)
    }
}
