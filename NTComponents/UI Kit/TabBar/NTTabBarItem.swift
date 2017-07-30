//
//  NTTabBarItem.swift
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

public protocol NTTabBarItemDelegate: NSObjectProtocol {
    func tabBarItem(didSelect item: NTTabBarItem)
}

open class NTTabBarItem: NTAnimatedView {
    
    open var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    open var image: UIImage? {
        get {
            return imageView.image?.withRenderingMode(.alwaysTemplate)
        }
        set {
            imageView.image = newValue?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    open var selectedImage: UIImage?
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .caption)
        label.textAlignment = .center
        label.font = Font.Default.Subhead.withSize(11)
        label.textColor = Color.Gray.P500
        return label
    }()
    
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.Gray.P500
        return imageView
    }()
    
    internal var isSelected: Bool = false {
        didSet {
            titleLabel.textColor = isSelected ? Color.Default.Text.Title : Color.Default.Tint.Inactive
            imageView.tintColor = isSelected ? activeTint() : Color.Default.Tint.Inactive
            imageView.image = isSelected ? (selectedImage?.withRenderingMode(.alwaysTemplate) ?? image) : image
        }
    }
    
    fileprivate func activeTint() -> UIColor {
        guard let bgColor = backgroundColor else {
            return Color.Default.Tint.TabBar
        }
        return bgColor.isLight ? Color.Default.Tint.TabBar : Color.White
    }
    
    open weak var delegate: NTTabBarItemDelegate?
    
    //MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(title: String?, image: UIImage?, selectedImage: UIImage?) {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackTouchLocation = false
        ripplePercent = 0.8
        touchUpAnimationTime = 0.5
        tintColor = Color.Default.Tint.TabBar
        backgroundColor = Color.Default.Background.TabBar
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: titleLabel.topAnchor, right: rightAnchor, topConstant: 3, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        titleLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 10)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            rippleColor = newValue.withAlpha(0.4)
        }
    }
    
    open override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.tabBarItem(didSelect: self)
        isSelected = true
    }
}
