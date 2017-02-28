/*
 MIT License
 
 Copyright © 2016 Nathan Tannar
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 NTNavigationContainer.swift
 Created by Nathan Tannar on 11/30/16.
*/

import Foundation
import UIKit
import QuartzCore

public enum NTNavigationContainerState {
    case leftPanelExpanded, rightPanelExpanded, bothPanelsCollapsed, inBackground
}

public enum NTPresentationDirection {
    case top, right, bottom, left
}

public class NTTapDismissGestureRecognizer: UITapGestureRecognizer {
    var toDirection: NTPresentationDirection!
    
    convenience init(target: Any?, action: Selector?, direction: NTPresentationDirection) {
        self.init(target: target, action: action)
        self.toDirection = direction
        self.numberOfTapsRequired = 1
    }
}

extension UIViewController {
    var getNTNavigationContainer: NTNavigationContainer? {
        var parentViewController = self.parent
        
        while parentViewController != nil {
            if let view = parentViewController as? NTNavigationContainer{
                return view
            }
            
            parentViewController = parentViewController!.parent
        }
        print("### ERROR: View controller did not have an NTNavigationContainer as a parent")
        return nil
    }
}

public protocol NTNavigationContainerDelegate: NSObjectProtocol {
    func dismissOverlayTo(_ direction: NTPresentationDirection)
    func toggleLeftPanel()
    func toggleRightPanel()
    func replaceCenterViewWith(_ view: UIViewController)
}

open class NTNavigationContainer: UIViewController, UIGestureRecognizerDelegate, NTNavigationContainerDelegate {
    
    // View Controllers
    private var centerNavigationController: UINavigationController!
    private var centerViewController: UIViewController!
    private var leftViewController: UIViewController? {
        didSet {
            let shouldShow = (self.leftViewController != nil)
            self.showLeftMenuButton(shouldShow)
        }
    }
    private var rightViewController: UIViewController? {
        didSet {
            let shouldShow = (self.rightViewController != nil)
            self.showLeftMenuButton(shouldShow)
        }
    }
    private var overlayDismissRecognizer: NTTapDismissGestureRecognizer = NTTapDismissGestureRecognizer()
    private var overlayViewController: UIViewController?
    private var overlayFrame: CGRect?
    
    open var centerView: UIViewController! {
        get {
            return self.centerViewController
        }
    }
    
    open func setCenterView(newView: UIViewController) {
        self.centerViewController = newView
        self.centerNavigationController.setViewControllers([self.centerViewController], animated: false)
        self.showLeftMenuButton(self.leftViewPanel != nil)
        self.showRightMenuButton(self.rightViewPanel != nil)
    }
    
    open var leftViewPanel: UIViewController? {
        get {
            return self.leftViewController
        }
    }
    
    open func setLeftViewPanel(newView: UIViewController, width: CGFloat) {
        self.leftViewController = newView
        self.leftPanelWidth = width
    }
    
    open func removeLeftViewPanel() {
        if self.currentState == .leftPanelExpanded {
            self.toggleLeftPanel()
        }
        self.leftViewController = nil
    }
    
    open var rightViewPanel: UIViewController? {
        get {
            return self.rightViewController
        }
    }
    
    open func setRightPanelView(newView: UIViewController, width: CGFloat) {
        self.rightPanelWidth = width
        self.rightViewController = newView
    }
    
    open func removeRightViewPanel() {
        if self.currentState == .rightPanelExpanded {
            self.toggleRightPanel()
        }
        self.rightViewController = nil
    }
    
    // Properties
    private var currentState: NTNavigationContainerState = .bothPanelsCollapsed {
        didSet {
            if self.currentState == .inBackground {
                self.lights(on: false)
                self.overlayDismissRecognizer.delegate = self
                self.view.window?.addGestureRecognizer(self.overlayDismissRecognizer)
            } else {
                self.lights(on: true)
                self.view.window?.removeGestureRecognizer(self.overlayDismissRecognizer)
            }
            
            if self.currentState == .leftPanelExpanded {
                self.setleftViewProperties(hidden: false)
            } else if self.currentState == .rightPanelExpanded {
                self.setRightViewProperties(hidden: false)
            }
        }
    }
    
    // MARK: - Container Appearance Properties
    public var leftPanelWidth: CGFloat = 250 {
        didSet {
            if self.leftPanelWidth > (self.view.frame.width - 60) { self.leftPanelWidth = self.view.frame.width - 60 }
            self.leftViewController?.view.frame = CGRect(x: 0, y: 0, width: self.leftPanelWidth, height: self.view.frame.height)
        }
    }
    public var rightPanelWidth: CGFloat = 250 {
        didSet {
            if self.rightPanelWidth > (self.view.frame.width - 60) { self.rightPanelWidth = self.view.frame.width - 60 }
            self.rightViewController?.view.frame = CGRect(x: self.view.frame.width - self.rightPanelWidth, y: 0, width: self.rightPanelWidth, height: self.view.frame.height)
        }
    }
    public var drawerShadowShown: Bool = true {
        didSet {
            self.showShadowForCenterViewController(self.drawerShadowShown)
        }
    }
    public var statusBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    // MARK: - Drawer Animation Properties
    public var drawerAnimationDuration: TimeInterval = 0.5
    public var drawerAnimationDelay: TimeInterval = 0.0
    public var drawerAnimationSpringDamping: CGFloat = 1.0
    public var drawerAnimationSpringVelocity: CGFloat = 1.0
    public var drawerAnimationStyle: UIViewAnimationOptions = .curveLinear
    
    // MARK: - Initializers
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init(centerView: UIViewController, leftView: UIViewController?, rightView: UIViewController?) {
        self.init()
        self.centerViewController = centerView
        self.leftViewController = leftView
        self.rightViewController = rightView
        self.initializeContainer()
    }
    
    public init(centerView: UIViewController) {
        self.init()
        self.centerViewController = centerView
        self.initializeContainer()
    }
    
    private func initializeContainer() {
        Log.write(.status, "Initializing NTNaviagationContainer")
        self.centerNavigationController = UINavigationController(rootViewController: self.centerViewController)
        self.centerViewController.didMove(toParentViewController: self.centerNavigationController)
        self.centerNavigationController.addChildViewController(self.centerViewController)
        
        self.centerNavigationController.navigationBar.isTranslucent = false
        self.centerNavigationController.navigationBar.tintColor = Color.Defaults.tint
        
        if self.centerViewController is UITabBarController || self.centerViewController is UINavigationController || self.centerViewController is NTPageViewController {
            self.centerNavigationController.setNavigationBarHidden(true, animated: false)
        }
        
        self.view.addSubview(self.centerNavigationController.view)
        self.addChildViewController(self.centerNavigationController)
        self.centerNavigationController.didMove(toParentViewController: self)
        self.addSidePanelViews()
        self.showShadowForCenterViewController(self.drawerShadowShown)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        panGestureRecognizer.delegate = self
        //self.centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    
    // MARK: - UI Properties
    private func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            Log.write(.status, "Will show shadow for center view")
            self.centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            Log.write(.status, "Will hide shadow for center view")
            self.centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    // MARK: - Navigation Drawer
    private func showLeftMenuButton(_ shouldShow: Bool) {
        Log.write(.status, "Will show left menu button is \(shouldShow)")
        if self.centerViewController.navigationItem.leftBarButtonItem == nil {
            let leftDrawerButton = UIBarButtonItem(image: Icon.Apple.menu?.resizeImage(width: 25, height: 25, renderingMode: .alwaysTemplate), style: .plain, target: self, action: #selector(toggleLeftPanel))
            self.centerViewController.navigationItem.leftBarButtonItem = shouldShow ? leftDrawerButton : nil
            
            //if let rootNav
        }
    }
    private func showRightMenuButton(_ shouldShow: Bool) {
        Log.write(.status, "Will show right menu button is \(shouldShow)")
        if self.centerViewController.navigationItem.rightBarButtonItem == nil {
            let rightDrawerButton = UIBarButtonItem(image: Icon.Apple.menu?.resizeImage(width: 25, height: 25, renderingMode: .alwaysTemplate), style: .plain, target: self, action: #selector(toggleRightPanel))
            self.centerViewController.navigationItem.rightBarButtonItem = shouldShow ? rightDrawerButton : nil
        }
    }
    
    private func addSidePanelViews() {
        if (self.leftViewController != nil) {
            self.addChildSidePanelController(leftViewController!)
            self.leftViewController!.view.isHidden = true
            self.showLeftMenuButton(true)
        }
        if (self.rightViewController != nil) {
            self.addChildSidePanelController(rightViewController!)
            self.rightViewController!.view.isHidden = true
            self.showRightMenuButton(true)
        }
    }
    
    private func addChildSidePanelController(_ sidePanelController: UIViewController) {
        self.view.insertSubview(sidePanelController.view, at: 0)
        self.addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.currentState == .inBackground {
            self.dismissOverlayFromRecognizer(sender: self.overlayDismissRecognizer)
        }
        if self.currentState == .leftPanelExpanded {
            self.setleftViewProperties(hidden: false)
        } else if self.currentState == .rightPanelExpanded {
            self.setRightViewProperties(hidden: false)
        }
    }
    
    // MARK: - Status Bar
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    open override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    // MARK: - NTNavigationContainer get functions
    public func getCurrentState() -> NTNavigationContainerState {
        return self.currentState
    }

    // MARK: - View Annimations & Property Setters
    private func animateLeftPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            self.currentState = .leftPanelExpanded
            self.setleftViewProperties(hidden: false)
            self.animateCenterPanelXPosition(leftPanelWidth)
        } else {
            self.animateCenterPanelXPosition(0) { finished in
                self.currentState = .bothPanelsCollapsed
                self.setleftViewProperties(hidden: true)
            }
        }
    }
    
    private func setleftViewProperties(hidden: Bool) {
        self.view.backgroundColor = self.leftViewController?.view.backgroundColor
        self.leftViewController?.view.isHidden = hidden
        self.leftViewController?.view.frame = CGRect(x: 0, y: 0, width: self.leftPanelWidth, height: self.view.frame.height)
        if !hidden {
            self.leftViewController?.viewWillAppear(true)
        }
    }
    
    private func animateRightPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .rightPanelExpanded
            self.setRightViewProperties(hidden: false)
            self.animateCenterPanelXPosition(-rightPanelWidth)
        } else {
            self.animateCenterPanelXPosition(0) { finished in
                self.currentState = .bothPanelsCollapsed
                self.setRightViewProperties(hidden: true)
            }
        }
    }
    
    private func setRightViewProperties(hidden: Bool) {
        self.view.backgroundColor = self.rightViewController?.view.backgroundColor
        self.rightViewController?.view.isHidden = hidden
        self.rightViewController?.view.frame = CGRect(x: self.view.frame.width - self.rightPanelWidth, y: 0, width: rightPanelWidth, height: self.view.frame.height)
        if !hidden {
            self.rightViewController?.viewWillAppear(true)
        }
    }
    
    private func animateCenterPanelXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: self.drawerAnimationDuration, delay: self.drawerAnimationDelay, usingSpringWithDamping: self.drawerAnimationSpringDamping, initialSpringVelocity: self.drawerAnimationSpringVelocity, options: self.drawerAnimationStyle, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        let boundWidth = recognizer.view!.frame.origin.x
        
        if boundWidth < 0 {
            // Animating Right Panel
            self.setRightViewProperties(hidden: false)
            self.setleftViewProperties(hidden: true)
        } else if boundWidth > 0 {
            // Animating Left Panel
            self.setRightViewProperties(hidden: true)
            self.setleftViewProperties(hidden: false)
        } else {
            self.setRightViewProperties(hidden: true)
            self.setleftViewProperties(hidden: true)
        }
        
        if self.currentState == .leftPanelExpanded && boundWidth >= self.leftPanelWidth && gestureIsDraggingFromLeftToRight {
            self.animateLeftPanel(true)
            return
        } else if self.currentState == .rightPanelExpanded && (-boundWidth) >= self.rightPanelWidth && !gestureIsDraggingFromLeftToRight {
            self.animateRightPanel(true)
            return
        }
        
        switch(recognizer.state) {
        case .began:
            if (self.currentState == .bothPanelsCollapsed) {
                if gestureIsDraggingFromLeftToRight && self.leftViewController != nil {
                    self.currentState = .leftPanelExpanded
                    self.setleftViewProperties(hidden: false)
                } else if self.rightViewController != nil {
                    self.currentState = .rightPanelExpanded
                    self.setRightViewProperties(hidden: false)
                }
            }
        case .changed:
            if self.currentState == .leftPanelExpanded {
                if boundWidth <= self.leftPanelWidth {
                    recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
                    recognizer.setTranslation(CGPoint.zero, in: self.view)
                }
            } else if self.currentState == .rightPanelExpanded {
                if (-boundWidth) <= self.rightPanelWidth {
                    recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
                    recognizer.setTranslation(CGPoint.zero, in: self.view)
                }
            }
        case .ended:
            // Animate the side panel open or closed based on whether the view has moved more or less than of its width
            if (self.currentState == .leftPanelExpanded) {
                let hasMovedGreaterThanHalfway = boundWidth > (self.leftPanelWidth / 2)
                Log.write(.status, "Center view did move more than halfway is \(hasMovedGreaterThanHalfway)")
                self.animateLeftPanel(hasMovedGreaterThanHalfway)
                self.currentState = hasMovedGreaterThanHalfway ? .leftPanelExpanded : .bothPanelsCollapsed
            } else if (self.currentState == .rightPanelExpanded) {
                let hasMovedGreaterThanHalfway = (-boundWidth) > (self.rightPanelWidth / 2)
                Log.write(.status, "Center view did move more than halfway is \(hasMovedGreaterThanHalfway)")
                self.animateRightPanel(hasMovedGreaterThanHalfway)
                self.currentState = hasMovedGreaterThanHalfway ? .rightPanelExpanded : .bothPanelsCollapsed
            }
        case .cancelled:
            self.currentState = .bothPanelsCollapsed
        default:
            break
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        switch self.currentState {
        case .leftPanelExpanded, .rightPanelExpanded, .bothPanelsCollapsed:
            return true
        case .inBackground:
            let point = touch.location(in: nil)
            let touchFrame = self.overlayViewController!.view.frame
            return !touchFrame.contains(point)
        }
    }
    
    
    // MARK: - Navigation and Presentation
    public func toggleLeftPanel() {
        Log.write(.status, "Toggle left panel")
        let notAlreadyExpanded = (self.currentState != .leftPanelExpanded)
        self.animateLeftPanel(notAlreadyExpanded)
    }
    
    public func toggleRightPanel() {
        Log.write(.status, "Toggle right panel")
        let notAlreadyExpanded = (self.currentState != .rightPanelExpanded)
        self.animateRightPanel(notAlreadyExpanded)
    }
    
    public func replaceCenterViewWith(_ view: UIViewController) {
        Log.write(.status, "Replacing center view")
        self.setCenterView(newView: view)
    }
    
    private func lights(on: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            switch on {
            case true:
                self.view.backgroundColor = UIColor.white
                self.centerNavigationController.view.alpha = 1.0
                self.leftViewController?.view.alpha = 1.0
                self.rightViewController?.view.alpha = 1.0
            case false:
                self.view.backgroundColor = UIColor.black
                self.centerNavigationController.view.alpha = 0.5
                self.leftViewController?.view.alpha = 0.5
                self.rightViewController?.view.alpha = 0.5
            }
        })
    }
    
    private func setDismissRecognizer(direction: NTPresentationDirection) {
        Log.write(.status, "Presenting overlay view from \(direction)")
        self.lights(on: false)
        self.overlayDismissRecognizer = NTTapDismissGestureRecognizer(target: self, action: #selector(dismissOverlayFromRecognizer(sender:)), direction: direction)
    }
    
    public func presentOverlay(_ overlay: UIViewController, from direction: NTPresentationDirection) {
        self.setDismissRecognizer(direction: direction)
        self.overlayViewController = overlay
        self.overlayFrame = self.overlayViewController!.view.frame
        self.presentViewController(self.overlayViewController!, from: direction, completion: {
            self.currentState = .inBackground
        })
    }
    
    public func presentOverlayFromBottom(_ overlay: UIViewController, height: CGFloat) {
        self.setDismissRecognizer(direction: .bottom)
        self.overlayViewController = overlay
        self.overlayViewController!.view.frame = CGRect(x: 0, y: self.view.frame.height - height, width: self.overlayViewController!.view.frame.width, height: height)
        self.overlayFrame = self.overlayViewController!.view.frame
        self.presentViewController(self.overlayViewController!, from: .bottom, completion: {
            self.currentState = .inBackground
        })
    }
    
    public func presentOverlayFromTop(_ overlay: UIViewController, height: CGFloat) {
        self.setDismissRecognizer(direction: .top)
        self.overlayViewController = overlay
        self.overlayViewController!.view.frame = CGRect(x: 0, y: 0, width: self.overlayViewController!.view.frame.width, height: height)
        self.overlayFrame = self.overlayViewController!.view.frame
        self.presentViewController(self.overlayViewController!, from: .top, completion: {
            self.currentState = .inBackground
        })
    }
    
    public func presentOverlayFromLeft(_ overlay: UIViewController, width: CGFloat) {
        self.setDismissRecognizer(direction: .left)
        self.overlayViewController = overlay
        self.overlayViewController!.view.frame = CGRect(x: 0, y: 0, width: width, height: self.overlayViewController!.view.frame.height)
        self.overlayFrame = self.overlayViewController!.view.frame
        self.presentViewController(self.overlayViewController!, from: .left, completion: {
            self.currentState = .inBackground
        })
    }
    
    public func presentOverlayFromRight(_ overlay: UIViewController, width: CGFloat) {
        self.setDismissRecognizer(direction: .right)
        self.overlayViewController = overlay
        self.overlayViewController!.view.frame = CGRect(x: self.view.frame.width - width, y: 0, width: width, height: self.overlayViewController!.view.frame.height)
        self.overlayFrame = self.overlayViewController!.view.frame
        self.presentViewController(self.overlayViewController!, from: .right, completion: {
            self.currentState = .inBackground
        })
    }
    
    public func dismissOverlayTo(_ direction: NTPresentationDirection) {
        Log.write(.status, "Dismissing overlay view to \(direction)")
        self.lights(on: true)
        self.overlayViewController?.dismissViewController(to: direction, completion: {
            self.overlayViewController = nil
            self.currentState = .bothPanelsCollapsed
            if let leftView = self.leftViewController?.view {
                if !leftView.isHidden { self.currentState = .leftPanelExpanded }
            }
            if let rightView = self.rightViewController?.view {
                if !rightView.isHidden { self.currentState = .rightPanelExpanded }
            }
        })
    }
    
    func dismissOverlayFromRecognizer(sender: NTTapDismissGestureRecognizer) {
        self.dismissOverlayTo(sender.toDirection)
    }
}
