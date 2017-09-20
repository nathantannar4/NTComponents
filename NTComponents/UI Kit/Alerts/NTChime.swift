//
//  NTChime.swift
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
//  Created by Nathan Tannar on 5/17/17.
//

import UIKit

open class NTChime: NTAnimatedView, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate {
    
    fileprivate var statusBar: UIView? {
        get {
            return UIApplication.shared.value(forKey: "statusBar") as? UIView
        }
    }
    
    fileprivate static var currentChime: NTChime? {
        willSet {
            currentChime?.isHidden = true
            currentChime?.dismiss()
        }
    }
    
    open var iconView: NTImageView = {
        let imageView = NTImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = .white
        return imageView
    }()
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.font = Font.Default.Title.withSize(15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    open var subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subhead)
        label.font = Font.Default.Subtitle.withSize(13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        return blurEffectView
    }()
    
    open var animationDuration: Double = 0.4
    open var animationDelay: Double = 0
    open var animationSpringDamping: CGFloat = 0.8
    open var animationSpringVelocity: CGFloat = 1.2
    open var animationOptions: UIViewAnimationOptions = [.curveEaseIn]
    open var frameTopAnchor: NSLayoutConstraint?
    open var transition = CircularTransitionAnimator()
    open var height: CGFloat = 48
    open var detailController: UIViewController?
    
    fileprivate weak var parent: UIViewController?
    fileprivate var currentState: NTViewState = .hidden
    
    // MARK: - Initialization
    
    public convenience init(type: NTAlertType = NTAlertType.isInfo, title: String? = nil, subtitle: String? = nil, icon: UIImage? = nil, blurBackground: Bool = false, height: CGFloat = 48, detailViewController: UIViewController? = nil) {
        
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - height
        bounds.size.height = height
        self.init(frame: bounds)
        
        clipsToBounds = true
        layer.cornerRadius = 5
        backgroundColor = Color.Gray.P100
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconView.image = icon
        blurView.isHidden = !blurBackground
        self.height = height
        self.detailController = detailViewController
        
        let topView = UIView()
        addSubview(topView)
        topView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        let hasImage = iconView.image != nil
        iconView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        if hasImage {
            iconView.anchorAspectRatio()
        } else {
            iconView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        
        titleLabel.anchor(topView.topAnchor, left: iconView.rightAnchor, bottom: topView.bottomAnchor, right: topView.rightAnchor, topConstant: 0, leftConstant: hasImage ? 8 : 0, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        subtitleLabel.anchor(topView.bottomAnchor, left: iconView.rightAnchor, bottom: bottomAnchor, right: topView.rightAnchor, topConstant: 2, leftConstant: hasImage ? 8 : 0, bottomConstant: 6, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        switch type {
        case .isInfo:
            topView.backgroundColor = Color.Default.Status.Info
        case .isSuccess:
            topView.backgroundColor = Color.Default.Status.Success
        case .isWarning:
            topView.backgroundColor = Color.Default.Status.Warning
        case .isDanger:
            topView.backgroundColor = Color.Default.Status.Danger
        }
        
        iconView.tintColor = topView.backgroundColor
        
        if topView.backgroundColor!.isDark {
            titleLabel.textColor = .white
        }
    
        if detailController != nil {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            addGestureRecognizer(panGesture)
            let start = CGPoint(x: (frame.width / 2) - 25, y: height - 6)
            let middle = CGPoint(x: (frame.width / 2), y: height - 4)
            let end = CGPoint(x: (frame.width / 2) + 25, y: height - 6)
            drawLineFrom([start, middle, end], ofColor: backgroundColor!.isLight ? Color.Gray.P500 : UIColor.white, ofWidth: 2.5, cornerRadius: 1)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    open func presentDetailController() {
        guard let vc = detailController else { return }
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.view.layer.cornerRadius = 50
        currentState = .hidden
        parent?.present(vc, animated: true, completion: {
            self.blurBackground(false)
            self.isHidden = true
            vc.view.layer.cornerRadius = 0
        })
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
        super.touchesEnded(touches, with: event)
    }
    
    // MARK: - Presentation Methods
    
    open func show(_ viewController: UIViewController? = UIApplication.presentedController, duration: TimeInterval? = 3) {
        if currentState != .hidden { return }
        
        guard let viewController = viewController else { return }
        viewController.view.addSubview(self)
        
        statusBar?.isHidden = true
        
        frameTopAnchor = anchorWithReturnAnchors(viewController.view.topAnchor, left: viewController.view.leftAnchor, bottom: nil, right: viewController.view.rightAnchor, topConstant: -self.frame.height, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: self.frame.height)[0]
        
        currentState = .transitioning
        
        parent = viewController
        blurBackground(true)
        viewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration, delay: animationDelay, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationSpringVelocity, options: animationOptions, animations: {
            self.frameTopAnchor?.constant = 8
            NTChime.currentChime?.layer.shadowOpacity = 0
            viewController.view.layoutIfNeeded()
            
        }) { (finished) in
            self.currentState = .visible
            NTChime.currentChime = self
            guard let duration = duration else { return }
            DispatchQueue.executeAfter(duration, closure: {
                self.dismiss()
            })
        }
    }
    
    open func dismiss() {
        guard let parent = parent else { return }
        if currentState != .visible { return }
        currentState = .transitioning
        statusBar?.isHidden = false
        
        parent.view.layoutIfNeeded()
        blurBackground(false)
        UIView.animate(withDuration: 0.2, animations: {
            self.frameTopAnchor?.constant = -self.frame.height
            parent.view.layoutIfNeeded()
        }, completion: { finished in
            self.currentState = .hidden
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Background Blur
    
    open func blurBackground(_ isBlurred: Bool) {
        guard let view = parent?.view else { return }
        if isBlurred {
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                if blurView.superview == nil {
                    view.insertSubview(blurView, belowSubview: self)
                    blurView.fillSuperview()
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelBlur))
                    blurView.addGestureRecognizer(tapGesture)
                    UIView.animate(withDuration: animationDuration, delay: animationDelay, options: .curveLinear, animations: {
                        self.blurView.alpha = 0.3
                    }, completion: nil)
                }
            } else {
                Log.write(.warning, "UIAccessibilityIsReduceTransparencyEnabled returned true, will not blur background")
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.blurView.alpha = 0
            }, completion: { success in
                self.blurView.removeFromSuperview()
                self.blurView.gestureRecognizers?.removeAll()
            })
        }
    }
    
    @objc internal func cancelBlur() {
        blurBackground(false)
    }
    
    // MARK: - Pan Gesture
    
    @objc open func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let velocity = gestureRecognizer.velocity(in: self).y
        let translation = gestureRecognizer.translation(in: self)
        
        if gestureRecognizer.state == .began  || gestureRecognizer.state == .changed {
            
            if velocity < 0 {
                dismiss()
                return
            }
            blurView.alpha = 0
            blurView.isHidden = false
            
            var offset = translation.y
            if center.y >= 20 {
                statusBar?.isHidden = false
            }
            if center.y >= (height * 1.9) {
                offset = 10 * offset / center.y
                if center.y > (height * 2.1) {
                    presentDetailController()
                    gestureRecognizer.isEnabled = false
                }
            }
            blurView.alpha = (center.y / (height * 1.5) / 2) < 0.8 ? center.y / (height * 1.5) / 6 : 0.3
            
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + offset)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
            if velocity > 1500 {
                statusBar?.isHidden = false
                presentDetailController()
                gestureRecognizer.isEnabled = false
            }
        } else {
            dismiss()
        }
    }
    
    // MARK: - Transition
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.referenceView = self
        transition.startingPoint = center
        transition.rippleView.isHidden = true
        return transition
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        var center = UIApplication.presentedWindow?.center ?? CGPoint.zero
        if center.y > 0 {
            center.y = center.y / 6
        }
        transition.startingPoint = center
        transition.rippleView.isHidden = false
        transition.rippleView.backgroundColor = backgroundColor
        detailController?.view.backgroundColor = backgroundColor
        DispatchQueue.executeAfter(1) {
            self.currentState = .visible
            self.dismiss()
        }
        return transition
    }
}
