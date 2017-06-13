//
//  NTActionSheetViewController.swift
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

import UIKit

open class NTActionSheetItem: NSObject {

    open var icon: UIImage?
    open var iconTint: UIColor?
    open var title: String
    open var color: UIColor
    open var action: (() -> Void)?

    public required init(title: String, icon: UIImage? = nil, iconTint: UIColor? = Color.Default.Tint.Button, color: UIColor = .white, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
        self.iconTint = iconTint
    }

}

open class NTActionSheetViewController: UIViewController  {

    open override var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    open var subtitle: String? {
        get {
            return subtitleLabel.text
        }
        set {
            subtitleLabel.text = newValue
        }
    }
    
    open var actionButtonHeight: CGFloat = 44
    open var titleLabelHeight: CGFloat = 30
    open var subtitleLabelHeight: CGFloat = 20
    
    fileprivate var actions: [NTActionSheetItem] = []
    fileprivate var actionButtons: [NTButton] = []

    public var titleLabel: NTLabel = {
        let label = NTLabel(style: .callout)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()

    public var subtitleLabel: NTLabel = {
        let label = NTLabel(style: .caption)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()

    fileprivate let actionsContainer: NTView = {
        let view = NTView()
        view.backgroundColor = .clear
        view.setDefaultShadow()
        view.layer.shadowOffset = CGSize(width: 0, height: -Color.Default.Shadow.Offset.height)
        return view
    }()

    // MARK: - Initialization

    public required init(title: String? = nil, subtitle: String? = nil, actions: [NTActionSheetItem] = []) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        self.actions = actions
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    // MARK: - Standard Methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        let tapAction = UITapGestureRecognizer(target: self, action: #selector(dismissActionSheet))
        view.addGestureRecognizer(tapAction)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentActionSheet()
    }
    
    open override func show(_ vc: UIViewController? = UIViewController.topWindow()?.rootViewController, sender: Any? = nil) {
        guard let viewController = vc else { return }
        viewController.present(self, animated: false, completion: nil)
    }

    // MARK: - NTActionSheetAction Methods
    
    open func dismissActionSheet() {
        dismiss()
    }

    public func addAction(_ action: NTActionSheetItem) {
        actions.append(action)
    }

    public func addDismissAction(withText text: String = "Dismiss", icon: UIImage? = nil, color: UIColor = .white) {
        
        let dismissAction = NTActionSheetItem(title: text, icon: icon, iconTint: UIColor.black, color: color)
        actions.append(dismissAction)
    }

    open func createButton(fromAction action: NTActionSheetItem) -> NTButton {
        let button = NTButton()
        button.backgroundColor = action.color
        button.touchUpAnimationTime = 0.4
        button.ripplePercent = 1.2
        button.imageView?.backgroundColor = .clear
        
        let separatorView = UIView()
        separatorView.backgroundColor = Color.Gray.P500
        button.addSubview(separatorView)
        separatorView.anchor(nil, left: button.leftAnchor, bottom: button.bottomAnchor, right: button.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)

        // Title
        button.title = action.title
        button.titleColor = action.color.isLight ? .black : .white

        // Icon
        if action.icon != nil {

            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets.left = 66

            let iconView = UIImageView(image: action.icon)
            iconView.tintColor = action.iconTint
            button.addSubview(iconView)
            iconView.anchor(nil, left: button.leftAnchor, bottom: nil, right: nil, topConstant: 6, leftConstant: 12, bottomConstant: 6, rightConstant: 0, widthConstant: 30, heightConstant: 30)
            iconView.anchorCenterYToSuperview()
        }
        button.addTarget(self, action: #selector(didSelectAction(sender:)), for: .touchUpInside)
        return button
    }

    open func didSelectAction(sender: NTButton) {
        if let index = actionButtons.index(of: sender) {
            dismiss(animated: false, completion: {
                self.actions[index].action?()
            })
        }
    }

    // MARK: - Animation Methods

    fileprivate func presentActionSheet() {

        let numberOfActions = CGFloat(actions.count)
        let containerHeight: CGFloat = (numberOfActions * actionButtonHeight) + (title != nil ? titleLabelHeight : 0) + (subtitle != nil ? subtitleLabelHeight : 0)

        view.addSubview(actionsContainer)
        actionsContainer.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: containerHeight)

        // Header
        if title != nil {
            actionsContainer.addSubview(titleLabel)
            titleLabel.anchor(actionsContainer.topAnchor, left: actionsContainer.leftAnchor, bottom: nil, right: actionsContainer.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: titleLabelHeight - 10)
            
            titleLabel.round(corners: [.topLeft, .topRight], radius: 16)
            
            if subtitle == nil {
                let separatorView = UIView()
                separatorView.backgroundColor = Color.Gray.P500
                titleLabel.addSubview(separatorView)
                separatorView.anchor(nil, left: titleLabel.leftAnchor, bottom: titleLabel.bottomAnchor, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
            }
        }
        if subtitle != nil {
            actionsContainer.addSubview(subtitleLabel)
            subtitleLabel.anchor((actionsContainer.secondLastSubview()?.bottomAnchor ?? actionsContainer.topAnchor), left: actionsContainer.leftAnchor, bottom: nil, right: actionsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: subtitleLabelHeight)
            
            if title == nil {
                subtitleLabel.round(corners: [.topLeft, .topRight], radius: 16)
            }
            
            let separatorView = UIView()
            separatorView.backgroundColor = Color.Gray.P500
            subtitleLabel.addSubview(separatorView)
            separatorView.anchor(nil, left: subtitleLabel.leftAnchor, bottom: subtitleLabel.bottomAnchor, right: subtitleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        }

        actionButtons.removeAll()

        // Actions
        for action in actions {
            let button = createButton(fromAction: action)
            actionButtons.append(button)
            actionsContainer.addSubview(button)
            button.anchor((actionsContainer.secondLastSubview()?.bottomAnchor ?? actionsContainer.topAnchor), left: actionsContainer.leftAnchor, bottom: nil, right: actionsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: CGFloat(actionButtonHeight))
        }

        actionsContainer.frame.origin.y = UIScreen.main.bounds.maxY
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.view.backgroundColor = Color.Gray.P900.withAlphaComponent(0.2)
            self.actionsContainer.frame.origin.y = UIScreen.main.bounds.maxY - containerHeight
        }, completion: nil)
    }

    open override func dismiss(animated flag: Bool = false, completion: (() -> Void)? = nil) {

        let containerHeight: CGFloat = (CGFloat(actions.count) * actionButtonHeight) + (title != nil ? titleLabelHeight : 0) + (subtitle != nil ? subtitleLabelHeight : 0)
        
        actionsContainer.frame.origin.y = UIScreen.main.bounds.maxY - containerHeight
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.actionsContainer.frame.origin.y = UIScreen.main.bounds.maxY
            self.view.backgroundColor = .clear
        }) { (success) in
            if success {
                super.dismiss(animated: flag, completion: completion)
            }
        }
    }
}
