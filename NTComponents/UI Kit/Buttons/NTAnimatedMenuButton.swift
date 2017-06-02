//
//  NTAnimatedMenuButton.swift
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

import Foundation
import QuartzCore
import UIKit

public enum DrawerSide: Int {
    case none
    case left
    case right
}

open class NTAnimatedMenuButton: NTButton {
    
    let top: CAShapeLayer = CAShapeLayer()
    let middle: CAShapeLayer = CAShapeLayer()
    let bottom: CAShapeLayer = CAShapeLayer()
    let strokeColor: UIColor
    
    // MARK: - Constants
    
    let animationDuration: CFTimeInterval = 8.0
    
    let longStroke: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 2, y: 2))
        path.addLine(to: CGPoint(x: 30, y: 2))
        return path
    }()
    
    let shortStroke: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 2, y: 2))
        path.addLine(to: CGPoint(x: 20, y: 2))
        return path
    }()
    
    // MARK: - Initializers
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
    }
    
    open override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, strokeColor: Color.Default.Tint.Button)
    }
    
    init(frame: CGRect, strokeColor: UIColor) {
        self.strokeColor = strokeColor
        super.init(frame: frame)
        touchUpAnimationTime = 0.2
        
        self.top.path = longStroke;
        self.middle.path = shortStroke;
        self.bottom.path = longStroke;
        
        for layer in [ self.top, self.middle, self.bottom ] {
            layer.fillColor = nil
            layer.strokeColor = self.strokeColor.cgColor
            layer.lineWidth = 2.4
            layer.miterLimit = 2
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            layer.cornerRadius = 5
            
            if let path = layer.path, let strokingPath = CGPath(__byStroking: path, transform: nil, lineWidth: 4, lineCap: .round, lineJoin: .miter, miterLimit: 4) {
                layer.bounds = strokingPath.boundingBoxOfPath
            }
            
            layer.actions = [
                "opacity": NSNull(),
                "transform": NSNull()
            ]
            
            self.layer.addSublayer(layer)
        }
        
        self.top.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.top.position = CGPoint(x: 31, y: 5)
        self.middle.position = CGPoint(x: 10, y: 15)
        self.bottom.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.bottom.position = CGPoint(x: 31, y: 25)
    }
    
    // MARK: - Animations
    
    open func animate(withPercentVisible percentVisible: CGFloat, drawerSide: DrawerSide) {
        
        if drawerSide == DrawerSide.left {
            self.top.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.top.position = CGPoint(x: 23, y: 7)
            self.middle.position = CGPoint(x: 13, y: 13)
            
            self.bottom.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.bottom.position = CGPoint(x: 23, y: 19)
        } else if drawerSide == DrawerSide.right {
            self.top.anchorPoint = CGPoint(x: 0, y: 0.5)
            self.top.position = CGPoint(x: 3, y: 7)
            self.middle.position = CGPoint(x: 13, y: 13)
            
            self.bottom.anchorPoint = CGPoint(x: 0, y: 0.5)
            self.bottom.position = CGPoint(x: 3, y: 19)
        }
        
        let middleTransform = CABasicAnimation(keyPath: "opacity")
        middleTransform.duration = animationDuration
        
        let topTransform = CABasicAnimation(keyPath: "transform")
        topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
        topTransform.duration = animationDuration
        topTransform.fillMode = kCAFillModeBackwards
        
        let bottomTransform = topTransform.copy() as! CABasicAnimation
        
        middleTransform.toValue = 1 - percentVisible
        
        let translation = CATransform3DMakeTranslation(-4 * percentVisible, 0, 0)
        
        let tanOfTransformAngle = 6.0/19.0
        let transformAngle = atan(tanOfTransformAngle)
        
        let sideInverter: CGFloat = drawerSide == DrawerSide.left ? -1 : 1
        topTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, 1.0 * sideInverter * (CGFloat(transformAngle) * percentVisible), 0, 0, 1))
        bottomTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, (-1.0 * sideInverter * CGFloat(transformAngle) * percentVisible), 0, 0, 1))
        
        topTransform.beginTime = CACurrentMediaTime()
        bottomTransform.beginTime = CACurrentMediaTime()
        
        self.top.add(topTransform, forKey: topTransform.keyPath)
        self.middle.add(middleTransform, forKey: middleTransform.keyPath)
        self.bottom.add(bottomTransform, forKey: bottomTransform.keyPath)
        
        self.top.setValue(topTransform.toValue, forKey: topTransform.keyPath!)
        self.middle.setValue(middleTransform.toValue, forKey: middleTransform.keyPath!)
        self.bottom.setValue(bottomTransform.toValue, forKey: bottomTransform.keyPath!)
    }
}

open class NTMenuBarButtonItem: UIBarButtonItem {
    
    var menuButton: NTAnimatedMenuButton
    
    // MARK: - Initializers
    
    public override init() {
        self.menuButton = NTAnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        super.init()
        self.customView = self.menuButton
    }
    
    public convenience init(target: AnyObject?, action: Selector) {
        self.init(target: target, action: action, menuIconColor: Color.Default.Tint.NavigationBar)
    }
    
    public convenience init(target: AnyObject?, action: Selector, menuIconColor: UIColor) {
        let menuButton = NTAnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30), strokeColor: menuIconColor)
        menuButton.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        menuButton.trackTouchLocation = false
        menuButton.ripplePercent = 1.5
        menuButton.touchUpAnimationTime = 0.4
        menuButton.rippleOverBounds = true
        
        
        self.init(customView: menuButton)
        
        self.menuButton = menuButton
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Animations
    
    open func animate(withPercentVisible percentVisible: CGFloat, drawerSide: DrawerSide) {
        if let btn = self.customView as? NTAnimatedMenuButton {
            btn.animate(withPercentVisible: percentVisible, drawerSide: drawerSide)
        }
    }
}
