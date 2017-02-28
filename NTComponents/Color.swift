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
        public static var tint = Color.blue
        public static var viewControllerBackground = UIColor.groupTableViewBackground
        public static var navigationBarTint = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        public static var navigationBarBackground = UIColor.white
        public static var buttonTint = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        public static var titleTextColor = UIColor.black
        public static var subtitleTextColor = UIColor.darkGray
    }
    
    public static let FacebookBlue = Color(hex: "#3b5998")
    public static let TwitterBlue = Color(hex: "#00aced")
    
    public struct Red {
        static let P50	= Color(rgba: 0xFDE0DCFF)
        static let P100	= Color(rgba: 0xF9BDBBFF)
        static let P200	= Color(rgba: 0xF69988FF)
        static let P300	= Color(rgba: 0xF36C60FF)
        static let P400	= Color(rgba: 0xE84E40FF)
        static let P500	= Color(rgba: 0xE51C23FF)
        static let P600	= Color(rgba: 0xDD191DFF)
        static let P700	= Color(rgba: 0xD01716FF)
        static let P800	= Color(rgba: 0xC41411FF)
        static let P900	= Color(rgba: 0xB0120AFF)
        static let A100	= Color(rgba: 0xFF7997FF)
        static let A200	= Color(rgba: 0xFF5177FF)
        static let A400	= Color(rgba: 0xFF2D6FFF)
        static let A700	= Color(rgba: 0xE00032FF)
    }
    
    public struct Pink {
        static let P50	= Color(rgba: 0xFCE4ECFF)
        static let P100	= Color(rgba: 0xF8BBD0FF)
        static let P200	= Color(rgba: 0xF48FB1FF)
        static let P300	= Color(rgba: 0xF06292FF)
        static let P400	= Color(rgba: 0xEC407AFF)
        static let P500	= Color(rgba: 0xE91E63FF)
        static let P600	= Color(rgba: 0xD81B60FF)
        static let P700	= Color(rgba: 0xC2185BFF)
        static let P800	= Color(rgba: 0xAD1457FF)
        static let P900	= Color(rgba: 0x880E4FFF)
        static let A100	= Color(rgba: 0xFF80ABFF)
        static let A200	= Color(rgba: 0xFF4081FF)
        static let A400	= Color(rgba: 0xF50057FF)
        static let A700	= Color(rgba: 0xC51162FF)
    }
    
    public struct Purple {
        static let P50	= Color(rgba: 0xF3E5F5FF)
        static let P100	= Color(rgba: 0xE1BEE7FF)
        static let P200	= Color(rgba: 0xCE93D8FF)
        static let P300	= Color(rgba: 0xBA68C8FF)
        static let P400	= Color(rgba: 0xAB47BCFF)
        static let P500	= Color(rgba: 0x9C27B0FF)
        static let P600	= Color(rgba: 0x8E24AAFF)
        static let P700	= Color(rgba: 0x7B1FA2FF)
        static let P800	= Color(rgba: 0x6A1B9AFF)
        static let P900	= Color(rgba: 0x4A148CFF)
        static let A100	= Color(rgba: 0xEA80FCFF)
        static let A200	= Color(rgba: 0xE040FBFF)
        static let A400	= Color(rgba: 0xD500F9FF)
        static let A700	= Color(rgba: 0xAA00FFFF)
    }
    
    public struct DeepPurple {
        static let P50	= Color(rgba: 0xEDE7F6FF)
        static let P100	= Color(rgba: 0xD1C4E9FF)
        static let P200	= Color(rgba: 0xB39DDBFF)
        static let P300	= Color(rgba: 0x9575CDFF)
        static let P400	= Color(rgba: 0x7E57C2FF)
        static let P500	= Color(rgba: 0x673AB7FF)
        static let P600	= Color(rgba: 0x5E35B1FF)
        static let P700	= Color(rgba: 0x512DA8FF)
        static let P800	= Color(rgba: 0x4527A0FF)
        static let P900	= Color(rgba: 0x311B92FF)
        static let A100	= Color(rgba: 0xB388FFFF)
        static let A200	= Color(rgba: 0x7C4DFFFF)
        static let A400	= Color(rgba: 0x651FFFFF)
        static let A700	= Color(rgba: 0x6200EAFF)
    }
    
    public struct Indigo {
        static let P50	= Color(rgba: 0xE8EAF6FF)
        static let P100	= Color(rgba: 0xC5CAE9FF)
        static let P200	= Color(rgba: 0x9FA8DAFF)
        static let P300	= Color(rgba: 0x7986CBFF)
        static let P400	= Color(rgba: 0x5C6BC0FF)
        static let P500	= Color(rgba: 0x3F51B5FF)
        static let P600	= Color(rgba: 0x3949ABFF)
        static let P700	= Color(rgba: 0x303F9FFF)
        static let P800	= Color(rgba: 0x283593FF)
        static let P900	= Color(rgba: 0x1A237EFF)
        static let A100	= Color(rgba: 0x8C9EFFFF)
        static let A200	= Color(rgba: 0x536DFEFF)
        static let A400	= Color(rgba: 0x3D5AFEFF)
        static let A700	= Color(rgba: 0x304FFEFF)
    }
    
    public struct Blue {
        static let P50	= Color(rgba: 0xE7E9FDFF)
        static let P100	= Color(rgba: 0xD0D9FFFF)
        static let P200	= Color(rgba: 0xAFBFFFFF)
        static let P300	= Color(rgba: 0x91A7FFFF)
        static let P400	= Color(rgba: 0x738FFEFF)
        static let P500	= Color(rgba: 0x5677FCFF)
        static let P600	= Color(rgba: 0x4E6CEFFF)
        static let P700	= Color(rgba: 0x455EDEFF)
        static let P800	= Color(rgba: 0x3B50CEFF)
        static let P900	= Color(rgba: 0x2A36B1FF)
        static let A100	= Color(rgba: 0xA6BAFFFF)
        static let A200	= Color(rgba: 0x6889FFFF)
        static let A400	= Color(rgba: 0x4D73FFFF)
        static let A700	= Color(rgba: 0x4D69FFFF)
    }
    
    public struct LightBlue {
        static let P50	= Color(rgba: 0xE1F5FEFF)
        static let P100	= Color(rgba: 0xB3E5FCFF)
        static let P200	= Color(rgba: 0x81D4FAFF)
        static let P300	= Color(rgba: 0x4FC3F7FF)
        static let P400	= Color(rgba: 0x29B6F6FF)
        static let P500	= Color(rgba: 0x03A9F4FF)
        static let P600	= Color(rgba: 0x039BE5FF)
        static let P700	= Color(rgba: 0x0288D1FF)
        static let P800	= Color(rgba: 0x0277BDFF)
        static let P900	= Color(rgba: 0x01579BFF)
        static let A100	= Color(rgba: 0x80D8FFFF)
        static let A200	= Color(rgba: 0x40C4FFFF)
        static let A400	= Color(rgba: 0x00B0FFFF)
        static let A700	= Color(rgba: 0x0091EAFF)
    }
    
    public struct Cyan {
        static let P50	= Color(rgba: 0xE0F7FAFF)
        static let P100	= Color(rgba: 0xB2EBF2FF)
        static let P200	= Color(rgba: 0x80DEEAFF)
        static let P300	= Color(rgba: 0x4DD0E1FF)
        static let P400	= Color(rgba: 0x26C6DAFF)
        static let P500	= Color(rgba: 0x00BCD4FF)
        static let P600	= Color(rgba: 0x00ACC1FF)
        static let P700	= Color(rgba: 0x0097A7FF)
        static let P800	= Color(rgba: 0x00838FFF)
        static let P900	= Color(rgba: 0x006064FF)
        static let A100	= Color(rgba: 0x84FFFFFF)
        static let A200	= Color(rgba: 0x18FFFFFF)
        static let A400	= Color(rgba: 0x00E5FFFF)
        static let A700	= Color(rgba: 0x00B8D4FF)
    }
    
    public struct Teal {
        static let P50	= Color(rgba: 0xE0F2F1FF)
        static let P100	= Color(rgba: 0xB2DFDBFF)
        static let P200	= Color(rgba: 0x80CBC4FF)
        static let P300	= Color(rgba: 0x4DB6ACFF)
        static let P400	= Color(rgba: 0x26A69AFF)
        static let P500	= Color(rgba: 0x009688FF)
        static let P600	= Color(rgba: 0x00897BFF)
        static let P700	= Color(rgba: 0x00796BFF)
        static let P800	= Color(rgba: 0x00695CFF)
        static let P900	= Color(rgba: 0x004D40FF)
        static let A100	= Color(rgba: 0xA7FFEBFF)
        static let A200	= Color(rgba: 0x64FFDAFF)
        static let A400	= Color(rgba: 0x1DE9B6FF)
        static let A700	= Color(rgba: 0x00BFA5FF)
    }
    
    public struct Green {
        static let P50	= Color(rgba: 0xD0F8CEFF)
        static let P100	= Color(rgba: 0xA3E9A4FF)
        static let P200	= Color(rgba: 0x72D572FF)
        static let P300	= Color(rgba: 0x42BD41FF)
        static let P400	= Color(rgba: 0x2BAF2BFF)
        static let P500	= Color(rgba: 0x259B24FF)
        static let P600	= Color(rgba: 0x0A8F08FF)
        static let P700	= Color(rgba: 0x0A7E07FF)
        static let P800	= Color(rgba: 0x056F00FF)
        static let P900	= Color(rgba: 0x0D5302FF)
        static let A100	= Color(rgba: 0xA2F78DFF)
        static let A200	= Color(rgba: 0x5AF158FF)
        static let A400	= Color(rgba: 0x14E715FF)
        static let A700	= Color(rgba: 0x12C700FF)
    }
    
    public struct LightGreen {
        static let P50	= Color(rgba: 0xF1F8E9FF)
        static let P100	= Color(rgba: 0xDCEDC8FF)
        static let P200	= Color(rgba: 0xC5E1A5FF)
        static let P300	= Color(rgba: 0xAED581FF)
        static let P400	= Color(rgba: 0x9CCC65FF)
        static let P500	= Color(rgba: 0x8BC34AFF)
        static let P600	= Color(rgba: 0x7CB342FF)
        static let P700	= Color(rgba: 0x689F38FF)
        static let P800	= Color(rgba: 0x558B2FFF)
        static let P900	= Color(rgba: 0x33691EFF)
        static let A100	= Color(rgba: 0xCCFF90FF)
        static let A200	= Color(rgba: 0xB2FF59FF)
        static let A400	= Color(rgba: 0x76FF03FF)
        static let A700	= Color(rgba: 0x64DD17FF)
    }
    
    public struct Lime {
        static let P50	= Color(rgba: 0xF9FBE7FF)
        static let P100	= Color(rgba: 0xF0F4C3FF)
        static let P200	= Color(rgba: 0xE6EE9CFF)
        static let P300	= Color(rgba: 0xDCE775FF)
        static let P400	= Color(rgba: 0xD4E157FF)
        static let P500	= Color(rgba: 0xCDDC39FF)
        static let P600	= Color(rgba: 0xC0CA33FF)
        static let P700	= Color(rgba: 0xAFB42BFF)
        static let P800	= Color(rgba: 0x9E9D24FF)
        static let P900	= Color(rgba: 0x827717FF)
        static let A100	= Color(rgba: 0xF4FF81FF)
        static let A200	= Color(rgba: 0xEEFF41FF)
        static let A400	= Color(rgba: 0xC6FF00FF)
        static let A700	= Color(rgba: 0xAEEA00FF)
    }
    
    public struct Yellow {
        static let P50	= Color(rgba: 0xFFFDE7FF)
        static let P100	= Color(rgba: 0xFFF9C4FF)
        static let P200	= Color(rgba: 0xFFF59DFF)
        static let P300	= Color(rgba: 0xFFF176FF)
        static let P400	= Color(rgba: 0xFFEE58FF)
        static let P500	= Color(rgba: 0xFFEB3BFF)
        static let P600	= Color(rgba: 0xFDD835FF)
        static let P700	= Color(rgba: 0xFBC02DFF)
        static let P800	= Color(rgba: 0xF9A825FF)
        static let P900	= Color(rgba: 0xF57F17FF)
        static let A100	= Color(rgba: 0xFFFF8DFF)
        static let A200	= Color(rgba: 0xFFFF00FF)
        static let A400	= Color(rgba: 0xFFEA00FF)
        static let A700	= Color(rgba: 0xFFD600FF)
    }
    
    public struct Amber {
        static let P50	= Color(rgba: 0xFFF8E1FF)
        static let P100	= Color(rgba: 0xFFECB3FF)
        static let P200	= Color(rgba: 0xFFE082FF)
        static let P300	= Color(rgba: 0xFFD54FFF)
        static let P400	= Color(rgba: 0xFFCA28FF)
        static let P500	= Color(rgba: 0xFFC107FF)
        static let P600	= Color(rgba: 0xFFB300FF)
        static let P700	= Color(rgba: 0xFFA000FF)
        static let P800	= Color(rgba: 0xFF8F00FF)
        static let P900	= Color(rgba: 0xFF6F00FF)
        static let A100	= Color(rgba: 0xFFE57FFF)
        static let A200	= Color(rgba: 0xFFD740FF)
        static let A400	= Color(rgba: 0xFFC400FF)
        static let A700	= Color(rgba: 0xFFAB00FF)
    }
    
    public struct Orange {
        static let P50	= Color(rgba: 0xFFF3E0FF)
        static let P100	= Color(rgba: 0xFFE0B2FF)
        static let P200	= Color(rgba: 0xFFCC80FF)
        static let P300	= Color(rgba: 0xFFB74DFF)
        static let P400	= Color(rgba: 0xFFA726FF)
        static let P500	= Color(rgba: 0xFF9800FF)
        static let P600	= Color(rgba: 0xFB8C00FF)
        static let P700	= Color(rgba: 0xF57C00FF)
        static let P800	= Color(rgba: 0xEF6C00FF)
        static let P900	= Color(rgba: 0xE65100FF)
        static let A100	= Color(rgba: 0xFFD180FF)
        static let A200	= Color(rgba: 0xFFAB40FF)
        static let A400	= Color(rgba: 0xFF9100FF)
        static let A700	= Color(rgba: 0xFF6D00FF)
    }
    
    public struct DeepOrange {
        static let P50	= Color(rgba: 0xFBE9E7FF)
        static let P100	= Color(rgba: 0xFFCCBCFF)
        static let P200	= Color(rgba: 0xFFAB91FF)
        static let P300	= Color(rgba: 0xFF8A65FF)
        static let P400	= Color(rgba: 0xFF7043FF)
        static let P500	= Color(rgba: 0xFF5722FF)
        static let P600	= Color(rgba: 0xF4511EFF)
        static let P700	= Color(rgba: 0xE64A19FF)
        static let P800	= Color(rgba: 0xD84315FF)
        static let P900	= Color(rgba: 0xBF360CFF)
        static let A100	= Color(rgba: 0xFF9E80FF)
        static let A200	= Color(rgba: 0xFF6E40FF)
        static let A400	= Color(rgba: 0xFF3D00FF)
        static let A700	= Color(rgba: 0xDD2C00FF)
    }
    
    public struct Brown {
        static let P50	= Color(rgba: 0xEFEBE9FF)
        static let P100	= Color(rgba: 0xD7CCC8FF)
        static let P200	= Color(rgba: 0xBCAAA4FF)
        static let P300	= Color(rgba: 0xA1887FFF)
        static let P400	= Color(rgba: 0x8D6E63FF)
        static let P500	= Color(rgba: 0x795548FF)
        static let P600	= Color(rgba: 0x6D4C41FF)
        static let P700	= Color(rgba: 0x5D4037FF)
        static let P800	= Color(rgba: 0x4E342EFF)
        static let P900	= Color(rgba: 0x3E2723FF)
    }
    
    public struct Gray {
        static let P0	= Color(rgba: 0xFFFFFFFF)
        static let P50	= Color(rgba: 0xFAFAFAFF)
        static let P100	= Color(rgba: 0xF5F5F5FF)
        static let P200	= Color(rgba: 0xEEEEEEFF)
        static let P300	= Color(rgba: 0xE0E0E0FF)
        static let P400	= Color(rgba: 0xBDBDBDFF)
        static let P500	= Color(rgba: 0x9E9E9EFF)
        static let P600	= Color(rgba: 0x757575FF)
        static let P700	= Color(rgba: 0x616161FF)
        static let P800	= Color(rgba: 0x424242FF)
        static let P900	= Color(rgba: 0x212121FF)
        static let P1000 = Color(rgba: 0x000000FF)
    }
    
    public struct BlueGray {
        static let P50	= Color(rgba: 0xECEFF1FF)
        static let P100	= Color(rgba: 0xCFD8DCFF)
        static let P200	= Color(rgba: 0xB0BEC5FF)
        static let P300	= Color(rgba: 0x90A4AEFF)
        static let P400	= Color(rgba: 0x78909CFF)
        static let P500	= Color(rgba: 0x607D8BFF)
        static let P600	= Color(rgba: 0x546E7AFF)
        static let P700	= Color(rgba: 0x455A64FF)
        static let P800	= Color(rgba: 0x37474FFF)
        static let P900	= Color(rgba: 0x263238FF)
    }
}
