//
//  NTLoginOptionCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/7/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit



open class NTLoginOptionCell: NTTableViewCell {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.backgroundView.layer.cornerRadius = 5
        self.titleLabel.addBorder(edges: .left, colour: UIColor.white, thickness: 1)
        self.titleLabel.textColor = UIColor.white
        self.imageView.contentMode = .scaleAspectFit
        
    }
    
    public var attributedTitle: NSAttributedString? {
        set {
            self.titleLabel.attributedText = newValue
        }
        get {
            return self.titleLabel.attributedText
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
    
    
    public class func initFromNib() -> NTLoginOptionCell {
        return UINib(nibName: "NTLoginOptionCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTLoginOptionCell
    }
}
