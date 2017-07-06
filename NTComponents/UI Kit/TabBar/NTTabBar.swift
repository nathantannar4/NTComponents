//
//  NTTabBar.swift
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
    
    public weak var delegate: NTTabBarDelegate?
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
        
        tintColor = Color.Default.Tint.TabBar
        backgroundColor = Color.Default.Background.TabBar
        
        setDefaultShadow()
        layer.shadowOffset = CGSize(width: 0, height: -Color.Default.Shadow.Offset.height)
        
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
