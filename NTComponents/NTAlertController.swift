//
//  NTAlertController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/12/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTAlertViewController: UIViewController  {
    
    fileprivate var currentState: NTViewState = .hidden
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.numberOfLines = 0
        label.font = Font.Defaults.title.withSize(20)
        label.textAlignment = .center
        return label
    }()
    
    open let subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subtitle)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let alertContainer: NTView = {
        let view = NTView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.setDefaultShadow()
        return view
    }()
    
    fileprivate let cancelButton: NTButton = {
        let button = NTButton()
        button.title = "Cancel"
        button.titleColor = .white
        button.backgroundColor = Color.Default.Status.Danger
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate let confirmButton: NTButton = {
        let button = NTButton()
        button.title = "Confirm"
        button.titleColor = .white
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = Color.Default.Status.Success
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(confirmButtonPresssed), for: .touchUpInside)
        return button
    }()
    
    open override var title: String? {
        get {
            return super.title
        }
        set {
            super.title = newValue
            titleLabel.text = newValue
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
    public var onCancel : (() -> Void)?
    public var onConfirm : (() -> Void)?
    
    public required init(title: String, subtitle: String? = nil) {
        self.init()
        self.title = title
        self.subtitle = subtitle
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    // MARK: - Class Functions
    open override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = Color.Gray.P900.withAlphaComponent(0.2)
        
        view.addSubview(alertContainer)
        
        alertContainer.addSubview(titleLabel)
        alertContainer.addSubview(subtitleLabel)
        alertContainer.addSubview(cancelButton)
        alertContainer.addSubview(confirmButton)
        
        alertContainer.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: 250)
        alertContainer.anchorCenterSuperview()
        titleLabel.anchor(alertContainer.topAnchor, left: alertContainer.leftAnchor, bottom: nil, right: alertContainer.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        cancelButton.anchor(nil, left: titleLabel.leftAnchor, bottom: alertContainer.bottomAnchor, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        confirmButton.anchor(nil, left: titleLabel.leftAnchor, bottom: cancelButton.topAnchor, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    // MARK: - Actions
    open func cancelButtonPressed() {
        onCancel?()
        Log.write(.status, "Cancel button pressed")
        dismiss(animated: true)
    }
    
    open func confirmButtonPresssed() {
        onConfirm?()
        Log.write(.status, "Confirm button pressed")
        dismiss(animated: true)
    }
}
