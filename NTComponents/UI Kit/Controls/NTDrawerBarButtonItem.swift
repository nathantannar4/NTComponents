//
//  NTDrawerBarButtonItem.swift
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

open class NTDrawerBarButtonItem: UIBarButtonItem {
    
    open var menuButton: AnimatedMenuButton
    
    open class AnimatedMenuButton: UIButton {
        
        lazy var top: CAShapeLayer = CAShapeLayer()
        lazy var middle: CAShapeLayer = CAShapeLayer()
        lazy var bottom: CAShapeLayer = CAShapeLayer()
        
        
        let shortStroke: CGPath = {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 3.5, y: 6))
            path.addLine(to: CGPoint(x: 22.5, y: 6))
            return path
        }()
        
        
        // MARK: - Initializers
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override convenience init(frame: CGRect) {
            self.init(frame: frame, strokeColor: Color.Default.Tint.NavigationBar)
        }
        
        public init(frame: CGRect, strokeColor: UIColor) {
            super.init(frame: frame)
            
            self.top.path = shortStroke;
            self.middle.path = shortStroke;
            self.bottom.path = shortStroke;
            
            for layer in [ self.top, self.middle, self.bottom ] {
                layer.fillColor = nil
                layer.strokeColor = strokeColor.cgColor
                layer.lineWidth = 1
                layer.miterLimit = 2
                layer.lineCap = kCALineCapSquare
                layer.masksToBounds = true
                
                if let path = layer.path, let strokingPath = CGPath(__byStroking: path, transform: nil, lineWidth: 1, lineCap: .square, lineJoin: .miter, miterLimit: 4) {
                    layer.bounds = strokingPath.boundingBoxOfPath
                }
                
                layer.actions = [
                    "opacity": NSNull(),
                    "transform": NSNull()
                ]
                
                self.layer.addSublayer(layer)
            }
            
            self.top.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.top.position = CGPoint(x: 23, y: 7)
            self.middle.position = CGPoint(x: 13, y: 13)
            
            self.bottom.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.bottom.position = CGPoint(x: 23, y: 19)
        }
        
        open override func draw(_ rect: CGRect) {
            
            Color.Default.Tint.NavigationBar.setStroke()
            
            let context = UIGraphicsGetCurrentContext()
            context?.setShouldAntialias(false)
            
            let top = UIBezierPath()
            top.move(to: CGPoint(x:3,y:6.5))
            top.addLine(to: CGPoint(x:23,y:6.5))
            top.stroke()
            
            let middle = UIBezierPath()
            middle.move(to: CGPoint(x:3,y:12.5))
            middle.addLine(to: CGPoint(x:23,y:12.5))
            middle.stroke()
            
            let bottom = UIBezierPath()
            bottom.move(to: CGPoint(x:3,y:18.5))
            bottom.addLine(to: CGPoint(x:23,y:18.5))
            bottom.stroke()
        }
    }
    
    
    // MARK: - Initializers
    
    public override init() {
        self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        super.init()
        self.customView = self.menuButton
    }
    
    public convenience init(target: AnyObject?, action: Selector) {
        self.init(target: target, action: action, menuIconColor: Color.Default.Tint.NavigationBar)
    }
    
    public convenience init(target: AnyObject?, action: Selector, menuIconColor: UIColor) {
        self.init(target: target, action: action, menuIconColor: menuIconColor, animatable: true)
    }
    
    public convenience init(target: AnyObject?, action: Selector, menuIconColor: UIColor, animatable: Bool) {
        let menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26), strokeColor: menuIconColor)
        menuButton.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView: menuButton)
        
        self.menuButton = menuButton
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        super.init(coder: aDecoder)
        self.customView = self.menuButton
    }
}
