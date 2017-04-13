//
//  String.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
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

