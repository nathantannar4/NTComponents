//
//  NTActionCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 12/31/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTActionCell: NTTableViewCell {
    
    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var centerButton: UIButton!
    @IBOutlet public weak var rightButton: UIButton!
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    public class func initFromNib() -> NTActionCell {
        return UINib(nibName: "NTActionCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTActionCell
    }
}
