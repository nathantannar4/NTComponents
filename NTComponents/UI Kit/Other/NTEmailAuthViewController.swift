//
//  NTEmailAuthViewController.swift
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

@objc public protocol NTEmailAuthDelegate {
    func authorize(_ controller: NTEmailAuthViewController, email: String, password: String)
    @objc optional func register(_ controller: NTEmailAuthViewController, email: String, password: String)
}

open class NTEmailAuthViewController: NTViewController, NTEmailAuthDelegate {
    
    open weak var delegate: NTEmailAuthDelegate?
    
    open let navBarView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Default.Background.NavigationBar
        view.setDefaultShadow()
        return view
    }()
    
    open let cancelButton: NTButton = {
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
        button.addTarget(self, action: #selector(cancelAuth), for: .touchUpInside)
        return button
    }()
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.font = Font.Default.Headline.withSize(22)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Email Sign In"
        return label
    }()
    
    open let signInButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.title = "Sign In"
        button.ripplePercent = 1
        button.layer.cornerRadius = 18
        button.setDefaultShadow()
        button.addTarget(self, action: #selector(submitAuth), for: .touchUpInside)
        return button
    }()
    
    open let signUpButton: NTButton = {
        let button = NTButton()
        button.title = "Sign Up"
        button.titleFont = Font.Default.Headline.withSize(12)
        button.ripplePercent = 0.6
        button.backgroundColor = .clear
        button.tintColor = Color.Gray.P500
        button.rippleColor = Color.Default.Background.ViewController.darker(by: 5)
        button.rippleOverBounds = true
        button.image = Icon.Arrow.Forward?.scale(to: 15)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.setPreferredFontStyle(to: .caption)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(showSignUpViewController), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: NTAnimatedTextField = {
        let textField = NTAnimatedTextField(style: .body)
        textField.placeholder = "Email"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let passwordTextField: NTAnimatedTextField = {
        let textField = NTAnimatedTextField(style: .body)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let passwordViewToggleButton: NTButton = {
        let button = NTButton()
        button.imageView?.tintColor = Color.Default.Tint.View
        button.backgroundColor = .clear
        button.trackTouchLocation = false
        button.ripplePercent = 1.5
        button.rippleOverBounds = true
        button.image = Icon.Lock
        button.addTarget(self, action: #selector(togglePasswordTextFieldSecurity), for: .touchUpInside)
        return button
    }()
    
    fileprivate let indicatorView = NTProgressHUD()
    
    open var showActivityIndicator: Bool = false {
        didSet {
            if showActivityIndicator {
                UIApplication.shared.beginIgnoringInteractionEvents()
                indicatorView.show()
            } else {
                UIApplication.shared.endIgnoringInteractionEvents()
                indicatorView.dismiss()
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.Default.Background.ViewController
        view.addSubview(navBarView)
        navBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 84)
        
        navBarView.addSubview(cancelButton)
        navBarView.addSubview(titleLabel)
        
        cancelButton.anchor(navBarView.topAnchor, left: navBarView.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        titleLabel.anchor(cancelButton.bottomAnchor, left: cancelButton.leftAnchor, bottom: navBarView.bottomAnchor, right: navBarView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 2, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.anchor(navBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        passwordTextField.anchor(emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        
        view.addSubview(passwordViewToggleButton)
        passwordViewToggleButton.anchor(passwordTextField.topAnchor, left: nil, bottom: nil, right: passwordTextField.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 5, widthConstant: 30, heightConstant: 30)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let accessoryView = NTInputAccessoryView()
        accessoryView.heightConstant = 52
        accessoryView.controller = self
        accessoryView.backgroundColor = .clear
        accessoryView.addSubview(signInButton)
        signInButton.anchor(nil, left: nil, bottom: accessoryView.bottomAnchor, right: accessoryView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 100, heightConstant: 36)
    }
    
    @objc open func submitAuth() {
        
        guard let email = emailTextField.text else {
            NTPing(type: .isDanger, title: "Invalid Email").show()
            return
        }
        if email.isValidEmail {
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            delegate?.authorize(self, email: email, password: passwordTextField.text ?? String())
        } else {
            NTPing(type: .isDanger, title: "Invalid Email").show()
        }
    }
    
    @objc open func cancelAuth() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func togglePasswordTextFieldSecurity() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordViewToggleButton.image = passwordTextField.isSecureTextEntry ? Icon.Lock : Icon.Unlock
    }
    
    @objc open func showSignUpViewController() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        let vc = NTEmailRegisterViewController()
        vc.delegate = self
        vc.view.setDefaultShadow()
        vc.view.layer.shadowOffset = CGSize(width: -2, height: 0)
        presentViewController(vc, from: .right, completion: nil)
    }
    
    // MARK: - NTEmailAuthDelegate
    
    public func authorize(_ controller: NTEmailAuthViewController, email: String, password: String) {
        delegate?.register?(controller, email: email, password: password)
    }
}
