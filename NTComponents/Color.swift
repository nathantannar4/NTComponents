//
//  Color.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/7/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//
// Colors From https://material.io/guidelines/style/color.html

import UIKit

public class Color: UIColor {
    
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
    
    public struct Defaults {
        public static var tint = Color.init(hex: "31485e")
        public static var viewControllerBackground = UIColor.groupTableViewBackground
        public static var navigationBarTint = Color.init(hex: "31485e")
        public static var navigationBarBackground = UIColor.white
        public static var tabBarTint = Color.init(hex: "31485e")
        public static var tabBarBackgound = UIColor.white
        public static var buttonTint = Color.init(hex: "31485e")
        public static var titleTextColor = UIColor.black
        public static var subtitleTextColor = UIColor.darkGray
    }
    
    public static let FacebookBlue = Color(hex: "#3b5998")
    public static let TwitterBlue = Color(hex: "#00aced")
    
    public struct Red {
        public static let P50	= Color(rgba: 0xFDE0DCFF)
        public static let P100	= Color(rgba: 0xF9BDBBFF)
        public static let P200	= Color(rgba: 0xF69988FF)
        public static let P300	= Color(rgba: 0xF36C60FF)
        public static let P400	= Color(rgba: 0xE84E40FF)
        public static let P500	= Color(rgba: 0xE51C23FF)
        public static let P600	= Color(rgba: 0xDD191DFF)
        public static let P700	= Color(rgba: 0xD01716FF)
        public static let P800	= Color(rgba: 0xC41411FF)
        public static let P900	= Color(rgba: 0xB0120AFF)
        public static let A100	= Color(rgba: 0xFF7997FF)
        public static let A200	= Color(rgba: 0xFF5177FF)
        public static let A400	= Color(rgba: 0xFF2D6FFF)
        public static let A700	= Color(rgba: 0xE00032FF)
    }
    
    public struct Pink {
        public static let P50	= Color(rgba: 0xFCE4ECFF)
        public static let P100	= Color(rgba: 0xF8BBD0FF)
        public static let P200	= Color(rgba: 0xF48FB1FF)
        public static let P300	= Color(rgba: 0xF06292FF)
        public static let P400	= Color(rgba: 0xEC407AFF)
        public static let P500	= Color(rgba: 0xE91E63FF)
        public static let P600	= Color(rgba: 0xD81B60FF)
        public static let P700	= Color(rgba: 0xC2185BFF)
        public static let P800	= Color(rgba: 0xAD1457FF)
        public static let P900	= Color(rgba: 0x880E4FFF)
        public static let A100	= Color(rgba: 0xFF80ABFF)
        public static let A200	= Color(rgba: 0xFF4081FF)
        public static let A400	= Color(rgba: 0xF50057FF)
        public static let A700	= Color(rgba: 0xC51162FF)
    }
    
    public struct Purple {
        public static let P50	= Color(rgba: 0xF3E5F5FF)
        public static let P100	= Color(rgba: 0xE1BEE7FF)
        public static let P200	= Color(rgba: 0xCE93D8FF)
        public static let P300	= Color(rgba: 0xBA68C8FF)
        public static let P400	= Color(rgba: 0xAB47BCFF)
        public static let P500	= Color(rgba: 0x9C27B0FF)
        public static let P600	= Color(rgba: 0x8E24AAFF)
        public static let P700	= Color(rgba: 0x7B1FA2FF)
        public static let P800	= Color(rgba: 0x6A1B9AFF)
        public static let P900	= Color(rgba: 0x4A148CFF)
        public static let A100	= Color(rgba: 0xEA80FCFF)
        public static let A200	= Color(rgba: 0xE040FBFF)
        public static let A400	= Color(rgba: 0xD500F9FF)
        public static let A700	= Color(rgba: 0xAA00FFFF)
    }
    
    public struct DeepPurple {
        public static let P50	= Color(rgba: 0xEDE7F6FF)
        public static let P100	= Color(rgba: 0xD1C4E9FF)
        public static let P200	= Color(rgba: 0xB39DDBFF)
        public static let P300	= Color(rgba: 0x9575CDFF)
        public static let P400	= Color(rgba: 0x7E57C2FF)
        public static let P500	= Color(rgba: 0x673AB7FF)
        public static let P600	= Color(rgba: 0x5E35B1FF)
        public static let P700	= Color(rgba: 0x512DA8FF)
        public static let P800	= Color(rgba: 0x4527A0FF)
        public static let P900	= Color(rgba: 0x311B92FF)
        public static let A100	= Color(rgba: 0xB388FFFF)
        public static let A200	= Color(rgba: 0x7C4DFFFF)
        public static let A400	= Color(rgba: 0x651FFFFF)
        public static let A700	= Color(rgba: 0x6200EAFF)
    }
    
    public struct Indigo {
        public static let P50	= Color(rgba: 0xE8EAF6FF)
        public static let P100	= Color(rgba: 0xC5CAE9FF)
        public static let P200	= Color(rgba: 0x9FA8DAFF)
        public static let P300	= Color(rgba: 0x7986CBFF)
        public static let P400	= Color(rgba: 0x5C6BC0FF)
        public static let P500	= Color(rgba: 0x3F51B5FF)
        public static let P600	= Color(rgba: 0x3949ABFF)
        public static let P700	= Color(rgba: 0x303F9FFF)
        public static let P800	= Color(rgba: 0x283593FF)
        public static let P900	= Color(rgba: 0x1A237EFF)
        public static let A100	= Color(rgba: 0x8C9EFFFF)
        public static let A200	= Color(rgba: 0x536DFEFF)
        public static let A400	= Color(rgba: 0x3D5AFEFF)
        public static let A700	= Color(rgba: 0x304FFEFF)
    }
    
    public struct Blue {
        public static let P50	= Color(rgba: 0xE7E9FDFF)
        public static let P100	= Color(rgba: 0xD0D9FFFF)
        public static let P200	= Color(rgba: 0xAFBFFFFF)
        public static let P300	= Color(rgba: 0x91A7FFFF)
        public static let P400	= Color(rgba: 0x738FFEFF)
        public static let P500	= Color(rgba: 0x5677FCFF)
        public static let P600	= Color(rgba: 0x4E6CEFFF)
        public static let P700	= Color(rgba: 0x455EDEFF)
        public static let P800	= Color(rgba: 0x3B50CEFF)
        public static let P900	= Color(rgba: 0x2A36B1FF)
        public static let A100	= Color(rgba: 0xA6BAFFFF)
        public static let A200	= Color(rgba: 0x6889FFFF)
        public static let A400	= Color(rgba: 0x4D73FFFF)
        public static let A700	= Color(rgba: 0x4D69FFFF)
    }
    
    public struct LightBlue {
        public static let P50	= Color(rgba: 0xE1F5FEFF)
        public static let P100	= Color(rgba: 0xB3E5FCFF)
        public static let P200	= Color(rgba: 0x81D4FAFF)
        public static let P300	= Color(rgba: 0x4FC3F7FF)
        public static let P400	= Color(rgba: 0x29B6F6FF)
        public static let P500	= Color(rgba: 0x03A9F4FF)
        public static let P600	= Color(rgba: 0x039BE5FF)
        public static let P700	= Color(rgba: 0x0288D1FF)
        public static let P800	= Color(rgba: 0x0277BDFF)
        public static let P900	= Color(rgba: 0x01579BFF)
        public static let A100	= Color(rgba: 0x80D8FFFF)
        public static let A200	= Color(rgba: 0x40C4FFFF)
        public static let A400	= Color(rgba: 0x00B0FFFF)
        public static let A700	= Color(rgba: 0x0091EAFF)
    }
    
    public struct Cyan {
        public static let P50	= Color(rgba: 0xE0F7FAFF)
        public static let P100	= Color(rgba: 0xB2EBF2FF)
        public static let P200	= Color(rgba: 0x80DEEAFF)
        public static let P300	= Color(rgba: 0x4DD0E1FF)
        public static let P400	= Color(rgba: 0x26C6DAFF)
        public static let P500	= Color(rgba: 0x00BCD4FF)
        public static let P600	= Color(rgba: 0x00ACC1FF)
        public static let P700	= Color(rgba: 0x0097A7FF)
        public static let P800	= Color(rgba: 0x00838FFF)
        public static let P900	= Color(rgba: 0x006064FF)
        public static let A100	= Color(rgba: 0x84FFFFFF)
        public static let A200	= Color(rgba: 0x18FFFFFF)
        public static let A400	= Color(rgba: 0x00E5FFFF)
        public static let A700	= Color(rgba: 0x00B8D4FF)
    }
    
    public struct Teal {
        public static let P50	= Color(rgba: 0xE0F2F1FF)
        public static let P100	= Color(rgba: 0xB2DFDBFF)
        public static let P200	= Color(rgba: 0x80CBC4FF)
        public static let P300	= Color(rgba: 0x4DB6ACFF)
        public static let P400	= Color(rgba: 0x26A69AFF)
        public static let P500	= Color(rgba: 0x009688FF)
        public static let P600	= Color(rgba: 0x00897BFF)
        public static let P700	= Color(rgba: 0x00796BFF)
        public static let P800	= Color(rgba: 0x00695CFF)
        public static let P900	= Color(rgba: 0x004D40FF)
        public static let A100	= Color(rgba: 0xA7FFEBFF)
        public static let A200	= Color(rgba: 0x64FFDAFF)
        public static let A400	= Color(rgba: 0x1DE9B6FF)
        public static let A700	= Color(rgba: 0x00BFA5FF)
    }
    
    public struct Green {
        public static let P50	= Color(rgba: 0xD0F8CEFF)
        public static let P100	= Color(rgba: 0xA3E9A4FF)
        public static let P200	= Color(rgba: 0x72D572FF)
        public static let P300	= Color(rgba: 0x42BD41FF)
        public static let P400	= Color(rgba: 0x2BAF2BFF)
        public static let P500	= Color(rgba: 0x259B24FF)
        public static let P600	= Color(rgba: 0x0A8F08FF)
        public static let P700	= Color(rgba: 0x0A7E07FF)
        public static let P800	= Color(rgba: 0x056F00FF)
        public static let P900	= Color(rgba: 0x0D5302FF)
        public static let A100	= Color(rgba: 0xA2F78DFF)
        public static let A200	= Color(rgba: 0x5AF158FF)
        public static let A400	= Color(rgba: 0x14E715FF)
        public static let A700	= Color(rgba: 0x12C700FF)
    }
    
    public struct LightGreen {
        public static let P50	= Color(rgba: 0xF1F8E9FF)
        public static let P100	= Color(rgba: 0xDCEDC8FF)
        public static let P200	= Color(rgba: 0xC5E1A5FF)
        public static let P300	= Color(rgba: 0xAED581FF)
        public static let P400	= Color(rgba: 0x9CCC65FF)
        public static let P500	= Color(rgba: 0x8BC34AFF)
        public static let P600	= Color(rgba: 0x7CB342FF)
        public static let P700	= Color(rgba: 0x689F38FF)
        public static let P800	= Color(rgba: 0x558B2FFF)
        public static let P900	= Color(rgba: 0x33691EFF)
        public static let A100	= Color(rgba: 0xCCFF90FF)
        public static let A200	= Color(rgba: 0xB2FF59FF)
        public static let A400	= Color(rgba: 0x76FF03FF)
        public static let A700	= Color(rgba: 0x64DD17FF)
    }
    
    public struct Lime {
        public static let P50	= Color(rgba: 0xF9FBE7FF)
        public static let P100	= Color(rgba: 0xF0F4C3FF)
        public static let P200	= Color(rgba: 0xE6EE9CFF)
        public static let P300	= Color(rgba: 0xDCE775FF)
        public static let P400	= Color(rgba: 0xD4E157FF)
        public static let P500	= Color(rgba: 0xCDDC39FF)
        public static let P600	= Color(rgba: 0xC0CA33FF)
        public static let P700	= Color(rgba: 0xAFB42BFF)
        public static let P800	= Color(rgba: 0x9E9D24FF)
        public static let P900	= Color(rgba: 0x827717FF)
        public static let A100	= Color(rgba: 0xF4FF81FF)
        public static let A200	= Color(rgba: 0xEEFF41FF)
        public static let A400	= Color(rgba: 0xC6FF00FF)
        public static let A700	= Color(rgba: 0xAEEA00FF)
    }
    
    public struct Yellow {
        public static let P50	= Color(rgba: 0xFFFDE7FF)
        public static let P100	= Color(rgba: 0xFFF9C4FF)
        public static let P200	= Color(rgba: 0xFFF59DFF)
        public static let P300	= Color(rgba: 0xFFF176FF)
        public static let P400	= Color(rgba: 0xFFEE58FF)
        public static let P500	= Color(rgba: 0xFFEB3BFF)
        public static let P600	= Color(rgba: 0xFDD835FF)
        public static let P700	= Color(rgba: 0xFBC02DFF)
        public static let P800	= Color(rgba: 0xF9A825FF)
        public static let P900	= Color(rgba: 0xF57F17FF)
        public static let A100	= Color(rgba: 0xFFFF8DFF)
        public static let A200	= Color(rgba: 0xFFFF00FF)
        public static let A400	= Color(rgba: 0xFFEA00FF)
        public static let A700	= Color(rgba: 0xFFD600FF)
    }
    
    public struct Amber {
        public static let P50	= Color(rgba: 0xFFF8E1FF)
        public static let P100	= Color(rgba: 0xFFECB3FF)
        public static let P200	= Color(rgba: 0xFFE082FF)
        public static let P300	= Color(rgba: 0xFFD54FFF)
        public static let P400	= Color(rgba: 0xFFCA28FF)
        public static let P500	= Color(rgba: 0xFFC107FF)
        public static let P600	= Color(rgba: 0xFFB300FF)
        public static let P700	= Color(rgba: 0xFFA000FF)
        public static let P800	= Color(rgba: 0xFF8F00FF)
        public static let P900	= Color(rgba: 0xFF6F00FF)
        public static let A100	= Color(rgba: 0xFFE57FFF)
        public static let A200	= Color(rgba: 0xFFD740FF)
        public static let A400	= Color(rgba: 0xFFC400FF)
        public static let A700	= Color(rgba: 0xFFAB00FF)
    }
    
    public struct Orange {
        public static let P50	= Color(rgba: 0xFFF3E0FF)
        public static let P100	= Color(rgba: 0xFFE0B2FF)
        public static let P200	= Color(rgba: 0xFFCC80FF)
        public static let P300	= Color(rgba: 0xFFB74DFF)
        public static let P400	= Color(rgba: 0xFFA726FF)
        public static let P500	= Color(rgba: 0xFF9800FF)
        public static let P600	= Color(rgba: 0xFB8C00FF)
        public static let P700	= Color(rgba: 0xF57C00FF)
        public static let P800	= Color(rgba: 0xEF6C00FF)
        public static let P900	= Color(rgba: 0xE65100FF)
        public static let A100	= Color(rgba: 0xFFD180FF)
        public static let A200	= Color(rgba: 0xFFAB40FF)
        public static let A400	= Color(rgba: 0xFF9100FF)
        public static let A700	= Color(rgba: 0xFF6D00FF)
    }
    
    public struct DeepOrange {
        public static let P50	= Color(rgba: 0xFBE9E7FF)
        public static let P100	= Color(rgba: 0xFFCCBCFF)
        public static let P200	= Color(rgba: 0xFFAB91FF)
        public static let P300	= Color(rgba: 0xFF8A65FF)
        public static let P400	= Color(rgba: 0xFF7043FF)
        public static let P500	= Color(rgba: 0xFF5722FF)
        public static let P600	= Color(rgba: 0xF4511EFF)
        public static let P700	= Color(rgba: 0xE64A19FF)
        public static let P800	= Color(rgba: 0xD84315FF)
        public static let P900	= Color(rgba: 0xBF360CFF)
        public static let A100	= Color(rgba: 0xFF9E80FF)
        public static let A200	= Color(rgba: 0xFF6E40FF)
        public static let A400	= Color(rgba: 0xFF3D00FF)
        public static let A700	= Color(rgba: 0xDD2C00FF)
    }
    
    public struct Brown {
        public static let P50	= Color(rgba: 0xEFEBE9FF)
        public static let P100	= Color(rgba: 0xD7CCC8FF)
        public static let P200	= Color(rgba: 0xBCAAA4FF)
        public static let P300	= Color(rgba: 0xA1887FFF)
        public static let P400	= Color(rgba: 0x8D6E63FF)
        public static let P500	= Color(rgba: 0x795548FF)
        public static let P600	= Color(rgba: 0x6D4C41FF)
        public static let P700	= Color(rgba: 0x5D4037FF)
        public static let P800	= Color(rgba: 0x4E342EFF)
        public static let P900	= Color(rgba: 0x3E2723FF)
    }
    
    public struct Gray {
        public static let P0	= Color(rgba: 0xFFFFFFFF)
        public static let P50	= Color(rgba: 0xFAFAFAFF)
        public static let P100	= Color(rgba: 0xF5F5F5FF)
        public static let P200	= Color(rgba: 0xEEEEEEFF)
        public static let P300	= Color(rgba: 0xE0E0E0FF)
        public static let P400	= Color(rgba: 0xBDBDBDFF)
        public static let P500	= Color(rgba: 0x9E9E9EFF)
        public static let P600	= Color(rgba: 0x757575FF)
        public static let P700	= Color(rgba: 0x616161FF)
        public static let P800	= Color(rgba: 0x424242FF)
        public static let P900	= Color(rgba: 0x212121FF)
        public static let P1000 = Color(rgba: 0x000000FF)
    }
    
    public struct BlueGray {
        public static let P50	= Color(rgba: 0xECEFF1FF)
        public static let P100	= Color(rgba: 0xCFD8DCFF)
        public static let P200	= Color(rgba: 0xB0BEC5FF)
        public static let P300	= Color(rgba: 0x90A4AEFF)
        public static let P400	= Color(rgba: 0x78909CFF)
        public static let P500	= Color(rgba: 0x607D8BFF)
        public static let P600	= Color(rgba: 0x546E7AFF)
        public static let P700	= Color(rgba: 0x455A64FF)
        public static let P800	= Color(rgba: 0x37474FFF)
        public static let P900	= Color(rgba: 0x263238FF)
    }
}
