//
//  NTSelfNavigatedViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 5/19/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

open class NTSelfNavigatedViewController: NTViewController {
    
    open override var title: String? {
        get {
            return super.title
        }
        set {
            titleLabel.text = newValue
            super.title = newValue
        }
    }
    
    open let navBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setDefaultShadow()
        return view
    }()
    
    open let backButton: NTButton = {
        let button = NTButton()
        button.backgroundColor = .clear
        button.trackTouchLocation = false
        button.tintColor = Color.Gray.P500
        button.rippleColor = Color.Gray.P200
        button.image = Icon.Arrow.Backward
        button.ripplePercent = 1.5
        button.rippleOverBounds = true
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.adjustsFontSizeToFitWidth = true
        label.font = Font.Default.Headline.withSize(44)
        return label
    }()
    
    open let nextButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.image = Icon.Arrow.Forward
        button.ripplePercent = 1
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.adjustsImageWhenHighlighted = false
        button.setDefaultShadow()
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    fileprivate var oldStatusBarStyle: UIStatusBarStyle = .default
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        oldStatusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = .default
        view.setDefaultShadow()
        view.addSubview(navBarView)
        navBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 84)
        
        navBarView.addSubview(backButton)
        navBarView.addSubview(titleLabel)
        view.addSubview(nextButton)
        
        backButton.anchor(navBarView.topAnchor, left: navBarView.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        titleLabel.anchor(backButton.bottomAnchor, left: backButton.leftAnchor, bottom: navBarView.bottomAnchor, right: navBarView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        nextButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 50, heightConstant: 50)
    }
    
    open func nextButtonPressed() {
        
    }
    
    open func backButtonPressed() {
        UIApplication.shared.statusBarStyle = oldStatusBarStyle
        dismissViewController(to: .right, completion: nil)
    }
}
