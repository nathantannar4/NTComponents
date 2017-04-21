//
//  Font.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/20/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//
//  Typography defaults inspired by https://experience.sap.com/fiori-design-ios/article/typography/
//

enum NTPreferredFontStyle {
    case title, subtitle, body, callout, caption, footnote, headline, subhead, disabled
}

public struct Font {

    public init() {}

    public static func whatIsAvailable() {
        for familyName in UIFont.familyNames {
            Log.write(.status, familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                Log.write(.status, "== \(fontName)")
            }
        }
    }

    // Depricated
    public struct Defaults {
        public static var title = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        public static var subtitle = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        public static var content = UIFont.systemFont(ofSize: 13)
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

extension UISearchBar {
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
