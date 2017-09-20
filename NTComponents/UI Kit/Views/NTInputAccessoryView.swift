//
//  NTInputAccessoryView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 5/22/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

open class NTInputAccessoryView: NTView {
    
    open var heightConstant: CGFloat = 40 {
        didSet {
            if controller != nil {
                layoutConstraints?[3].constant = heightConstant
                controller?.view.layoutIfNeeded()
            }
        }
    }
    
    open var controller: UIViewController? {
        didSet {
            guard let vc = controller else {
                return
            }
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
            vc.view.addSubview(self)
            layoutConstraints = anchorWithReturnAnchors(nil, left: vc.view.leftAnchor, bottom: vc.view.bottomAnchor, right: vc.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: heightConstant)
        }
    }
    
    open var layoutConstraints: [NSLayoutConstraint]?
    
    fileprivate var keyboardIsHidden: Bool = true
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - De-Initialization

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Observer
    
    @objc open func keyboardDidChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, !keyboardIsHidden, let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            guard let constant = self.layoutConstraints?[1].constant else {
                return
            }
            if keyboardSize.height < constant {
                return
            }
            
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.layoutConstraints?[1].constant = -keyboardSize.height
                self.controller?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc open func keyboardWillShow(notification: NSNotification) {
        keyboardIsHidden = false
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.layoutConstraints?[1].constant = -keyboardSize.height
                self.controller?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc open func keyboardWillHide(notification: NSNotification) {
        keyboardIsHidden = true
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: { () -> Void in
                self.layoutConstraints?[1].constant = 0
                self.controller?.view.layoutIfNeeded()
            })
        }
    }
}


