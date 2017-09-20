//
//  NSMutableAttributedString.swift
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

public extension NSMutableAttributedString {
    
    func bold(_ text: String) -> NSMutableAttributedString {
        let attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.boldSystemFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes: attrs)
        self.append(boldString)
        return self
    }
    
    func italic(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.italicSystemFont(ofSize: 14)]
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
            self.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)], range: foundRange)
            self.addAttributes([NSAttributedStringKey.foregroundColor: Color.Default.Tint.Button], range: foundRange)
        }
    }
}
