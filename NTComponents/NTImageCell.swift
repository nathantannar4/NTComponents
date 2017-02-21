//
//  NTImageCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/1/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTImageCell: NTTableViewCell {
    
    @IBOutlet public weak var contentImageView: UIImageView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public var image: UIImage? {
        set {
            self.contentImageView.image = newValue
        }
        get {
            return self.contentImageView.image
        }
    }
    
    public class func initFromNib() -> NTImageCell {
        return UINib(nibName: "NTImageCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTImageCell
    }
}
