//
//  ScaleBackTransitionAnimator.swift
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
//  Created by Nathan Tannar on 7/2/17.
//

open class ScaleBackTransitionAnimatorDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    open var delay: TimeInterval = 0
    open var duration: TimeInterval = 0.5
    open var scale: CGFloat = 0.85
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScaleBackTransitionAnimator(scale: scale, duration: duration, delay: delay, forwardTransition: true)
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScaleBackTransitionAnimator(scale: scale, duration: duration, delay: delay, forwardTransition: false)
    }
}

open class ScaleBackTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var forwardTransition = true
    open var delay: TimeInterval = 0
    open var duration: TimeInterval = 0.5
    open let scale: CGFloat
    
    public init(scale: CGFloat, duration: TimeInterval = 0.5, delay: TimeInterval = 0, forwardTransition: Bool) {
        self.scale = scale
        super.init()
        self.delay = delay
        self.duration = duration
        self.forwardTransition = forwardTransition
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let containerView = transitionContext.containerView
        
        if forwardTransition {
            containerView.addSubview(toVC.view)
            UIView.animate(withDuration: duration, delay: delay,
                           usingSpringWithDamping: 1, initialSpringVelocity: 0,
                           options: .beginFromCurrentState,
                           animations: {
                            fromVC.view.layer.transform = CATransform3DMakeScale(self.scale, self.scale, 1)
            }) { _ in
                transitionContext.completeTransition(true)
            }
        } else {
            UIView.animate(withDuration: duration, delay: delay,
                           usingSpringWithDamping: 1, initialSpringVelocity: 0,
                           options: .beginFromCurrentState,
                           animations: {
                            toVC.view.layer.transform = CATransform3DIdentity
            }) { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
}
