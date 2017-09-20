//
//  NTCredentialPromptViewController.swift
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
//  Created by Nathan Tannar on 5/15/17.
//

open class NTCredentialPromptViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    fileprivate let alertContainer: NTView = {
        let view = NTView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.setDefaultShadow()
        return view
    }()
    
    let emailTextField: NTTextField = {
        let textField = NTTextField(style: .body)
        textField.placeholder = "Email"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tag = 0
        return textField
    }()
    
    let emailIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.Gray.P700
        imageView.contentMode = .scaleAspectFit
        imageView.image = Icon.Email
        return imageView
    }()
    
    let passwordTextField: NTTextField = {
        let textField = NTTextField(style: .body)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.tag = 1
        return textField
    }()
    
    let passwordIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.Gray.P700
        imageView.contentMode = .scaleAspectFit
        imageView.image = Icon.Lock
        return imageView
    }()
    
    fileprivate let loginButton: NTButton = {
        let button = NTButton()
        button.title = "Login"
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(loginButtonPresssed), for: .touchUpInside)
        button.setDefaultShadow()
        return button
    }()
    
    public var onSubmit: ((_ email: String?, _ password: String?) -> Bool)?
    
    public required init(onSubmit: ((_ email: String?, _ password: String?) -> Bool)?) {
        self.init()
        self.onSubmit = onSubmit
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
        
        view.backgroundColor = Color.Gray.P900.withAlphaComponent(0.4)
        view.addSubview(alertContainer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelPrompt))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        alertContainer.frame = CGRect(x: 40, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 80, height: 160)
        alertContainer.addSubview(loginButton)
        alertContainer.addSubview(emailTextField)
        alertContainer.addSubview(emailIconView)
        alertContainer.addSubview(passwordTextField)
        alertContainer.addSubview(passwordIconView)
        
        emailIconView.anchor(alertContainer.topAnchor, left: alertContainer.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        emailTextField.anchor(emailIconView.topAnchor, left: emailIconView.rightAnchor, bottom: nil, right: alertContainer.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
        
        passwordIconView.anchor(emailIconView.bottomAnchor, left: emailIconView.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        passwordTextField.anchor(passwordIconView.topAnchor, left: passwordIconView.rightAnchor, bottom: nil, right: alertContainer.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
        
        loginButton.anchor(passwordTextField.bottomAnchor, left: alertContainer.leftAnchor, bottom: nil, right: alertContainer.rightAnchor, topConstant: 32, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 30)
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .go
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alertContainer.frame = CGRect(x: 40, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 80, height: 160)
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.85, initialSpringVelocity: 1.2, options: .curveLinear, animations: {
            self.alertContainer.frame = CGRect(x: 40, y: 100, width: UIScreen.main.bounds.width - 80, height: 160)
        }) { (success) in
            if success {
                self.alertContainer.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 100, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 160)
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        }
        if textField.tag == 1 {
            loginButtonPresssed()
        }
        return true
    }
    
    // MARK: - Actions
    @objc open func cancelPrompt() {
        if emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
            return
        }
        if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.alertContainer.frame = CGRect(x: 40, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 80, height: 160)
        }) { (success) in
            if success {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc open func loginButtonPresssed() {
        Log.write(.status, "Login button pressed")
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text else {
            NTPing(type: .isDanger, title: "Invalid Email").show(duration: 1)
            return
        }
        
        if email.isValidEmail {
            guard let success = onSubmit?(emailTextField.text, passwordTextField.text) else {
                return
            }
            if success {
                dismiss(animated: true, completion: nil)
            }
        } else {
            NTPing(type: .isDanger, title: "Invalid Email").show(duration: 2)
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let point = touch.location(in: nil)
        return !alertContainer.frame.contains(point)
    }
}
