//
//  PropertyLoopable.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public protocol PropertyLoopable {
    func allProperties() throws -> [String : Any]
    func overrideProperties<T>(toValue value: T)
}

public extension PropertyLoopable {

    public func overrideProperties<T>(toValue value: T) {
        do {
            try {
                let mirror = Mirror(reflecting: self)

                // Optional check to make sure we're iterating over a struct or class
                guard let style = mirror.displayStyle, style == .struct || style == .class else {
                    throw NSError()
                }

                for (property, value) in mirror.children {
                    if property is T {
                        property = value
                    }
                }
            }
        } catch {
            Log.write(.error, "Not all properties ")
        }
    }

    public func allProperties() throws -> [String : Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value
        }

        return result
    }
}
