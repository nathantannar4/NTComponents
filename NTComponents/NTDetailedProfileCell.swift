//
//  NTDetailedProfileCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/28/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTDetailedProfileCell: NTTableViewCell {
    
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
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
    
    public var subtitle: String? {
        set {
            self.subtitleLabel.text = newValue
        }
        get {
            return self.subtitleLabel.text
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
    
    public class func initFromNib() -> NTDetailedProfileCell {
        return UINib(nibName: "NTDetailedProfileCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTDetailedProfileCell
    }
}
