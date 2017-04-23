//
//  String.swift
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

public extension String {
    
    static func random(ofLength length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func parseAttributes() -> NSMutableAttributedString {
        var text = self
        let BOLD = "*"
        let ITALIC = "_"
        let attributedString = NSMutableAttributedString()
        
        var boldComponents = text.components(separatedBy: BOLD)
        while boldComponents.count > 1 {
            attributedString.append(boldComponents[0].parseAttributes())
            attributedString.append(NSMutableAttributedString().bold(boldComponents[1]))
            text = String()
            if boldComponents.count > 2 {
                for index in 2...(boldComponents.count - 1) {
                    text.append(boldComponents[index])
                }
            }
            boldComponents = text.components(separatedBy: BOLD)
        }
        
        var italicComponents = text.components(separatedBy: ITALIC)
        while italicComponents.count > 1 && (boldComponents.count % 2 == 1) {
            attributedString.append(italicComponents[0].parseAttributes())
            attributedString.append(NSMutableAttributedString().italic(italicComponents[1]))
            text = String()
            if italicComponents.count > 2 {
                for index in 2...(italicComponents.count - 1) {
                    text.append(italicComponents[index])
                }
            }
            italicComponents = text.components(separatedBy: ITALIC)
        }
        
        
        attributedString.append(NSMutableAttributedString(string: text))
        return attributedString
    }
}

