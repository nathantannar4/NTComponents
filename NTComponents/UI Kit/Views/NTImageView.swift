//
//  NTImageView.swift
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

/**
 A convenient UIImageView to load and cache images.
 */
open class NTImageView: UIImageView {
    
    open static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()
    
    open var shouldUseEmptyImage = true
    
    private var urlStringForChecking: String?
    private var emptyImage: UIImage?
    
    public convenience init(cornerRadius: CGFloat = 0, tapCallback: @escaping (() ->())) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func handleTap() {
        tapCallback?()
    }
    
    private var tapCallback: (() -> ())?
    
    public convenience init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        self.init(frame: .zero)
        contentMode = .scaleAspectFit
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
        tintColor = Color.Default.Tint.View
    }
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
        
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        
        contentMode = .scaleAspectFit
        tintColor = Color.Default.Tint.View
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        
        contentMode = .scaleAspectFit
        tintColor = Color.Default.Tint.View
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .scaleAspectFit
        tintColor = Color.Default.Tint.View
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Easily load an image from a URL string and cache it to reduce network overhead later.
     
     - parameter urlString: The url location of your image, usually on a remote server somewhere.
     - parameter completion: Optionally execute some task after the image download completes
     */
    
    open func loadImage(url: URL?, allowCache: Bool = true, completion: (() -> ())? = nil) {
        guard let url = url else {
            completion?()
            return
        }
        if allowCache, let cachedItem = NTImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            image = cachedItem.image
            completion?()
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    let cacheItem = DiscardableImageCacheItem(image: image)
                    NTImageView.imageCache.setObject(cacheItem, forKey: url.absoluteString as NSString)
                    
                    self?.image = image
                    completion?()
                }
            }
        }).resume()
    }

    open func loadImage(urlString: String?, allowCache: Bool = true, completion: (() -> ())? = nil) {
        
        guard let urlString = urlString else {
            return
        }
        
        self.urlStringForChecking = urlString
        
        let urlKey = urlString as NSString
        
        Log.write(.status, "Loading from url " + urlString)
        
        if allowCache, let cachedItem = NTImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem.image
            completion?()
            return
        }
        
        guard let url = URL(string: urlString) else {
            if shouldUseEmptyImage {
                image = emptyImage
            }
            return
        }
        loadImage(url: url, allowCache: allowCache, completion: completion)
    }
}
