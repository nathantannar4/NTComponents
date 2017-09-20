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
    
    open var loginMethods: [NTLoginMethod] = [.email, .facebook, .twitter, .google, .github, .linkedin]
    
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
        let label = NTLabel(style: .headline)
        label.font = Font.Default.Title.withSize(28)
        label.adjustsFontSizeToFitWidth = true
        label.text = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
        label.textAlignment = .center
        return label
    }()
    
    open var subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subhead)
        label.font = Font.Default.Subtitle.withSize(18)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    open var versionLabel: NTLabel = {
        let label = NTLabel(style: .subtitle)
        label.font = Font.Default.Footnote
        label.adjustsFontSizeToFitWidth = true
        label.text = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        label.backgroundColor = .clear
        return label
    }()
    
    open var tableView: NTTableView = {
        let tableView = NTTableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        return tableView
    }()
    
    open var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Gray.P500
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
        view.addSubview(versionLabel)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        logoView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 36, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        logoView.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        titleLabel.anchor(logoView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        subtitleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 20).isActive = true
        
        separatorView.anchor(subtitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 6, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0.5)
        
        versionLabel.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 0, widthConstant: 50, heightConstant: 20)
        
        tableView.anchor(separatorView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // MARK: - Login Button Methods
    
    open func createLoginButton(forMethod method: NTLoginMethod) -> NTLoginButton {
        var button: NTLoginButton
        switch method {
        case .email:
            button = createLoginButton(color: Color.Gray.P200, title: "Login with Email", logo: Icon.Email)
        case .facebook:
            button = createLoginButton(color: Color.FacebookBlue, title: "Login with Facebook", logo: Icon.facebook)
        case .twitter:
            button = createLoginButton(color: Color.TwitterBlue, title: "Login with Twitter", logo: Icon.twitter)
        case .google:
            button = createLoginButton(color: Color.Gray.P200, title: "Login with Google", logo: Icon.google)
        case .linkedin:
            button = createLoginButton(color: Color.LinkedInBlue, title: "Login with LinkedIn", logo: Icon.linkedin)
        case .github:
            button = createLoginButton(color: Color.Gray.P200, title: "Login with Github", logo: Icon.github)
        case .custom:
            button = createLoginButton(color: Color.Gray.P200, title: "Custom Login", logo: nil)
        }
        button.loginMethod = method
        return button
    }
    
    open func createLoginButton(color: UIColor = .white, title: String?, logo: UIImage?) -> NTLoginButton {
        let button = NTLoginButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = color
        button.touchUpAnimationTime = 0.6
        button.ripplePercent = 1.2
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
    
    @objc open func loginLogic(sender: NTLoginButton) {
        if sender.loginMethod == .email {
            let vc = NTEmailAuthViewController()
            present(vc, animated: true, completion: nil)
        } else {
            Log.write(.warning, "You need to override loginLogic(sender: NTLoginButton)")
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
