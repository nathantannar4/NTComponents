//
//  NTLoginViewController.swift
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

public enum NTLoginMethod {
    case email, facebook, twitter, google, github, linkedin, custom
}

open class NTLoginButton: NTButton {
    open var loginMethod: NTLoginMethod?
}

open class NTLoginViewController: NTViewController, UITableViewDataSource, UITableViewDelegate {
    
    open var loginMethods: [NTLoginMethod] = [.facebook, .twitter, .google, .github, .linkedin, .email]
    
    open var logo: UIImage? {
        get {
            return logoView.image
        }
        set {
            logoView.image = newValue
        }
    }
    
    open var logoView: NTImageView = {
        let imageView = NTImageView()
        return imageView
    }()
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.font = Font.Default.Title.withSize(36)
        label.adjustsFontSizeToFitWidth = true
        label.text = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        label.textAlignment = .center
        return label
    }()
    
    open var subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subtitle)
        label.font = Font.Default.Subtitle.withSize(24)
        label.adjustsFontSizeToFitWidth = true
        label.text = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        label.textAlignment = .center
        return label
    }()
    
    open var tableView: NTTableView = {
        let tableView = NTTableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 10
        return tableView
    }()
    
    open var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Gray.P700
        return view
    }()
    
    // MARK: - Standard Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(logoView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(separatorView)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        logoView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        logoView.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        titleLabel.anchor(logoView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        subtitleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 20).isActive = true
        
        separatorView.anchor(subtitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 6, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0.5)
        
        tableView.anchor(separatorView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // MARK: - Login Button Methods
    
    open func createLoginButton(forMethod method: NTLoginMethod) -> NTLoginButton {
        var button: NTLoginButton
        switch method {
        case .email:
            button = createLoginButton(color: Color.Default.Tint.Button, title: "Login with Email", logo: Icon.Email)
        case .facebook:
            button = createLoginButton(color: Color.FacebookBlue, title: "Login with Facebook", logo: Icon.facebook)
        case .twitter:
            button = createLoginButton(color: Color.TwitterBlue, title: "Login with Twitter", logo: Icon.twitter)
        case .google:
            button = createLoginButton(color: Color.White, title: "Login with Google", logo: Icon.google)
        case .linkedin:
            button = createLoginButton(color: Color.LinkedInBlue, title: "Login with LinkedIn", logo: Icon.linkedin)
        case .github:
            button = createLoginButton(color: Color.White, title: "Login with Github", logo: Icon.github)
        case .custom:
            button = createLoginButton(color: Color.White, title: "Custom Login", logo: nil)
        }
        button.loginMethod = method
        return button
    }
    
    open func createLoginButton(color: UIColor = .white, title: String?, logo: UIImage?) -> NTLoginButton {
        let button = NTLoginButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = color
        button.touchUpAnimationTime = 0.35
        button.ripplePercent = 0.8
        button.imageView?.backgroundColor = .clear
        button.addTarget(self, action: #selector(loginLogic(sender:)), for: .touchUpInside)
        
        // Title
        button.title = title
        button.titleColor = color.isLight ? .black : .white
        
        // Icon
        if logo != nil {
            
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets.left = 66
            
            let iconView = UIImageView(image: logo)
            iconView.tintColor = color.isLight ? .black : .white
            button.addSubview(iconView)
            iconView.anchor(nil, left: button.leftAnchor, bottom: nil, right: nil, topConstant: 6, leftConstant: 12, bottomConstant: 6, rightConstant: 0, widthConstant: 30, heightConstant: 30)
            iconView.anchorCenterYToSuperview()
        }
        return button
    }
    
    open func loginLogic(sender: NTLoginButton) {
        if sender.loginMethod == .email {
            let vc = NTCredentialPromptViewController(onSubmit: { (email, password) -> Bool in
                NTPing(type: .isSuccess, title: "Login Successful").show(duration: 2)
                return true
            })
            present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    final public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loginMethods.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let button = createLoginButton(forMethod: loginMethods[indexPath.row])
        cell.addSubview(button)
        button.anchor(cell.topAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 6, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        return cell
    }

    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

/*

public class NTTextInputCell: NTTableViewCell {
    
    public var delegate: UITextViewDelegate? {
        get {
            return textInput.delegate
        }
        set {
            textInput.delegate = newValue
        }
    }
    
    public let textInput: NTTextView = {
        let textView = NTTextView()
        textView.isScrollEnabled = true
        return textView
    }()
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textInput)
        autoresizesSubviews = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        autoresizesSubviews = true
        textInput.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 8, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        
        
    }
}

public class NTLoginOptionCell: NTTableViewCell {
    
    var loginOption: NTLoginLogicOptions?
    
    convenience init(_ option: NTLoginLogicOptions) {
        self.init()
        self.loginOption = option
    }
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        
        addSubview(colorView)
        colorView.addSubview(separatorView)
        colorView.addSubview(logoView)
        colorView.addSubview(titleLabel)
        
        colorView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 30, bottomConstant: 10, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        logoView.anchor(colorView.topAnchor, left: colorView.leftAnchor, bottom: colorView.bottomAnchor, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 5, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        separatorView.anchor(logoView.topAnchor, left: logoView.rightAnchor, bottom: logoView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 1.5, heightConstant: 0)
        titleLabel.anchor(separatorView.topAnchor, left: separatorView.rightAnchor, bottom: separatorView.bottomAnchor, right: colorView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        guard let option = loginOption else { return }
        switch option {
        case .email:
            colorView.backgroundColor = Color.Default.Tint.NavigationBar
            logoView.image = Icon.email?.withRenderingMode(.alwaysTemplate)
        case .facebook:
            colorView.backgroundColor = Color.FacebookBlue
            logoView.image = Icon.facebook
        case .google:
            colorView.backgroundColor = .white
            logoView.image = Icon.google
            titleLabel.textColor = .black
            separatorView.backgroundColor = .black
        case .twitter:
            colorView.backgroundColor = Color.TwitterBlue
            logoView.image = Icon.twitter?.withRenderingMode(.alwaysTemplate)
        }
    }
}

open class NTLoginViewController: UITableViewController {
    
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
        
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .groupTableViewBackground
        self.tableView.separatorStyle = .none
        
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
    
    func toggleLoginView() {
        if self.viewPurpose == .login || self.viewPurpose == .register {
            self.viewPurpose = .loginOptions
        } else {
            self.viewPurpose = .login
        }
        self.tableView.reloadData()
    }
    
    func loginPressed() {
        self.dismissKeyboard()
        if self.isValidEmail && self.isValidPassword {
            self.emailLoginLogic(email: self.emailText!, password: self.passwordText!)
        } else if self.isValidEmail {
            self.toastError("Invalid Password")
        } else {
            self.toastError("Invalid Email")
        }
    }
    
    func registerPressed() {
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
        self.tableView.reloadData()
    }
    
    final func backToLogin() {
        self.viewPurpose = .login
        self.tableView.reloadData()
    }
    
    // MARK: Error Handling
    
    open func toastError(_ error: String) {
        NTToast(text: error).show(duration: 2.0)
    }
    
    // MARK: Validation Variables
    
    open var isValidEmail: Bool {
        guard let email = self.emailText else {
            return false
        }
        return email.isValidEmail
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
    
    func keyboardWillShow(notification: NSNotification) {
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
    
    func keyboardWillHide(notification: NSNotification) {
        if self.tableView.frame.origin.y != 0 {
            self.tableView.frame.origin.y = 0
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewPurpose != .register {
            self.dismissKeyboard()
        }
    }
    
    // MARK: UITableViewDataSource
    
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = NTTableViewHeaderFooterView()
        
        if self.viewPurpose == .loginOptions {
            return nil
        } else {
            if section == 2 {
                header.textLabel.text = "Email"
                return header
            } else if section == 3 {
                header.textLabel.text = "Password"
                return header
            }
            if self.viewPurpose == .login && section == 4 {
                return header
            } else if self.viewPurpose == .register {
                if section == 4 {
                    header.textLabel.text = "Verify Password"
                    return header
                } else if section == 5 {
                    header.textLabel.text = "Full Name"
                    return header
                } else if section == 6 {
                    return header
                }
            }
            return nil
        }
    }
    
    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = NTTableViewHeaderFooterView()
        
        if section == (numberOfSections(in: self.tableView) - 1) {

            if self.viewPurpose != .loginOptions && loginOptions.count > 1 {
                let loginOptions = NSMutableAttributedString(string: "Or login with ")
                for option in self.loginOptions {
                    if option != .email {
                        loginOptions.append(NSMutableAttributedString(string: option.rawValue, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: Color.Default.Tint.Button]))
                        loginOptions.append(NSMutableAttributedString(string: "/", attributes: [NSForegroundColorAttributeName: Color.Default.Tint.Button]))
                    }
                }
                footer.textLabel.attributedText = loginOptions
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(toggleLoginView))
                footer.addGestureRecognizer(tapAction)
            } else {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    footer.textLabel.text = "Version \(version)"
                }
            }
            return footer
        } else if section <= 1 && self.viewPurpose == .loginOptions {
            return footer
        }
        return nil
    }
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        switch self.viewPurpose {
        case .loginOptions:
            return (self.loginOptions.count + 2)
        case .login:
            return 5
        case .register:
            return 8
        }
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewPurpose == .loginOptions {
            return 0
        }
        return 20
    }
    
    open override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (numberOfSections(in: self.tableView) - 1) {
            return 30
        }
        return 0
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            // Image row
            return UITableViewCell()
        } else if section == 1 {
            // Title row
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            if let name = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String {
                cell.textLabel?.text = name
                cell.textLabel?.font = Font.Default.Title.withSize(28)
                cell.textLabel?.textAlignment = .center
            }
            cell.backgroundColor = .clear
            return cell
        }
        switch self.viewPurpose {
        case .login:
            /*
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
            */
            return UITableViewCell()
        case .register:
            return UITableViewCell()
            /*
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
        */
        case .loginOptions:
            let loginOption = self.loginOptions[section - 2]
            let cell = NTLoginOptionCell(loginOption)
            let cellTitle = NSMutableAttributedString()
            cellTitle.append(NSMutableAttributedString(string: "Login", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
            cellTitle.append(NSMutableAttributedString(string: " with ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]))
            switch loginOption {
            case .email:
                cellTitle.append(NSMutableAttributedString(string: "Email", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.titleLabel.attributedText = cellTitle
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(toggleLoginView))
                cell.colorView.addGestureRecognizer(tapAction)
            case .facebook:
                cellTitle.append(NSMutableAttributedString(string: "Facebook", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.titleLabel.attributedText = cellTitle
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(facebookLoginLogic))
                cell.colorView.addGestureRecognizer(tapAction)
            case .twitter:
                cellTitle.append(NSMutableAttributedString(string: "Twitter", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.titleLabel.attributedText = cellTitle
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(twitterLoginLogic))
                cell.colorView.addGestureRecognizer(tapAction)
            case .google:
                cellTitle.append(NSMutableAttributedString(string: "Google", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)]))
                cell.titleLabel.attributedText = cellTitle
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(googleLoginLogic))
                cell.colorView.addGestureRecognizer(tapAction)
            }
            return cell
        }
    }
    
    override open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer: NTTableViewHeaderFooterView = view as! NTTableViewHeaderFooterView
        footer.textLabel.textAlignment = .center
    }
}

extension NTLoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidChange(textField: UITextField) {
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
}
 */
