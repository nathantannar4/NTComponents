//
//  Print.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/9/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public enum LogType {
    case error, warning, status
}

public enum LogMode {
    case debug, verbose, off
}

public struct Log {

    public static func write(_ type: LogType, _ text: String) {
        var message = String()
        switch type {
        case .error:
            message.append("### ERROR  : ")
        case .warning:
            message.append("### WARNING: ")
        case .status:
            message.append("### STATUS : ")
        }
        message.append(text)
        print(message)
    }
    
}
