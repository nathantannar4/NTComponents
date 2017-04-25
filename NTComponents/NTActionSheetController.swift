//
//  NTActionSheetController.swift
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

open class NTActionSheetAction: NSObject {

    public var icon: UIImage?
    public var title: String
    public var color: UIColor
    public var action: (() -> Void)?

    public required init(title: String, icon: UIImage? = nil, color: UIColor = .white, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }

}

open class NTActionSheetController: UIViewController  {

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

    fileprivate var actions: [NTActionSheetAction] = []
    fileprivate var actionButtons: [NTButton] = []

    public var titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()

    public var subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subtitle)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()

    fileprivate let actionsContainer: NTView = {
        let view = NTView()
        view.backgroundColor = .clear
        view.setDefaultShadow()
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.isHidden = true
        return view
    }()

    // MARK: - Initialization

    public required init(title: String? = nil, subtitle: String? = nil, actions: [NTActionSheetAction] = []) {
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
    }

    // MARK: - Standard Methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        let tapAction = UITapGestureRecognizer(target: self, action: #selector(dismiss(animated:completion:)))
        view.addGestureRecognizer(tapAction)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentActionSheet()
    }

    // MARK: - NTActionSheetAction Methods

    public func addAction(_ action: NTActionSheetAction) {
        actions.append(action)
    }

    public func addDismissAction(withText text: String = "Dismiss", icon: UIImage? = Icon.icon("Delete_ffffff_100"), color: UIColor = .white) {
        let dismissAction = NTActionSheetAction(title: text, icon: icon, color: color)
        actions.append(dismissAction)
    }

    open func createButton(fromAction action: NTActionSheetAction) -> NTButton {
        let button = NTButton()
        button.backgroundColor = action.color
        button.touchUpAnimationTime = 0.2
        button.trackTouchLocation = false
        button.ripplePercent = 1
        button.imageView?.backgroundColor = .clear

        // Title
        button.title = action.title
        button.titleColor = action.color.isLight ? .black : .white

        // Icon
        if action.icon != nil {

            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets.left = 66

            let iconView = UIImageView(image: action.icon)
            iconView.tintColor = action.color.isLight ? .black : .white
            button.addSubview(iconView)
            iconView.anchor(nil, left: button.leftAnchor, bottom: nil, right: nil, topConstant: 6, leftConstant: 12, bottomConstant: 6, rightConstant: 0, widthConstant: 30, heightConstant: 30)
            iconView.anchorCenterYToSuperview()
        }
        button.addTarget(self, action: #selector(didSelectAction(sender:)), for: .touchUpInside)
        return button
    }

    open func didSelectAction(sender: NTButton) {
        if let index = actionButtons.index(of: sender) {
            actions[index].action?()
            dismiss()
        }
    }

    // MARK: - Animation Methods

    public func presentActionSheet() {

        let numberOfActions = actions.count

        if numberOfActions <= 0 {
            return
        }

        let actionButtonHeight = 44
        let titleLabelHeight: CGFloat = 20
        let subtitleLabelHeight: CGFloat = 15
        let containerHeight: CGFloat = CGFloat(numberOfActions * actionButtonHeight) + (title != nil ? titleLabelHeight : 0) + (subtitle != nil ? subtitleLabelHeight : 0)

        view.addSubview(actionsContainer)
        actionsContainer.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: containerHeight)

        // Header
        if title != nil {
            actionsContainer.addSubview(titleLabel)
            titleLabel.anchor(actionsContainer.topAnchor, left: actionsContainer.leftAnchor, bottom: nil, right: actionsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: titleLabelHeight)
        }
        if subtitle != nil {
            actionsContainer.addSubview(subtitleLabel)
            subtitleLabel.anchor((actionsContainer.secondLastSubview()?.bottomAnchor ?? actionsContainer.topAnchor), left: actionsContainer.leftAnchor, bottom: nil, right: actionsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: subtitleLabelHeight)
        }

        actionButtons.removeAll()

        // Actions
        for action in actions {
            let button = createButton(fromAction: action)
            actionButtons.append(button)
            actionsContainer.addSubview(button)
            button.anchor((actionsContainer.secondLastSubview()?.bottomAnchor ?? actionsContainer.topAnchor), left: actionsContainer.leftAnchor, bottom: nil, right: actionsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: CGFloat(actionButtonHeight))
        }

        self.actionsContainer.frame.origin.y = UIScreen.main.bounds.maxY
        self.actionsContainer.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = Color.Gray.P900.withAlphaComponent(0.2)
            self.actionsContainer.frame.origin.y = UIScreen.main.bounds.maxY - containerHeight
        }, completion: nil)
    }

    open override func dismiss(animated flag: Bool = false, completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
            self.actionsContainer.frame.origin.y = UIScreen.main.bounds.maxY
            self.view.backgroundColor = .clear
        }) { (success) in
            if success {
                super.dismiss(animated: flag, completion: completion)
            }
        }
    }
}
