//
//  NTLabeledCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/14/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTLabeledCell: NTTableViewCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var contentLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = Color.defaultButtonTint
    }
    
    public var title: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
    
    public var text: String? {
        set {
            self.contentLabel.text = newValue
        }
        get {
            return self.contentLabel.text
        }
    }
    
    public class func initFromNib() -> NTLabeledCell {
        return UINib(nibName: "NTLabeledCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTLabeledCell
    }
}

