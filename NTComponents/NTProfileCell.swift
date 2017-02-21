//
//  NTProfileCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/29/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTProfileCell: NTTableViewCell {
    
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var accessoryButton: UIButton!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryButton.tintColor = UIColor.darkGray
    }
    
    public var title: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    
    public var image: UIImage? {
        set {
            self.imageView.image = newValue
        }
        get {
            return self.imageView.image
        }
    }
    
    open func setImageViewDefaults() {
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.setRounded()
    }
    
    public class func initFromNib() -> NTProfileCell {
        return UINib(nibName: "NTProfileCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTProfileCell
    }
}
