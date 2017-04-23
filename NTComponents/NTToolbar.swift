//
//  NTToolbar.swift
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

public class NTToolbar: UIToolbar {

    public init(text: String?, button: UIBarButtonItem?, color: UIColor, height: CGFloat) {
        
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - height
        bounds.size.height = height
        
        super.init(frame: bounds)
        
        barTintColor = color
        
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

