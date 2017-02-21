//
//  NTMenuItemCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/29/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTMenuItemCell: NTTableViewCell {
    
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
    
    public class func initFromNib() -> NTMenuItemCell {
        return UINib(nibName: "NTMenuItemCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTMenuItemCell
    }
}
