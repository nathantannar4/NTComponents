//
//  NTScrollableTabBarItem.swift
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
            currentBarView.backgroundColor = Color.Default.Tint.TabBar
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
        button.backgroundColor = Color.Default.Background.TabBar
        button.titleFont = Font.Default.Subtitle
        button.trackTouchLocation = false
        button.ripplePercent = 1
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
        animatedButton.titleColor = Color.Default.Tint.TabBar
    }

    internal func unHighlightTitle() {
        animatedButton.titleColor = Color.Default.Tint.Inactive
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let title = animatedButton.title else {
            return .zero
        }
        if title.characters.count == 0 {
            return .zero
        }
        
        return intrinsicContentSize
    }
}
