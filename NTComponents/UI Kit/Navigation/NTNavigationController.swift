//
//  NTNavigationController.swift
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

open class NTNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    open var pushTransitionDelegate = ScaleBackTransitionAnimatorDelegate()
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        navigationBar.tintColor = Color.Default.Tint.NavigationBar
        navigationBar.barTintColor = Color.Default.Background.NavigationBar
        navigationBar.backgroundColor = Color.Default.Background.NavigationBar
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.setDefaultShadow()
        setup()
    }
    
    
    open func setup() {
        delegate = self
        updateStatusBarStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates the status bar style to light or default based on the background color of the navigation bar
    open func updateStatusBarStyle() {
        guard let color = navigationBar.backgroundColor else {
            return
        }
        if color.isLight  {
            UIApplication.shared.statusBarStyle = .default
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    
    /// Pushes the viewController with a transitioningDelegate of NTNavigationController if previously nil
    ///
    /// - Parameters:
    ///   - viewController: View controller to push
    ///   - animated: Transition Animated
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewController.transitioningDelegate == nil, animated {
            viewController.transitioningDelegate = pushTransitionDelegate
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - UINavigationControllerDelegate
    
//    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        
//    }
//    
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    
//    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let push = PushAnimation()
//        push.isReverse = operation == .pop
//        return push
//    }
//    
//    open class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
//        
//        open var isReverse: Bool = false
//        
//        open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//            return 0.3
//        }
//        
//        open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//            
//            let containerView = transitionContext.containerView
//            
//            guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toView = toViewController.view, let fromView = fromViewController.view else {
//                return
//            }
////
//            containerView.addSubview(toView)
////            containerView.frame.origin.x = reverse ? -containerView.frame.size.width : containerView.frame.size.width
//            
//            toViewController.beginAppearanceTransition(true, animated: true)
//            
//            if !isReverse {
//                toView.transform = CGAffineTransform(translationX: containerView.frame.size.width, y: 0)
//            } else {
//                containerView.addSubview(fromView)
//            }
//            
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
////                containerView.transform = CGAffineTransform(translationX: -direction * containerView.frame.size.width, y: 0)
//                
//                if self.isReverse {
//                    fromView.transform = CGAffineTransform(translationX: containerView.frame.size.width, y: 0)
//                } else {
//                    toView.transform = CGAffineTransform.identity
//                }
//                
//            }, completion: {
//                finished in
//                
////                containerView.frame.origin.x = 0
////                containerView.transform = CGAffineTransform.identity
//                toViewController.endAppearanceTransition()
//                
//                if (transitionContext.transitionWasCancelled) {
//                    toView.removeFromSuperview()
//                } else {
//                    fromView.removeFromSuperview()
//                }
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            })
//        }
//    }
}

