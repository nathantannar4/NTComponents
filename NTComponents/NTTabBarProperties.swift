//
//  NTTabBarProperties.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/12/17.
//  Modifications Copyright © 2017 Nathan Tannar. All rights reserved.

import UIKit

public struct NTTabBarProperties {

    public init() {}

    public var fontSize = UIFont.systemFontSize
    public var currentColor = Color.Defaults.tabBarTint
    public var defaultColor = Color.darkGray
    public var tabHeight: CGFloat = 32.0
    public var tabMargin: CGFloat = 20.0
    public var tabWidth: CGFloat?
    public var currentBarHeight: CGFloat = 2.0
    public var tabBackgroundColor: UIColor = Color.Defaults.tabBarBackgound
    public var pageBackgoundColor: UIColor = Color.Defaults.viewControllerBackground
    public var isTranslucent: Bool = true
    public var hidesTabBarOnSwipe: Bool = false

    internal var tabBarAlpha: CGFloat {
        return isTranslucent ? 0.95 : 1.0
    }
    internal var tabBackgroundImage: UIImage {
        return convertImage()
    }

    fileprivate func convertImage() -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext? = UIGraphicsGetCurrentContext()
        let backgroundColor = tabBackgroundColor.withAlphaComponent(tabBarAlpha).cgColor
        context?.setFillColor(backgroundColor)
        context?.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
