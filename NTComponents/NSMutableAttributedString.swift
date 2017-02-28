//
//  NSMutableAttributedString.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public extension NSMutableAttributedString {
    func bold(_ text: String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes: attrs)
        self.append(boldString)
        return self
    }
    
    func italic(_ text: String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.italicSystemFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes: attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
    
    func linkUsers(fromList list: [String]) -> NSMutableAttributedString {
        
        for user in list {
            self.setAsLink(textToFind: "@" + user, linkURL: "asasas")
        }
        return self
    }
    
    func setAsLink(textToFind: String, linkURL: String) {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            //self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            self.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)], range: foundRange)
            self.addAttributes([NSForegroundColorAttributeName: Color.Defaults.tint], range: foundRange)
        }
    }
}
