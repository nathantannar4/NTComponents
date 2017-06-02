//
//  Icon.swift
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
    
    public static let facebook = UIImage(named: "ic_facebook_logo", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public static let twitter = UIImage(named: "ic_twitter_logo", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public static let google = UIImage(named: "ic_google_logo", in: bundle, compatibleWith: nil)
    public static let linkedin = UIImage(named: "ic_linkedin_logo", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public static let github = UIImage(named: "ic_github_logo", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    
    
    public static let NTLogo = icon("NT Logo Black")
    
    public static let Delete = icon("Delete_ffffff_100")
    
    public static let Email = icon("ic_email")
    
    public static let Lock = icon("ic_lock")
    public static let Unlock = icon("ic_unlock")
    
    public static let Search = icon("Search")
    public static let Create = icon("Create")
    public static let Check = icon("Check")
    public static let Send = icon("Send")
    public static let Camera = icon("Camera")
    public static let Help = icon("Help")
    public static let More = icon("More")
    public static let MoreVertical = UIImage().imageRotatedByDegrees(oldImage: icon("More")!, deg: 90)
    public static let Expand = icon("Expand-100")
    public static let Spinner = icon("Synchronize-100")
    public static let PullDownArrow = icon("Down-100")
    
    public struct Arrow {
        public static let Backward = Icon.icon("Backward_ffffff_100")
        public static let Forward = Icon.icon("Forward_ffffff_100")
        public static let Down = Icon.icon("Expand_Arrow")
    }
}
