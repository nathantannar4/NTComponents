//
//  NTToolbar.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/2/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

public class NTToolbar: UIToolbar {

    public init(text: String?, button: UIBarButtonItem?, color: UIColor, height: CGFloat) {
        
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - height
        bounds.size.height = height
        
        super.init(frame: bounds)
        
        self.barTintColor = Color.darkGray
        
        if text != nil {
            self.appendButton(buttonItem: self.fixedSpace)
            self.appendButton(buttonItem: self.titleItem(text: text!, font: UIFont.systemFont(ofSize: 14), color: UIColor.white))
            self.appendButton(buttonItem: self.flexibleSpace)
        }
        if button != nil {
            self.appendButton(buttonItem: self.flexibleSpace)
            self.appendButton(buttonItem: button!)
            self.appendButton(buttonItem: self.fixedSpace)

        }
    }
    
    public init() {
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - 44
        bounds.size.height = 44
        super.init(frame: bounds)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buttonItem(systemItem: UIBarButtonSystemItem, selector: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: selector)
    }
    
    public var flexibleSpace: UIBarButtonItem {
        return self.buttonItem(systemItem: UIBarButtonSystemItem.flexibleSpace, selector:nil)
    }
    
    public var fixedSpace: UIBarButtonItem {
        let space = self.buttonItem(systemItem: UIBarButtonSystemItem.fixedSpace, selector:nil)
        space.width = 10
        return space
    }
    
    public func titleItem (text: String, font: UIFont, color: UIColor) -> UIBarButtonItem {
        return NTBarLabelItem(text: text, font: font, color: color)
    }
    
    public func appendButton(buttonItem: UIBarButtonItem) {
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        items!.append(buttonItem)
    }
}

public class NTBarLabelItem: UIBarButtonItem {
    
    public var label: UILabel
    
    public init(text: String, font: UIFont, color: UIColor) {
        
        label =  UILabel(frame: UIScreen.main.bounds)
        label.text = text
        label.sizeToFit()
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        
        super.init()
        
        customView = label
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

