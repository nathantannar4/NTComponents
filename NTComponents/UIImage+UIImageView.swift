//
//  UIImage+UIImageView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public extension UIImage {
    
    func resizeImage(width: CGFloat, height: CGFloat) -> UIImage? {
        var newImage = self
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        newImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.withRenderingMode(renderingMode)
    }
    
    func scale(to size: CGFloat) -> UIImage? {
        return self.resizeImage(width: size, height: size)
    }
    
    
    func toSquare() -> UIImage? {
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
                print(error.debugDescription)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
    
    var containsBlurEffect: Bool {
        for subview in subviews {
            if subview is UIVisualEffectView {
                return true
            }
        }
        return false
    }
    
    func addBlurEffect(style: UIBlurEffectStyle, animationDuration: TimeInterval = 0.0) {
        let blurEffect = UIBlurEffect(style: style)
        let overlay = UIVisualEffectView()
        overlay.frame = self.bounds
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(overlay)
        
        UIView.animate(withDuration: animationDuration, animations: {
            overlay.effect = blurEffect
        })
    }
    
    func removeBlurEffects() {
        for subview in subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}
