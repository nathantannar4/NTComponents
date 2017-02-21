//
//  NTFooterCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/1/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTFooterCell: NTView {
    
    
    @IBOutlet public weak var titleLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public var title: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    
    public var attributedTitle: NSAttributedString? {
        set {
            self.titleLabel.attributedText = newValue
        }
        get {
            return self.titleLabel.attributedText
        }
    }
    
    public class func initFromNib() -> NTFooterCell {
        return UINib(nibName: "NTFooterCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTFooterCell
    }
}
