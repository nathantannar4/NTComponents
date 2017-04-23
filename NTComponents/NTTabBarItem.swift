//
//  NTTabBarItem.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/18/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
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
        let label = NTLabel(style: .body)
        label.textAlignment = .center
        label.font = Font.Defaults.subtitle.withSize(11)
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
    
    open var delegate: NTTabBarItemDelegate?
    
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
            rippleColor = newValue.withAlpha(newAlpha: 0.4)
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
