//
//  NTNavigationViewController.swift
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

open class NTNavigationViewController: NTViewController {
    
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
        view.backgroundColor = Color.Default.Background.NavigationBar
        view.setDefaultShadow()
        return view
    }()
    
    open let backButton: NTButton = {
        let button = NTButton()
        button.backgroundColor = .clear
        button.trackTouchLocation = false
        button.tintColor = Color.Default.Tint.NavigationBar
        button.rippleColor = Color.Gray.P200
        button.image = Icon.Arrow.Backward
        button.ripplePercent = 1.2
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultShadow()
        view.addSubview(navBarView)
        navBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 84)
        
        navBarView.addSubview(backButton)
        navBarView.addSubview(titleLabel)
        view.addSubview(nextButton)
        
        backButton.anchor(navBarView.topAnchor, left: navBarView.leftAnchor, bottom: nil, right: nil, topConstant: 22, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        titleLabel.anchor(backButton.bottomAnchor, left: backButton.leftAnchor, bottom: navBarView.bottomAnchor, right: navBarView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        nextButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 50, heightConstant: 50)
        
        let flickGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backButtonPressed))
        flickGesture.edges = .left
        view.addGestureRecognizer(flickGesture)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let navColor = navBarView.backgroundColor else {
            return
        }
        statusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = navColor.isLight ? .default : .lightContent
    }
    
    open func nextButtonPressed() {
        
    }
    
    open func backButtonPressed() {
        dismissViewController(to: .right, completion: {
            UIViewController.topController()?.viewDidAppear(true)
        })
    }
}
