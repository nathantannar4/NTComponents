//
//  NTPageHeaderCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTPageHeaderCell: NTTableViewCell {
    
    @IBOutlet public weak var imageView: UIView!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var rightButton: UIButton!
    public var pageImageView = UIImageView()
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.pageImageView.contentMode = .scaleAspectFill
        self.pageImageView.bounds = self.imageView.bounds
        self.pageImageView.layer.borderWidth = 3
        self.pageImageView.layer.masksToBounds = false
        self.pageImageView.layer.borderColor = UIColor.white.cgColor
        self.pageImageView.layer.cornerRadius = 5
        self.pageImageView.clipsToBounds = true
        self.imageView.addSubview(self.pageImageView)
        self.pageImageView.bindFrameToSuperviewBounds()
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOpacity = 0.3
        self.imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.imageView.layer.shadowRadius = 3
        self.imageView.layer.cornerRadius = 5
        self.imageView.layer.zPosition = 10
    }
    
    public var name: String? {
        set {
            self.nameLabel.text = newValue
        }
        get {
            return self.nameLabel.text
        }
    }
    
    public var image: UIImage? {
        set {
            self.pageImageView.image = newValue
        }
        get {
            return self.pageImageView.image
        }
    }
    
    public class func initFromNib() -> NTPageHeaderCell {
        return UINib(nibName: "NTPageHeaderCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTPageHeaderCell
    }
}
