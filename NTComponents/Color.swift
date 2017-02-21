//
//  Color.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/7/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

public struct Color {
    
    public static func fromHex(_ hexString: String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
    
    public static var defaultNavbarTint = UIColor.black
    public static var defaultNavbarBackground = UIColor.white
    public static var defaultButtonTint = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    public static var defaultTitle = UIColor.black
    public static var defaultSubtitle = UIColor.darkGray
    
    public struct Defaults {
        public static var navigationBarTint = UIColor.black
        public static var navigationBarBackground = UIColor.white
        public static var buttonTint = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        public static var titleTextColor = UIColor.black
        public static var subtitleTextColor = UIColor.darkGray
    }
    
    public static let lightGray = UIColor.groupTableViewBackground
    public static let darkGray = Color.fromHex("424242")
    public static let red = Color.fromHex("F44336")
    public static let darkRed = Color.fromHex("B71C1C")
    public static let darkGreen = Color.fromHex("388E3C")
    public static let blue = Color.fromHex("2196F3")
    public static let darkBlue = Color.fromHex("0D47A1")
    
    public static let facebookBlue = Color.fromHex("3b5998")
    public static let twitterBlue = Color.fromHex("0084b4")
    
}
