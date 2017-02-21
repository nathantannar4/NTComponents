//
//  NTDualActionCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/7/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTDualActionCell: NTTableViewCell {
    
    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var rightButton: UIButton!
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    public class func initFromNib() -> NTDualActionCell {
        return UINib(nibName: "NTDualActionCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTDualActionCell
    }
}
