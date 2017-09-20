//
//  NTNavigationViewController.swift
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
//  Created by Nathan Tannar on 5/19/17.
//

public protocol NTNavigationViewControllerDelegate: NSObjectProtocol {
    func nextViewController(_ navigationViewController: NTNavigationViewController) -> UIViewController?
    func navigationViewController(_ navigationViewController: NTNavigationViewController, shouldMoveTo viewController: UIViewController) -> Bool
}

public extension UIViewController {
    var navigationViewController: NTNavigationViewController? {
        var parentViewController = parent
        
        while parentViewController != nil {
            if let view = parentViewController as? NTNavigationViewController{
                return view
            }
            parentViewController = parentViewController!.parent
        }
        Log.write(.warning, "View controller did not have an NTNavigationViewController as a parent")
        return nil
    }
}

open class NTNavigationViewController: NTViewController {
    
    open override var title: String? {
        get {
            return super.title
        }
        set {
            titleLabel.text = newValue
            super.title = newValue
        }
    }
    
    open weak var delegate: NTNavigationViewControllerDelegate?

    open let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Default.Background.NavigationBar
        view.setDefaultShadow()
        return view
    }()
    
    open let backButton: NTButton = {
        let button = NTButton()
        button.backgroundColor = .clear
        button.trackTouchLocation = false
        button.tintColor = Color.Default.Tint.NavigationBar
        if Color.Default.Background.Button == Color.Default.Background.NavigationBar {
            button.rippleColor = Color.Default.Background.Button.darker(by: 10)
        }
        button.image = Icon.Delete
        button.ripplePercent = 1.2
        button.rippleOverBounds = true
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.adjustsFontSizeToFitWidth = true
        label.font = Font.Default.Title.withSize(22)
        return label
    }()
    
    open let nextButton: NTButton = {
        let button = NTButton()
        button.isHidden = true
        button.trackTouchLocation = false
        button.image = Icon.Arrow.Forward
        button.ripplePercent = 1
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.adjustsImageWhenHighlighted = false
        button.setDefaultShadow()
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        return button
    }()
    
    fileprivate var rootViewController: UIViewController! {
        didSet {
            title = rootViewController.title
        }
    }
    fileprivate weak var previousViewController: UIViewController?
    
    // MARK: - Initialization
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(rootViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)
        self.rootViewController = rootViewController
        self.rootViewController.didMove(toParentViewController: self)
        self.addChildViewController(self.rootViewController)
        view.insertSubview(self.rootViewController.view, at: 0)
        self.rootViewController.view.anchor(navigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // MARK: - Standard Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultShadow()
        view.layer.shadowOffset = CGSize(width: -Color.Default.Shadow.Offset.width, height: 0)
        view.addSubview(navigationBar)
        navigationBar.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 84)
        
        navigationBar.addSubview(backButton)
        navigationBar.addSubview(titleLabel)
        view.addSubview(nextButton)
        
        backButton.anchor(navigationBar.topAnchor, left: navigationBar.leftAnchor, bottom: nil, right: nil, topConstant: 22, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        titleLabel.anchor(backButton.bottomAnchor, left: backButton.leftAnchor, bottom: navigationBar.bottomAnchor, right: navigationBar.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        nextButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 50, heightConstant: 50)
        
        let flickGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backButtonPressed))
        flickGesture.edges = .left
        view.addGestureRecognizer(flickGesture)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let navColor = navigationBar.backgroundColor else {
            return
        }
        UIApplication.shared.statusBarStyle = navColor.isLight ? .default : .lightContent
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if previousViewController != nil {
            backButton.image = Icon.Arrow.Backward
        } 
        if (delegate?.nextViewController(self)) != nil {
            nextButton.isHidden = false
        }
    }
    
    @objc open func nextButtonPressed() {
        guard let vc = delegate?.nextViewController(self) else {
            return
        }
        if delegate!.navigationViewController(self, shouldMoveTo: vc) {
            let navVC = NTNavigationViewController(rootViewController: vc)
            navVC.previousViewController = self
            presentViewController(navVC, from: .right, completion: nil)
        }
    }
    
    @objc open func backButtonPressed() {
        if previousViewController == nil {
            
            dismiss(animated: true, completion: {
                UIApplication.presentedController?.viewWillAppear(true)
            })
        } else {
            dismissViewController(to: .right) {
                self.previousViewController?.viewWillAppear(true)
            }
        }
    }
}
