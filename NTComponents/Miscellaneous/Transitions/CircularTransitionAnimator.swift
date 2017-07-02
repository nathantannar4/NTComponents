//
//  CircularTransitionAnimator.swift
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
//  Created by Nathan Tannar on 5/30/17.
//

import UIKit

open class CircularTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum NTTransitionMode:Int {
        case present, dismiss, pop
    }
    
    open var rippleView = UIView()
    open var startingPoint: CGPoint = .zero {
        didSet {
            rippleView.center = startingPoint
        }
    }
    open weak var referenceView: UIView? {
        didSet {
            guard let center = referenceView?.center else { return }
            startingPoint = center
        }
    }
    
    open var duration = 0.3
    open var transitionMode: NTTransitionMode = .present
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                rippleView.setDefaultShadow()
                rippleView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                rippleView.layer.cornerRadius = (referenceView?.layer.cornerRadius ?? rippleView.frame.size.height / 2)
                rippleView.center = startingPoint
                rippleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(rippleView)
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.rippleView.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                    
                }, completion: { (success:Bool) in
                    self.referenceView = nil
                    transitionContext.completeTransition(success)
                })
            }
            
        } else {
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
//                rippleView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
//                rippleView.layer.cornerRadius = (referenceView?.layer.cornerRadius ?? rippleView.frame.size.height / 2)
//                rippleView.center = startingPoint
                
                rippleView.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                rippleView.layer.cornerRadius = (referenceView?.layer.cornerRadius ?? rippleView.frame.size.height / 2)
                rippleView.center = startingPoint
                
                
                UIView.animate(withDuration: duration, animations: {
                    self.rippleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.rippleView, belowSubview: returningView)
                    }
                }, completion: { (success:Bool) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    
                    self.rippleView.removeFromSuperview()
                    transitionContext.completeTransition(success)
                    
                })
            }
        }
    }
    
    open func frameForCircle(withViewCenter viewCenter:CGPoint, size viewSize: CGSize, startPoint:CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
        
    }
}

