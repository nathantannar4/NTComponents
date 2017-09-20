//
//  NTLandingViewController.swift
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
//  Created by Nathan Tannar on 6/8/17.
//


open class NTLandingViewController: NTViewController {
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.font = Font.Default.Headline.withSize(44)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    open let subtitleLabel: NTLabel = {
        let label = NTLabel()
        label.font = Font.Default.Body.withSize(36)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Color.Gray.P50
        return label
    }()
    
    open let detailLabel: NTLabel = {
        let label = NTLabel()
        label.font = Font.Default.Subtitle
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    open let buttonA: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.backgroundColor = .white
        button.tintColor = Color.Default.Background.Button
        button.layer.cornerRadius = 10
        button.setDefaultShadow()
        button.addTarget(self, action: #selector(buttonAAction), for: .touchUpInside)
        return button
    }()
    
    open let buttonB: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.backgroundColor = .white
        button.tintColor = Color.Default.Background.Button
        button.layer.cornerRadius = 10
        button.setDefaultShadow()
        button.addTarget(self, action: #selector(buttonBAction), for: .touchUpInside)
        return button
    }()
    
    open let signOutButton: NTButton = {
        let button = NTButton()
        button.isHidden = true
        button.trackTouchLocation = false
        button.backgroundColor = .white
        button.tintColor = Color.Gray.P800
        button.title = "Sign Out"
        button.ripplePercent = 1
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        button.setDefaultShadow()
        button.addTarget(self, action: #selector(signoutAction), for: .touchUpInside)
        return button
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(detailLabel)
        
        let referenceView = UIView()
        view.addSubview(referenceView)
        referenceView.anchorCenterSuperview()
        
        view.addSubview(buttonA)
        view.addSubview(buttonB)
        
        titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 64, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        detailLabel.anchor(subtitleLabel.bottomAnchor, left: subtitleLabel.leftAnchor, bottom: referenceView.bottomAnchor, right: subtitleLabel.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        buttonA.anchor(referenceView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        buttonB.anchor(buttonA.topAnchor, left: buttonA.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        
        
        view.addSubview(signOutButton)
        signOutButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 0, widthConstant: 100, heightConstant: 32)
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    @objc open func buttonAAction() {
        
    }
    
    @objc open func buttonBAction() {
        
    }
    
    @objc open func signoutAction() {
        
    }
}

