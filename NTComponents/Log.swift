//
//  Log.swift
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


/// Type of print statement sent to be logged. If the current log mode allows such a type it will be logged
///
/// - error:
/// - warning:
/// - status: 
public enum LogType {
    case error, warning, status
}


/// Default is debug
///
/// - off: rawValue of 0
/// - verbose: rawValue of 1
/// - debug: rawValue of 2
public enum LogMode: Int {
    case off = 0
    case verbose = 1
    case debug = 2
}

public struct Log {
    
    fileprivate static var mode: LogMode = .debug
    
    
    /// Sets the current LogMode to the passed parameter
    ///
    /// - Parameter mode: LogMode
    public static func setTraceLevel(to mode: LogMode) {
        Log.mode = mode
    }

    
    /// Checks if the current LogMode allows for such an print statement, if so the statment is printed to the console
    ///
    /// - Parameters:
    ///   - type: LogType
    ///   - text: Statement to be printed
    public static func write(_ type: LogType, _ text: Any) {
        var message = String()
        switch type {
        case .error:
            if Log.mode.rawValue != 0 {
                message.append("### ERROR  : ")
                message.append(String(describing: text))
                print(message)
            }
        case .warning:
            if Log.mode.rawValue >= 1 {
                message.append("### WARNING: ")
                message.append(String(describing: text))
                print(message)
            }
        case .status:
            if Log.mode.rawValue == 2 {
                message.append("### STATUS : ")
                message.append(String(describing: text))
                print(message)
            }
        }
    }
    
}
