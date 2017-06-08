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
            NotificationCenter.default.addObserver(self, selector: #selector(NTTextInputBar.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(NTTextInputBar.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(NTTextInputBar.keyboardDidChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
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
        super.init(frame: .zero)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Keyboard Observer
    
    open func keyboardDidChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, !keyboardIsHidden {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.layoutConstraints?[1].constant = -keyboardSize.height
                self.controller?.view.layoutIfNeeded()
            })
        }
    }
    
    open func keyboardWillShow(notification: NSNotification) {
        keyboardIsHidden = false
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.layoutConstraints?[1].constant = -keyboardSize.height
                self.controller?.view.layoutIfNeeded()
            })
        }
    }
    
    open func keyboardWillHide(notification: NSNotification) {
        keyboardIsHidden = true
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.layoutConstraints?[1].constant = 0
            self.controller?.view.layoutIfNeeded()
        })
    }
}

