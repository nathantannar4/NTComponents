//
//  NTChime.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/29/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTChime: NTView {
    
    open var iconView: NTImageView = {
        let imageView = NTImageView()
        return imageView
    }()
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.font = Font.Default.Title.withSize(15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    open var subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subtitle)
        label.font = Font.Default.Subtitle.withSize(13)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    open var action : (() -> Void)?
    open var animationDuration: Double = 0.6
    open var animationDelay: Double = 0
    open var animationSpringDamping: CGFloat = 0.85
    open var animationSpringVelocity: CGFloat = 1.12
    open var animationOptions: UIViewAnimationOptions = [.curveEaseOut]
    
    fileprivate var originalStatusBarStyle: UIStatusBarStyle = .default
    fileprivate var currentState: NTViewState = .hidden
    
    // MARK: - Initialization
    
    public convenience init(type: NTAlertType = NTAlertType.isInfo, title: String? = nil, subtitle: String? = nil, icon: UIImage? = nil, action : (() -> Void)? = nil) {
        
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - 64
        bounds.size.height = 64
        self.init(frame: bounds)
        
        setDefaultShadow()
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        iconView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 12, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.anchor(topAnchor, left: nil, bottom: subtitleLabel.topAnchor, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconView.image = icon
        
        iconView.widthAnchor.constraint(equalToConstant: (icon != nil ? 40 : 0)).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: (icon != nil ? 40 : 0)).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: (icon != nil ? 8 : 0)).isActive = true
       
        
        switch type {
        case .isInfo:
            backgroundColor = Color.Default.Status.Info
        case .isSuccess:
            backgroundColor = Color.Default.Status.Success
        case .isWarning:
            backgroundColor = Color.Default.Status.Warning
        case .isDanger:
            backgroundColor = Color.Default.Status.Danger
        }
        
        if backgroundColor!.isDark {
            iconView.tintColor = .white
            titleLabel.textColor = .white
            subtitleLabel.textColor = .white
        }
    }
    
    public convenience init(title: String? = nil, height: CGFloat = 64, color: UIColor = Color.Default.Status.Info, onTap : (() -> Void)?) {
        
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - height
        bounds.size.height = height
        self.init(frame: bounds)
        
        action = onTap
        backgroundColor = color
        animationSpringDamping = 1
        animationSpringVelocity = 1
        
        addSubview(titleLabel)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        
        titleLabel.text = title
        if color.isDark {
            titleLabel.textColor = .white
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    internal func didTap(_ recognizer: UITapGestureRecognizer) {
        action?()
        dismiss()
    }
    
    // MARK: - Presentation Methods
    
    open func show(_ view: UIView? = UIViewController.topWindow(), duration: TimeInterval? = nil) {
        if currentState != .hidden { return }
        guard let view = view else { return }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(NTToast.didTap(_:))))
        view.addSubview(self)
        frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: self.frame.height)
        
        let topView: UIView = {
            let view = UIView()
            view.backgroundColor = self.backgroundColor
            view.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
            return view
        }()
        self.addSubview(topView)
        
        if backgroundColor!.isDark {
            Log.write(.warning, "Ensure that 'View controller-based status bar appearance' is set to 'NO' in your projects Info.plist")
            originalStatusBarStyle = UIApplication.shared.statusBarStyle
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        currentState = .transitioning
        UIView.animate(withDuration: animationDuration, delay: animationDelay, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationSpringVelocity, options: animationOptions, animations: {
            self.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.frame.height)
            
        }) { (finished) in
            self.currentState = .visible
            self.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.frame.height)
            topView.removeFromSuperview()
            guard let duration = duration else { return }
            DispatchQueue.executeAfter(duration, closure: {
                self.dismiss()
            })
        }
    }
    
    open func dismiss() {
        if currentState != .visible { return }
        currentState = .transitioning
        
        UIView.transition(with: self, duration: 0.2, options: .curveLinear, animations: {() -> Void in
            self.frame.origin = CGPoint(x: 0, y: -self.frame.height)
        }, completion: { finished in
            self.currentState = .hidden
            UIApplication.shared.statusBarStyle = self.originalStatusBarStyle
            self.removeFromSuperview()
        })
    }
}
