//
//  NTTabBar.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

/*
 Items
 
 var items: [UITabBarItem]?
 The items displayed by the tab bar.
 func setItems([UITabBarItem]?, animated: Bool)
 Sets the items on the tab bar, optionally animating any changes into position.
 var selectedItem: UITabBarItem?
 The currently selected item on the tab bar.
 Customizing Tab Bar Appearance
 
 var barStyle: UIBarStyle
 The tab bar style that specifies its appearance.
 var isTranslucent: Bool
 A Boolean value that indicates whether the tab bar is translucent.
 var barTintColor: UIColor?
 The tint color to apply to the tab bar background.
 var itemPositioning: UITabBarItemPositioning
 The positioning scheme for the tab bar items in the tab bar.
 var itemSpacing: CGFloat
 The amount of space (in points) to use between tab bar items.
 var itemWidth: CGFloat
 The width (in points) of tab bar items.
 var tintColor: UIColor!
 The tint color to apply to the tab bar items.
 var backgroundImage: UIImage?
 The custom background image for the tab bar.
 var shadowImage: UIImage?
 The shadow image to use for the tab bar.
 var selectionIndicatorImage: UIImage?
 The image to use for the selection indicator.
 Setting the Delegate
 
 var delegate: UITabBarDelegate?
 The tab bar’s delegate object.
 Supporting User Customization of Tab Bars
 
 func beginCustomizingItems([UITabBarItem])
 Presents a standard interface that lets the user customize the contents of the tab bar.
 func endCustomizing(animated: Bool)
 Dismisses the standard interface used to customize the tab bar.
 Deprecated
 
 var selectedImageTintColor: UIColor?
 The tint color applied to the selected tab bar item.
 Deprecated
 Constants
 
 UITabBarItemPositioning
 Constants that specify tab bar item positioning.
 Instance Properties
 
 var isCustomizing: Bool
 var unselectedItemTintColor: UIColor?
*/

public protocol NTTabBarDelegate: NSObjectProtocol {
    func tabBar(_ tabBar: NTTabBar, didSelect index: Int)
}

open class NTTabBar: UIView, NTTabBarItemDelegate {
    
    fileprivate var _items: [NTTabBarItem]?
    public var items: [NTTabBarItem] {
        get {
            return _items ?? []
        }
    }
    
    public var delegate: NTTabBarDelegate?
    public var selectedItem: NTTabBarItem?
    public var numberOfItems: Int {
        get {
            return items.count
        }
    }
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = Color.Defaults.tabBarTint
        backgroundColor = Color.Defaults.tabBarBackgound
        
        setDefaultShadow()
        layer.shadowOffset = CGSize(width: 0, height: -1)
        
        _items = []
//        
//        
//        for i in 0...3 {
//            let item = NTTabBarItem()
//            item.title = "Title"
//            item.image = Icon.google
//
//            item.delegate = self
//            addSubview(item)
//            _items?.append(item)
//        }
//        
//        _items?[0].isSelected = true
//        selectedItem = _items?[0]
//        
//        guard let items = items else { return }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: NTTabBar Methods
    
    func setItems(_ newItems: [NTTabBarItem]) {
        _items = newItems
        selectedItem = items[0]
        items[0].isSelected = true
        
        items.forEach { (item) in
            item.delegate = self
            item.backgroundColor = backgroundColor
            item.tintColor = tintColor
            addSubview(item)
        }
        
        for item in items {
            
            if (items.index(of: item) == 0) {
                // First Item
                if numberOfItems == 1 {
                    item.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
                } else {
                    item.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: items[1].leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
                }
            } else if (items.index(of: item) == (numberOfItems - 1)) {
                // Last Item
                item.anchor(topAnchor, left: items[numberOfItems - 2].rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
                item.anchorWidthToItem(items[0])
            } else {
                let index = items.index(of: item)!
                item.anchor(topAnchor, left: items[index - 1].rightAnchor, bottom: bottomAnchor, right: items[index + 1].leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
                item.anchorWidthToItem(items[0])
            }
        }
    }
    
    public func tabBarItem(didSelect item: NTTabBarItem) {
        selectedItem?.isSelected = false
        if let index = items.index(of: item) {
            delegate?.tabBar(self, didSelect: index)
            selectedItem = item
        }
    }
}
