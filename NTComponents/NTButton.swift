//
//  NTButton.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//
//  Ripple effect created by Amornchai Kanokpullwad on 6/26/14.
//  Copyright (c) 2014 zoonref. All rights reserved.

import UIKit
import QuartzCore

open class NTButton: UIButton {
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
        
        layer.borderColor = Color.Defaults.buttonTint.cgColor
        tintColor = Color.Defaults.buttonTint
        titleLabel?.textAlignment = .center
        titleLabel?.font = Font.Defaults.content
        setTitleColor(Color.Defaults.buttonTint, for: .normal)
        imageView?.contentMode = .scaleAspectFit
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    open var title: String? {
        get {
            return titleLabel?.text
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    open var titleColor: UIColor? {
        get {
            return titleLabel?.textColor
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    
    open var titleFont: UIFont? {
        get {
            return titleLabel?.font
        }
        set {
            titleLabel?.font = newValue
        }
    }
    
    open override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            rippleBackgroundColor = newValue ?? .white
            rippleColor = rippleBackgroundColor.isLight ? rippleBackgroundColor.darker(by: 10) : rippleBackgroundColor.lighter(by: 10)
        }
    }
    
    open var ripplePercent: Float = 0.8 {
        didSet {
            setupRippleView()
        }
    }
    
    open var rippleColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    
    open var rippleBackgroundColor: UIColor = .white {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    
    open var buttonCornerRadius: Float = 0 {
        didSet{
            layer.cornerRadius = CGFloat(buttonCornerRadius)
        }
    }
    
    open var rippleOverBounds: Bool = false
    open var shadowRippleRadius: Float = 1
    open var shadowRippleEnable: Bool = false
    open var trackTouchLocation: Bool = true
    open var touchUpAnimationTime: Double = 0.6
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    
    fileprivate var tempShadowRadius: CGFloat = 0
    fileprivate var tempShadowOpacity: Float = 0
    fileprivate var touchCenterLocation: CGPoint?
    
    fileprivate var rippleMask: CAShapeLayer? {
        get {
            if !rippleOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds,
                                              cornerRadius: layer.cornerRadius).cgPath
                return maskLayer
            } else {
                return nil
            }
        }
    }
    
    fileprivate func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.addSubview(rippleView)
        rippleBackgroundView.alpha = 0
        addSubview(rippleBackgroundView)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
    }
    
    fileprivate func setupRippleView() {
        let size: CGFloat = bounds.width * CGFloat(ripplePercent)
        let x: CGFloat = (bounds.width/2) - (size/2)
        let y: CGFloat = (bounds.height/2) - (size/2)
        let corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRect(x: x, y: y, width: size, height: size)
        rippleView.layer.cornerRadius = corner
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if trackTouchLocation {
            touchCenterLocation = touch.location(in: self)
        } else {
            touchCenterLocation = nil
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
        }, completion: nil)
        
        rippleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [UIViewAnimationOptions.curveEaseOut, UIViewAnimationOptions.allowUserInteraction],
                       animations: {
                        self.rippleView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        if shadowRippleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowOpacity = layer.shadowOpacity
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = shadowRippleRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = 1
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.isRemovedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            layer.add(groupAnim, forKey:"shadow")
        }
        return super.beginTracking(touch, with: event)
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animateToNormal()
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animateToNormal()
    }
    
    fileprivate func animateToNormal() {
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
        }, completion: {(success: Bool) -> () in
            UIView.animate(withDuration: self.touchUpAnimationTime, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.rippleBackgroundView.alpha = 0
            }, completion: nil)
        })
        
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
               animations: {
                self.rippleView.transform = CGAffineTransform.identity
                
                let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
                shadowAnim.toValue = self.tempShadowRadius
                
                let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
                opacityAnim.toValue = self.tempShadowOpacity
                
                let groupAnim = CAAnimationGroup()
                groupAnim.duration = 0.7
                groupAnim.fillMode = kCAFillModeForwards
                groupAnim.isRemovedOnCompletion = false
                groupAnim.animations = [shadowAnim, opacityAnim]
                
                self.layer.add(groupAnim, forKey:"shadowBack")
        }, completion: nil)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        setupRippleView()
        if let knownTouchCenterLocation = touchCenterLocation {
            rippleView.center = knownTouchCenterLocation
        }
        
        rippleBackgroundView.layer.frame = bounds
        rippleBackgroundView.layer.mask = rippleMask
    }

}
