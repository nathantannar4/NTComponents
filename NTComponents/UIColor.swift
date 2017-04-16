//
//  UIColor.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public extension UIColor {
    
    public convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
    
    public convenience init(rgba: UInt){
        let sRgba = min(rgba,0xFFFFFFFF)
        let red: CGFloat = CGFloat((sRgba & 0xFF000000) >> 24) / 255.0
        let green: CGFloat = CGFloat((sRgba & 0x00FF0000) >> 16) / 255.0
        let blue: CGFloat = CGFloat((sRgba & 0x0000FF00) >> 8) / 255.0
        let alpha: CGFloat = CGFloat(sRgba & 0x000000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor {
        return self.adjust(by: abs(percentage)) ?? .white
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage)) ?? .black
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if (self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else{
            return nil
        }
    }
    
    convenience init(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }

    var RGBA: [CGFloat] {
        var RGBA: [CGFloat] = [0,0,0,0]
        self.getRed(&RGBA[0], green: &RGBA[1], blue: &RGBA[2], alpha: &RGBA[3])
        return RGBA
    }
    
    var luminance: CGFloat {
        // http://www.w3.org/WAI/GL/WCAG20-TECHS/G18.html
        
        let RGBA = self.RGBA
        
        func lumHelper(c: CGFloat) -> CGFloat {
            return (c < 0.03928) ? (c/12.92): pow((c+0.055)/1.055, 2.4)
        }
        
        return 0.2126 * lumHelper(c: RGBA[0]) + 0.7152 * lumHelper(c: RGBA[1]) + 0.0722 * lumHelper(c: RGBA[2])
    }

    var isDark: Bool {
        return self.luminance < 0.5
    }
    
    var isLight: Bool {
        return !self.isDark
    }
    
    func isDarker(than color: UIColor) -> Bool {
        return self.luminance < color.luminance
    }
    
    func isLighter(than color: UIColor) -> Bool {
        return !self.isDarker(than: color)
    }
    
    var isBlackOrWhite: Bool {
        let RGBA = self.RGBA
        let isBlack = RGBA[0] < 0.09 && RGBA[1] < 0.09 && RGBA[2] < 0.09
        let isWhite = RGBA[0] > 0.91 && RGBA[1] > 0.91 && RGBA[2] > 0.91
        
        return isBlack || isWhite
    }
    
    func withAlpha(newAlpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(newAlpha)
    }
}
