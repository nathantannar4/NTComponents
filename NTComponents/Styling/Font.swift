//
//  Font.swift
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
//  Typography defaults inspired by https://experience.sap.com/fiori-design-ios/article/typography/
//

import Foundation
import CoreFoundation

public enum NTPreferredFontStyle {
    case title, subtitle, body, callout, caption, footnote, headline, subhead, disabled
}

public struct Font {

    /// An internal reference to the fonts bundle.
    private static var internalBundle: Bundle?
    
    /// A public reference to the font bundle, that aims to detect the correct bundle to use.
    public static var bundle: Bundle {
        if nil == Font.internalBundle {
            Font.internalBundle = Bundle(for: NTView.self)
            let url = Font.internalBundle!.resourceURL!
            let b = Bundle(url: url)
            if let v = b {
                Font.internalBundle = v
            }
        }
        return Font.internalBundle!
    }
    
    
    /// Prints the available/loaded fonts
    public static func whatIsAvailable() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("== \(name)")
            }
        }
    }
    
    
    /// Loads a custom font
    ///
    /// - Parameters:
    ///   - fromBundle: The bundle the font is located under, defaults to Font.bundle
    ///   - name: The name of the font file
    ///   - withExtension: The extension of the font file
    ///   - size: The font size you would like returned, defaults 15
    /// - Returns: A UIFont generated from the custom font file
    @discardableResult
    public static func load(fromBundle: Bundle = bundle, name: String?, withExtension: String = "ttf", withSize size: CGFloat = 15) -> UIFont? {
        
        guard let name = name else {
            return nil
        }
        
        // Check if font is already loaded
        if UIFont.fontNames(forFamilyName: name).count != 0 {
            return UIFont(name: name, size: size)
        }
        
        // Else try to load the font
        guard let url = fromBundle.url(forResource: name, withExtension: withExtension) else {
            Log.write(.error, "Failed to find the font: \(name).\(withExtension) in the supplied bundle")
            return nil
        }
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            return nil
        }
        let font = CGFont(fontDataProvider)
        var error: Unmanaged<CFError>?
        
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            Log.write(.error, "Failed to register font from file: \(name).\(withExtension)")
            Log.write(.error, error.debugDescription)
            return nil
        }
        return UIFont(name: name, size: size)
    }

    public struct Default {
        public static var Title     = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        public static var Subtitle  = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        public static var Body      = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        public static var Callout   = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        public static var Caption   = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        public static var Footnote  = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        public static var Headline  = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        public static var Subhead   = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
        public static var Disabled  = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
    }

    public struct Roboto {
        public static let Regular       = Font.load(name: "Roboto-Regular")!
        public static let Thin          = Font.load(name: "Roboto-Thin")!
        public static let ThinItalic    = Font.load(name: "Roboto-ThinItalic")!
        public static let Italic        = Font.load(name: "Roboto-Italic")!
        public static let Light         = Font.load(name: "Roboto-Light")!
        public static let LightItalic   = Font.load(name: "Roboto-LightItalic")!
        public static let Medium        = Font.load(name: "Roboto-Medium")!
        public static let MediumItalic  = Font.load(name: "Roboto-MediumItalic")!
        public static let Bold          = Font.load(name: "Roboto-Bold")!
        public static let BoldItalic    = Font.load(name: "Roboto-BoldItalic")!
        public static let Black         = Font.load(name: "Roboto-Black")!
        public static let BlackItalic   = Font.load(name: "Roboto-BlackItalic")!
    }
    
    public static let BebasNeue = Font.load(name: "BebasNeue", withExtension: "otf", withSize: 15)
}

public extension UILabel {
    /**
     Sets the textColor and font to that stored in Color.Default.Text and Font.Default

     - parameter to: The style of your preferred font
     - returns: Void
    */
    func setPreferredFontStyle(to style: NTPreferredFontStyle) {
        switch style {
        case .title:
            self.textColor = Color.Default.Text.Title
            self.font = Font.Default.Title
        case .subtitle:
            self.textColor = Color.Default.Text.Subtitle
            self.font = Font.Default.Subtitle
        case .body:
            self.textColor = Color.Default.Text.Body
            self.font = Font.Default.Body
        case .callout:
            self.textColor = Color.Default.Text.Callout
            self.font = Font.Default.Callout
        case .caption:
            self.textColor = Color.Default.Text.Caption
            self.font = Font.Default.Caption
        case .footnote:
            self.textColor = Color.Default.Text.Footnote
            self.font = Font.Default.Footnote
        case .headline:
            self.textColor = Color.Default.Text.Headline
            self.font = Font.Default.Headline
        case .subhead:
            self.textColor = Color.Default.Text.Subhead
            self.font = Font.Default.Subhead
        case .disabled:
            self.textColor = Color.Default.Text.Disabled
            self.font = Font.Default.Disabled
        }
    }
}

public extension UITextField {
    /**
     Sets the textColor and font to that stored in Color.Default.Text and Font.Default

     - parameter to: The style of your preferred font
     - returns: Void
    */
    func setPreferredFontStyle(to style: NTPreferredFontStyle) {
        switch style {
        case .title:
            self.textColor = Color.Default.Text.Title
            self.font = Font.Default.Title
        case .subtitle:
            self.textColor = Color.Default.Text.Subtitle
            self.font = Font.Default.Subtitle
        case .body:
            self.textColor = Color.Default.Text.Body
            self.font = Font.Default.Body
        case .callout:
            self.textColor = Color.Default.Text.Callout
            self.font = Font.Default.Callout
        case .caption:
            self.textColor = Color.Default.Text.Caption
            self.font = Font.Default.Caption
        case .footnote:
            self.textColor = Color.Default.Text.Footnote
            self.font = Font.Default.Footnote
        case .headline:
            self.textColor = Color.Default.Text.Headline
            self.font = Font.Default.Headline
        case .subhead:
            self.textColor = Color.Default.Text.Subhead
            self.font = Font.Default.Subhead
        case .disabled:
            self.textColor = Color.Default.Text.Disabled
            self.font = Font.Default.Disabled
        }
    }
}

public extension UITextView {
    /**
     Sets the textColor and font to that stored in Color.Default.Text and Font.Default

     - parameter to: The style of your preferred font
     - returns: Void
    */
    func setPreferredFontStyle(to style: NTPreferredFontStyle) {
        switch style {
        case .title:
            self.textColor = Color.Default.Text.Title
            self.font = Font.Default.Title
        case .subtitle:
            self.textColor = Color.Default.Text.Subtitle
            self.font = Font.Default.Subtitle
        case .body:
            self.textColor = Color.Default.Text.Body
            self.font = Font.Default.Body
        case .callout:
            self.textColor = Color.Default.Text.Callout
            self.font = Font.Default.Callout
        case .caption:
            self.textColor = Color.Default.Text.Caption
            self.font = Font.Default.Caption
        case .footnote:
            self.textColor = Color.Default.Text.Footnote
            self.font = Font.Default.Footnote
        case .headline:
            self.textColor = Color.Default.Text.Headline
            self.font = Font.Default.Headline
        case .subhead:
            self.textColor = Color.Default.Text.Subhead
            self.font = Font.Default.Subhead
        case .disabled:
            self.textColor = Color.Default.Text.Disabled
            self.font = Font.Default.Disabled
        }
    }
}

public extension UIButton {
    /**
     Sets the textColor and font to that stored in Color.Default.Text and Font.Default
     
     - parameter to: The style of your preferred font
     - returns: Void
     */
    func setPreferredFontStyle(to style: NTPreferredFontStyle) {
        switch style {
        case .title:
            self.setTitleColor(Color.Default.Text.Title, for: .normal)
            self.titleLabel?.font = Font.Default.Title
        case .subtitle:
            self.setTitleColor(Color.Default.Text.Subtitle, for: .normal)
            self.titleLabel?.font = Font.Default.Subtitle
        case .body:
            self.setTitleColor(Color.Default.Text.Body, for: .normal)
            self.titleLabel?.font = Font.Default.Body
        case .callout:
            self.setTitleColor(Color.Default.Text.Callout, for: .normal)
            self.titleLabel?.font = Font.Default.Callout
        case .caption:
            self.setTitleColor(Color.Default.Text.Caption, for: .normal)
            self.titleLabel?.font = Font.Default.Caption
        case .footnote:
            self.setTitleColor(Color.Default.Text.Footnote, for: .normal)
            self.titleLabel?.font = Font.Default.Footnote
        case .headline:
            self.setTitleColor(Color.Default.Text.Headline, for: .normal)
            self.titleLabel?.font = Font.Default.Headline
        case .subhead:
            self.setTitleColor(Color.Default.Text.Subhead, for: .normal)
            self.titleLabel?.font = Font.Default.Subhead
        case .disabled:
            self.setTitleColor(Color.Default.Text.Disabled, for: .normal)
            self.titleLabel?.font = Font.Default.Disabled
        }
    }
}
