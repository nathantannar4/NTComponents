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

open class NTScrollableTabBarItem: NTAnimatedCollectionViewCell {

    open var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
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
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .body)
        label.font = Font.Default.Subtitle.withSize(13)
        label.textAlignment = .center
        return label
    }()
    
    open var tabBarPosition: NTTabBarPosition = .top {
        didSet {
            currentBarView.removeAllConstraints()
            
            if tabBarPosition == .top {
                currentBarView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: currentTabLineWeight)
            } else {
                currentBarView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: currentTabLineWeight)
            }
        }
    }
    
    fileprivate var currentTabLineWeight: CGFloat = 2.0 {
        didSet {
            if tabBarPosition == .top {
                currentBarView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: currentTabLineWeight)
            } else {
                currentBarView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: currentTabLineWeight)
            }
        }
    }
    
    fileprivate let currentBarView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Default.Tint.TabBar
        return view
    }()
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.Default.Background.TabBar
        rippleColor = Color.Default.Tint.TabBar.withAlpha(0.4)
        trackTouchLocation = false
        ripplePercent = 1.1
        
        addSubview(titleLabel)
        addSubview(currentBarView)
        
        titleLabel.fillSuperview()
        
        currentBarView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: currentTabLineWeight)
        
        currentBarView.isHidden = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - User Actions

    internal func hideCurrentBarView() {
        currentBarView.isHidden = true
    }

    internal func showCurrentBarView() {
        currentBarView.isHidden = false
    }

    internal func highlightTitle() {
        titleLabel.textColor = Color.Default.Tint.TabBar
    }

    internal func unHighlightTitle() {
        titleLabel.textColor = Color.Default.Tint.Inactive
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let title = titleLabel.text else {
            return .zero
        }
        if title.characters.count == 0 {
            return .zero
        }
        return intrinsicContentSize
    }
}
