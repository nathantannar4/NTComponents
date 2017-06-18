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
//  Adapted from https://github.com/sascha/DrawerController
//

import Foundation
import UIKit
import QuartzCore

/*
open class DrawerBarButtonItem: UIBarButtonItem {
    
    open var menuButton: AnimatedMenuButton
    
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
        menuButton.animatable = animatable
        menuButton.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView: menuButton)
        
        self.menuButton = menuButton
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        super.init(coder: aDecoder)
        self.customView = self.menuButton
    }
    
    // MARK: - Animations
    
    open func animate(withPercentVisible percentVisible: CGFloat, drawerSide: DrawerSide) {
        if let btn = self.customView as? AnimatedMenuButton {
            btn.animate(withPercentVisible: percentVisible, drawerSide: drawerSide)
        }
    }
}

open class AnimatedMenuButton : UIButton {
    
    lazy var top: CAShapeLayer = CAShapeLayer()
    lazy var middle: CAShapeLayer = CAShapeLayer()
    lazy var bottom: CAShapeLayer = CAShapeLayer()
    
    // MARK: - Constants
    
    let animationDuration: CFTimeInterval = 8.0
    
    let shortStroke: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 3.5, y: 6))
        path.addLine(to: CGPoint(x: 22.5, y: 6))
        return path
    }()
    
    var animatable = true
    
    // MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, strokeColor: Color.Default.Tint.NavigationBar)
    }
    
    public init(frame: CGRect, strokeColor: UIColor) {
        super.init(frame: frame)
        if !self.animatable {
            return
        }
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
        if self.animatable {
            return
        }
        
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
    
    // MARK: - Animations
    
    open func animate(withPercentVisible percentVisible: CGFloat, drawerSide: DrawerSide) {
        if !self.animatable {
            return
        }
        
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



public extension UIViewController {
    
    var evo_drawerController: NTNavigationContainer? {
        var parentViewController = self.parent
        
        while parentViewController != nil {
            if parentViewController!.isKind(of: NTNavigationContainer.self) {
                return parentViewController as? NTNavigationContainer
            }
            
            parentViewController = parentViewController!.parent
        }
        
        return nil
    }
    
    var evo_visibleDrawerFrame: CGRect {
        if let drawerController = self.evo_drawerController {
            if drawerController.leftDrawerViewController != nil {
                if self == drawerController.leftDrawerViewController || self.navigationController == drawerController.leftDrawerViewController {
                    var rect = drawerController.view.bounds
                    rect.size.width = drawerController.maximumLeftDrawerWidth
                    return rect
                }
            }
            
            if drawerController.rightDrawerViewController != nil {
                if self == drawerController.rightDrawerViewController || self.navigationController == drawerController.rightDrawerViewController {
                    var rect = drawerController.view.bounds
                    rect.size.width = drawerController.maximumRightDrawerWidth
                    rect.origin.x = drawerController.view.bounds.width - rect.size.width
                    return rect
                }
            }
        }
        
        return CGRect.null
    }
}

private func bounceKeyFrameAnimation(forDistance distance: CGFloat, on view: UIView) -> CAKeyframeAnimation {
    let factors: [CGFloat] = [0, 32, 60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 24, 42, 54, 62, 64, 62, 54, 42, 24, 0, 18, 28, 32, 28, 18, 0]
    
    let values = factors.map { x -> NSNumber in
        // This could be refactored as `NSNumber(value: Float(x / 128 * distance + view.bounds.midX))`
        // but unfortunately that would require 400ms+ more compile time
        var value = x
        value /= 128
        value *= distance
        value += view.bounds.midX
        
        return NSNumber(value: Float(value))
    }
    
    let animation = CAKeyframeAnimation(keyPath: "position.x")
    animation.repeatCount = 1
    animation.duration = 0.8
    animation.fillMode = kCAFillModeForwards
    animation.values = values
    animation.isRemovedOnCompletion = true
    animation.autoreverses = false
    
    return animation
}

public struct OpenDrawerGestureMode: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    public static let panningNavigationBar = OpenDrawerGestureMode(rawValue: 0b0001)
    public static let panningCenterView = OpenDrawerGestureMode(rawValue: 0b0010)
    public static let bezelPanningCenterView = OpenDrawerGestureMode(rawValue: 0b0100)
    public static let custom = OpenDrawerGestureMode(rawValue: 0b1000)
    public static let all: OpenDrawerGestureMode = [panningNavigationBar, panningCenterView, bezelPanningCenterView, custom]
}

public struct CloseDrawerGestureMode: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    public static let panningNavigationBar = CloseDrawerGestureMode(rawValue: 0b0000001)
    public static let panningCenterView = CloseDrawerGestureMode(rawValue: 0b0000010)
    public static let bezelPanningCenterView = CloseDrawerGestureMode(rawValue: 0b0000100)
    public static let tapNavigationBar = CloseDrawerGestureMode(rawValue: 0b0001000)
    public static let tapCenterView = CloseDrawerGestureMode(rawValue: 0b0010000)
    public static let panningDrawerView = CloseDrawerGestureMode(rawValue: 0b0100000)
    public static let custom = CloseDrawerGestureMode(rawValue: 0b1000000)
    public static let all: CloseDrawerGestureMode = [panningNavigationBar, panningCenterView, bezelPanningCenterView, tapNavigationBar, tapCenterView, panningDrawerView, custom]
}

public enum DrawerOpenCenterInteractionMode: Int {
    case none
    case full
    case navigationBarOnly
}

private let DrawerDefaultWidth: CGFloat = 280.0
private let DrawerDefaultAnimationVelocity: CGFloat = 840.0

private let DrawerDefaultFullAnimationDelay: TimeInterval = 0.10

private let DrawerDefaultBounceDistance: CGFloat = 50.0

private let DrawerMinimumAnimationDuration: CGFloat = 0.15
private let DrawerDefaultDampingFactor: CGFloat = 1.0
private let DrawerDefaultShadowRadius: CGFloat = 10.0
private let DrawerDefaultShadowOpacity: Float = 0.8

private let DrawerPanVelocityXAnimationThreshold: CGFloat = 200.0

/** The amount of overshoot that is panned linearly. The remaining percentage nonlinearly asymptotes to the max percentage. */
private let DrawerOvershootLinearRangePercentage: CGFloat = 0.75

/** The percent of the possible overshoot width to use as the actual overshoot percentage. */
private let DrawerOvershootPercentage: CGFloat = 0.1

private let DrawerBezelRange: CGFloat = 20.0

private let DrawerLeftDrawerKey = "DrawerLeftDrawer"
private let DrawerRightDrawerKey = "DrawerRightDrawer"
private let DrawerCenterKey = "DrawerCenter"
private let DrawerOpenSideKey = "DrawerOpenSide"

public typealias DrawerGestureShouldRecognizeTouchBlock = (NTNavigationContainer, UIGestureRecognizer, UITouch) -> Bool
public typealias DrawerGestureCompletionBlock = (NTNavigationContainer, UIGestureRecognizer) -> Void
public typealias DrawerControllerDrawerVisualStateBlock = (NTNavigationContainer, DrawerSide, CGFloat) -> Void

private class DrawerCenterContainerView: UIView {
    fileprivate var openSide: DrawerSide = .none
    var centerInteractionMode: DrawerOpenCenterInteractionMode = .none
    
    fileprivate override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        
        if hitView != nil && self.openSide != .none {
            if self.centerInteractionMode == .none {
                hitView = nil
            } else if let navBar = self.navigationBarContained(withinSubviewsOf: self) {
                let navBarFrame = navBar.convert(navBar.bounds, to: self)
                
                if self.centerInteractionMode == .navigationBarOnly && navBarFrame.contains(point) == false {
                    hitView = nil
                }
            }
        }
        
        return hitView
    }
    
    fileprivate func navigationBarContained(withinSubviewsOf view: UIView) -> UINavigationBar? {
        var navBar: UINavigationBar?
        
        for subview in view.subviews as [UIView] {
            if view.isKind(of: UINavigationBar.self) {
                navBar = view as? UINavigationBar
                break
            } else {
                navBar = self.navigationBarContained(withinSubviewsOf: subview)
                if navBar != nil {
                    break
                }
            }
        }
        
        return navBar
    }
}

open class NTNavigationContainer: UIViewController, UIGestureRecognizerDelegate {
    fileprivate var _centerViewController: UIViewController?
    fileprivate var _leftDrawerViewController: UIViewController?
    fileprivate var _rightDrawerViewController: UIViewController?
    fileprivate var _maximumLeftDrawerWidth = DrawerDefaultWidth
    fileprivate var _maximumRightDrawerWidth = DrawerDefaultWidth
    
    /**
     The center view controller.
     
     This can only be set via the init methods, as well as the `setNewCenterViewController:...` methods. The size of this view controller will automatically be set to the size of the drawer container view controller, and it's position is modified from within this class. Do not modify the frame externally.
     */
    open var centerViewController: UIViewController? {
        get {
            return self._centerViewController
        }
        
        set {
            self.setCenter(newValue, animated: false)
        }
    }
    
    /**
     The left drawer view controller.
     
     The size of this view controller is managed within this class, and is automatically set to the appropriate size based on the `maximumLeftDrawerWidth`. Do not modify the frame externally.
     */
    open var leftDrawerViewController: UIViewController? {
        get {
            return self._leftDrawerViewController
        }
        
        set {
            self.setDrawer(newValue, for: .left)
        }
    }
    
    /**
     The right drawer view controller.
     
     The size of this view controller is managed within this class, and is automatically set to the appropriate size based on the `maximumRightDrawerWidth`. Do not modify the frame externally.
     */
    open var rightDrawerViewController: UIViewController? {
        get {
            return self._rightDrawerViewController
        }
        
        set {
            self.setDrawer(newValue, for: .right)
        }
    }
    
    /**
     The maximum width of the `leftDrawerViewController`.
     
     By default, this is set to 280. If the `leftDrawerViewController` is nil, this property will return 0.0;
     */
    open var maximumLeftDrawerWidth: CGFloat {
        get {
            if self.leftDrawerViewController != nil {
                return self._maximumLeftDrawerWidth
            } else {
                return 0.0
            }
        }
        
        set {
            self.setMaximumLeftDrawerWidth(newValue, animated: false, completion: nil)
        }
    }
    
    /**
     The maximum width of the `rightDrawerViewController`.
     
     By default, this is set to 280. If the `rightDrawerViewController` is nil, this property will return 0.0;
     
     */
    open var maximumRightDrawerWidth: CGFloat {
        get {
            if self.rightDrawerViewController != nil {
                return self._maximumRightDrawerWidth
            } else {
                return 0.0
            }
        }
        
        set {
            self.setMaximumRightDrawerWidth(newValue, animated: false, completion: nil)
        }
    }
    
    /**
     The visible width of the `leftDrawerViewController`.
     
     Note this value can be greater than `maximumLeftDrawerWidth` during the full close animation when setting a new center view controller;
     */
    open var visibleLeftDrawerWidth: CGFloat {
        get {
            return max(0.0, self.centerContainerView.frame.minX)
        }
    }
    
    /**
     The visible width of the `rightDrawerViewController`.
     
     Note this value can be greater than `maximumRightDrawerWidth` during the full close animation when setting a new center view controller;
     */
    open var visibleRightDrawerWidth: CGFloat {
        get {
            if self.centerContainerView.frame.minX < 0 {
                return self.childControllerContainerView.bounds.width - self.centerContainerView.frame.maxX
            } else {
                return 0.0
            }
        }
    }
    
    /**
     A boolean that determines whether or not the panning gesture will "hard-stop" at the maximum width for a given drawer side.
     
     By default, this value is set to YES. Enabling `shouldStretchDrawer` will give the pan a gradual asymptotic stopping point much like `UIScrollView` behaves. Note that if this value is set to YES, the `drawerVisualStateBlock` can be passed a `percentVisible` greater than 1.0, so be sure to handle that case appropriately.
     */
    open var shouldStretchDrawer = true
    open var drawerDampingFactor = DrawerDefaultDampingFactor
    open var shadowRadius = DrawerDefaultShadowRadius
    open var shadowOpacity = DrawerDefaultShadowOpacity
    open var bezelRange = DrawerBezelRange
    
    /**
     The flag determining if a shadow should be drawn off of `centerViewController` when a drawer is open.
     
     By default, this is set to YES.
     */
    open var showsShadows: Bool = true {
        didSet {
            self.updateShadowForCenterView()
        }
    }
    
    open var animationVelocity = DrawerDefaultAnimationVelocity
    open var minimumAnimationDuration = DrawerMinimumAnimationDuration
    fileprivate var animatingDrawer: Bool = false {
        didSet {
            self.view.isUserInteractionEnabled = !self.animatingDrawer
        }
    }
    
    fileprivate lazy var childControllerContainerView: UIView = {
        let childContainerViewFrame = self.view.bounds
        let childControllerContainerView = UIView(frame: childContainerViewFrame)
        childControllerContainerView.backgroundColor = UIColor.clear
        childControllerContainerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(childControllerContainerView)
        
        return childControllerContainerView
    }()
    
    fileprivate lazy var centerContainerView: DrawerCenterContainerView = {
        let centerFrame = self.childControllerContainerView.bounds
        
        let centerContainerView = DrawerCenterContainerView(frame: centerFrame)
        centerContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        centerContainerView.backgroundColor = UIColor.clear
        centerContainerView.openSide = self.openSide
        centerContainerView.centerInteractionMode = self.centerHiddenInteractionMode
        self.childControllerContainerView.addSubview(centerContainerView)
        
        return centerContainerView
    }()
    
    /**
     The current open side of the drawer.
     
     Note this value will change as soon as a pan gesture opens a drawer, or when a open/close animation is finished.
     */
    open fileprivate(set) var openSide: DrawerSide = .none {
        didSet {
            self.centerContainerView.openSide = self.openSide
            if self.openSide == .none {
                self.leftDrawerViewController?.view.isHidden = true
                self.rightDrawerViewController?.view.isHidden = true
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    fileprivate var startingPanRect: CGRect = CGRect.null
    
    /**
     Sets a callback to be called when a gesture has been completed.
     
     This block is called when a gesture action has been completed. You can query the `openSide` of the `NTNavigationContainer` to determine what the new state of the drawer is.
     
     - parameter gestureCompletionBlock: A block object to be called that allows the implementer be notified when a gesture action has been completed.
     */
    open var gestureCompletionBlock: DrawerGestureCompletionBlock?
    
    /**
     Sets a callback to be called when a drawer visual state needs to be updated.
     
     This block is responsible for updating the drawer's view state, and the drawer controller will handle animating to that state from the current state. This block will be called when the drawer is opened or closed, as well when the user is panning the drawer. This block is not responsible for doing animations directly, but instead just updating the state of the properies (such as alpha, anchor point, transform, etc). Note that if `shouldStretchDrawer` is set to YES, it is possible for `percentVisible` to be greater than 1.0. If `shouldStretchDrawer` is set to NO, `percentVisible` will never be greater than 1.0.
     
     Note that when the drawer is finished opening or closing, the side drawer controller view will be reset with the following properies:
     
     - alpha: 1.0
     - transform: CATransform3DIdentity
     - anchorPoint: (0.5,0.5)
     
     - parameter drawerVisualStateBlock: A block object to be called that allows the implementer to update visual state properties on the drawer. `percentVisible` represents the amount of the drawer space that is current visible, with drawer space being defined as the edge of the screen to the maxmimum drawer width. Note that you do have access to the NTNavigationContainer, which will allow you to update things like the anchor point of the side drawer layer.
     */
    open var drawerVisualStateBlock: DrawerControllerDrawerVisualStateBlock?
    
    /**
     Sets a callback to be called to determine if a UIGestureRecognizer should recieve the given UITouch.
     
     This block provides a way to allow a gesture to be recognized with custom logic. For example, you may have a certain part of your view that should accept a pan gesture recognizer to open the drawer, but not another a part. If you return YES, the gesture is recognized and the appropriate action is taken. This provides similar support to how Facebook allows you to pan on the background view of the main table view, but not the content itself. You can inspect the `openSide` property of the `drawerController` to determine the current state of the drawer, and apply the appropriate logic within your block.
     
     Note that either `openDrawerGestureModeMask` must contain `OpenDrawerGestureModeCustom`, or `closeDrawerGestureModeMask` must contain `CloseDrawerGestureModeCustom` for this block to be consulted.
     
     - parameter gestureShouldRecognizeTouchBlock: A block object to be called to determine if the given `touch` should be recognized by the given gesture.
     */
    open var gestureShouldRecognizeTouchBlock: DrawerGestureShouldRecognizeTouchBlock?
    
    /**
     How a user is allowed to open a drawer using gestures.
     
     By default, this is set to `OpenDrawerGestureModeNone`. Note these gestures may affect user interaction with the `centerViewController`, so be sure to use appropriately.
     */
    open var openDrawerGestureModeMask: OpenDrawerGestureMode = []
    
    /**
     How a user is allowed to close a drawer.
     
     By default, this is set to `CloseDrawerGestureModeNone`. Note these gestures may affect user interaction with the `centerViewController`, so be sure to use appropriately.
     */
    open var closeDrawerGestureModeMask: CloseDrawerGestureMode = []
    
    /**
     The value determining if the user can interact with the `centerViewController` when a side drawer is open.
     
     By default, it is `DrawerOpenCenterInteractionModeNavigationBarOnly`, meaning that the user can only interact with the buttons on the `UINavigationBar`, if the center view controller is a `UINavigationController`. Otherwise, the user cannot interact with any other center view controller elements.
     */
    open var centerHiddenInteractionMode: DrawerOpenCenterInteractionMode = .navigationBarOnly {
        didSet {
            self.centerContainerView.centerInteractionMode = self.centerHiddenInteractionMode
        }
    }
    
    // MARK: - Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
     Creates and initializes an `DrawerController` object with the specified center view controller, left drawer view controller, and right drawer view controller.
     
     - parameter centerViewController: The center view controller. This argument must not be `nil`.
     - parameter leftDrawerViewController: The left drawer view controller.
     - parameter rightDrawerViewController: The right drawer controller.
     
     - returns: The newly-initialized drawer container view controller.
     */
    public init(centerViewController: UIViewController, leftDrawerViewController: UIViewController?, rightDrawerViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        self.centerViewController = centerViewController
        if leftDrawerViewController != nil {
            self.leftDrawerViewController = leftDrawerViewController
            setupLeftMenuButton()
        }
        if rightDrawerViewController != nil {
            self.rightDrawerViewController = rightDrawerViewController
            setupRightMenuButton()
        }
    }
    
    /**
     Creates and initializes an `DrawerController` object with the specified center view controller, left drawer view controller.
     
     - parameter centerViewController: The center view controller. This argument must not be `nil`.
     - parameter leftDrawerViewController: The left drawer view controller.
     
     - returns: The newly-initialized drawer container view controller.
     */
    public convenience init(centerViewController: UIViewController, leftDrawerViewController: UIViewController?) {
        self.init(centerViewController: centerViewController, leftDrawerViewController: leftDrawerViewController, rightDrawerViewController: nil)
    }
    
    /**
     Creates and initializes an `DrawerController` object with the specified center view controller, right drawer view controller.
     
     - parameter centerViewController: The center view controller. This argument must not be `nil`.
     - parameter rightDrawerViewController: The right drawer controller.
     
     - returns: The newly-initialized drawer container view controller.
     */
    public convenience init(centerViewController: UIViewController, rightDrawerViewController: UIViewController?) {
        self.init(centerViewController: centerViewController, leftDrawerViewController: nil, rightDrawerViewController: rightDrawerViewController)
    }
    
    public func setupLeftMenuButton() {
        if let navVC = centerViewController as? UINavigationController {
            let leftDrawerButton = DrawerBarButtonItem(target: self, action: #selector(leftDrawerButtonPress(_:)))
            navVC.viewControllers[0].navigationItem.setLeftBarButton(leftDrawerButton, animated: false)
        }
    }
    
    public func setupRightMenuButton() {
        if let navVC = centerViewController as? UINavigationController {
            let rightDrawerButton = DrawerBarButtonItem(target: self, action: #selector(rightDrawerButtonPress(_:)))
            navVC.viewControllers[0].navigationItem.setRightBarButton(rightDrawerButton, animated: false)
        }
    }
    
    func leftDrawerButtonPress(_ sender: AnyObject?) {
        toggleDrawerSide(.left, animated: true, completion: nil)
    }
    
    func rightDrawerButtonPress(_ sender: AnyObject?) {
        toggleDrawerSide(.right, animated: true, completion: nil)
    }
    
    // MARK: - State Restoration
    
    open override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        if let leftDrawerViewController = self.leftDrawerViewController {
            coder.encode(leftDrawerViewController, forKey: DrawerLeftDrawerKey)
        }
        
        if let rightDrawerViewController = self.rightDrawerViewController {
            coder.encode(rightDrawerViewController, forKey: DrawerRightDrawerKey)
        }
        
        if let centerViewController = self.centerViewController {
            coder.encode(centerViewController, forKey: DrawerCenterKey)
        }
        
        coder.encode(self.openSide.rawValue, forKey: DrawerOpenSideKey)
    }
    
    open override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if self.leftDrawerViewController == nil {
            if let leftDrawerViewController = coder.decodeObject(forKey: DrawerLeftDrawerKey) as? UIViewController {
                self.leftDrawerViewController = leftDrawerViewController
            }
        }
        
        if self.rightDrawerViewController == nil {
            if let rightDrawerViewController = coder.decodeObject(forKey: DrawerRightDrawerKey) as? UIViewController {
                self.rightDrawerViewController = rightDrawerViewController
            }
        }
        
        if self.centerViewController == nil {
            if let centerViewController = coder.decodeObject(forKey: DrawerCenterKey) as? UIViewController {
                self.centerViewController = centerViewController
            }
        }
        
        if let openSide = DrawerSide(rawValue: coder.decodeInteger(forKey: DrawerOpenSideKey)) {
            if openSide != .none {
                self.openDrawerSide(openSide, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - UIViewController Containment
    
    override open var childViewControllerForStatusBarHidden : UIViewController? {
        return self.childViewController(for: self.openSide)
    }
    
    override open var childViewControllerForStatusBarStyle : UIViewController? {
        return self.childViewController(for: self.openSide)
    }
    
    // MARK: - Animation helpers
    
    fileprivate func finishAnimationForPanGesture(withXVelocity xVelocity: CGFloat, completion: ((Bool) -> Void)?) {
        var currentOriginX = self.centerContainerView.frame.minX
        let animationVelocity = max(abs(xVelocity), DrawerPanVelocityXAnimationThreshold * 2)
        
        if self.openSide == .left {
            let midPoint = self.maximumLeftDrawerWidth / 2.0
            
            if xVelocity > DrawerPanVelocityXAnimationThreshold {
                self.openDrawerSide(.left, animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if xVelocity < -DrawerPanVelocityXAnimationThreshold {
                self.closeDrawer(animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if currentOriginX < midPoint {
                self.closeDrawer(animated: true, completion: completion)
            } else {
                self.openDrawerSide(.left, animated: true, completion: completion)
            }
        } else if self.openSide == .right {
            currentOriginX = self.centerContainerView.frame.maxX
            let midPoint = (self.childControllerContainerView.bounds.width - self.maximumRightDrawerWidth) + (self.maximumRightDrawerWidth / 2.0)
            
            if xVelocity > DrawerPanVelocityXAnimationThreshold {
                self.closeDrawer(animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if xVelocity < -DrawerPanVelocityXAnimationThreshold {
                self.openDrawerSide(.right, animated: true, velocity: animationVelocity, animationOptions: [], completion: completion)
            } else if currentOriginX > midPoint {
                self.closeDrawer(animated: true, completion: completion)
            } else {
                self.openDrawerSide(.right, animated: true, completion: completion)
            }
        } else {
            completion?(false)
        }
    }
    
    fileprivate func updateDrawerVisualState(for drawerSide: DrawerSide, percentVisible: CGFloat) {
        if let drawerVisualState = self.drawerVisualStateBlock {
            drawerVisualState(self, drawerSide, percentVisible)
        } else if self.shouldStretchDrawer {
            self.applyOvershootScaleTransform(for: drawerSide, percentVisible: percentVisible)
        }
    }
    
    fileprivate func applyOvershootScaleTransform(for drawerSide: DrawerSide, percentVisible: CGFloat) {
        if percentVisible >= 1.0 {
            var transform = CATransform3DIdentity
            
            if let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide) {
                if drawerSide == .left {
                    transform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                    transform = CATransform3DTranslate(transform, self._maximumLeftDrawerWidth * (percentVisible - 1.0) / 2, 0, 0)
                } else if drawerSide == .right {
                    transform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                    transform = CATransform3DTranslate(transform, -self._maximumRightDrawerWidth * (percentVisible - 1.0) / 2, 0, 0)
                }
                
                sideDrawerViewController.view.layer.transform = transform
            }
        }
    }
    
    fileprivate func resetDrawerVisualState(for drawerSide: DrawerSide) {
        if let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide) {
            sideDrawerViewController.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sideDrawerViewController.view.layer.transform = CATransform3DIdentity
            sideDrawerViewController.view.alpha = 1.0
        }
    }
    
    fileprivate func roundedOriginX(forDrawerConstraints originX: CGFloat) -> CGFloat {
        if originX < -self.maximumRightDrawerWidth {
            if self.shouldStretchDrawer && self.rightDrawerViewController != nil {
                let maxOvershoot: CGFloat = (self.centerContainerView.frame.width - self.maximumRightDrawerWidth) * DrawerOvershootPercentage
                return self.originX(forDrawerOriginX: originX, andTargetOriginOffset: -self.maximumRightDrawerWidth, maxOvershoot: maxOvershoot)
            } else {
                return -self.maximumRightDrawerWidth
            }
        } else if originX > self.maximumLeftDrawerWidth {
            if self.shouldStretchDrawer && self.leftDrawerViewController != nil {
                let maxOvershoot = (self.centerContainerView.frame.width - self.maximumLeftDrawerWidth) * DrawerOvershootPercentage;
                return self.originX(forDrawerOriginX: originX, andTargetOriginOffset: self.maximumLeftDrawerWidth, maxOvershoot: maxOvershoot)
            } else {
                return self.maximumLeftDrawerWidth
            }
        }
        
        return originX
    }
    
    fileprivate func originX(forDrawerOriginX originX: CGFloat, andTargetOriginOffset targetOffset: CGFloat, maxOvershoot: CGFloat) -> CGFloat {
        let delta: CGFloat = abs(originX - targetOffset)
        let maxLinearPercentage = DrawerOvershootLinearRangePercentage
        let nonLinearRange = maxOvershoot * maxLinearPercentage
        let nonLinearScalingDelta = delta - nonLinearRange
        let overshoot = nonLinearRange + nonLinearScalingDelta * nonLinearRange / sqrt(pow(nonLinearScalingDelta, 2.0) + 15000)
        
        if delta < nonLinearRange {
            return originX
        } else if targetOffset < 0 {
            return targetOffset - round(overshoot)
        } else {
            return targetOffset + round(overshoot)
        }
    }
    
    // MARK: - Helpers
    
    fileprivate func setupGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureCallback(_:)))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureCallback(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    fileprivate func childViewController(for drawerSide: DrawerSide) -> UIViewController? {
        var childViewController: UIViewController?
        
        switch drawerSide {
        case .left:
            childViewController = self.leftDrawerViewController
        case .right:
            childViewController = self.rightDrawerViewController
        case .none:
            childViewController = self.centerViewController
        }
        
        return childViewController
    }
    
    fileprivate func sideDrawerViewController(for drawerSide: DrawerSide) -> UIViewController? {
        var sideDrawerViewController: UIViewController?
        
        if drawerSide != .none {
            sideDrawerViewController = self.childViewController(for: drawerSide)
        }
        
        return sideDrawerViewController
    }
    
    fileprivate func prepareToPresentDrawer(for drawer: DrawerSide, animated: Bool) {
        var drawerToHide: DrawerSide = .none
        
        if drawer == .left {
            drawerToHide = .right
        } else if drawer == .right {
            drawerToHide = .left
        }
        
        if let sideDrawerViewControllerToHide = self.sideDrawerViewController(for: drawerToHide) {
            self.childControllerContainerView.sendSubview(toBack: sideDrawerViewControllerToHide.view)
            sideDrawerViewControllerToHide.view.isHidden = true
        }
        
        if let sideDrawerViewControllerToPresent = self.sideDrawerViewController(for: drawer) {
            sideDrawerViewControllerToPresent.view.isHidden = false
            self.resetDrawerVisualState(for: drawer)
            sideDrawerViewControllerToPresent.view.frame = sideDrawerViewControllerToPresent.evo_visibleDrawerFrame
            self.updateDrawerVisualState(for: drawer, percentVisible: 0.0)
            sideDrawerViewControllerToPresent.beginAppearanceTransition(true, animated: animated)
        }
    }
    
    fileprivate func updateShadowForCenterView() {
        if self.showsShadows {
            self.centerContainerView.layer.masksToBounds = false
            self.centerContainerView.layer.shadowRadius = shadowRadius
            self.centerContainerView.layer.shadowOpacity = shadowOpacity
            
            /** In the event this gets called a lot, we won't update the shadowPath
             unless it needs to be updated (like during rotation) */
            if let shadowPath = centerContainerView.layer.shadowPath {
                let currentPath = shadowPath.boundingBoxOfPath
                
                if currentPath.equalTo(centerContainerView.bounds) == false {
                    centerContainerView.layer.shadowPath = UIBezierPath(rect: centerContainerView.bounds).cgPath
                }
            } else {
                self.centerContainerView.layer.shadowPath = UIBezierPath(rect: self.centerContainerView.bounds).cgPath
            }
        } else if self.centerContainerView.layer.shadowPath != nil {
            self.centerContainerView.layer.shadowRadius = 0.0
            self.centerContainerView.layer.shadowOpacity = 0.0
            self.centerContainerView.layer.shadowPath = nil
            self.centerContainerView.layer.masksToBounds = true
        }
    }
    
    fileprivate func animationDuration(forAnimationDistance distance: CGFloat) -> TimeInterval {
        return TimeInterval(max(distance / self.animationVelocity, minimumAnimationDuration))
    }
    
    // MARK: - Size Methods
    
    /**
     Sets the maximum width of the left drawer view controller.
     
     If the drawer is open, and `animated` is YES, it will animate the drawer frame as well as adjust the center view controller. If the drawer is not open, this change will take place immediately.
     
     - parameter width: The new width of left drawer view controller. This must be greater than zero.
     - parameter animated: Determines whether the drawer should be adjusted with an animation.
     - parameter completion: The block called when the animation is finished.
     
     */
    open func setMaximumLeftDrawerWidth(_ width: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        self.setMaximumDrawerWidth(width, forSide: .left, animated: animated, completion: completion)
    }
    
    /**
     Sets the maximum width of the right drawer view controller.
     
     If the drawer is open, and `animated` is YES, it will animate the drawer frame as well as adjust the center view controller. If the drawer is not open, this change will take place immediately.
     
     - parameter width: The new width of right drawer view controller. This must be greater than zero.
     - parameter animated: Determines whether the drawer should be adjusted with an animation.
     - parameter completion: The block called when the animation is finished.
     
     */
    open func setMaximumRightDrawerWidth(_ width: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        self.setMaximumDrawerWidth(width, forSide: .right, animated: animated, completion: completion)
    }
    
    fileprivate func setMaximumDrawerWidth(_ width: CGFloat, forSide drawerSide: DrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return width > 0
        }(), "width must be greater than 0")
        
        assert({ () -> Bool in
            return drawerSide != .none
        }(), "drawerSide cannot be .None")
        
        if let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide) {
            var oldWidth: CGFloat = 0.0
            var drawerSideOriginCorrection: NSInteger = 1
            
            if drawerSide == .left {
                oldWidth = self._maximumLeftDrawerWidth
                self._maximumLeftDrawerWidth = width
            } else if (drawerSide == .right) {
                oldWidth = self._maximumRightDrawerWidth
                self._maximumRightDrawerWidth = width
                drawerSideOriginCorrection = -1
            }
            
            let distance: CGFloat = abs(width - oldWidth)
            let duration: TimeInterval = animated ? self.animationDuration(forAnimationDistance: distance) : 0.0
            
            if self.openSide == drawerSide {
                var newCenterRect = self.centerContainerView.frame
                newCenterRect.origin.x = CGFloat(drawerSideOriginCorrection) * width
                
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: self.animationVelocity / distance, options: [], animations: { () -> Void in
                    self.centerContainerView.frame = newCenterRect
                    sideDrawerViewController.view.frame = sideDrawerViewController.evo_visibleDrawerFrame
                }, completion: { (finished) -> Void in
                    completion?(finished)
                    return
                })
            } else {
                sideDrawerViewController.view.frame = sideDrawerViewController.evo_visibleDrawerFrame
                completion?(true)
            }
        }
    }
    
    // MARK: - Setters
    
    fileprivate func setRightDrawer(_ rightDrawerViewController: UIViewController?) {
        self.setDrawer(rightDrawerViewController, for: .right)
    }
    
    fileprivate func setLeftDrawer(_ leftDrawerViewController: UIViewController?) {
        self.setDrawer(leftDrawerViewController, for: .left)
    }
    
    fileprivate func setDrawer(_ viewController: UIViewController?, for drawerSide: DrawerSide) {
        assert({ () -> Bool in
            return drawerSide != .none
        }(), "drawerSide cannot be .None")
        
        let currentSideViewController = self.sideDrawerViewController(for: drawerSide)
        
        if currentSideViewController == viewController {
            return
        }
        
        if currentSideViewController != nil {
            currentSideViewController!.beginAppearanceTransition(false, animated: false)
            currentSideViewController!.view.removeFromSuperview()
            currentSideViewController!.endAppearanceTransition()
            currentSideViewController!.willMove(toParentViewController: nil)
            currentSideViewController!.removeFromParentViewController()
        }
        
        var autoResizingMask = UIViewAutoresizing()
        
        if drawerSide == .left {
            self._leftDrawerViewController = viewController
            autoResizingMask = [.flexibleRightMargin, .flexibleHeight]
        } else if drawerSide == .right {
            self._rightDrawerViewController = viewController
            autoResizingMask = [.flexibleLeftMargin, .flexibleHeight]
        }
        
        if viewController != nil {
            self.addChildViewController(viewController!)
            
            if (self.openSide == drawerSide) && (self.childControllerContainerView.subviews as NSArray).contains(self.centerContainerView) {
                self.childControllerContainerView.insertSubview(viewController!.view, belowSubview: self.centerContainerView)
                viewController!.beginAppearanceTransition(true, animated: false)
                viewController!.endAppearanceTransition()
            } else {
                self.childControllerContainerView.addSubview(viewController!.view)
                self.childControllerContainerView.sendSubview(toBack: viewController!.view)
                viewController!.view.isHidden = true
            }
            
            viewController!.didMove(toParentViewController: self)
            viewController!.view.autoresizingMask = autoResizingMask
            viewController!.view.frame = viewController!.evo_visibleDrawerFrame
        }
    }
    
    // MARK: - Updating the Center View Controller
    
    fileprivate func setCenter(_ centerViewController: UIViewController?, animated: Bool) {
        if self._centerViewController == centerViewController {
            return
        }
        
        if let oldCenterViewController = self._centerViewController {
            oldCenterViewController.willMove(toParentViewController: nil)
            
            if animated == false {
                oldCenterViewController.beginAppearanceTransition(false, animated: false)
            }
            
            oldCenterViewController.removeFromParentViewController()
            oldCenterViewController.view.removeFromSuperview()
            
            if animated == false {
                oldCenterViewController.endAppearanceTransition()
            }
        }
        
        self._centerViewController = centerViewController
        
        if self._centerViewController != nil {
            self.addChildViewController(self._centerViewController!)
            self._centerViewController!.view.frame = self.childControllerContainerView.bounds
            self.centerContainerView.addSubview(self._centerViewController!.view)
            self.childControllerContainerView.bringSubview(toFront: self.centerContainerView)
            self._centerViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.updateShadowForCenterView()
            
            if animated == false {
                // If drawer is offscreen, then viewWillAppear: will take care of this
                if self.view.window != nil {
                    self._centerViewController!.beginAppearanceTransition(true, animated: false)
                    self._centerViewController!.endAppearanceTransition()
                }
                
                self._centerViewController!.didMove(toParentViewController: self)
            }
        }
    }
    
    /**
     Sets the new `centerViewController`.
     
     This sets the view controller and will automatically adjust the frame based on the current state of the drawer controller. If `closeAnimated` is YES, it will immediately change the center view controller, and close the drawer from its current position.
     
     - parameter centerViewController: The new `centerViewController`.
     - parameter closeAnimated: Determines whether the drawer should be closed with an animation.
     - parameter completion: The block called when the animation is finsihed.
     
     */
    open func setCenter(_ newCenterViewController: UIViewController, withCloseAnimation animated: Bool, completion: ((Bool) -> Void)?) {
        var animated = animated
        
        if self.openSide == .none {
            // If a side drawer isn't open, there is nothing to animate
            animated = false
        }
        
        let forwardAppearanceMethodsToCenterViewController = (self.centerViewController! == newCenterViewController) == false
        self.setCenter(newCenterViewController, animated: animated)
        
        if animated {
            self.updateDrawerVisualState(for: self.openSide, percentVisible: 1.0)
            
            if forwardAppearanceMethodsToCenterViewController {
                self.centerViewController!.beginAppearanceTransition(true, animated: animated)
            }
            
            self.closeDrawer(animated: animated, completion: { (finished) in
                if forwardAppearanceMethodsToCenterViewController {
                    self.centerViewController!.endAppearanceTransition()
                    self.centerViewController!.didMove(toParentViewController: self)
                }
                
                completion?(finished)
            })
        } else {
            completion?(true)
        }
    }
    
    /**
     Sets the new `centerViewController`.
     
     This sets the view controller and will automatically adjust the frame based on the current state of the drawer controller. If `closeFullAnimated` is YES, the current center view controller will animate off the screen, the new center view controller will then be set, followed by the drawer closing across the full width of the screen.
     
     - parameter newCenterViewController: The new `centerViewController`.
     - parameter fullCloseAnimated: Determines whether the drawer should be closed with an animation.
     - parameter completion: The block called when the animation is finsihed.
     
     */
    open func setCenter(_ newCenterViewController: UIViewController, withFullCloseAnimation animated: Bool, completion: ((Bool) -> Void)?) {
        if self.openSide != .none && animated {
            let forwardAppearanceMethodsToCenterViewController = (self.centerViewController! == newCenterViewController) == false
            let sideDrawerViewController = self.sideDrawerViewController(for: self.openSide)
            
            var targetClosePoint: CGFloat = 0.0
            
            if self.openSide == .right {
                targetClosePoint = -self.childControllerContainerView.bounds.width
            } else if self.openSide == .left {
                targetClosePoint = self.childControllerContainerView.bounds.width
            }
            
            let distance: CGFloat = abs(self.centerContainerView.frame.origin.x - targetClosePoint)
            let firstDuration = self.animationDuration(forAnimationDistance: distance)
            
            var newCenterRect = self.centerContainerView.frame
            
            self.animatingDrawer = animated
            
            let oldCenterViewController = self.centerViewController
            
            if forwardAppearanceMethodsToCenterViewController {
                oldCenterViewController?.beginAppearanceTransition(false, animated: animated)
            }
            
            newCenterRect.origin.x = targetClosePoint
            
            UIView.animate(withDuration: firstDuration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: distance / self.animationVelocity, options: [], animations: { () -> Void in
                self.centerContainerView.frame = newCenterRect
                sideDrawerViewController?.view.frame = self.childControllerContainerView.bounds
            }, completion: { (finished) -> Void in
                let oldCenterRect = self.centerContainerView.frame
                self.setCenter(newCenterViewController, animated: animated)
                self.centerContainerView.frame = oldCenterRect
                self.updateDrawerVisualState(for: self.openSide, percentVisible: 1.0)
                
                if forwardAppearanceMethodsToCenterViewController {
                    oldCenterViewController?.endAppearanceTransition()
                    self.centerViewController?.beginAppearanceTransition(true, animated: animated)
                }
                
                sideDrawerViewController?.beginAppearanceTransition(false, animated: animated)
                
                UIView.animate(withDuration: self.animationDuration(forAnimationDistance: self.childControllerContainerView.bounds.width), delay: DrawerDefaultFullAnimationDelay, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: self.childControllerContainerView.bounds.width / self.animationVelocity, options: [], animations: { () -> Void in
                    self.centerContainerView.frame = self.childControllerContainerView.bounds
                    self.updateDrawerVisualState(for: self.openSide, percentVisible: 0.0)
                }, completion: { (finished) -> Void in
                    if forwardAppearanceMethodsToCenterViewController {
                        self.centerViewController?.endAppearanceTransition()
                        self.centerViewController?.didMove(toParentViewController: self)
                    }
                    
                    sideDrawerViewController?.endAppearanceTransition()
                    self.resetDrawerVisualState(for: self.openSide)
                    
                    if sideDrawerViewController != nil {
                        sideDrawerViewController!.view.frame = sideDrawerViewController!.evo_visibleDrawerFrame
                    }
                    
                    self.openSide = .none
                    self.animatingDrawer = false
                    
                    completion?(finished)
                })
            })
        } else {
            self.setCenter(newCenterViewController, animated: animated)
            
            if self.openSide != .none {
                self.closeDrawer(animated: animated, completion: completion)
            } else if completion != nil {
                completion!(true)
            }
        }
    }
    
    // MARK: - Bounce Methods
    
    /**
     Bounce preview for the specified `drawerSide` a distance of 40 points.
     
     - parameter drawerSide: The drawer to preview. This value cannot be `DrawerSideNone`.
     - parameter completion: The block called when the animation is finsihed.
     
     */
    open func bouncePreview(for drawerSide: DrawerSide, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
        }(), "drawerSide cannot be .None")
        
        self.bouncePreview(for: drawerSide, distance: DrawerDefaultBounceDistance, completion: nil)
    }
    
    /**
     Bounce preview for the specified `drawerSide`.
     
     - parameter drawerSide: The drawer side to preview. This value cannot be `DrawerSideNone`.
     - parameter distance: The distance to bounce.
     - parameter completion: The block called when the animation is finsihed.
     
     */
    open func bouncePreview(for drawerSide: DrawerSide, distance: CGFloat, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
        }(), "drawerSide cannot be .None")
        
        let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide)
        
        if sideDrawerViewController == nil || self.openSide != .none {
            completion?(false)
            return
        } else {
            self.prepareToPresentDrawer(for: drawerSide, animated: true)
            
            self.updateDrawerVisualState(for: drawerSide, percentVisible: 1.0)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                sideDrawerViewController!.endAppearanceTransition()
                sideDrawerViewController!.beginAppearanceTransition(false, animated: false)
                sideDrawerViewController!.endAppearanceTransition()
                
                completion?(true)
            }
            
            let modifier: CGFloat = (drawerSide == .left) ? 1.0 : -1.0
            let animation = bounceKeyFrameAnimation(forDistance: distance * modifier, on: self.centerContainerView)
            self.centerContainerView.layer.add(animation, forKey: "bouncing")
            
            CATransaction.commit()
        }
    }
    
    // MARK: - Gesture Handlers
    
    func tapGestureCallback(_ tapGesture: UITapGestureRecognizer) {
        if self.openSide != .none && self.animatingDrawer == false {
            self.closeDrawer(animated: true, completion: { (finished) in
                if self.gestureCompletionBlock != nil {
                    self.gestureCompletionBlock!(self, tapGesture)
                }
            })
        }
    }
    
    func panGestureCallback(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            if self.animatingDrawer {
                panGesture.isEnabled = false
            } else {
                self.startingPanRect = self.centerContainerView.frame
            }
        case .changed:
            self.view.isUserInteractionEnabled = false
            var newFrame = self.startingPanRect
            let translatedPoint = panGesture.translation(in: self.centerContainerView)
            newFrame.origin.x = self.roundedOriginX(forDrawerConstraints: self.startingPanRect.minX + translatedPoint.x)
            newFrame = newFrame.integral
            let xOffset = newFrame.origin.x
            
            var visibleSide: DrawerSide = .none
            var percentVisible: CGFloat = 0.0
            
            if xOffset > 0 {
                visibleSide = .left
                percentVisible = xOffset / self.maximumLeftDrawerWidth
            } else if xOffset < 0 {
                visibleSide = .right
                percentVisible = abs(xOffset) / self.maximumRightDrawerWidth
            }
            
            if let visibleSideDrawerViewController = self.sideDrawerViewController(for: visibleSide) {
                if self.openSide != visibleSide {
                    // Handle disappearing the visible drawer
                    if let sideDrawerViewController = self.sideDrawerViewController(for: self.openSide) {
                        sideDrawerViewController.beginAppearanceTransition(false, animated: false)
                        sideDrawerViewController.endAppearanceTransition()
                    }
                    
                    // Drawer is about to become visible
                    self.prepareToPresentDrawer(for: visibleSide, animated: false)
                    visibleSideDrawerViewController.endAppearanceTransition()
                    self.openSide = visibleSide
                } else if visibleSide == .none {
                    self.openSide = .none
                }
                
                self.updateDrawerVisualState(for: visibleSide, percentVisible: percentVisible)
                self.centerContainerView.frame.origin.x = newFrame.origin.x
            }
        case .ended, .cancelled:
            self.startingPanRect = CGRect.null
            let velocity = panGesture.velocity(in: self.childControllerContainerView)
            self.finishAnimationForPanGesture(withXVelocity: velocity.x) { finished in
                if self.gestureCompletionBlock != nil {
                    self.gestureCompletionBlock!(self, panGesture)
                }
            }
            panGesture.isEnabled = true
            self.view.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    // MARK: - Open / Close Methods
    
    // DrawerSide enum is not exported to Objective-C, so use these two methods instead
    open func toggleLeftDrawerSide(animated: Bool, completion: ((Bool) -> Void)?) {
        self.toggleDrawerSide(.left, animated: animated, completion: completion)
    }
    
    open func toggleRightDrawerSide(animated: Bool, completion: ((Bool) -> Void)?) {
        self.toggleDrawerSide(.right, animated: animated, completion: completion)
    }
    
    /**
     Toggles the drawer open/closed based on the `drawer` passed in.
     
     Note that if you attempt to toggle a drawer closed while the other is open, nothing will happen. For example, if you pass in DrawerSideLeft, but the right drawer is open, nothing will happen. In addition, the completion block will be called with the finished flag set to NO.
     
     - parameter drawerSide: The `DrawerSide` to toggle. This value cannot be `DrawerSideNone`.
     - parameter animated: Determines whether the `drawer` should be toggle animated.
     - parameter completion: The block that is called when the toggle is complete, or if no toggle took place at all.
     
     */
    open func toggleDrawerSide(_ drawerSide: DrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
        }(), "drawerSide cannot be .None")
        
        if self.openSide == DrawerSide.none {
            self.openDrawerSide(drawerSide, animated: animated, completion: completion)
        } else {
            if (drawerSide == DrawerSide.left && self.openSide == DrawerSide.left) || (drawerSide == DrawerSide.right && self.openSide == DrawerSide.right) {
                self.closeDrawer(animated: animated, completion: completion)
            } else if completion != nil {
                completion!(false)
            }
        }
    }
    
    /**
     Opens the `drawer` passed in.
     
     - parameter drawerSide: The `DrawerSide` to open. This value cannot be `DrawerSideNone`.
     - parameter animated: Determines whether the `drawer` should be open animated.
     - parameter completion: The block that is called when the toggle is open.
     
     */
    open func openDrawerSide(_ drawerSide: DrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
        }(), "drawerSide cannot be .None")
        
        self.openDrawerSide(drawerSide, animated: animated, velocity: self.animationVelocity, animationOptions: [], completion: completion)
    }
    
    fileprivate func openDrawerSide(_ drawerSide: DrawerSide, animated: Bool, velocity: CGFloat, animationOptions options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        assert({ () -> Bool in
            return drawerSide != .none
        }(), "drawerSide cannot be .None")
        
        if self.animatingDrawer {
            completion?(false)
        } else {
            self.animatingDrawer = animated
            let sideDrawerViewController = self.sideDrawerViewController(for: drawerSide)
            
            if self.openSide != drawerSide {
                self.prepareToPresentDrawer(for: drawerSide, animated: animated)
            }
            
            if sideDrawerViewController != nil {
                var newFrame: CGRect
                let oldFrame = self.centerContainerView.frame
                
                if drawerSide == .left {
                    newFrame = self.centerContainerView.frame
                    newFrame.origin.x = self._maximumLeftDrawerWidth
                } else {
                    newFrame = self.centerContainerView.frame
                    newFrame.origin.x = 0 - self._maximumRightDrawerWidth
                }
                
                let distance = abs(oldFrame.minX - newFrame.origin.x)
                let duration: TimeInterval = animated ? TimeInterval(max(distance / abs(velocity), minimumAnimationDuration)) : 0.0
                
                UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: velocity / distance, options: options, animations: { () -> Void in
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.centerContainerView.frame = newFrame
                    self.updateDrawerVisualState(for: drawerSide, percentVisible: 1.0)
                }, completion: { (finished) -> Void in
                    if drawerSide != self.openSide {
                        sideDrawerViewController!.endAppearanceTransition()
                    }
                    
                    self.openSide = drawerSide
                    
                    self.resetDrawerVisualState(for: drawerSide)
                    self.animatingDrawer = false
                    
                    completion?(finished)
                })
            }
        }
    }
    
    /**
     Closes the open drawer.
     
     - parameter animated: Determines whether the drawer side should be closed animated
     - parameter completion: The block that is called when the close is complete
     
     */
    open func closeDrawer(animated: Bool, completion: ((Bool) -> Void)?) {
        self.closeDrawer(animated: animated, velocity: self.animationVelocity, animationOptions: [], completion: completion)
    }
    
    fileprivate func closeDrawer(animated: Bool, velocity: CGFloat, animationOptions options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        if self.animatingDrawer {
            completion?(false)
        } else {
            self.animatingDrawer = animated
            let newFrame = self.childControllerContainerView.bounds
            
            let distance = abs(self.centerContainerView.frame.minX)
            let duration: TimeInterval = animated ? TimeInterval(max(distance / abs(velocity), minimumAnimationDuration)) : 0.0
            
            let leftDrawerVisible = self.centerContainerView.frame.minX > 0
            let rightDrawerVisible = self.centerContainerView.frame.minX < 0
            
            var visibleSide: DrawerSide = .none
            var percentVisible: CGFloat = 0.0
            
            if leftDrawerVisible {
                let visibleDrawerPoint = self.centerContainerView.frame.minX
                percentVisible = max(0.0, visibleDrawerPoint / self._maximumLeftDrawerWidth)
                visibleSide = .left
            } else if rightDrawerVisible {
                let visibleDrawerPoints = self.centerContainerView.frame.width - self.centerContainerView.frame.maxX
                percentVisible = max(0.0, visibleDrawerPoints / self._maximumRightDrawerWidth)
                visibleSide = .right
            }
            
            let sideDrawerViewController = self.sideDrawerViewController(for: visibleSide)
            
            self.updateDrawerVisualState(for: visibleSide, percentVisible: percentVisible)
            sideDrawerViewController?.beginAppearanceTransition(false, animated: animated)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: self.drawerDampingFactor, initialSpringVelocity: velocity / distance, options: options, animations: { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
                self.centerContainerView.frame = newFrame
                self.updateDrawerVisualState(for: visibleSide, percentVisible: 0.0)
            }, completion: { (finished) -> Void in
                sideDrawerViewController?.endAppearanceTransition()
                self.openSide = .none
                self.resetDrawerVisualState(for: visibleSide)
                self.animatingDrawer = false
                completion?(finished)
            })
        }
    }
    
    // MARK: - UIViewController
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        self.setupGestureRecognizers()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.centerViewController?.beginAppearanceTransition(true, animated: animated)
        
        if self.openSide == .left {
            self.leftDrawerViewController?.beginAppearanceTransition(true, animated: animated)
        } else if self.openSide == .right {
            self.rightDrawerViewController?.beginAppearanceTransition(true, animated: animated)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateShadowForCenterView()
        self.centerViewController?.endAppearanceTransition()
        
        if self.openSide == .left {
            self.leftDrawerViewController?.endAppearanceTransition()
        } else if self.openSide == .right {
            self.rightDrawerViewController?.endAppearanceTransition()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.centerViewController?.beginAppearanceTransition(false, animated: animated)
        
        if self.openSide == .left {
            self.leftDrawerViewController?.beginAppearanceTransition(false, animated: animated)
        } else if self.openSide == .right {
            self.rightDrawerViewController?.beginAppearanceTransition(false, animated: animated)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.centerViewController?.endAppearanceTransition()
        
        if self.openSide == .left {
            self.leftDrawerViewController?.endAppearanceTransition()
        } else if self.openSide == .right {
            self.rightDrawerViewController?.endAppearanceTransition()
        }
    }
    
    open override var shouldAutomaticallyForwardAppearanceMethods : Bool {
        return false
    }
    
    override open var shouldAutorotate: Bool {
        if let controller = centerViewController {
            return controller.shouldAutorotate
        }
        
        return super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let controller = centerViewController {
            return controller.supportedInterfaceOrientations
        }
        
        return super.supportedInterfaceOrientations
    }
    
    // MARK: - Rotation
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        //If a rotation begins, we are going to cancel the current gesture and reset transform and anchor points so everything works correctly
        var gestureInProgress = false
        
        for gesture in self.view.gestureRecognizers! as [UIGestureRecognizer] {
            if gesture.state == .changed {
                gesture.isEnabled = false
                gesture.isEnabled = true
                gestureInProgress = true
            }
            
            if gestureInProgress {
                self.resetDrawerVisualState(for: self.openSide)
            }
        }
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            //We need to support the shadow path rotation animation
            //Inspired from here: http://blog.radi.ws/post/8348898129/calayers-shadowpath-and-uiview-autoresizing
            if self.showsShadows {
                let oldShadowPath = self.centerContainerView.layer.shadowPath
                
                self.updateShadowForCenterView()
                
                if oldShadowPath != nil {
                    let transition = CABasicAnimation(keyPath: "shadowPath")
                    transition.fromValue = oldShadowPath
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.duration = context.transitionDuration
                    self.centerContainerView.layer.add(transition, forKey: "transition")
                }
            }
        }, completion:nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.openSide == .none {
            let possibleOpenGestureModes = self.possibleOpenGestureModes(for: gestureRecognizer, with: touch)
            
            return !self.openDrawerGestureModeMask.intersection(possibleOpenGestureModes).isEmpty
        } else {
            let possibleCloseGestureModes = self.possibleCloseGestureModes(for: gestureRecognizer, with: touch)
            
            return !self.closeDrawerGestureModeMask.intersection(possibleCloseGestureModes).isEmpty
        }
    }
    
    // MARK: - Gesture Recognizer Delegate Helpers
    
    func possibleCloseGestureModes(for gestureRecognizer: UIGestureRecognizer, with touch: UITouch) -> CloseDrawerGestureMode {
        let point = touch.location(in: self.childControllerContainerView)
        var possibleCloseGestureModes: CloseDrawerGestureMode = []
        
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            if self.isPointContained(withinNavigationRect: point) {
                possibleCloseGestureModes.insert(.tapNavigationBar)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) {
                possibleCloseGestureModes.insert(.tapCenterView)
            }
        } else if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if self.isPointContained(withinNavigationRect: point) {
                possibleCloseGestureModes.insert(.panningNavigationBar)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) {
                possibleCloseGestureModes.insert(.panningCenterView)
            }
            
            if self.isPointContained(withinRightBezelRect: point) && self.openSide == .left {
                possibleCloseGestureModes.insert(.bezelPanningCenterView)
            }
            
            if self.isPointContained(withinLeftBezelRect: point) && self.openSide == .right {
                possibleCloseGestureModes.insert(.bezelPanningCenterView)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) == false && self.isPointContained(withinNavigationRect: point) == false {
                possibleCloseGestureModes.insert(.panningDrawerView)
            }
        }
        
        if self.closeDrawerGestureModeMask.contains(.custom) && self.gestureShouldRecognizeTouchBlock != nil {
            if self.gestureShouldRecognizeTouchBlock!(self, gestureRecognizer, touch) {
                possibleCloseGestureModes.insert(.custom)
            }
        }
        
        return possibleCloseGestureModes
    }
    
    func possibleOpenGestureModes(for gestureRecognizer: UIGestureRecognizer, with touch: UITouch) -> OpenDrawerGestureMode {
        let point = touch.location(in: self.childControllerContainerView)
        var possibleOpenGestureModes: OpenDrawerGestureMode = []
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if self.isPointContained(withinNavigationRect: point) {
                possibleOpenGestureModes.insert(.panningNavigationBar)
            }
            
            if self.isPointContained(withinCenterViewContentRect: point) {
                possibleOpenGestureModes.insert(.panningCenterView)
            }
            
            if self.isPointContained(withinLeftBezelRect: point) && self.leftDrawerViewController != nil {
                possibleOpenGestureModes.insert(.bezelPanningCenterView)
            }
            
            if self.isPointContained(withinRightBezelRect: point) && self.rightDrawerViewController != nil {
                possibleOpenGestureModes.insert(.bezelPanningCenterView)
            }
        }
        
        if self.openDrawerGestureModeMask.contains(.custom) && self.gestureShouldRecognizeTouchBlock != nil {
            if self.gestureShouldRecognizeTouchBlock!(self, gestureRecognizer, touch) {
                possibleOpenGestureModes.insert(.custom)
            }
        }
        
        return possibleOpenGestureModes
    }
    
    func isPointContained(withinNavigationRect point: CGPoint) -> Bool {
        var navigationBarRect = CGRect.null
        
        if let centerViewController = self.centerViewController {
            if centerViewController.isKind(of: UINavigationController.self) || centerViewController.isKind(of: NTNavigationController.self) {
                if let navBar = centerViewController.navigationController?.navigationBar {
                    navigationBarRect = navBar.convert(navBar.bounds, to: self.childControllerContainerView)
                    navigationBarRect = navigationBarRect.intersection(self.childControllerContainerView.bounds)
                }
            }
        }
        
        return navigationBarRect.contains(point)
    }
    
    func isPointContained(withinCenterViewContentRect point: CGPoint) -> Bool {
        var centerViewContentRect = self.centerContainerView.frame
        centerViewContentRect = centerViewContentRect.intersection(self.childControllerContainerView.bounds)
        
        return centerViewContentRect.contains(point) && self.isPointContained(withinNavigationRect: point) == false
    }
    
    func isPointContained(withinLeftBezelRect point: CGPoint) -> Bool {
        let (leftBezelRect, _) = childControllerContainerView.bounds.divided(atDistance: bezelRange, from: .minXEdge)
        
        return leftBezelRect.contains(point) && self.isPointContained(withinCenterViewContentRect: point)
    }
    
    func isPointContained(withinRightBezelRect point: CGPoint) -> Bool {
        let (rightBezelRect, _) = childControllerContainerView.bounds.divided(atDistance: bezelRange, from: .maxXEdge)
        
        return rightBezelRect.contains(point) && self.isPointContained(withinCenterViewContentRect: point)
    }
}

public struct DrawerVisualState {
    
    /**
     Creates a slide and scale visual state block that gives an experience similar to Mailbox.app. It scales from 90% to 100%, and translates 50 pixels in the x direction. In addition, it also sets alpha from 0.0 to 1.0.
     
     - returns: The visual state block.
     */
    public static var slideAndScaleVisualStateBlock: DrawerControllerDrawerVisualStateBlock {
        let visualStateBlock: DrawerControllerDrawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) -> Void in
            let minScale: CGFloat = 0.9
            let scale: CGFloat = minScale + (percentVisible * (1.0-minScale))
            let scaleTransform = CATransform3DMakeScale(scale, scale, scale)
            
            let maxDistance: CGFloat = 50
            let distance: CGFloat = maxDistance * percentVisible
            var translateTransform = CATransform3DIdentity
            var sideDrawerViewController: UIViewController?
            
            if drawerSide == DrawerSide.left {
                sideDrawerViewController = drawerController.leftDrawerViewController
                translateTransform = CATransform3DMakeTranslation((maxDistance - distance), 0, 0)
            } else if drawerSide == DrawerSide.right {
                sideDrawerViewController = drawerController.rightDrawerViewController
                translateTransform = CATransform3DMakeTranslation(-(maxDistance-distance), 0.0, 0.0)
            }
            
            sideDrawerViewController?.view.layer.transform = CATransform3DConcat(scaleTransform, translateTransform)
            sideDrawerViewController?.view.alpha = percentVisible
        }
        
        return visualStateBlock
    }
    
    /**
     Creates a slide visual state block that gives the user an experience that slides at the same speed of the center view controller during animation. This is equal to calling `parallaxVisualStateBlockWithParallaxFactor:` with a parallax factor of 1.0.
     
     - returns: The visual state block.
     */
    public static var slideVisualStateBlock: DrawerControllerDrawerVisualStateBlock {
        return self.parallaxVisualStateBlock(parallaxFactor: 1.0)
    }
    
    /**
     Creates a swinging door visual state block that gives the user an experience that animates the drawer in along the hinge.
     
     - returns: The visual state block.
     */
    public static var swingingDoorVisualStateBlock: DrawerControllerDrawerVisualStateBlock {
        let visualStateBlock: DrawerControllerDrawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) -> Void in
            
            var sideDrawerViewController: UIViewController?
            var anchorPoint: CGPoint
            var maxDrawerWidth: CGFloat = 0.0
            var xOffset: CGFloat
            var angle: CGFloat = 0.0
            
            if drawerSide == .left {
                sideDrawerViewController = drawerController.leftDrawerViewController
                anchorPoint = CGPoint(x: 1.0, y: 0.5)
                maxDrawerWidth = max(drawerController.maximumLeftDrawerWidth, drawerController.visibleLeftDrawerWidth)
                xOffset = -(maxDrawerWidth / 2) + maxDrawerWidth * percentVisible
                angle = -CGFloat(Double.pi / 2) + percentVisible * CGFloat(Double.pi / 2)
            } else {
                sideDrawerViewController = drawerController.rightDrawerViewController
                anchorPoint = CGPoint(x: 0.0, y: 0.5)
                maxDrawerWidth = max(drawerController.maximumRightDrawerWidth, drawerController.visibleRightDrawerWidth)
                xOffset = (maxDrawerWidth / 2) - maxDrawerWidth * percentVisible
                angle = CGFloat(Double.pi / 2) - percentVisible * CGFloat(Double.pi / 2)
            }
            
            sideDrawerViewController?.view.layer.anchorPoint = anchorPoint
            sideDrawerViewController?.view.layer.shouldRasterize = true
            sideDrawerViewController?.view.layer.rasterizationScale = UIScreen.main.scale
            
            var swingingDoorTransform: CATransform3D = CATransform3DIdentity
            
            if percentVisible <= 1.0 {
                var identity: CATransform3D = CATransform3DIdentity
                identity.m34 = -1.0 / 1000.0
                let rotateTransform: CATransform3D = CATransform3DRotate(identity, angle,
                                                                         0.0, 1.0, 0.0)
                let translateTransform: CATransform3D = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
                let concatTransform = CATransform3DConcat(rotateTransform, translateTransform)
                
                swingingDoorTransform = concatTransform
            } else {
                var overshootTransform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                var scalingModifier: CGFloat = 1.0
                
                if (drawerSide == .right) {
                    scalingModifier = -1.0
                }
                
                overshootTransform = CATransform3DTranslate(overshootTransform, scalingModifier * maxDrawerWidth / 2, 0.0, 0.0)
                swingingDoorTransform = overshootTransform
            }
            
            sideDrawerViewController?.view.layer.transform = swingingDoorTransform
        }
        
        return visualStateBlock
    }
    
    /**
     Creates a parallax experience that slides the side drawer view controller at a different rate than the center view controller during animation. For every parallaxFactor of points moved by the center view controller, the side drawer view controller will move 1 point. Passing in 1.0 is the  equivalent of a applying a sliding animation, while passing in MAX_FLOAT is the equivalent of having no animation at all.
     
     - parameter parallaxFactor: The amount of parallax applied to the side drawer conroller. This value must be greater than 1.0. The closer the value is to 1.0, the faster the side drawer view controller will be parallaxing.
     
     - returns: The visual state block.
     */
    public static func parallaxVisualStateBlock(parallaxFactor: CGFloat) -> DrawerControllerDrawerVisualStateBlock {
        let visualStateBlock: DrawerControllerDrawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) -> Void in
            
            assert({ () -> Bool in
                return parallaxFactor >= 1.0
            }(), "parallaxFactor must be >= 1.0")
            
            var transform: CATransform3D = CATransform3DIdentity
            var sideDrawerViewController: UIViewController?
            
            if (drawerSide == .left) {
                sideDrawerViewController = drawerController.leftDrawerViewController
                let distance: CGFloat = max(drawerController.maximumLeftDrawerWidth, drawerController.visibleLeftDrawerWidth)
                
                if (percentVisible <= 1.0) {
                    transform = CATransform3DMakeTranslation((-distance) / parallaxFactor + (distance * percentVisible / parallaxFactor), 0.0, 0.0)
                } else {
                    transform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                    transform = CATransform3DTranslate(transform, drawerController.maximumLeftDrawerWidth * (percentVisible - 1.0) / 2, 0.0, 0.0)
                }
            } else if (drawerSide == .right) {
                sideDrawerViewController = drawerController.rightDrawerViewController
                let distance: CGFloat = max(drawerController.maximumRightDrawerWidth, drawerController.visibleRightDrawerWidth)
                
                if (percentVisible <= 1.0) {
                    transform = CATransform3DMakeTranslation((distance) / parallaxFactor - (distance * percentVisible / parallaxFactor), 0.0, 0.0)
                } else {
                    transform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                    transform = CATransform3DTranslate(transform, -drawerController.maximumRightDrawerWidth * (percentVisible - 1.0) / 2, 0.0, 0.0)
                }
            }
            
            sideDrawerViewController?.view.layer.transform = transform
        }
        
        return visualStateBlock
    }
    
    public static var animatedHamburgerButtonVisualStateBlock: DrawerControllerDrawerVisualStateBlock {
        let visualStateBlock: DrawerControllerDrawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) -> Void in
            
            var hamburgerItem: DrawerBarButtonItem?
            if let navController = drawerController.centerViewController as? UINavigationController {
                if (drawerSide == .left) {
                    if let item = navController.topViewController!.navigationItem.leftBarButtonItem as? DrawerBarButtonItem {
                        hamburgerItem = item
                    }
                } else if (drawerSide == .right) {
                    if let item = navController.topViewController!.navigationItem.rightBarButtonItem as? DrawerBarButtonItem {
                        hamburgerItem = item
                    }
                }
            }
            
            hamburgerItem?.animate(withPercentVisible: percentVisible, drawerSide: drawerSide)
        }
        
        return visualStateBlock
    }
}


public class DrawerSegue: UIStoryboardSegue {
    override public func perform() {
        assert(source is NTNavigationContainer, "DrawerSegue can only be used to define left/center/right controllers for a NTNavigationContainer")
    }
}

fileprivate extension UIViewController {
    
    // check if a view controller can perform segue
    func canPerformSegue(withIdentifier identifier: String) -> Bool {
        let templates: NSArray = value(forKey: "storyboardSegueTemplates") as! NSArray
        let predicate: NSPredicate = NSPredicate(format: "identifier=%@", identifier)
        let filteredtemplates = templates.filtered(using: predicate)
        return filteredtemplates.count > 0
    }
}

extension NTNavigationContainer {
    
    private enum Keys: String {
        case center = "center"
        case left = "left"
        case right = "right"
    }
    
    open override func awakeFromNib() {
        guard storyboard != nil else {
            return
        }
        
        // Required segue "center". Uncaught exception if undefined in storyboard.
        performSegue(withIdentifier: Keys.center.rawValue, sender: self)
        
        // Optional segue "left".
        if canPerformSegue(withIdentifier: Keys.left.rawValue) {
            performSegue(withIdentifier: Keys.left.rawValue, sender: self)
        }
        
        // Optional segue "right".
        if canPerformSegue(withIdentifier: Keys.right.rawValue) {
            performSegue(withIdentifier: Keys.right.rawValue, sender: self)
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is DrawerSegue {
            switch segue.identifier {
            case let x where x == Keys.center.rawValue:
                centerViewController = segue.destination
            case let x where x == Keys.left.rawValue:
                leftDrawerViewController = segue.destination
            case let x where x == Keys.right.rawValue:
                rightDrawerViewController = segue.destination
            default:
                break
            }
            
            return
        }
        
        super.prepare(for: segue, sender: sender)
    }
    
}

*/

public enum NTNavigationContainerState {
    case leftPanelExpanded, rightPanelExpanded, bothPanelsCollapsed
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

open class NTNavigationContainer: UIViewController, UIGestureRecognizerDelegate {
    
    // View Controllers
    
    private var centerViewController: UIViewController?
    
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
    
    open func setCenterView(to newView: UIViewController, completion: ((Bool) -> Void)! = nil) {
        if currentState == .leftPanelExpanded {
            animateLeftPanel(false, completion: { finished in
                completion?(finished)
                if finished {

                    self.centerViewController?.view.removeFromSuperview()
                    self.centerViewController?.willMove(toParentViewController: nil)
                    self.centerViewController = nil
                    self.centerViewController = newView
                    self.centerViewController?.willMove(toParentViewController: self)
                    self.view.addSubview(self.centerViewController!.view)
                    self.addChildViewController(self.centerViewController!)
                    
                    self.showLeftMenuButton(self.leftViewPanel != nil)
                    self.showRightMenuButton(self.rightViewPanel != nil)
                }
                
            })
        } else if currentState == .rightPanelExpanded {
            animateRightPanel(false, completion: { finished in
                completion?(finished)
                if finished {
                    
                    self.centerViewController?.view.removeFromSuperview()
                    self.centerViewController?.willMove(toParentViewController: nil)
                    self.centerViewController = nil
                    self.centerViewController = newView
                    self.centerViewController?.willMove(toParentViewController: self)
                    self.view.addSubview(self.centerViewController!.view)
                    self.addChildViewController(self.centerViewController!)
                    
                    self.showLeftMenuButton(self.leftViewPanel != nil)
                    self.showRightMenuButton(self.rightViewPanel != nil)
                }
                
            })
        } else {
            
            centerViewController?.view.removeFromSuperview()
            centerViewController?.willMove(toParentViewController: nil)
            centerViewController = nil
            centerViewController = newView
            centerViewController?.willMove(toParentViewController: self)
            view.addSubview(centerViewController!.view)
            addChildViewController(centerViewController!)
            
            showLeftMenuButton(self.leftViewPanel != nil)
            showRightMenuButton(self.rightViewPanel != nil)
            completion?(true)
        }
    }
    
    open var leftViewPanel: UIViewController? {
        get {
            return leftViewController
        }
    }
    
    open func setLeftViewPanel(newView: UIViewController, width: CGFloat) {
        
        leftViewController?.view.removeFromSuperview()
        leftViewController?.willMove(toParentViewController: nil)
        leftViewController = nil
        leftViewController = newView
        leftViewController?.willMove(toParentViewController: self)
        view.insertSubview(leftViewController!.view, at: 0)
        addChildViewController(leftViewController!)
        
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
//                centerViewController?.view.isUserInteractionEnabled = false  
            } else if currentState == .rightPanelExpanded {
                setRightViewProperties(hidden: false)
//                centerViewController?.view.isUserInteractionEnabled = false
            } else {
//                centerViewController?.view.isUserInteractionEnabled = true
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
    
    public required init(centerViewController: UIViewController, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
        self.init()
        self.centerViewController = centerViewController
        self.leftViewController = leftViewController
        self.rightViewController = rightViewController
        initializeContainer()
    }
    
    private func initializeContainer() {
        Log.write(.status, "Initializing NTNaviagationContainer")
        
        
        centerViewController!.didMove(toParentViewController: self)
        view.addSubview(centerViewController!.view)
        addChildViewController(centerViewController!)
        
        addSidePanelViews()
        showShadowForCenterViewController(drawerShadowShown)
        //addPanGestureRecognizer()
    }
    
    open func addPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        panGestureRecognizer.delegate = self
        centerView?.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    // MARK: - UI Properties
    private func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            Log.write(.status, "Will show shadow for center view")
            centerViewController?.view.setDefaultShadow()
            centerViewController?.view.layer.shadowOffset = CGSize(width: -Color.Default.Shadow.Offset.width, height: 0)
        } else {
            Log.write(.status, "Will hide shadow for center view")
            centerViewController?.view.hideShadow()
        }
    }
    
    // MARK: - Navigation Drawer
    private func showLeftMenuButton(_ shouldShow: Bool) {
        Log.write(.status, "Will show left menu button is \(shouldShow)")
        
        let leftDrawerButton = NTMenuBarButtonItem(target: self, action: #selector(toggleLeftPanel))
        
        if centerViewController?.navigationItem.leftBarButtonItem == nil {
            centerViewController?.navigationItem.leftBarButtonItem = shouldShow ? leftDrawerButton : nil
        }
        if let navVC = centerViewController as? UINavigationController {
            navVC.viewControllers[0].navigationItem.leftBarButtonItem = shouldShow ? leftDrawerButton : nil
        }
    }
    private func showRightMenuButton(_ shouldShow: Bool) {
        Log.write(.status, "Will show right menu button is \(shouldShow)")
        
        let rightDrawerButton = NTMenuBarButtonItem(target: self, action: #selector(toggleRightPanel))
        
        if centerViewController?.navigationItem.rightBarButtonItem == nil {
            centerViewController?.navigationItem.rightBarButtonItem = shouldShow ? rightDrawerButton : nil
        }
        if let navVC = centerViewController as? UINavigationController {
            navVC.viewControllers[0].navigationItem.leftBarButtonItem = shouldShow ? rightDrawerButton : nil
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
    private func animateLeftPanel(_ shouldExpand: Bool, completion: ((Bool) -> Void)! = nil) {
        if (shouldExpand) {
            currentState = .leftPanelExpanded
            setleftViewProperties(hidden: false)
            animateCenterPanelXPosition(leftPanelWidth) { finished in
                completion?(finished)
            }
        } else {
            animateCenterPanelXPosition(0) { finished in
                completion?(finished)
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
    
    private func animateRightPanel(_ shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
        if (shouldExpand) {
            currentState = .rightPanelExpanded
            setRightViewProperties(hidden: false)
            animateCenterPanelXPosition(-rightPanelWidth) { finished in
                completion?(finished)
            }
        } else {
            animateCenterPanelXPosition(0) { finished in
                completion?(finished)
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
    
    private func animateCenterPanelXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: drawerAnimationDuration, delay: drawerAnimationDelay, usingSpringWithDamping: drawerAnimationSpringDamping, initialSpringVelocity: drawerAnimationSpringVelocity, options: drawerAnimationStyle, animations: {
            self.centerViewController?.view.frame.origin.x = targetPosition
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
    
    open func replaceCenterViewWith(_ viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
        Log.write(.status, "Replacing center view")
        setCenterView(to: viewController, completion: completion)
    }
}
 
