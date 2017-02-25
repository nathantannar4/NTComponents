//
//  Font.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/20/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public struct Font {
    
    public static func availableFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
    public struct Defaults {
        public static var title = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        public static var subtitle = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        public static var content = UIFont.systemFont(ofSize: 13)
    }
    
}

