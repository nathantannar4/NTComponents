//
//  NTLoginViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/7/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

public enum NTLoginLogicOptions: String {
    case email = "Email"
    case facebook = "Facebook"
    case google = "Google"
    case twitter = "Twitter"
}

open class NTLoginViewController: NTTableViewController, NTTableViewDataSource, UITextFieldDelegate {
    
    public var logo: UIImage?
    public var loginOptions = [NTLoginLogicOptions]()
    public enum tableCells {
        case loginOptions, login, register
    }
    public var viewPurpose = tableCells.loginOptions
    public var emailText: String?
    public var passwordText: String?
    public var passwordVerifyText: String?
    public var fullnameText: String?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.tableView.contentInset.top = 10
        self.tableView.contentInset.bottom = 60
        self.tableView.emptyFooterHeight = 40
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.loginOptions.count == 0 {
            self.loginOptions = [.email]
        }
        if self.loginOptions.count == 1 && self.loginOptions[0] == .email {
            self.viewPurpose = .login
        }
    }
    
    // MARK: Actions
    
    internal func toggleLoginView() {
        if self.viewPurpose == .login || self.viewPurpose == .register {
            self.viewPurpose = .loginOptions
        } else {
            self.viewPurpose = .login
        }
        self.reloadData()
    }
    
    internal func loginPressed() {
        self.dismissKeyboard()
        if self.isValidEmail && self.isValidPassword {
            self.emailLoginLogic(email: self.emailText!, password: self.passwordText!)
        } else if self.isValidEmail {
            self.toastError("Invalid Password")
        } else {
            self.toastError("Invalid Email")
        }
    }
    
    internal func registerPressed() {
        self.dismissKeyboard()
        if self.isValidEmail && self.isValidPassword && self.passwordText == self.passwordVerifyText {
            if self.fullnameText == nil {
                self.fullnameText = self.emailText?.components(separatedBy: "@")[0]
            } else if self.fullnameText!.isEmpty {
                self.fullnameText = self.emailText?.components(separatedBy: "@")[0]
            }
            self.emailRegisterLogic(email: self.emailText!, password: self.passwordText!, name: self.fullnameText!)
        } else if self.isValidEmail {
            self.toastError("Choose a Stronger Password")
        } else {
            self.toastError("Invalid Email")
        }
    }

    // To be overridden by subclass
    open func emailLoginLogic(email: String, password: String) {
        print("### ERROR: You have not overriden the email login logic")
    }
    
    // To be overridden by subclass
    open func facebookLoginLogic() {
        print("### ERROR: You have not overriden the Facebook login logic")
    }
    
    // To be overridden by subclass
    open func twitterLoginLogic() {
        print("### ERROR: You have not overriden the Twitter login logic")
    }
    
    // To be overridden by subclass
    open func googleLoginLogic() {
        print("### ERROR: You have not overriden the Google login logic")
    }
    
    // To be overridden by subclass
    open func emailRegisterLogic(email: String, password: String, name: String) {
        print("### ERROR: You have not overriden the email register logic")
    }
    
    // Can be overridden by subclass
    open func registerButtonPressed() {
        self.viewPurpose = .register
        self.reloadData()
    }
    
    final func backToLogin() {
        self.viewPurpose = .login
        self.reloadData()
    }
    
    // MARK: Error Handling
    
    open func toastError(_ error: String) {
        let toast = Toast(text: error, button: nil, color: Color.darkGray, height: 44)
        toast.dismissOnTap = true
        toast.show(duration: 2.0)
    }
    
    // MARK: NTTableViewDataSource
    
    public func tableView(_ tableView: NTTableView, cellForHeaderInSection section: Int) -> NTHeaderCell? {
        if self.viewPurpose == .login {
            if section == 2 {
                let header = NTHeaderCell.initFromNib()
                header.title = "Email"
                return header
            } else if section == 3 {
                let header = NTHeaderCell.initFromNib()
                header.title = "Password"
                return header
            } else if section == 4 {
                return NTHeaderCell()
            } else {
                return nil
            }
        } else if self.viewPurpose == .register {
            if section == 2 {
                let header = NTHeaderCell.initFromNib()
                header.title = "Email"
                return header
            } else if section == 3 {
                let header = NTHeaderCell.initFromNib()
                header.title = "Password"
                return header
            } else if section == 4 {
                let header = NTHeaderCell.initFromNib()
                header.title = "Verify Password"
                return header
            } else if section == 5 {
                let header = NTHeaderCell.initFromNib()
                header.title = "Full Name"
                return header
            } else if section == 6 {
                return NTHeaderCell()
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    open func tableView(_ tableView: NTTableView, cellForFooterInSection section: Int) -> NTFooterCell? {
        if section == (numberOfSections(in: self.tableView) - 1) {
            let footer = NTFooterCell.initFromNib()
            if self.viewPurpose != .loginOptions && loginOptions.count > 1 {
                let loginOptions = NSMutableAttributedString(string: "Or login with ")
                for option in self.loginOptions {
                    if option != .email {
                        loginOptions.append(NSMutableAttributedString(string: option.rawValue, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: Color.defaultButtonTint]))
                        let index = self.loginOptions.index(of: option)!
                        if (index != self.loginOptions.count - 1) && self.loginOptions[index + 1] != .email {
                            loginOptions.append(NSMutableAttributedString(string: "/", attributes: [NSForegroundColorAttributeName: Color.defaultButtonTint]))
                        }
                    }
                }
                footer.attributedTitle = loginOptions
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(toggleLoginView))
                footer.addGestureRecognizer(tapAction)
            } else {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    footer.title = "Version \(version)"
                }
            }
            return footer
        } else if section == 0 {
            return NTFooterCell()
        } else if section == 1 && self.viewPurpose == .loginOptions {
            return NTFooterCell()
        } else {
            return nil
        }
    }
    
    final public func numberOfSections(in tableView: NTTableView) -> Int {
        switch self.viewPurpose {
        case .loginOptions:
            return (self.loginOptions.count + 2)
        case .login:
            return 5
        case .register:
            return 8
        }
    }
    
    final public func tableView(_ tableView: NTTableView, rowsInSection section: Int) -> Int {
        return 1
    }
    
    final public func tableView(_ tableView: NTTableView, cellForRowAt indexPath: IndexPath) -> NTTableViewCell {
        let section = indexPath.section
        if section == 0 {
            // Image row
            let cell = NTImageCell.initFromNib()
            cell.image = logo
            cell.horizontalInset = self.view.frame.width / 4
            cell.backgroundColor = UIColor.clear
            return cell
        } else if section == 1 {
            // Title row
            let cell = NTDynamicHeightTextCell.initFromNib()
            if let name = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String {
                cell.text = name
            }
            cell.contentLabel.font = UIFont.systemFont(ofSize: 36, weight: UIFontWeightLight)
            cell.contentLabel.textAlignment = .center
            cell.verticalInset = -20
            cell.backgroundColor = UIColor.clear
            return cell
        }
        switch self.viewPurpose {
        case .login:
            switch section {
            case 2:
                // Email row
                let cell = NTInputCell.initFromNib()
                cell.setDefaults()
                cell.textField.delegate = self
                cell.textField.tag = 0
                cell.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
                cell.textField.keyboardType = .emailAddress
                cell.textField.font = UIFont.systemFont(ofSize: 17)
                self.addToolBar(textField: cell.textField)
                return cell
            case 3:
                // Password row
                let cell = NTInputCell.initFromNib()
                cell.setDefaults()
                cell.textField.delegate = self
                cell.textField.tag = 1
                cell.textField.isSecureTextEntry = true
                cell.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
                cell.textField.font = UIFont.systemFont(ofSize: 17)
                self.addToolBar(textField: cell.textField)
                return cell
            case 4:
                // Login row
                let cell = NTDualActionCell.initFromNib()
                cell.verticalInset = 6
                cell.backgroundColor = UIColor.clear
                cell.leftButton.setTitle("Register", for: .normal)
                cell.leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
                cell.leftButton.backgroundColor = UIColor.white
                cell.leftButton.layer.cornerRadius = 5
                cell.leftButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
                cell.rightButton.setTitle("Login", for: .normal)
                cell.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
                cell.rightButton.backgroundColor = UIColor.white
                cell.rightButton.layer.cornerRadius = 5
                cell.rightButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
                return cell
            default:
                return NTTableViewCell()
            }
        case .register:
            switch section {
            case 2:
                // Email row
                let cell = NTInputCell.initFromNib()
                cell.setDefaults()
                cell.textField.delegate = self
                cell.textField.tag = 0
                cell.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
                cell.textField.keyboardType = .emailAddress
                cell.textField.font = UIFont.systemFont(ofSize: 17)
                self.addToolBar(textField: cell.textField)
                return cell
            case 3:
                // Password row
                let cell = NTInputCell.initFromNib()
                cell.setDefaults()
                cell.textField.delegate = self
                cell.textField.tag = 1
                cell.textField.isSecureTextEntry = true
                cell.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
                cell.textField.font = UIFont.systemFont(ofSize: 17)
                self.addToolBar(textField: cell.textField)
                return cell
            case 4:
                // Password verify row
                let cell = NTInputCell.initFromNib()
                cell.setDefaults()
                cell.textField.delegate = self
                cell.textField.tag = 2
                cell.textField.isSecureTextEntry = true
                cell.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
                cell.textField.font = UIFont.systemFont(ofSize: 17)
                self.addToolBar(textField: cell.textField)
                return cell
            case 5:
                // Full Name row
                let cell = NTInputCell.initFromNib()
                cell.setDefaults()
                cell.textField.delegate = self
                cell.textField.tag = 3
                cell.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
                cell.textField.font = UIFont.systemFont(ofSize: 17)
                self.addToolBar(textField: cell.textField)
                return cell
            case 6:
                // Login row
                let cell = NTDualActionCell.initFromNib()
                cell.verticalInset = 6
                cell.backgroundColor = UIColor.clear
                cell.leftButton.setTitle("Back", for: .normal)
                cell.leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
                cell.leftButton.backgroundColor = UIColor.white
                cell.leftButton.layer.cornerRadius = 5
                cell.leftButton.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
                cell.rightButton.setTitle("Register", for: .normal)
                cell.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
                cell.rightButton.backgroundColor = UIColor.white
                cell.rightButton.layer.cornerRadius = 5
                cell.rightButton.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
                return cell
            default:
                return NTTableViewCell()
            }
        case .loginOptions:
            let cell = NTLoginOptionCell.initFromNib()
            cell.horizontalInset = 20
            let loginOption = self.loginOptions[section - 2]
            let cellTitle = NSMutableAttributedString()
            cellTitle.append(NSMutableAttributedString(string: "   Login", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
            cellTitle.append(NSMutableAttributedString(string: " with ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]))
            switch loginOption {
            case .email:
                cell.backgroundView.backgroundColor = UIColor.white
                cell.image = Icon.email?.withRenderingMode(.alwaysTemplate)
                cell.imageView.tintColor = UIColor.black
                cellTitle.append(NSMutableAttributedString(string: "Email", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.attributedTitle = cellTitle
                cell.titleLabel.textColor = UIColor.black
                cell.titleLabel.addBorder(edges: .left, colour: UIColor.black, thickness: 1)
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(toggleLoginView))
                cell.addGestureRecognizer(tapAction)
            case .facebook:
                cell.backgroundView.backgroundColor = Color.FacebookBlue
                cell.image = Icon.facebook
                cellTitle.append(NSMutableAttributedString(string: "Facebook", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.attributedTitle = cellTitle
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(facebookLoginLogic))
                cell.addGestureRecognizer(tapAction)
            case .twitter:
                cell.backgroundView.backgroundColor = Color.TwitterBlue
                cell.image = Icon.twitter?.withRenderingMode(.alwaysTemplate)
                cell.imageView.tintColor = UIColor.white
                cellTitle.append(NSMutableAttributedString(string: "Twitter", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.attributedTitle = cellTitle
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(twitterLoginLogic))
                cell.addGestureRecognizer(tapAction)
            case .google:
                cell.backgroundView.backgroundColor = UIColor.white
                cell.image = Icon.google
                cellTitle.append(NSMutableAttributedString(string: "Google", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.attributedTitle = cellTitle
                cell.titleLabel.textColor = UIColor.black
                cell.titleLabel.addBorder(edges: .left, colour: UIColor.black, thickness: 1)
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(googleLoginLogic))
                cell.addGestureRecognizer(tapAction)
            }
            return cell
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewPurpose != .register {
            self.dismissKeyboard()
        }
    }
    
    // MARK: UITextFieldDelegate
    
    internal func textFieldDidChange(textField: UITextField) {
        if textField.tag == 0 {
            // Email text field
            self.emailText = textField.text
            if self.viewPurpose == .register {
                if !self.isValidEmail {
                    textField.textColor = Color.Red.P500
                } else {
                    textField.textColor = UIColor.black
                }
            }
        } else if textField.tag == 1 {
            // Password text field
            self.passwordText = textField.text
        } else if textField.tag == 2 {
            // Password verify text field
            self.passwordVerifyText = textField.text
            if self.passwordText != self.passwordVerifyText {
                textField.textColor = Color.Red.P500
            } else {
                textField.textColor = UIColor.black
            }
        } else if textField.tag == 3 {
            // Fullname text field
            self.fullnameText = textField.text?.lowercased().capitalized
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField.tag == 1 && self.viewPurpose == .login {
            self.loginPressed()
        } else if textField.tag == 3 && self.viewPurpose == .register {
            self.registerPressed()
        }
        return false
    }
    
    private func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Color.defaultButtonTint
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    // MARK: Validation Variables
    
    open var isValidEmail: Bool {
        guard let email = self.emailText else {
            return false
        }
        return email.isValidEmail()
    }
    
    open var isValidPassword: Bool {
        guard let password = self.passwordText else {
            return false
        }
        return (password.characters.count >= 8)
    }
    
    // MARK: Keyboard
    
    public func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    internal func keyboardWillShow(notification: NSNotification) {
        if self.tableView.frame.origin.y == 0 {
            if self.tableView.frame.width > self.tableView.frame.height {
                // Landscape
                self.tableView.frame.origin.y -= 100
            } else {
                // Portait
                self.tableView.frame.origin.y -= 200
            }
        }
    }
    
    internal func keyboardWillHide(notification: NSNotification) {
        if self.tableView.frame.origin.y != 0 {
            self.tableView.frame.origin.y = 0
        }
    }
}
