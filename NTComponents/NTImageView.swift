//
//  NTImageView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/20/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
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
    
    public init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
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

    open func loadImage(urlString: String, allowCache: Bool = true, completion: (() -> ())? = nil) {
        
        self.urlStringForChecking = urlString
        
        let urlKey = urlString as NSString
        print(urlKey)
        
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
