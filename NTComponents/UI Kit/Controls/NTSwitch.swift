//
//  NTSwitch.swift
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
//  Adapted from https://github.com/JaleelNazir/MJMaterialSwitch to support auto
//  layout and NTComponents integration
//


open class NTSwitch: UIControl {
    
    open var isOn: Bool = false {
        didSet {
            if oldValue != isOn {
                self.onSwitchChanged?(self)
            }
        }
    }
    
    open var isBounceEnabled: Bool = false {
        didSet {
            if isBounceEnabled {
                bounceOffset = 3.0
            } else {
                bounceOffset = 0.0
            }
        }
    }

    open var isRippleEnabled: Bool = true
    
    open var sliderOnTintColor: UIColor = Color.Default.Tint.View {
        didSet {
            rippleColor = sliderOnTintColor.isLight ? sliderOnTintColor.darker(by: 10) : sliderOnTintColor.lighter(by: 10)
        }
    }

    open var trackOnTintColor: UIColor = Color.Default.Tint.View.lighter(by: 20)
    open var trackOffTintColor: UIColor = Color.Gray.P500
    open var sliderOffTintColor: UIColor = Color.Gray.P300
    open var sliderDisabledTintColor: UIColor = Color.Gray.P300
    open var trackDisabledTintColor: UIColor = Color.Gray.P300
    open var rippleColor: UIColor = Color.Default.Tint.View.isLight ? Color.Default.Tint.View.darker(by: 10) : Color.Default.Tint.View.lighter(by: 10)
    
    open var slider: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.shadowOpacity = Color.Default.Shadow.Opacity
        button.layer.shadowOffset = CGSize(width: 0.0, height: Color.Default.Shadow.Offset.height)
        button.layer.shadowColor = Color.Default.Shadow.cgColor
        button.layer.shadowRadius = Color.Default.Shadow.Radius
        return button
    }()
    
    open var track: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Gray.P500
        return view
    }()
    
    fileprivate var thumbOnPosition: CGFloat = 0
    fileprivate var thumbOffPosition: CGFloat = 0
    fileprivate var bounceOffset: CGFloat = 3.0
    fileprivate var rippleLayer: CAShapeLayer!
    
    // MARK: - Handlers
    
    open var onSwitchChanged: ((NTSwitch) -> Void)?
    
    @discardableResult
    open func onSwitchChanged(_ handler: @escaping ((NTSwitch) -> Void)) -> Self {
        onSwitchChanged = handler
        return self
    }
    
    // MARK: - Initializer
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(track)
        addSubview(slider)
        
        addGestureRecognizers()
        setOn(on: isOn, animated: false)
    }
    
    public convenience init(frame: CGRect, isOn: Bool) {
        self.init(frame: frame)
        
        setOn(on: isOn, animated: false)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var trackFrame: CGRect = .zero
        var thumbFrame: CGRect = .zero
        
        trackFrame.size.height = frame.height / 2.2
        trackFrame.size.width = frame.size.width
        trackFrame.origin.x = 0.0
        trackFrame.origin.y = (frame.size.height - trackFrame.size.height) / 2
        thumbFrame.size.height = frame.width * 5 / 8
        thumbFrame.size.width = thumbFrame.size.height
        thumbFrame.origin.x = 0.0
        thumbFrame.origin.y = (frame.size.height - thumbFrame.size.height) / 2
        
        track.frame = trackFrame
        track.layer.cornerRadius = min(track.frame.size.height, track.frame.size.width) / 2
        
        slider.frame = thumbFrame
        slider.layer.cornerRadius = slider.frame.size.height / 2
        thumbOnPosition = frame.size.width - slider.frame.size.width
        thumbOffPosition = slider.frame.origin.x
    }
    
    open func addGestureRecognizers() {
        slider.addTarget(self, action: #selector(onTouchDown(btn:withEvent:)), for: UIControlEvents.touchDown)
        slider.addTarget(self, action: #selector(onTouchUpOutsideOrCanceled(btn:withEvent:)), for: UIControlEvents.touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTapped), for: UIControlEvents.touchUpInside)
        slider.addTarget(self, action: #selector(onTouchDragInside(btn:withEvent:)), for: UIControlEvents.touchDragInside)
        slider.addTarget(self, action: #selector(onTouchUpOutsideOrCanceled(btn:withEvent:)), for: UIControlEvents.touchCancel)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(switchAreaTapped(recognizer:)))
        addGestureRecognizer(singleTap)
    }

    open func setOn(on: Bool, animated: Bool)  {
        if on {
            if animated {
                changeThumbStateONwithAnimation()
            } else {
                changeThumbStateONwithoutAnimation()
            }
        } else {
            if animated {
                changeThumbStateOFFwithAnimation()
            } else {
                changeThumbStateOFFwithoutAnimation()
            }
        }
    }
    
    open func setEnabled(enabled: Bool)  {
        super.isEnabled = enabled
        
        UIView.animate(withDuration: 0.1) {
            if enabled {
                if self.isOn {
                    self.slider.backgroundColor = self.sliderOnTintColor
                    self.track.backgroundColor = self.trackOnTintColor
                } else {
                    self.slider.backgroundColor = self.sliderOffTintColor
                    self.track.backgroundColor = self.trackOffTintColor
                }
                self.isEnabled = true
                
            } else {
                self.slider.backgroundColor = self.sliderDisabledTintColor
                self.track.backgroundColor = self.trackDisabledTintColor
                self.isEnabled = false
            }
        }
    }
    
    @objc open func switchAreaTapped(recognizer: UITapGestureRecognizer) {
        changeThumbState()
    }
    
    fileprivate func changeThumbState() {
        
        if isOn {
            changeThumbStateOFFwithAnimation()
        } else {
            changeThumbStateONwithAnimation()
        }
        
        if isRippleEnabled {
            animateRippleEffect()
        }
    }
    
    fileprivate func changeThumbStateONwithAnimation() {
        
        // switch movement animation
        UIView.animate(withDuration: 0.15, delay: 0.05, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            
            var thumbFrame = self.slider.frame
            thumbFrame.origin.x = self.thumbOnPosition + self.bounceOffset
            self.slider.frame = thumbFrame
            if self.isEnabled {
                self.slider.hideShadow()
                self.slider.backgroundColor = self.sliderOnTintColor
                self.track.backgroundColor = self.trackOnTintColor
            } else {
                self.slider.backgroundColor = self.sliderDisabledTintColor
                self.track.backgroundColor = self.trackDisabledTintColor
            }
            self.isUserInteractionEnabled = false
            
        }) { (finished) in
            
            // change state to ON
            if self.isOn {
                self.isOn = true // Expressly put this code here to change surely and send action correctly
                self.sendActions(for: UIControlEvents.valueChanged)
            }
            self.isOn = true
            
            UIView.animate(withDuration: 0.15, animations: {
                // Bounce to the position
                var thumbFrame = self.slider.frame
                thumbFrame.origin.x = self.thumbOnPosition
                self.slider.frame = thumbFrame
                
            }, completion: { (finished) in
                self.isUserInteractionEnabled = true
            })
        }
    }
    
    fileprivate func changeThumbStateOFFwithAnimation() {
        
        // switch movement animation
        UIView.animate(withDuration: 0.15, delay: 0.05, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            var thumbFrame = self.slider.frame
            thumbFrame.origin.x = self.thumbOffPosition - self.bounceOffset
            self.slider.frame = thumbFrame
            if self.isEnabled {
                self.slider.backgroundColor = self.sliderOffTintColor
                self.track.backgroundColor = self.trackOffTintColor
            } else {
                self.slider.setDefaultShadow()
                self.slider.backgroundColor = self.sliderDisabledTintColor
                self.track.backgroundColor = self.trackDisabledTintColor
            }
            self.isUserInteractionEnabled = false
            
        }) { (finished) in
            
            // change state to OFF
            if self.isOn {
                self.isOn = false // Expressly put this code here to change surely and send action correctly
                self.sendActions(for: UIControlEvents.valueChanged)
            }
            self.isOn = false
            
            UIView.animate(withDuration: 0.15, animations: {
                
                // Bounce to the position
                var thumbFrame = self.slider.frame
                thumbFrame.origin.x = self.thumbOffPosition
                self.slider.frame = thumbFrame
            }, completion: { (finish) in
                self.isUserInteractionEnabled = true
            })
        }
    }
    
    // Without animation
    fileprivate func changeThumbStateONwithoutAnimation() {
        
        var thumbFrame = slider.frame
        thumbFrame.origin.x = thumbOnPosition
        slider.frame = thumbFrame
        if isEnabled {
            slider.backgroundColor = sliderOnTintColor
            track.backgroundColor = trackOnTintColor
        } else {
            slider.hideShadow()
            slider.backgroundColor = sliderDisabledTintColor
            track.backgroundColor = trackDisabledTintColor
        }
        
        if isOn {
            isOn = true
            sendActions(for: UIControlEvents.valueChanged)
        }
        isOn = true
    }
    
    // Without animation
    fileprivate func changeThumbStateOFFwithoutAnimation() {
        
        var thumbFrame = slider.frame
        thumbFrame.origin.x = thumbOffPosition
        slider.frame = thumbFrame
        
        if isEnabled {
            slider.backgroundColor = sliderOffTintColor
            track.backgroundColor = trackOffTintColor
        } else {
            slider.setDefaultShadow()
            slider.backgroundColor = sliderDisabledTintColor
            track.backgroundColor = trackDisabledTintColor
        }
        
        if isOn {
            isOn = false
            sendActions(for: UIControlEvents.valueChanged)
        }
        isOn = false
    }
    
    fileprivate func initializeRipple() {
        // Ripple size is twice as large as switch thumb
        let rippleScale : CGFloat = 2
        var rippleFrame = CGRect.zero
        rippleFrame.origin.x = -slider.frame.size.width / (rippleScale * 2)
        rippleFrame.origin.y = -slider.frame.size.height / (rippleScale * 2)
        rippleFrame.size.height = slider.frame.size.height * rippleScale
        rippleFrame.size.width = rippleFrame.size.height
        
        let path = UIBezierPath(roundedRect: rippleFrame, cornerRadius: slider.layer.cornerRadius*2)
        
        rippleLayer = CAShapeLayer()
        rippleLayer.path = path.cgPath
        rippleLayer.frame = rippleFrame
        rippleLayer.opacity = 0.2
        rippleLayer.strokeColor = UIColor.clear.cgColor
        rippleLayer.fillColor = rippleColor.cgColor
        rippleLayer.lineWidth = 0
    
        slider.layer.insertSublayer(rippleLayer, below: slider.layer)
    }
    
    open func animateRippleEffect() {
        
        if rippleLayer == nil {
            initializeRipple()
        }
        
        rippleLayer.opacity = 0.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if self.rippleLayer != nil {
                self.rippleLayer.removeFromSuperlayer()
                self.rippleLayer = nil
            }
        }
        
        // Scale ripple to the modelate size
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 1.25
        
        // Alpha animation for smooth disappearing
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0.4
        alphaAnimation.toValue = 0
        
        // Do above animations at the same time with proper duration
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        rippleLayer.add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
    //MARK: - Event Actions
    @objc func onTouchDown(btn: UIButton, withEvent event: UIEvent) {
        
        if isRippleEnabled {
            
            if rippleLayer == nil {
                initializeRipple()
            }
            
            // Animate for appearing ripple circle when tap and hold the switch thumb
            CATransaction.begin()
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.0
            scaleAnimation.toValue = 1.0
            
            let alphaAnimation = CABasicAnimation(keyPath:"opacity")
            alphaAnimation.fromValue = 0
            alphaAnimation.toValue = 0.2
            
            // Do above animations at the same time with proper duration
            let animation = CAAnimationGroup()
            animation.animations = [scaleAnimation, alphaAnimation]
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            rippleLayer.add(animation, forKey: nil)
            CATransaction.commit()
        }
    }
    

    @objc internal func sliderTapped() {
        changeThumbState()
    }
    
    // Change thumb state when touchUPOutside action is detected
    @objc internal func onTouchUpOutsideOrCanceled(btn: UIButton, withEvent event: UIEvent) {
        
        // print("Touch released at ouside")
        if let touch = event.touches(for: btn)?.first {
            
            let prevPos = touch.previousLocation(in: btn)
            let pos = touch.location(in: btn)
            
            let dX = pos.x - prevPos.x
            
            //Get the new origin after this motion
            let newXOrigin = btn.frame.origin.x + dX
            
            if (newXOrigin > (frame.size.width - slider.frame.size.width)/2) {
                changeThumbStateONwithAnimation()
            } else {
                changeThumbStateOFFwithAnimation()
            }
            
            if isRippleEnabled {
                animateRippleEffect()
            }
        }
    }
    
    // Drag the switch thumb
    @objc internal func onTouchDragInside(btn: UIButton, withEvent event:UIEvent) {
        //This code can go awry if there is more than one finger on the screen
        
        if let touch = event.touches(for: btn)?.first {
            
            let prevPos = touch.previousLocation(in: btn)
            let pos = touch.location(in: btn)
            let dX = pos.x - prevPos.x
            
            //Get the original position of the thumb
            var thumbFrame = btn.frame
            
            thumbFrame.origin.x += dX
            //Make sure it's within two bounds
            thumbFrame.origin.x = min(thumbFrame.origin.x, thumbOnPosition)
            thumbFrame.origin.x = max(thumbFrame.origin.x, thumbOffPosition)
            
            //Set the thumb's new frame if need to
            if thumbFrame.origin.x != btn.frame.origin.x {
                btn.frame = thumbFrame
            }
        }
    }
}
