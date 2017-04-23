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

public enum NTPreferredFontStyle {
    case title, subtitle, body, callout, caption, footnote, headline, subhead, disabled
}

public struct Font {

    public static func whatIsAvailable() {
        for familyName in UIFont.familyNames {
            Log.write(.status, familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                Log.write(.status, "== \(fontName)")
            }
        }
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
        public static let Regular       = UIFont(name: "Roboto-Regular", size: 15)
        public static let Thin          = UIFont(name: "Roboto-Thin", size: 15)
        public static let ThinItalic    = UIFont(name: "Roboto-ThinItalic", size: 15)
        public static let Italic        = UIFont(name: "Roboto-Italic", size: 15)
        public static let Light         = UIFont(name: "Roboto-Light", size: 15)
        public static let LightItalic   = UIFont(name: "Roboto-LightItalic", size: 15)
        public static let Medium        = UIFont(name: "Roboto-Medium", size: 15)
        public static let MediumItalic  = UIFont(name: "Roboto-MediumItalic", size: 15)
        public static let Bold          = UIFont(name: "Roboto-Bold", size: 15)
        public static let BoldItalic    = UIFont(name: "Roboto-BoldItalic", size: 15)
        public static let Black         = UIFont(name: "Roboto-Black", size: 15)
        public static let BlackItalic   = UIFont(name: "Roboto-BlackItalic", size: 15)
    }
}

extension UILabel {
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

extension UITextField {
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

extension UITextView {
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
