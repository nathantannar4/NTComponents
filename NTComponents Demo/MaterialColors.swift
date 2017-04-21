//
//  MaterialColors.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

struct MaterialColors {
    
    func all() -> [UIColor] {
        
        let all = try! All().allProperties()
        
        var colors = [UIColor]()
        for (_, value) in all {
            if let subcolors = value as? [String : Any] {
                
                for (_, color) in subcolors {
                    colors.append(color as! UIColor)
                }
            } else {
                print("fail")
            }
        }
        
        return colors
    }
    
    struct All: PropertyLoopable {
        let red = try! Red().allProperties()
        let pink = try! Pink().allProperties()
        let purple = try! Purple().allProperties()
        let deeppurple = try! DeepPurple().allProperties()
        let indigo = try! Indigo().allProperties()
        let blue = try! Blue().allProperties()
        let lightblue = try! LightBlue().allProperties()
        let cyan = try! Cyan().allProperties()
        let teal = try! Teal().allProperties()
        let green = try! Green().allProperties()
        let lightgreen = try! LightGreen().allProperties()
        let lime = try! Lime().allProperties()
        let yellow = try! Yellow().allProperties()
        let amber = try! Amber().allProperties()
        let orange = try! Orange().allProperties()
        let deeporange = try! DeepOrange().allProperties()
        let brown = try! Brown().allProperties()
        let gray = try! Gray().allProperties()
        let bluegray = try! BlueGray().allProperties()
    }
    
    public struct Red: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xFDE0DCFF)
        public let P100	= UIColor(rgba: 0xF9BDBBFF)
        public let P200	= UIColor(rgba: 0xF69988FF)
        public let P300	= UIColor(rgba: 0xF36C60FF)
        public let P400	= UIColor(rgba: 0xE84E40FF)
        public let P500	= UIColor(rgba: 0xE51C23FF)
        public let P600	= UIColor(rgba: 0xDD191DFF)
        public let P700	= UIColor(rgba: 0xD01716FF)
        public let P800	= UIColor(rgba: 0xC41411FF)
        public let P900	= UIColor(rgba: 0xB0120AFF)
        public let A100	= UIColor(rgba: 0xFF7997FF)
        public let A200	= UIColor(rgba: 0xFF5177FF)
        public let A400	= UIColor(rgba: 0xFF2D6FFF)
        public let A700	= UIColor(rgba: 0xE00032FF)
    }
    
    public struct Pink: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xFCE4ECFF)
        public let P100	= UIColor(rgba: 0xF8BBD0FF)
        public let P200	= UIColor(rgba: 0xF48FB1FF)
        public let P300	= UIColor(rgba: 0xF06292FF)
        public let P400	= UIColor(rgba: 0xEC407AFF)
        public let P500	= UIColor(rgba: 0xE91E63FF)
        public let P600	= UIColor(rgba: 0xD81B60FF)
        public let P700	= UIColor(rgba: 0xC2185BFF)
        public let P800	= UIColor(rgba: 0xAD1457FF)
        public let P900	= UIColor(rgba: 0x880E4FFF)
        public let A100	= UIColor(rgba: 0xFF80ABFF)
        public let A200	= UIColor(rgba: 0xFF4081FF)
        public let A400	= UIColor(rgba: 0xF50057FF)
        public let A700	= UIColor(rgba: 0xC51162FF)
    }
    
    public struct Purple: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xF3E5F5FF)
        public let P100	= UIColor(rgba: 0xE1BEE7FF)
        public let P200	= UIColor(rgba: 0xCE93D8FF)
        public let P300	= UIColor(rgba: 0xBA68C8FF)
        public let P400	= UIColor(rgba: 0xAB47BCFF)
        public let P500	= UIColor(rgba: 0x9C27B0FF)
        public let P600	= UIColor(rgba: 0x8E24AAFF)
        public let P700	= UIColor(rgba: 0x7B1FA2FF)
        public let P800	= UIColor(rgba: 0x6A1B9AFF)
        public let P900	= UIColor(rgba: 0x4A148CFF)
        public let A100	= UIColor(rgba: 0xEA80FCFF)
        public let A200	= UIColor(rgba: 0xE040FBFF)
        public let A400	= UIColor(rgba: 0xD500F9FF)
        public let A700	= UIColor(rgba: 0xAA00FFFF)
    }
    
    public struct DeepPurple: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xEDE7F6FF)
        public let P100	= UIColor(rgba: 0xD1C4E9FF)
        public let P200	= UIColor(rgba: 0xB39DDBFF)
        public let P300	= UIColor(rgba: 0x9575CDFF)
        public let P400	= UIColor(rgba: 0x7E57C2FF)
        public let P500	= UIColor(rgba: 0x673AB7FF)
        public let P600	= UIColor(rgba: 0x5E35B1FF)
        public let P700	= UIColor(rgba: 0x512DA8FF)
        public let P800	= UIColor(rgba: 0x4527A0FF)
        public let P900	= UIColor(rgba: 0x311B92FF)
        public let A100	= UIColor(rgba: 0xB388FFFF)
        public let A200	= UIColor(rgba: 0x7C4DFFFF)
        public let A400	= UIColor(rgba: 0x651FFFFF)
        public let A700	= UIColor(rgba: 0x6200EAFF)
    }
    
    public struct Indigo: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xE8EAF6FF)
        public let P100	= UIColor(rgba: 0xC5CAE9FF)
        public let P200	= UIColor(rgba: 0x9FA8DAFF)
        public let P300	= UIColor(rgba: 0x7986CBFF)
        public let P400	= UIColor(rgba: 0x5C6BC0FF)
        public let P500	= UIColor(rgba: 0x3F51B5FF)
        public let P600	= UIColor(rgba: 0x3949ABFF)
        public let P700	= UIColor(rgba: 0x303F9FFF)
        public let P800	= UIColor(rgba: 0x283593FF)
        public let P900	= UIColor(rgba: 0x1A237EFF)
        public let A100	= UIColor(rgba: 0x8C9EFFFF)
        public let A200	= UIColor(rgba: 0x536DFEFF)
        public let A400	= UIColor(rgba: 0x3D5AFEFF)
        public let A700	= UIColor(rgba: 0x304FFEFF)
    }
    
    public struct Blue: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xE7E9FDFF)
        public let P100	= UIColor(rgba: 0xD0D9FFFF)
        public let P200	= UIColor(rgba: 0xAFBFFFFF)
        public let P300	= UIColor(rgba: 0x91A7FFFF)
        public let P400	= UIColor(rgba: 0x738FFEFF)
        public let P500	= UIColor(rgba: 0x5677FCFF)
        public let P600	= UIColor(rgba: 0x4E6CEFFF)
        public let P700	= UIColor(rgba: 0x455EDEFF)
        public let P800	= UIColor(rgba: 0x3B50CEFF)
        public let P900	= UIColor(rgba: 0x2A36B1FF)
        public let A100	= UIColor(rgba: 0xA6BAFFFF)
        public let A200	= UIColor(rgba: 0x6889FFFF)
        public let A400	= UIColor(rgba: 0x4D73FFFF)
        public let A700	= UIColor(rgba: 0x4D69FFFF)
    }
    
    public struct LightBlue: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xE1F5FEFF)
        public let P100	= UIColor(rgba: 0xB3E5FCFF)
        public let P200	= UIColor(rgba: 0x81D4FAFF)
        public let P300	= UIColor(rgba: 0x4FC3F7FF)
        public let P400	= UIColor(rgba: 0x29B6F6FF)
        public let P500	= UIColor(rgba: 0x03A9F4FF)
        public let P600	= UIColor(rgba: 0x039BE5FF)
        public let P700	= UIColor(rgba: 0x0288D1FF)
        public let P800	= UIColor(rgba: 0x0277BDFF)
        public let P900	= UIColor(rgba: 0x01579BFF)
        public let A100	= UIColor(rgba: 0x80D8FFFF)
        public let A200	= UIColor(rgba: 0x40C4FFFF)
        public let A400	= UIColor(rgba: 0x00B0FFFF)
        public let A700	= UIColor(rgba: 0x0091EAFF)
    }
    
    public struct Cyan: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xE0F7FAFF)
        public let P100	= UIColor(rgba: 0xB2EBF2FF)
        public let P200	= UIColor(rgba: 0x80DEEAFF)
        public let P300	= UIColor(rgba: 0x4DD0E1FF)
        public let P400	= UIColor(rgba: 0x26C6DAFF)
        public let P500	= UIColor(rgba: 0x00BCD4FF)
        public let P600	= UIColor(rgba: 0x00ACC1FF)
        public let P700	= UIColor(rgba: 0x0097A7FF)
        public let P800	= UIColor(rgba: 0x00838FFF)
        public let P900	= UIColor(rgba: 0x006064FF)
        public let A100	= UIColor(rgba: 0x84FFFFFF)
        public let A200	= UIColor(rgba: 0x18FFFFFF)
        public let A400	= UIColor(rgba: 0x00E5FFFF)
        public let A700	= UIColor(rgba: 0x00B8D4FF)
    }
    
    public struct Teal: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xE0F2F1FF)
        public let P100	= UIColor(rgba: 0xB2DFDBFF)
        public let P200	= UIColor(rgba: 0x80CBC4FF)
        public let P300	= UIColor(rgba: 0x4DB6ACFF)
        public let P400	= UIColor(rgba: 0x26A69AFF)
        public let P500	= UIColor(rgba: 0x009688FF)
        public let P600	= UIColor(rgba: 0x00897BFF)
        public let P700	= UIColor(rgba: 0x00796BFF)
        public let P800	= UIColor(rgba: 0x00695CFF)
        public let P900	= UIColor(rgba: 0x004D40FF)
        public let A100	= UIColor(rgba: 0xA7FFEBFF)
        public let A200	= UIColor(rgba: 0x64FFDAFF)
        public let A400	= UIColor(rgba: 0x1DE9B6FF)
        public let A700	= UIColor(rgba: 0x00BFA5FF)
    }
    
    public struct Green: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xD0F8CEFF)
        public let P100	= UIColor(rgba: 0xA3E9A4FF)
        public let P200	= UIColor(rgba: 0x72D572FF)
        public let P300	= UIColor(rgba: 0x42BD41FF)
        public let P400	= UIColor(rgba: 0x2BAF2BFF)
        public let P500	= UIColor(rgba: 0x259B24FF)
        public let P600	= UIColor(rgba: 0x0A8F08FF)
        public let P700	= UIColor(rgba: 0x0A7E07FF)
        public let P800	= UIColor(rgba: 0x056F00FF)
        public let P900	= UIColor(rgba: 0x0D5302FF)
        public let A100	= UIColor(rgba: 0xA2F78DFF)
        public let A200	= UIColor(rgba: 0x5AF158FF)
        public let A400	= UIColor(rgba: 0x14E715FF)
        public let A700	= UIColor(rgba: 0x12C700FF)
    }
    
    public struct LightGreen: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xF1F8E9FF)
        public let P100	= UIColor(rgba: 0xDCEDC8FF)
        public let P200	= UIColor(rgba: 0xC5E1A5FF)
        public let P300	= UIColor(rgba: 0xAED581FF)
        public let P400	= UIColor(rgba: 0x9CCC65FF)
        public let P500	= UIColor(rgba: 0x8BC34AFF)
        public let P600	= UIColor(rgba: 0x7CB342FF)
        public let P700	= UIColor(rgba: 0x689F38FF)
        public let P800	= UIColor(rgba: 0x558B2FFF)
        public let P900	= UIColor(rgba: 0x33691EFF)
        public let A100	= UIColor(rgba: 0xCCFF90FF)
        public let A200	= UIColor(rgba: 0xB2FF59FF)
        public let A400	= UIColor(rgba: 0x76FF03FF)
        public let A700	= UIColor(rgba: 0x64DD17FF)
    }
    
    public struct Lime: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xF9FBE7FF)
        public let P100	= UIColor(rgba: 0xF0F4C3FF)
        public let P200	= UIColor(rgba: 0xE6EE9CFF)
        public let P300	= UIColor(rgba: 0xDCE775FF)
        public let P400	= UIColor(rgba: 0xD4E157FF)
        public let P500	= UIColor(rgba: 0xCDDC39FF)
        public let P600	= UIColor(rgba: 0xC0CA33FF)
        public let P700	= UIColor(rgba: 0xAFB42BFF)
        public let P800	= UIColor(rgba: 0x9E9D24FF)
        public let P900	= UIColor(rgba: 0x827717FF)
        public let A100	= UIColor(rgba: 0xF4FF81FF)
        public let A200	= UIColor(rgba: 0xEEFF41FF)
        public let A400	= UIColor(rgba: 0xC6FF00FF)
        public let A700	= UIColor(rgba: 0xAEEA00FF)
    }
    
    public struct Yellow: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xFFFDE7FF)
        public let P100	= UIColor(rgba: 0xFFF9C4FF)
        public let P200	= UIColor(rgba: 0xFFF59DFF)
        public let P300	= UIColor(rgba: 0xFFF176FF)
        public let P400	= UIColor(rgba: 0xFFEE58FF)
        public let P500	= UIColor(rgba: 0xFFEB3BFF)
        public let P600	= UIColor(rgba: 0xFDD835FF)
        public let P700	= UIColor(rgba: 0xFBC02DFF)
        public let P800	= UIColor(rgba: 0xF9A825FF)
        public let P900	= UIColor(rgba: 0xF57F17FF)
        public let A100	= UIColor(rgba: 0xFFFF8DFF)
        public let A200	= UIColor(rgba: 0xFFFF00FF)
        public let A400	= UIColor(rgba: 0xFFEA00FF)
        public let A700	= UIColor(rgba: 0xFFD600FF)
    }
    
    public struct Amber: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xFFF8E1FF)
        public let P100	= UIColor(rgba: 0xFFECB3FF)
        public let P200	= UIColor(rgba: 0xFFE082FF)
        public let P300	= UIColor(rgba: 0xFFD54FFF)
        public let P400	= UIColor(rgba: 0xFFCA28FF)
        public let P500	= UIColor(rgba: 0xFFC107FF)
        public let P600	= UIColor(rgba: 0xFFB300FF)
        public let P700	= UIColor(rgba: 0xFFA000FF)
        public let P800	= UIColor(rgba: 0xFF8F00FF)
        public let P900	= UIColor(rgba: 0xFF6F00FF)
        public let A100	= UIColor(rgba: 0xFFE57FFF)
        public let A200	= UIColor(rgba: 0xFFD740FF)
        public let A400	= UIColor(rgba: 0xFFC400FF)
        public let A700	= UIColor(rgba: 0xFFAB00FF)
    }
    
    public struct Orange: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xFFF3E0FF)
        public let P100	= UIColor(rgba: 0xFFE0B2FF)
        public let P200	= UIColor(rgba: 0xFFCC80FF)
        public let P300	= UIColor(rgba: 0xFFB74DFF)
        public let P400	= UIColor(rgba: 0xFFA726FF)
        public let P500	= UIColor(rgba: 0xFF9800FF)
        public let P600	= UIColor(rgba: 0xFB8C00FF)
        public let P700	= UIColor(rgba: 0xF57C00FF)
        public let P800	= UIColor(rgba: 0xEF6C00FF)
        public let P900	= UIColor(rgba: 0xE65100FF)
        public let A100	= UIColor(rgba: 0xFFD180FF)
        public let A200	= UIColor(rgba: 0xFFAB40FF)
        public let A400	= UIColor(rgba: 0xFF9100FF)
        public let A700	= UIColor(rgba: 0xFF6D00FF)
    }
    
    public struct DeepOrange: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xFBE9E7FF)
        public let P100	= UIColor(rgba: 0xFFCCBCFF)
        public let P200	= UIColor(rgba: 0xFFAB91FF)
        public let P300	= UIColor(rgba: 0xFF8A65FF)
        public let P400	= UIColor(rgba: 0xFF7043FF)
        public let P500	= UIColor(rgba: 0xFF5722FF)
        public let P600	= UIColor(rgba: 0xF4511EFF)
        public let P700	= UIColor(rgba: 0xE64A19FF)
        public let P800	= UIColor(rgba: 0xD84315FF)
        public let P900	= UIColor(rgba: 0xBF360CFF)
        public let A100	= UIColor(rgba: 0xFF9E80FF)
        public let A200	= UIColor(rgba: 0xFF6E40FF)
        public let A400	= UIColor(rgba: 0xFF3D00FF)
        public let A700	= UIColor(rgba: 0xDD2C00FF)
    }
    
    public struct Brown: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xEFEBE9FF)
        public let P100	= UIColor(rgba: 0xD7CCC8FF)
        public let P200	= UIColor(rgba: 0xBCAAA4FF)
        public let P300	= UIColor(rgba: 0xA1887FFF)
        public let P400	= UIColor(rgba: 0x8D6E63FF)
        public let P500	= UIColor(rgba: 0x795548FF)
        public let P600	= UIColor(rgba: 0x6D4C41FF)
        public let P700	= UIColor(rgba: 0x5D4037FF)
        public let P800	= UIColor(rgba: 0x4E342EFF)
        public let P900	= UIColor(rgba: 0x3E2723FF)
    }
    
    public struct Gray: PropertyLoopable {
        public let P0	= UIColor(rgba: 0xFFFFFFFF)
        public let P50	= UIColor(rgba: 0xFAFAFAFF)
        public let P100	= UIColor(rgba: 0xF5F5F5FF)
        public let P200	= UIColor(rgba: 0xEEEEEEFF)
        public let P300	= UIColor(rgba: 0xE0E0E0FF)
        public let P400	= UIColor(rgba: 0xBDBDBDFF)
        public let P500	= UIColor(rgba: 0x9E9E9EFF)
        public let P600	= UIColor(rgba: 0x757575FF)
        public let P700	= UIColor(rgba: 0x616161FF)
        public let P800	= UIColor(rgba: 0x424242FF)
        public let P900	= UIColor(rgba: 0x212121FF)
        public let P1000 = UIColor(rgba: 0x000000FF)
    }
    
    public struct BlueGray: PropertyLoopable {
        public let P50	= UIColor(rgba: 0xECEFF1FF)
        public let P100	= UIColor(rgba: 0xCFD8DCFF)
        public let P200	= UIColor(rgba: 0xB0BEC5FF)
        public let P300	= UIColor(rgba: 0x90A4AEFF)
        public let P400	= UIColor(rgba: 0x78909CFF)
        public let P500	= UIColor(rgba: 0x607D8BFF)
        public let P600	= UIColor(rgba: 0x546E7AFF)
        public let P700	= UIColor(rgba: 0x455A64FF)
        public let P800	= UIColor(rgba: 0x37474FFF)
        public let P900	= UIColor(rgba: 0x263238FF)
    }

}
