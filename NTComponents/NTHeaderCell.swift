//
//  NTHeaderCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 12/31/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTHeaderCell: NTView {
    
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var actionButton: UIButton!
    
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
    
    public class func initFromNib() -> NTHeaderCell {
        return UINib(nibName: "NTHeaderCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTHeaderCell
    }
}

