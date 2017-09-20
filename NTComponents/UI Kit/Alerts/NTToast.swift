//
//  NTToast.swift
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

open class NTToast: NTAnimatedView {

    open var currentState: NTViewState = .hidden
    open var dismissOnTap: Bool = true
    
    open let label: NTLabel = {
        let label = NTLabel(style: .body)
        return label
    }()
    
    open let button: NTButton = {
        let button = NTButton()
        button.backgroundColor = .clear
        button.trackTouchLocation = false
        button.contentHorizontalAlignment = .center
        button.ripplePercent = 0.7
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    public convenience init(text: String?, color: UIColor = Color.Gray.P800, actionTitle: String, target: Any, selector: Selector) {
        
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - 50
        bounds.size.height = 50
        
        self.init(frame: bounds)
        
        backgroundColor = color
        
        label.text = text
        label.textColor = color.isLight ? .black : .white
        
        button.rippleColor = color.isLight ? color.darker(by: 10) : color.lighter(by: 10)
        button.title = actionTitle
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: button.leftAnchor, topConstant: 2, leftConstant: 12, bottomConstant: 2, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        button.anchor(label.topAnchor, left: nil, bottom: label.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 60, heightConstant: 0)
    }
    
    public convenience init(text: String?, color: UIColor = Color.Gray.P800, height: CGFloat = 50) {

        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - height
        bounds.size.height = height

        self.init(frame: bounds)

        backgroundColor = color

        label.text = text
        label.textColor = color.isLight ? .black : .white
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 12, bottomConstant: 2, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        ripplePercent = 1.5
        touchUpAnimationTime = 0.4
        addSubview(label)
        addSubview(button)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc internal func didTap(_ recognizer: UITapGestureRecognizer) {
        if dismissOnTap {
            dismiss()
        }
    }

    open func show(_ view: UIView? = UIApplication.presentedController?.view, duration: TimeInterval? = 2) {
        if currentState != .hidden { return }
        guard let view = view else { return }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(NTToast.didTap(_:))))
        frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: self.frame.height)
        view.addSubview(self)
        currentState = .transitioning
        UIView.transition(with: self, duration: 0.3, options: .curveLinear, animations: {() -> Void in
            self.frame = CGRect(x: 0, y: view.frame.height - self.frame.height, width: view.frame.width, height: self.frame.height)
        }, completion: { finished in
            self.currentState = .visible
            guard let duration = duration else { return }
            DispatchQueue.executeAfter(duration, closure: {
                self.dismiss()
            })
        })
    }

    @objc open func dismiss() {
        if currentState != .visible {
            return
        }
        currentState = .transitioning
        button.isEnabled = false
        UIView.transition(with: self, duration: 0.6, options: .curveLinear, animations: {() -> Void in
            self.alpha = 0
        }, completion: { finished in
            self.currentState = .hidden
            self.removeFromSuperview()
        })
    }
    
    open override func animateToNormal() {
        // Purposefully Empty
    }

    open class func genericErrorMessage() {
        let alert = NTToast(text: "Sorry, an error occurred")
        alert.show(duration: 3.0)
    }
}
