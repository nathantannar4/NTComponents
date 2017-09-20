//
//  NTCheckbox.swift
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
//  Created by Nathan Tannar on 6/4/17.
//

open class NTCheckbox: UIControl, CAAnimationDelegate {
    
    open var checkBox: NTAnimatedView = {
        let view = NTAnimatedView()
        view.ripplePercent = 1.7
        view.touchUpAnimationTime = 0.4
        view.rippleOverBounds = true
        view.trackTouchLocation = false
        view.backgroundColor = .clear
        view.rippleColor = Color.Default.Tint.View.isLight ? Color.Default.Tint.View.darker(by: 10) : Color.Default.Tint.View.lighter(by: 10)
        view.rippleView.alpha = 0.3
        view.layer.borderWidth = 1.5
        view.layer.borderColor = Color.Gray.P500.cgColor
        return view
    }()
    
    open var pathLayer = CAShapeLayer()
    
    open let pathAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.2
        animation.fromValue = NSNumber(floatLiteral: 0)
        animation.toValue = NSNumber(floatLiteral: 1)
        return animation
    }()
    
    open let reverseAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.1
        animation.fromValue = NSNumber(floatLiteral: 1)
        animation.toValue = NSNumber(floatLiteral: 0)
        return animation
    }()
    
    open override var isSelected: Bool {
        set {
            super.isSelected = newValue
            if newValue {
                layer.addSublayer(pathLayer)
                pathLayer.strokeEnd = 1.0
                pathLayer.removeAllAnimations()
                pathLayer.add(pathAnimation, forKey:"strokeEnd")
                UIView.animate(withDuration: pathAnimation.duration, animations: {
                    self.checkBox.layer.borderColor = Color.Default.Tint.View.lighter(by: 20).cgColor
                    
                })
            } else {
                pathLayer.strokeEnd = 0.0
                pathLayer.removeAllAnimations()
                pathLayer.add(reverseAnimation, forKey:"strokeEnd")
                UIView.animate(withDuration: reverseAnimation.duration, animations: {
                    self.checkBox.layer.borderColor = Color.Gray.P500.cgColor
                })
            }
        }
        get {
            return super.isSelected
        }
    }
    
    open var isRippleEnabled: Bool = true
    fileprivate var rippleLayer: CAShapeLayer!
    
    // MARK: - Handlers
    
    open var onCheckboxChanged: ((NTCheckbox) -> Void)?
    
    @discardableResult
    open func onCheckboxChanged(_ handler: @escaping ((NTCheckbox) -> Void)) -> Self {
        onCheckboxChanged = handler
        return self
    }
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(checkBox)
        reverseAnimation.delegate = self
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(toggle(recognizer:)))
        addGestureRecognizer(singleTap)
        
        setupPathLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func checkPath() -> UIBezierPath {
        let size = bounds.height
        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: 0, y: size * 2 / 3))
        checkPath.addLine(to: CGPoint(x: size / 3, y: size))
        checkPath.addLine(to: CGPoint(x: size, y: 0))
        return checkPath
    }
    
    open func setupPathLayer() {
        pathLayer.frame = checkBox.bounds
        pathLayer.path = checkPath().cgPath
        pathLayer.strokeColor = Color.Default.Tint.View.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 3.5
        pathLayer.lineCap = kCALineCapRound
        pathLayer.lineJoin = kCALineJoinBevel
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        checkBox.frame = bounds
        setupPathLayer()
    }
    
    @objc open func toggle(recognizer: UITapGestureRecognizer) {
        isSelected = !isSelected
        checkBox.autoAnimate()
        onCheckboxChanged?(self)
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        pathLayer.removeFromSuperlayer()
    }
}
