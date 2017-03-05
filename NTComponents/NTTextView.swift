//
//  NTTextView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public class NTTextView: UITextView {
    
    public var placeholder: String? {
        didSet {
            if text.isEmpty {
                text = placeholder
                textColor = Color.lightGray
            }
        }
    }
    private var _textColor: UIColor?
    public override var textColor: UIColor? {
        set {
            super.textColor = newValue
            if text != placeholder {
                _textColor = newValue
            }
        }
        get {
            return super.textColor
        }
    }
    
    public convenience init() {
        self.init(frame: .zero)
        
        font = Font.Defaults.content
        backgroundColor = .clear
        isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(notification:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(notification:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    func textViewTextDidChange(notification: NSNotification) {
//        let contentSize = sizeThatFits(bounds.size)
//        var frame = self.frame
//        frame.size.height = contentSize.height
//        self.frame = frame
    }
    
    func textViewDidBeginEditing(notification: NSNotification) {
        if text == placeholder {
            text = String()
            textColor = _textColor
        }
    }
    
    func textViewDidEndEditing(notification: NSNotification) {
        if text.isEmpty {
            text = placeholder
            textColor = Color.lightGray
        }
    }
}

