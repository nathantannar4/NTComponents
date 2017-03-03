//
//  Date.swift
//  NTComponents
//
//  Created by Nathan Tannar on 3/2/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public extension Date {
    
    func mediumDateShortTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    func mediumDateNoTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    func fullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: self)
    }
    
    func timeElapsedDescription() -> String {
        let seconds = Date().timeIntervalSince(self)
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
