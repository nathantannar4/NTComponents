//
//  NTLabeledInputCell.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/7/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTLabeledInputCell: NTTableViewCell {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
    
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
            self.textField.text = newValue
        }
        get {
            return self.textField.text
        }
    }
    
    public var placeholder: String? {
        set {
            self.textField.placeholder = newValue
        }
        get {
            return self.textField.placeholder
        }
    }
    
    public class func initFromNib() -> NTLabeledInputCell {
        return UINib(nibName: "NTLabeledInputCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTLabeledInputCell
    }
}
