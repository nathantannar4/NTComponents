//
//  File.swift
//  NTComponents
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 6/11/17.
//


open class TagView: UIButton {
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    open var borderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    open var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    open var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    open var paddingY: CGFloat = 5 {
        didSet {
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    open var paddingX: CGFloat = 10 {
        didSet {
            titleEdgeInsets.left = paddingX
            updateRightInsets()
        }
    }
    
    open var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadStyles()
        }
    }
    
    open var highlightedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    open var selectedBorderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    open var selectedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    var textFont: UIFont = Font.Default.Body.withSize(16) {
        didSet {
            titleLabel?.font = textFont
        }
    }
    
    private func reloadStyles() {
        if isHighlighted {
            if let highlightedBackgroundColor = highlightedBackgroundColor {
                // For highlighted, if it's nil, we should not fallback to backgroundColor.
                // Instead, we keep the current color.
                backgroundColor = highlightedBackgroundColor
            }
        }
        else if isSelected {
            backgroundColor = selectedBackgroundColor ?? tagBackgroundColor
            layer.borderColor = selectedBorderColor?.cgColor ?? borderColor?.cgColor
            setTitleColor(selectedTextColor, for: UIControlState())
        }
        else {
            backgroundColor = tagBackgroundColor
            layer.borderColor = borderColor?.cgColor
            setTitleColor(textColor, for: UIControlState())
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    // MARK: Delete button
    
    open var deleteButton = NTTagButton()
    
    open var enableDeleteButton: Bool = false {
        didSet {
            deleteButton.isHidden = !enableDeleteButton
            updateRightInsets()
        }
    }
    
    open var deleteButtonIconSize: CGFloat = 8 {
        didSet {
            updateRightInsets()
        }
    }
    
    /// Handles Tap (TouchUpInside)
    open var onTap: ((TagView) -> Void)?
    open var onLongPress: ((TagView) -> Void)?
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, for: UIControlState())
        
        setupView()
    }
    
    private func setupView() {
        frame.size = intrinsicContentSize
        addSubview(deleteButton)
        deleteButton.tagView = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        self.addGestureRecognizer(longPress)
    }
    
    func longPress() {
        onLongPress?(self)
    }
    
    // MARK: - layout
    
    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(attributes: [NSFontAttributeName: textFont]) ?? CGSize.zero
        size.height = textFont.pointSize + paddingY * 2
        size.width += paddingX * 2
        if size.width < size.height {
            size.width = size.height
        }
        if enableDeleteButton {
            size.width += deleteButtonIconSize + paddingX
        }
        return size
    }
    
    private func updateRightInsets() {
        if enableDeleteButton {
            titleEdgeInsets.right = paddingX  + deleteButtonIconSize + paddingX
        }
        else {
            titleEdgeInsets.right = paddingX
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if enableDeleteButton {
            deleteButton.frame.size.width = paddingX + deleteButtonIconSize + paddingX
            deleteButton.frame.origin.x = self.frame.width - deleteButton.frame.width
            deleteButton.frame.size.height = self.frame.height
            deleteButton.frame.origin.y = 0
        }
    }
}

open class NTTagButton: UIButton {
    
    open weak var tagView: TagView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .white
        setImage(Icon.Delete, for: .normal)
        adjustsImageWhenHighlighted = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
