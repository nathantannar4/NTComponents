//
//  Toast.swift
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

public class Toast: NTAnimatedView {
    
    private var currentState: NTViewState = .hidden
    public var dismissOnTap: Bool = true
    
    public convenience init(text: String?) {
        self.init(text: text, color: Color.Gray.P800, height: 50)
    }
    
    public convenience init(text: String?, color: UIColor, height: CGFloat) {
        
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - height
        bounds.size.height = height
        
        self.init(frame: bounds)
        
        backgroundColor = color
        
        let label = NTLabel(style: .body)
        label.text = text
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.textColor = color.isLight ? .black : .white
        addSubview(label)
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 12, bottomConstant: 2, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        ripplePercent = 0.5
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let toast = Toast(text: "Sorry, an error occurred", color: Color.Gray.P600, height: 50)
        toast.dismissOnTap = true
        toast.show(duration: 1.5)
    }
}
