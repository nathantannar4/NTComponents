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
//  GMD and FA implementation credited to https://github.com/Vaberer
//  Modified to be generic as long as the enum conforms to IconType
//

import Foundation

// The protocal that icons must conform to in order to be used by the helper functions for the UI elements
public protocol IconType {
    var text: String? { get }
    var filename: String { get }
}

public struct Icon {
    
    /// An internal reference to the icons bundle.
    private static var internalBundle: Bundle?
    
    /// A public reference to the icons bundle, that aims to detect the correct bundle to use.
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
    public static let NavBackButton = icon("NavBackButton")
    public static let Target = icon("Target")
    public static let MapMarker = icon("MapMarker")
    public static let Map = icon("Map")
    public static let Clock = icon("Clock")
    
    public struct Arrow {
        public static let Backward = Icon.icon("Backward_ffffff_100")
        public static let Forward = Icon.icon("Forward_ffffff_100")
        public static let Down = Icon.icon("Expand_Arrow")
    }
}

/**
 Allows for the initialization of UIImages from an IconType
 */
public extension UIImage {
    
    public convenience init<T:IconType>(icon: T, size iconSize: CGSize, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = Color.Default.Tint.View, backgroundColor: UIColor = UIColor.clear) {
        
        var size = iconSize
        if size == .zero {
            // Default size of 100, 100 if size was zero. This fixes issues if one uses auto layout
            size = CGSize(width: 100, height: 100)
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        
        let font = Font.load(name: icon.filename, withSize: fontSize)!
        
        let attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: textColor, NSBackgroundColorAttributeName: backgroundColor, NSParagraphStyleAttributeName: paragraph]
        
        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) * 0.5, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        if let image = image {
            var imageOrientation = image.imageOrientation
            
            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }
            
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
    
    public convenience init<T:IconType>(bgIcon: T, orientation: UIImageOrientation = UIImageOrientation.down, bgTextColor: UIColor = Color.Default.Tint.View, bgBackgroundColor: UIColor = .clear, topIcon: T, topTextColor: UIColor = .black, bgLarge: Bool? = true, size iconSize: CGSize) {
        
        var size = iconSize
        if size == .zero {
            // Default size of 100, 100 if size was zero. This fixes issues if one uses auto layout
            size = CGSize(width: 100, height: 100)
        }
        
        let bgSize: CGSize!
        let topSize: CGSize!
        let bgRect: CGRect!
        let topRect: CGRect!
        
        if bgLarge! {
            topSize = size
            bgSize = CGSize(width: 2 * topSize.width, height: 2 * topSize.height)
            
        } else {
            
            bgSize = size
            topSize = CGSize(width: 2 * bgSize.width, height: 2 * bgSize.height)
        }
        
        let bgImage = UIImage(icon: bgIcon, size: bgSize, orientation: orientation, textColor: bgTextColor)
        let topImage = UIImage(icon: topIcon, size: topSize, orientation: orientation, textColor: topTextColor)
        
        if bgLarge! {
            bgRect = CGRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
            topRect = CGRect(x: topSize.width/2, y: topSize.height/2, width: topSize.width, height: topSize.height)
            UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
            
        } else {
            topRect = CGRect(x: 0, y: 0, width: topSize.width, height: topSize.height)
            bgRect = CGRect(x: bgSize.width/2, y: bgSize.height/2, width: bgSize.width, height: bgSize.height)
            UIGraphicsBeginImageContextWithOptions(topImage.size, false, 0.0)
            
        }
        
        bgImage.draw(in: bgRect)
        topImage.draw(in: topRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            var imageOrientation = image.imageOrientation
            
            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }
            
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
}

public extension UIBarButtonItem {
    
    func setIcon<T:IconType>(icon: T, iconSize: CGFloat = 30) {
        
        guard let font = Font.load(name: icon.filename, withSize: iconSize) else { return }
        setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        title = icon.text
    }
    
    func setIcon<T:IconType>(prefixText: String, icon: T, postfixText: String, size: CGFloat = 30) {
        
        guard let font = Font.load(name: icon.filename, withSize: size) else { return }
        setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        
        var text = prefixText
        if let iconText = icon.text {
            text += iconText
        }
        text += postfixText
        title = text
    }
}


public extension UITextField {
    
    public func setRightViewIcon<T:IconType>(icon: T, rightViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = Color.Default.Tint.View, backgroundColor: UIColor = .clear, size: CGSize = CGSize(width: 30, height: 30)) {
        
        let image = UIImage(icon: icon, size: size, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView(image: image)
        
        self.rightView = imageView
        self.rightViewMode = rightViewMode
    }
    
    public func setLeftViewIcon<T:IconType>(icon: T, leftViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = Color.Default.Tint.View, backgroundColor: UIColor = .clear, size: CGSize = CGSize(width: 30, height: 30)) {
        
        let image = UIImage(icon: icon, size: size, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView(image: image)
        
        self.leftView = imageView
        self.leftViewMode = leftViewMode
    }
}

public extension UIButton {
    
    func setIcon<T:IconType>(icon: T, forState state: UIControlState) {
        
        guard let titleLabel = titleLabel else { return }
        guard let font = Font.load(name: icon.filename, withSize: titleLabel.font.pointSize) else { return }
        setAttributedTitle(nil, for: state)
        titleLabel.font = font
        setTitle(icon.text, for: state)
    }
    
    func setIcon<T:IconType>(icon: T, iconSize: CGFloat, forState state: UIControlState) {
        
        setIcon(icon: icon, forState: state)
        guard let fontName = titleLabel?.font.fontName else { return }
        titleLabel?.font = UIFont(name: fontName, size: iconSize)
    }
    
    
    func setText<T:IconType>(prefixText: String, icon: T, postfixText: String, size: CGFloat?, forState state: UIControlState, iconSize: CGFloat? = nil) {
        setTitle(nil, for: state)
        
        Font.load(name: icon.filename)
        guard let titleLabel = titleLabel else { return }
        let attributedText = attributedTitle(for: .normal) ?? NSAttributedString()
        let  startFont =  attributedText.length == 0 ? nil : attributedText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attributedText.length == 0 ? nil : attributedText.attribute(NSFontAttributeName, at: attributedText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = titleLabel.font
        if let f = startFont , f.fontName != icon.filename  {
            textFont = f
        } else if let f = endFont , f.fontName != icon.filename  {
            textFont = f
        }
        
        var textColor: UIColor = .black
        attributedText.enumerateAttribute(NSForegroundColorAttributeName, in:NSMakeRange(0,attributedText.length), options:.longestEffectiveRangeNotRequired) {
            value, range, stop in
            if value != nil {
                textColor = value as! UIColor
            }
        }
        
        let textAttributes = [NSFontAttributeName: textFont!, NSForegroundColorAttributeName: textColor] as [String : Any]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttributes)
        
        let iconFont = UIFont(name: icon.filename, size: iconSize ?? size ?? titleLabel.font.pointSize)!
        let iconAttributes = [NSFontAttributeName: iconFont, NSForegroundColorAttributeName: textColor] as [String : Any]
        
        let iconString = NSAttributedString(string: icon.text!, attributes: iconAttributes)
        prefixTextAttribured.append(iconString)
        
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttributes)
        prefixTextAttribured.append(postfixTextAttributed)
        
        setAttributedTitle(prefixTextAttribured, for: state)
    }
    
    
    func setIconColor(color: UIColor, forState state: UIControlState = .normal) {
        
        let attributedString = NSMutableAttributedString(attributedString: attributedTitle(for: state) ?? NSAttributedString())
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedString.length))
        
        setAttributedTitle(attributedString, for: state)
        setTitleColor(color, for: state)
    }
}

public extension UILabel {
    
    func setIcon<T:IconType>(icon: T, iconSize: CGFloat) {
        guard let font = Font.load(name: icon.filename, withSize: self.font.pointSize) else { return }
        self.font = font
        text = icon.text
    }
    
    
    func setIconColor(color: UIColor) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedText!.length))
        textColor = color
    }
    
    
    func setText<T:IconType>(prefixText: String, icon: T, postfixText: String, size: CGFloat?, iconSize: CGFloat? = nil) {
        text = nil
        Font.load(name: icon.filename)
        
        let attrText = attributedText ?? NSAttributedString()
        let startFont = attrText.length == 0 ? nil : attrText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attrText.length == 0 ? nil : attrText.attribute(NSFontAttributeName, at: attrText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = font
        if let f = startFont , f.fontName != icon.filename  {
            textFont = f
        } else if let f = endFont , f.fontName != icon.filename  {
            textFont = f
        }
        let textAttribute = [NSFontAttributeName : textFont!]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
        
        let iconFont = UIFont(name: icon.filename, size: iconSize ?? size ?? font.pointSize)!
        let iconAttribute = [NSFontAttributeName : iconFont]
        
        let iconString = NSAttributedString(string: icon.text ?? String(), attributes: iconAttribute)
        prefixTextAttribured.append(iconString)
        
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)
        
        attributedText = prefixTextAttribured
    }
}

public extension UIImageView {

    public func setIconAsImage<T:IconType>(icon: T, textColor: UIColor = Color.Default.Tint.View, orientation: UIImageOrientation = UIImageOrientation.down, backgroundColor: UIColor = UIColor.clear, size: CGSize? = nil) {
        self.image = UIImage(icon: icon, size: size ?? frame.size, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
    }
}

public extension UITabBarItem {
    
    public func setIcon<T:IconType>(icon: T, size: CGSize? = nil, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = Color.Default.Tint.View, backgroundColor: UIColor = UIColor.clear, selectedTextColor: UIColor = UIColor.black, selectedBackgroundColor: UIColor = UIColor.clear) {
        
        let tabBarItemImageSize = size ?? CGSize(width: 30, height: 30)
        
        image = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        selectedImage = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: selectedTextColor, backgroundColor: selectedBackgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        setTitleTextAttributes([NSForegroundColorAttributeName: textColor], for: .normal)
        setTitleTextAttributes([NSForegroundColorAttributeName: selectedTextColor], for: .selected)
    }
}


public extension UISegmentedControl {
    
    public func setIcon<T:IconType>(icon: T, forSegmentAtIndex segment: Int) {
        
        guard let font = Font.load(name: icon.filename, withSize: 30) else { return }
        setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        setTitle(icon.text, forSegmentAt: segment)
    }
}

public extension UIStepper {
    
    public func setIconBackgroundImage<T:IconType>(icon: T, forState state: UIControlState) {
        
        let backgroundSize = CGSize(width: 47, height: 29)
        let image = UIImage(icon: icon, size: backgroundSize)
        setBackgroundImage(image, for: state)
    }
    
    public func setIconIncrementImage<T:IconType>(icon: T, forState state: UIControlState) {
    
        let incrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: incrementSize)
        setIncrementImage(image, for: state)
    }
    
    public func setIconDecrementImage<T:IconType>(icon: T, forState state: UIControlState) {
        
        let decrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: decrementSize)
        setDecrementImage(image, for: state)
    }
}

public extension UISlider {
    
    func setIconMaximumValueImage<T:IconType>(icon: T, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        maximumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
    
    
    func setIconMinimumValueImage<T:IconType>(icon: T, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        minimumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
}


public extension UIViewController {
    
    var iconTitle: IconType? {
        set {
            guard let icon = newValue else { return }
            guard let font = Font.load(name: icon.filename, withSize: 30) else { return }
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font]
            title = newValue?.text
        }
        get {
            guard let title = title else { return nil }
            if let index = FAIcons.index(of: title) {
                return FAType(rawValue: index)
            }
            if let index = GMDIcons.index(of: title) {
                return GMDType(rawValue: index)
            }
            return nil
        }
    }
}
