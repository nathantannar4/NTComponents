//
//  NTTableViewCell.swift
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

open class NTTableViewCell: UITableViewCell {
    
    open override var reuseIdentifier: String? {
        get {
            return "NTTableViewCell"
        }
    }
    
    open override var selectionStyle: UITableViewCellSelectionStyle {
        didSet {
            if selectionStyle == .none {
                ripplePercent = 0
            } else {
                ripplePercent = 1.2
            }
        }
    }
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(style: .default, reuseIdentifier: "NTTableViewCell")
    }
    
    public convenience init(style: UITableViewCellStyle) {
        self.init(style: style, reuseIdentifier: "NTTableViewCell")
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var backgroundColor: UIColor? {
        get {
            return contentView.backgroundColor
        }
        set {
            contentView.backgroundColor = newValue
            rippleBackgroundColor = newValue ?? .clear
            rippleColor = rippleBackgroundColor.isLight ? rippleBackgroundColor.darker(by: 10) : rippleBackgroundColor.lighter(by: 10)
        }
    }
    
    // MARK: - Standard Methods
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        // Purposefully Empty
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Purposefully Empty
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if trackTouchLocation {
            rippleView.center = touches.first?.location(in: self) ?? contentView.center
        } else {
            rippleView.center = contentView.center
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
        return super.touchesBegan(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateToNormal()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateToNormal()
    }
    
    open var ripplePercent: Float = 1.2 {
        didSet {
            setupRippleView()
        }
    }
    
    open var rippleColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    
    open var rippleBackgroundColor: UIColor {
        get {
            return rippleBackgroundView.backgroundColor ?? .clear
        }
        set {
            rippleBackgroundView.backgroundColor = newValue
        }
    }
    
    open var rippleOverBounds: Bool = false
    open var shadowRippleRadius: Float = 1
    open var shadowRippleEnable: Bool = false
    open var trackTouchLocation: Bool = true
    open var touchUpAnimationTime: Double = 0.4
    
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
        
        selectionStyle = .none
        ripplePercent = 1.2
        tintColor = Color.Default.Tint.View
        textLabel?.setPreferredFontStyle(to: .body)
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        detailTextLabel?.setPreferredFontStyle(to: .footnote)
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.lineBreakMode = .byWordWrapping
        imageView?.tintColor = Color.Default.Tint.View
        imageView?.layer.cornerRadius = 5
        imageView?.layer.borderWidth = 0
        imageView?.layer.borderColor = Color.Default.Tint.View.cgColor
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.addSubview(rippleView)
        rippleBackgroundView.alpha = 0
        contentView.insertSubview(rippleBackgroundView, at: 0)
        
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
