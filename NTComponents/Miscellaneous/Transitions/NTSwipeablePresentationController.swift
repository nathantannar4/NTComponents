//
//  NTSwipeablePresentationController.swift
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
//  Created by Nathan Tannar on 6/2/17.
//


open class NTSwipeablePresentationController : UIPresentationController {
    var isMaximized: Bool = false
    
    open var darkView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Gray.P900
        view.alpha = 0
        return view
    }()
    
    open var presentedViewFrame: CGRect?
    
    public convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, frame: CGRect?) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.presentedViewFrame = frame
    }
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    open func adjustToFullScreen() {
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
                presentedView.frame = containerView.frame
                
                if let navController = self.presentedViewController as? UINavigationController {
                    self.isMaximized = true
                    
                    navController.setNeedsStatusBarAppearanceUpdate()
                    
                    // Force the navigation bar to update its size
                    navController.isNavigationBarHidden = true
                    navController.isNavigationBarHidden = false
                }
            }, completion: nil)
        }
    }
    
    override open var frameOfPresentedViewInContainerView: CGRect {
        return presentedViewFrame ?? CGRect(x: 16, y: containerView!.bounds.height * 1 / 4, width: containerView!.bounds.width - 32, height: (containerView!.bounds.height * 3 / 4) + 20)
    }
    
    override open func presentationTransitionWillBegin() {
        
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            
            containerView.addSubview(darkView)
            darkView.fillSuperview()
            darkView.addSubview(presentedViewController.view)
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.darkView.alpha = 0.2
            }, completion: nil)
        }
    }
    
    override open func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.darkView.alpha = 0
                self.presentingViewController.view.transform = CGAffineTransform.identity
            })
            
        }
    }
    
    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            darkView.removeFromSuperview()
            isMaximized = false
        }
    }
}
