//
//  NTTextViewCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTTextViewCell: NTTableViewCell, UITextViewDelegate {
    
    @IBOutlet public weak var textView: UITextView!
    private var _placeholder: String?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.textView.delegate = self
    }
    
    public var text: String? {
        set {
            self.textView.text = newValue
            self.textView.textColor = UIColor.black
        }
        get {
            return self.textView.text
        }
    }
    
    public var attributedText: NSAttributedString {
        set {
            self.textView.attributedText = newValue
        }
        get {
            return self.textView.attributedText
        }
    }
    
    public var placeholder: String? {
        set {
            self._placeholder = newValue
            self.textView.text = newValue
            self.textView.textColor = UIColor.lightGray
        }
        get {
            return self.textView.text
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            self.text = String()
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholder = self._placeholder
        }
    }
    
    public class func initFromNib() -> NTTextViewCell {
        return UINib(nibName: "NTTextViewCell", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! NTTextViewCell
    }
}
