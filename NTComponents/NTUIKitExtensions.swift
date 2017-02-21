//
//  NTUIKitExtensions.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 12/28/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

public enum NTPresentationDirection {
    case top, right, bottom, left
}

public extension UIViewController {
    
    func setTitleView(title: String?, subtitle: String?, titleColor: UIColor, subtitleColor: UIColor) {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.textColor = subtitleColor
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        self.navigationItem.titleView = titleView
    }
    
    var getNTNavigationContainer: NTNavigationContainer? {
        var parentViewController = self.parent
        
        while parentViewController != nil {
            if let view = parentViewController as? NTNavigationContainer{
                return view
            }
            
            parentViewController = parentViewController!.parent
        }
        print("### ERROR: View controller did not have an NTNavigationContainer as a parent")
        return nil
    }
    
    public func presentViewController(_ viewController: UIViewController, from: NTPresentationDirection, completion:  (() -> Void)?) {
        viewController.view.alpha = 0.0
        viewController.modalPresentationStyle = .overCurrentContext
        let windowFrame = self.view.window!.frame
        let viewFrame = viewController.view.frame
        let finalFrame = viewFrame
        self.present(viewController, animated: false) { () -> Void in
            switch from {
            case .top:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: -windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .right:
                viewController.view.frame = CGRect(x: windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            case .bottom:
                viewController.view.frame = CGRect(x: viewFrame.origin.x, y: windowFrame.height, width: viewFrame.width, height: viewFrame.height)
            case .left:
                viewController.view.frame = CGRect(x: -windowFrame.width, y: viewFrame.origin.y, width: viewFrame.width, height: viewFrame.height)
            }
            viewController.view.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                viewController.view.frame = finalFrame
            }, completion: { (success) -> Void in
                if success && (completion != nil) {
                    completion!()
                }
            })
        }
    }
    
    func dismissViewController(to: NTPresentationDirection, completion:  (() -> Void)?) {
        let frame = self.view.frame
        guard let windowFrame = self.view.window?.frame else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            switch to {
            case .top:
                self.view.frame = CGRect(x: frame.origin.x, y: -windowFrame.height, width: frame.width, height: frame.height)
            case .right:
                self.view.frame = CGRect(x: windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            case .bottom:
                self.view.frame = CGRect(x: frame.origin.x, y: windowFrame.height, width: frame.width, height: frame.height)
            case .left:
                self.view.frame = CGRect(x: -windowFrame.width, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }, completion: { (success) -> Void in
            if success == true {
                self.dismiss(animated: false, completion: {
                    if completion != nil {
                        completion!()
                    }
                })
            }
        })
    }
    
    func setTabBarVisible(visible: Bool, animated: Bool) {
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (isTabBarVisible == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration: TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }
        }
    }
    
    var isTabBarVisible: Bool {
        return (self.tabBarController?.tabBar.frame.origin.y ?? 0) < self.view.frame.maxY
    }
}


public extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            Log.write(.warning, "`superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
    func bindFrameToSuperviewTopBounds(withHeight height: CGFloat) {
        guard let superview = self.superview else {
            Log.write(.warning, "`superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        if #available(iOS 9.0, *) {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        } else {
            Log.write(.warning, "iOS 9 is required")
        }
    }
    
    func bindFrameToSuperviewTopBounds(withHeight height: CGFloat, withTopInset inset: Int) {
        guard let superview = self.superview else {
            Log.write(.warning, "`superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(inset))-[subview(\(height)@250)]", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        if #available(iOS 9.0, *) {
            //self.heightAnchor.constraint(equalToConstant: height).isActive = true
        } else {
            Log.write(.warning, "iOS 9 is required")
        }
    }
    
    func bindFrameToSuperviewBounds(withTopInset inset: Int) {
        guard let superview = self.superview else {
            Log.write(.warning, "`bindFrameToSuperviewTopBounds(withHeight height: CGFloat)` requires iOS 9")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(inset))-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
    func setDefaultShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
    }
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }

    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.white, thickness: CGFloat = 1) {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            border.alpha = CGFloat(self.layer.shadowOpacity)
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
    }
    
    func removeAllConstraints() {
        var view: UIView? = self
        while let currentView = view {
            currentView.removeConstraints(currentView.constraints.filter {
                return $0.firstItem as? UIView == self || $0.secondItem as? UIView == self
            })
            view = view?.superview
        }
    }
}

public extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
}

public extension UITabBarController {
    func setTabBar(hidden:Bool, animated:Bool) {
        
        if self.tabBar.isHidden == hidden {
            return
        }
        
        guard let frame = self.tabBarController?.tabBar.frame else {
            return
        }
        let height = frame.size.height
        let offsetY = hidden ? height : -height
        
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y + offsetY, width: frame.width, height: frame.height)
        }
    }
}


public extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
    var isLight:  Bool {
        guard let components = self.cgColor.components else {
            return false
        }
        var brightness: CGFloat = 0
        for color in components {
            switch components.index(of: color)! {
            case 0:
                brightness += color * 0.299
            case 1:
                brightness += color * 0.587
            case 2:
                brightness += color * 0.114
            default:
                break
            }
        }
        if brightness < 0.5 {
            return false
        }
        return true
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
}

public extension UIImage {
    
    func resizeImage(width: CGFloat, height: CGFloat, renderingMode: UIImageRenderingMode) -> UIImage {
        var newImage = self
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        newImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.withRenderingMode(renderingMode)
    }
    
    
    func cropToSquare() -> UIImage? {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(cgImage: self.cgImage!)
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: width, height: height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        return UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    }
}

public extension UIImageView {
    
    func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}

extension NSMutableAttributedString {
    func bold(_ text: String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes: attrs)
        self.append(boldString)
        return self
    }
    
    func italic(_ text: String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.italicSystemFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes: attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}

public extension NSMutableAttributedString {
    
    func linkUsers(fromList list: [String]) -> NSMutableAttributedString {
        
        for user in list {
            self.setAsLink(textToFind: "@" + user, linkURL: "asasas")
        }
        return self
    }
    
    func setAsLink(textToFind: String, linkURL: String) {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            //self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            self.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)], range: foundRange)
            self.addAttributes([NSForegroundColorAttributeName: Color.defaultButtonTint], range: foundRange)
        }
    }
}

public extension UITextField {
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}

public extension String {
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func parseAttributes() -> NSMutableAttributedString {
        var text = self
        let BOLD = "*"
        let ITALIC = "_"
        var attributedString = NSMutableAttributedString()
        
        var boldComponents = text.components(separatedBy: BOLD)
        while boldComponents.count > 1 {
            attributedString.append(boldComponents[0].parseAttributes())
            attributedString.append(NSMutableAttributedString().bold(boldComponents[1]))
            text = String()
            if boldComponents.count > 2 {
                for index in 2...(boldComponents.count - 1) {
                    text.append(boldComponents[index])
                }
            }
            boldComponents = text.components(separatedBy: BOLD)
        }
        
        var italicComponents = text.components(separatedBy: ITALIC)
        while italicComponents.count > 1 && (boldComponents.count % 2 == 1) {
            attributedString.append(italicComponents[0].parseAttributes())
            attributedString.append(NSMutableAttributedString().italic(italicComponents[1]))
            text = String()
            if italicComponents.count > 2 {
                for index in 2...(italicComponents.count - 1) {
                    text.append(italicComponents[index])
                }
            }
            italicComponents = text.components(separatedBy: ITALIC)
        }

        
        attributedString.append(NSMutableAttributedString(string: text))
        return attributedString
    }
    
    static func mediumDateShortTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date as Date)
    }
    
    static func mediumDateNoTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date as Date)
    }
    
    static func fullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date as Date)
    }
    
    static func timeElapsedSince(_ date: Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        var elapsed: String
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let suffix = (minutes > 1) ? "mins" : "min"
            elapsed = "\(minutes) \(suffix) ago"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let suffix = (hours > 1) ? "hours" : "hour"
            elapsed = "\(hours) \(suffix) ago"
        }
        else {
            let days = Int(seconds / (24 * 60 * 60))
            let suffix = (days > 1) ? "days" : "day"
            elapsed = "\(days) \(suffix) ago"
        }
        return elapsed
    }
}
