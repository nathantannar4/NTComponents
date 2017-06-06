//
//  NTNavigationContainer.swift
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
import UIKit
import QuartzCore

public enum NTNavigationContainerState {
    case leftPanelExpanded, rightPanelExpanded, bothPanelsCollapsed
}

public enum NTPresentationDirection {
    case top, right, bottom, left
}

public extension UIViewController {
    var navigationContainer: NTNavigationContainer? {
        var parentViewController = parent
        
        while parentViewController != nil {
            if let view = parentViewController as? NTNavigationContainer{
                return view
            }
            parentViewController = parentViewController!.parent
        }
        Log.write(.warning, "View controller did not have an NTNavigationContainer as a parent")
        return nil
    }
}

public protocol NTNavigationContainerDelegate {
    func toggleLeftPanel()
    func toggleRightPanel()
    func replaceCenterViewWith(_ view: UIViewController)
}

open class NTNavigationContainer: UIViewController, UIGestureRecognizerDelegate, NTNavigationContainerDelegate {
    
    // View Controllers
    private var centerNavigationController: NTNavigationController!
    private var centerViewController: UIViewController!
    private var leftViewController: UIViewController? {
        didSet {
            let shouldShow = (leftViewController != nil)
            showLeftMenuButton(shouldShow)
        }
    }
    private var rightViewController: UIViewController? {
        didSet {
            let shouldShow = (rightViewController != nil)
            showLeftMenuButton(shouldShow)
        }
    }
    open var centerView: UIViewController! {
        get {
            return centerViewController
        }
    }
    
    open func setCenterView(newView: UIViewController) {
        centerViewController = newView
        centerNavigationController.setViewControllers([centerViewController], animated: false)
        showLeftMenuButton(leftViewPanel != nil)
        showRightMenuButton(rightViewPanel != nil)
    }
    
    open var leftViewPanel: UIViewController? {
        get {
            return leftViewController
        }
    }
    
    open func setLeftViewPanel(newView: UIViewController, width: CGFloat) {
        leftViewController = newView
        leftPanelWidth = width
    }
    
    open func removeLeftViewPanel() {
        if currentState == .leftPanelExpanded {
            toggleLeftPanel()
        }
        leftViewController = nil
    }
    
    open var rightViewPanel: UIViewController? {
        get {
            return rightViewController
        }
    }
    
    open func setRightPanelView(newView: UIViewController, width: CGFloat) {
        rightPanelWidth = width
        rightViewController = newView
    }
    
    open func removeRightViewPanel() {
        if currentState == .rightPanelExpanded {
            toggleRightPanel()
        }
        rightViewController = nil
    }
    
    // Properties
    private var currentState: NTNavigationContainerState = .bothPanelsCollapsed {
        didSet {
            if currentState == .leftPanelExpanded {
                setleftViewProperties(hidden: false)
                centerViewController.view.isUserInteractionEnabled = false  
            } else if currentState == .rightPanelExpanded {
                setRightViewProperties(hidden: false)
                centerViewController.view.isUserInteractionEnabled = false
            } else {
                centerViewController.view.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: - Container Appearance Properties
    open var leftPanelWidth: CGFloat = 250 {
        didSet {
            if leftPanelWidth > (view.frame.width - 60) { leftPanelWidth = view.frame.width - 60 }
            leftViewController?.view.frame = CGRect(x: 0, y: 0, width: leftPanelWidth, height: view.frame.height)
        }
    }
    open var rightPanelWidth: CGFloat = 250 {
        didSet {
            if rightPanelWidth > (view.frame.width - 60) { rightPanelWidth = view.frame.width - 60 }
            rightViewController?.view.frame = CGRect(x: view.frame.width - rightPanelWidth, y: 0, width: rightPanelWidth, height: view.frame.height)
        }
    }
    open var drawerShadowShown: Bool = true {
        didSet {
            showShadowForCenterViewController(drawerShadowShown)
        }
    }
    open var statusBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: drawerAnimationDuration) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    // MARK: - Drawer Animation Properties
    open var drawerAnimationDuration: TimeInterval = 0.5
    open var drawerAnimationDelay: TimeInterval = 0.0
    open var drawerAnimationSpringDamping: CGFloat = 1.0
    open var drawerAnimationSpringVelocity: CGFloat = 1.0
    open var drawerAnimationStyle: UIViewAnimationOptions = .curveLinear
    
    // MARK: - Initializers
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init(centerView: UIViewController, leftView: UIViewController? = nil, rightView: UIViewController? = nil) {
        self.init()
        centerViewController = centerView
        leftViewController = leftView
        rightViewController = rightView
        initializeContainer()
    }
    
    private func initializeContainer() {
        Log.write(.status, "Initializing NTNaviagationContainer")
        centerNavigationController = NTNavigationController(rootViewController: centerViewController)
        centerViewController.didMove(toParentViewController: centerNavigationController)
        centerNavigationController.addChildViewController(centerViewController)
        
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)
        addSidePanelViews()
        showShadowForCenterViewController(drawerShadowShown)
        //addPanGestureRecognizer()
    }
    
    open func addPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        panGestureRecognizer.delegate = self
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    // MARK: - UI Properties
    private func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            Log.write(.status, "Will show shadow for center view")
            centerNavigationController.view.setDefaultShadow()
            centerNavigationController.view.layer.shadowOffset = CGSize(width: -Color.Default.Shadow.Offset.width, height: 0)
        } else {
            Log.write(.status, "Will hide shadow for center view")
            centerNavigationController.view.hideShadow()
        }
    }
    
    // MARK: - Navigation Drawer
    private func showLeftMenuButton(_ shouldShow: Bool) {
        Log.write(.status, "Will show left menu button is \(shouldShow)")
        if centerViewController.navigationItem.leftBarButtonItem == nil {
            let leftDrawerButton = NTMenuBarButtonItem(target: self, action: #selector(toggleLeftPanel))
            centerViewController.navigationItem.leftBarButtonItem = shouldShow ? leftDrawerButton : nil
        }
    }
    private func showRightMenuButton(_ shouldShow: Bool) {
        Log.write(.status, "Will show right menu button is \(shouldShow)")
        if centerViewController.navigationItem.rightBarButtonItem == nil {
            let rightDrawerButton = NTMenuBarButtonItem(target: self, action: #selector(toggleRightPanel))
            centerViewController.navigationItem.rightBarButtonItem = shouldShow ? rightDrawerButton : nil
        }
    }
    
    private func addSidePanelViews() {
        if (leftViewController != nil) {
            addChildSidePanelController(leftViewController!)
            leftViewController!.view.isHidden = true
            showLeftMenuButton(true)
        }
        if (rightViewController != nil) {
            addChildSidePanelController(rightViewController!)
            rightViewController!.view.isHidden = true
            showRightMenuButton(true)
        }
    }
    
    private func addChildSidePanelController(_ sidePanelController: UIViewController) {
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if currentState == .leftPanelExpanded {
            setleftViewProperties(hidden: false)
        } else if currentState == .rightPanelExpanded {
            setRightViewProperties(hidden: false)
        }
    }
    
    // MARK: - Status Bar
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    open override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    // MARK: - NTNavigationContainer get functions
    open func getCurrentState() -> NTNavigationContainerState {
        return currentState
    }

    // MARK: - View Annimations & Property Setters
    private func animateLeftPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .leftPanelExpanded
            setleftViewProperties(hidden: false)
            animateCenterPanelXPosition(leftPanelWidth)
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .bothPanelsCollapsed
                self.setleftViewProperties(hidden: true)
            }
        }
    }
    
    private func setleftViewProperties(hidden: Bool) {
        view.backgroundColor = leftViewController?.view.backgroundColor
        leftViewController?.view.isHidden = hidden
        leftViewController?.view.frame = CGRect(x: 0, y: 0, width: leftPanelWidth, height: view.frame.height)
        if !hidden {
            leftViewController?.viewWillAppear(true)
        }
    }
    
    private func animateRightPanel(_ shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .rightPanelExpanded
            setRightViewProperties(hidden: false)
            animateCenterPanelXPosition(-rightPanelWidth)
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .bothPanelsCollapsed
                self.setRightViewProperties(hidden: true)
            }
        }
    }
    
    private func setRightViewProperties(hidden: Bool) {
        view.backgroundColor = rightViewController?.view.backgroundColor
        rightViewController?.view.isHidden = hidden
        rightViewController?.view.frame = CGRect(x: view.frame.width - rightPanelWidth, y: 0, width: rightPanelWidth, height: view.frame.height)
        if !hidden {
            rightViewController?.viewWillAppear(true)
        }
    }
    
    private func animateCenterPanelXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: drawerAnimationDuration, delay: drawerAnimationDelay, usingSpringWithDamping: drawerAnimationSpringDamping, initialSpringVelocity: drawerAnimationSpringVelocity, options: drawerAnimationStyle, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    open func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        let boundWidth = recognizer.view!.frame.origin.x
        
        if boundWidth < 0 {
            // Animating Right Panel
            setRightViewProperties(hidden: false)
            setleftViewProperties(hidden: true)
        } else if boundWidth > 0 {
            // Animating Left Panel
            setRightViewProperties(hidden: true)
            setleftViewProperties(hidden: false)
        } else {
            setRightViewProperties(hidden: true)
            setleftViewProperties(hidden: true)
        }
        
        if currentState == .leftPanelExpanded && boundWidth >= leftPanelWidth && gestureIsDraggingFromLeftToRight {
            animateLeftPanel(true)
            return
        } else if currentState == .rightPanelExpanded && (-boundWidth) >= rightPanelWidth && !gestureIsDraggingFromLeftToRight {
            animateRightPanel(true)
            return
        }
        
        switch(recognizer.state) {
        case .began:
            if (currentState == .bothPanelsCollapsed) {
                if gestureIsDraggingFromLeftToRight && leftViewController != nil {
                    currentState = .leftPanelExpanded
                    setleftViewProperties(hidden: false)
                } else if rightViewController != nil {
                    currentState = .rightPanelExpanded
                    setRightViewProperties(hidden: false)
                }
            }
        case .changed:
            if currentState == .leftPanelExpanded {
                if boundWidth <= leftPanelWidth {
                    recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
                    recognizer.setTranslation(CGPoint.zero, in: view)
                }
            } else if currentState == .rightPanelExpanded {
                if (-boundWidth) <= rightPanelWidth {
                    recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
                    recognizer.setTranslation(CGPoint.zero, in: view)
                }
            }
        case .ended:
            
            // Animate the side panel open or closed based on whether the view has moved more or less than of its width
            if (currentState == .leftPanelExpanded) {
                let hasMovedGreaterThanHalfway = boundWidth > (leftPanelWidth / 2)
                Log.write(.status, "Center view did move more than halfway is \(hasMovedGreaterThanHalfway)")
                animateLeftPanel(hasMovedGreaterThanHalfway)
                currentState = hasMovedGreaterThanHalfway ? .leftPanelExpanded : .bothPanelsCollapsed
            } else if (currentState == .rightPanelExpanded) {
                let hasMovedGreaterThanHalfway = (-boundWidth) > (rightPanelWidth / 2)
                Log.write(.status, "Center view did move more than halfway is \(hasMovedGreaterThanHalfway)")
                animateRightPanel(hasMovedGreaterThanHalfway)
                currentState = hasMovedGreaterThanHalfway ? .rightPanelExpanded : .bothPanelsCollapsed
            }
        case .cancelled:
            currentState = .bothPanelsCollapsed
        default:
            break
        }
    }
    
    // MARK: - Navigation and Presentation
    
    open func toggleLeftPanel() {
        Log.write(.status, "Toggle left panel")
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        animateLeftPanel(notAlreadyExpanded)
    }
    
    open func toggleRightPanel() {
        Log.write(.status, "Toggle right panel")
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        animateRightPanel(notAlreadyExpanded)
    }
    
    open func replaceCenterViewWith(_ view: UIViewController) {
        Log.write(.status, "Replacing center view")
        setCenterView(newView: view)
    }
}
