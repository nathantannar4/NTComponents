//
//  NTTextInputBar.swift
//  NTComponents
//
//  Created by Nathan Tannar on 5/21/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//


open class NTTextInputBar: NTInputAccessoryView, UITextViewDelegate {
    
    open var maxHeight: CGFloat = 120
    
    open let textView: NTTextView = {
        let textView = NTTextView()
        textView.placeholder = "Tap to edit.."
        textView.isEditable = true
        textView.font = Font.Default.Body.withSize(15)
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 5
        textView.layer.backgroundColor = Color.Gray.P100.cgColor
        textView.edgePadding = UIEdgeInsets(top: 8, left: 10, bottom: 2, right: 10)
        return textView
    }()
    
    open let accessoryButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.rippleOverBounds = true
        button.ripplePercent = 1.25
        button.backgroundColor = .white
        button.image = Icon.Camera
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    open let sendButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.rippleOverBounds = true
        button.ripplePercent = 1.25
        button.backgroundColor = .white
        button.image = Icon.Send
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    open var resignResponderOnSend: Bool = false
    open var alwaysShowSendButton: Bool = false
    open var showAccessoryButton: Bool = false {
        didSet {
            accessoryButtonWidthConstraint?.constant = showAccessoryButton ? 30 : 0
            layoutIfNeeded()
        }
    }
    
    fileprivate var accessoryButtonWidthConstraint: NSLayoutConstraint?
    fileprivate var sendButtonWidthConstraint: NSLayoutConstraint?
    fileprivate var previousRect: CGRect = .zero
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setDefaultShadow()
        layer.shadowOffset = CGSize(width: 0, height: -Color.Default.Shadow.Offset.height)
        addSubview(textView)
        addSubview(accessoryButton)
        addSubview(sendButton)
        textView.delegate = self
        
        accessoryButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 4, leftConstant: 12, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        accessoryButtonWidthConstraint = accessoryButton.widthAnchor.constraint(equalToConstant: 0)
        accessoryButtonWidthConstraint?.isActive = true
        
        textView.anchor(topAnchor, left: accessoryButton.rightAnchor, bottom: bottomAnchor, right: sendButton.leftAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        sendButton.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 12, widthConstant: 0, heightConstant: 30)
        sendButtonWidthConstraint = sendButton.widthAnchor.constraint(lessThanOrEqualToConstant: 0)
        sendButtonWidthConstraint?.isActive = true
        sendButton.addTarget(self, action: #selector(didPressSend(_:)), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods
    
    @objc open func didPressSend(_ sender: NTButton) {
        if resignResponderOnSend {
            textView.resignFirstResponder()
        }
    }
    
    open override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    open override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    
    open func textViewDidChange(_ textView: UITextView) {
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        if previousRect != .zero {
            if currentRect.origin.y > previousRect.origin.y {
                let newContant = heightConstant + 15.5
                if newContant < maxHeight {
                    heightConstant = newContant
                    let range = NSRange(location: textView.text.characters.count - 1, length: 1)
                    textView.scrollRangeToVisible(range)
                }
            } else if currentRect.origin.y < previousRect.origin.y{
                heightConstant = heightConstant - 15.5
            }
        }
        previousRect = currentRect
        
        if textView.text.isEmpty && !alwaysShowSendButton {
            UIView.animate(withDuration: 0.2, animations: {
                self.sendButtonWidthConstraint?.constant = 0
                self.controller?.view.layoutIfNeeded()
            })
        } else if !alwaysShowSendButton {
            UIView.animate(withDuration: 0.2, animations: {
                self.sendButtonWidthConstraint?.constant = 30
                self.controller?.view.layoutIfNeeded()
            })
        }
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            didPressSend(sendButton)
            return false
        }
        return true
    }
}
