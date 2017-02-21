//
//  NTProfileHeaderCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/29/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTProfileHeaderCell: NTTableViewCell {

    @IBOutlet public weak var imageView: UIView!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    @IBOutlet public weak var rightButton: UIButton!
    @IBOutlet public weak var leftButton: UIButton!
    private var profileImageView = UIImageView()
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.bounds = self.imageView.bounds
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.cornerRadius = self.imageView.bounds.width / 2
        self.profileImageView.clipsToBounds = true
        self.imageView.addSubview(self.profileImageView)
        self.profileImageView.bindFrameToSuperviewBounds()
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOpacity = 0.3
        self.imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.imageView.layer.shadowRadius = 3
        self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2
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
            self.profileImageView.image = newValue
        }
        get {
            return self.profileImageView.image
        }
    }
    
    public class func initFromNib() -> NTProfileHeaderCell {
        return UINib(nibName: "NTProfileHeaderCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTProfileHeaderCell
    }
}
