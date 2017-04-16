//
//  NTScrollableTabBarItem.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/12/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.

import UIKit

open class NTScrollableTabBarItem: UICollectionViewCell {

    open var tabItemButtonPressedBlock: ((Void) -> Void)?
    open var title: String? {
        get {
            return animatedButton.title
        }
        set {
            animatedButton.title = newValue
        }
    }
    internal var isCurrent: Bool = false {
        didSet {
            currentBarView.isHidden = !isCurrent
            if isCurrent {
                highlightTitle()
            } else {
                unHighlightTitle()
            }
            currentBarView.backgroundColor = Color.Defaults.tabBarTint
            layoutIfNeeded()
        }
    }
    
    public static var cellIdentifier: String {
        get {
            return "NTScrollableTabBarItem"
        }
    }
    
    internal var properties: NTTabBarProperties = NTTabBarProperties()
    
    fileprivate var animatedButton: NTButton = {
        let button = NTButton()
        button.backgroundColor = Color.Defaults.tabBarBackgound
        button.titleFont = Font.Defaults.subtitle
        return button
    }()
    
    fileprivate var currentTabLineWeight: CGFloat = 2.0 {
        didSet {
            currentBarView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: currentTabLineWeight)
        }
    }
    
    fileprivate let currentBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(animatedButton)
        addSubview(currentBarView)
        
        animatedButton.fillSuperview()
        
        currentBarView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: currentTabLineWeight)
        
        currentBarView.isHidden = true
        animatedButton.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - User Actions
    
    func didTouchUpInside() {
        tabItemButtonPressedBlock?()
    }

    // MARK: - Standard Methods
    
    override open var intrinsicContentSize : CGSize {
        let width: CGFloat
        if let tabWidth = properties.tabWidth , tabWidth > 0.0 {
            width = tabWidth
        } else {
            width = animatedButton.intrinsicContentSize.width + properties.tabMargin * 2
        }

        let size = CGSize(width: width, height: properties.tabHeight)
        return size
    }

    internal func hideCurrentBarView() {
        currentBarView.isHidden = true
    }

    internal func showCurrentBarView() {
        currentBarView.isHidden = false
    }

    internal func highlightTitle() {
        animatedButton.titleColor = Color.Defaults.tabBarTint
    }

    internal func unHighlightTitle() {
        animatedButton.titleColor = Color.Defaults.tabBarBackgound.isLight ? .lightGray : .white
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if animatedButton.title!.characters.count == 0 {
            return .zero
        }
        
        return intrinsicContentSize
    }
}
