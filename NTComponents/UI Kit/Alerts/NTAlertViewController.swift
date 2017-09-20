//
//  NTAlertController.swift
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

public enum NTAlertType {
    case isInfo, isSuccess, isWarning, isDanger
}

open class NTAlertViewController: UIViewController  {
    
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
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.numberOfLines = 0
        label.font = Font.Default.Headline.withSize(20)
        label.textAlignment = .center
        return label
    }()
    
    open let subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subhead)
        label.font = Font.Default.Subhead.withSize(13)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let alertContainer: NTView = {
        let view = NTView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    open let cancelButton: NTButton = {
        let button = NTButton()
        button.title = "Cancel"
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
//        button.setDefaultShadow()
        button.layer.borderWidth = 0.5
        button.layer.borderColor = Color.Gray.P400.cgColor
        return button
    }()
    
    open let confirmButton: NTButton = {
        let button = NTButton()
        button.title = "Confirm"
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(confirmButtonPresssed), for: .touchUpInside)
//        button.setDefaultShadow()
        return button
    }()
    
    open var onCancel : (() -> Void)?
    open var onConfirm : (() -> Void)?
    
    public required init(title: String? = nil, subtitle: String? = nil, type: NTAlertType? = nil) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        if let type = type {
            switch type {
            case .isInfo:
                confirmButton.backgroundColor = Color.Default.Status.Info
            case .isSuccess:
                confirmButton.backgroundColor = Color.Default.Status.Success
                confirmButton.titleColor = .white
            case .isWarning:
                confirmButton.backgroundColor = Color.Default.Status.Warning
            case .isDanger:
                confirmButton.backgroundColor = Color.Default.Status.Danger
                confirmButton.titleColor = .white
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    // MARK: - Standard Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = Color.Gray.P900.withAlphaComponent(0.2)
        view.addSubview(alertContainer)
        
        alertContainer.addSubview(titleLabel)
        alertContainer.addSubview(subtitleLabel)
        alertContainer.addSubview(cancelButton)
        alertContainer.addSubview(confirmButton)
        
        alertContainer.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 250, heightConstant: 150)
        alertContainer.anchorCenterSuperview()
        titleLabel.anchor(alertContainer.topAnchor, left: alertContainer.leftAnchor, bottom: nil, right: alertContainer.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        cancelButton.anchor(nil, left: alertContainer.leftAnchor, bottom: alertContainer.bottomAnchor, right: confirmButton.leftAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 8, widthConstant: 0, heightConstant: 40)
        confirmButton.anchor(nil, left: cancelButton.rightAnchor, bottom: alertContainer.bottomAnchor, right: alertContainer.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        cancelButton.anchorWidthToItem(confirmButton)
    }
    
    open override func show(_ vc: UIViewController? = UIApplication.presentedController, sender: Any? = nil) {
        guard let viewController = vc else { return }
        viewController.present(self, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc open func cancelButtonPressed() {
        Log.write(.status, "Cancel button pressed")
        dismiss(animated: true) { 
            self.onCancel?()
        }
    }
    
    @objc open func confirmButtonPresssed() {
        Log.write(.status, "Confirm button pressed")
        dismiss(animated: true) {
            self.onConfirm?()
        }
    }
}
