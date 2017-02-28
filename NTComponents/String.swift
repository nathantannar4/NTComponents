//
//  String.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public extension String {
    
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
    
    static func mediumDateShortTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date as Date)
    }
    
    static func mediumDateNoTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date as Date)
    }
    
    static func fullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date as Date)
    }
    
    static func timeElapsedSince(_ date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        var elapsed: String
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let suffix = (minutes > 1) ? "mins" : "min"
            elapsed = "\(minutes) \(suffix) ago"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let suffix = (hours > 1) ? "hours" : "hour"
            elapsed = "\(hours) \(suffix) ago"
        }
        else {
            let days = Int(seconds / (24 * 60 * 60))
            let suffix = (days > 1) ? "days" : "day"
            elapsed = "\(days) \(suffix) ago"
        }
        return elapsed
    }
}

