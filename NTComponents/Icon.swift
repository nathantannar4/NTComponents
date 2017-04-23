//
//  Icon.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/2/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import Foundation

public struct Icon {
    
    /// An internal reference to the icons bundle.
    private static var internalBundle: Bundle?
    
    /**
     A public reference to the icons bundle, that aims to detect
     the correct bundle to use.
     */
    public static var bundle: Bundle {
        if nil == Icon.internalBundle {
            Icon.internalBundle = Bundle(for: NTView.self)
            let url = Icon.internalBundle!.resourceURL!
            let b = Bundle(url: url)
            if let v = b {
                Icon.internalBundle = v
            }
        }
        return Icon.internalBundle!
    }
    
    /// Get the icon by the file name.
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    public static let facebook = UIImage(named: "ic_facebook_logo", in: bundle, compatibleWith: nil)
    public static let twitter = UIImage(named: "ic_twitter_logo", in: bundle, compatibleWith: nil)
    public static let google = UIImage(named: "ic_google_logo", in: bundle, compatibleWith: nil)
    public static let email = UIImage(named: "ic_email_logo", in: bundle, compatibleWith: nil)
}
