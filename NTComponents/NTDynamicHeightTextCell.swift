//
//  NTDynamicHeightTextCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/2/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTDynamicHeightTextCell: NTTableViewCell {
    
    @IBOutlet public weak var contentLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public var text: String? {
        set {
            self.contentLabel.text = newValue
            self.contentLabel.sizeToFit()
            self.bounds = self.contentLabel.bounds
        }
        get {
            return self.contentLabel.text
        }
    }
    
    public var attributedTitle: NSAttributedString? {
        set {
            self.contentLabel.attributedText = newValue
            self.contentLabel.sizeToFit()
            self.bounds = self.contentLabel.bounds
        }
        get {
            return self.contentLabel.attributedText
        }
    }
    
    public class func initFromNib() -> NTDynamicHeightTextCell {
        return UINib(nibName: "NTDynamicHeightTextCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTDynamicHeightTextCell
    }
}
