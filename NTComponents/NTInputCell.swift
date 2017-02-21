//
//  NTInputCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/7/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//


import UIKit

open class NTInputCell: NTTableViewCell {
    
    @IBOutlet public weak var textField: UITextField!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    public class func initFromNib() -> NTInputCell {
        return UINib(nibName: "NTInputCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTInputCell
    }
}

