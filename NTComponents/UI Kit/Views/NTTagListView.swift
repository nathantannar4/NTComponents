//
//  NTTagListView.swift
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
//  Adapted from https://github.com/ElaWorkshop/TagListView
//

@objc public protocol NTTagListViewDelegate {
    @objc optional func tagPressed(_ tagView: NTTagView, sender: NTTagListView) -> Void
    @objc optional func tagAdded(_ tagView: NTTagView, sender: NTTagListView) -> Void
    @objc optional func tagDeleted(_ tagView: NTTagView, sender: NTTagListView) -> Void
}

open class NTTagListView: UIScrollView {
    
    @objc open dynamic var textColor: UIColor = UIColor.white {
        didSet {
            for tagView in tagViews {
                tagView.textColor = textColor
            }
        }
    }
    
    @objc open dynamic var selectedTextColor: UIColor = UIColor.white {
        didSet {
            for tagView in tagViews {
                tagView.selectedTextColor = selectedTextColor
            }
        }
    }
    
    @objc open dynamic var tagHighlightedBackgroundColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
            }
        }
    }
    
    @objc open dynamic var cornerRadius: CGFloat = 5 {
        didSet {
            for tagView in tagViews {
                tagView.cornerRadius = cornerRadius
            }
        }
    }
    @objc open dynamic var borderWidth: CGFloat = 0 {
        didSet {
            for tagView in tagViews {
                tagView.borderWidth = borderWidth
            }
        }
    }
    
    @objc open dynamic var borderColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.borderColor = borderColor
            }
        }
    }
    
    @objc open dynamic var selectedBorderColor: UIColor? {
        didSet {
            for tagView in tagViews {
                tagView.selectedBorderColor = selectedBorderColor
            }
        }
    }
    
    @objc open dynamic var paddingY: CGFloat = 5 {
        didSet {
            for tagView in tagViews {
                tagView.paddingY = paddingY
            }
            rearrangeViews()
        }
    }
    @objc open dynamic var paddingX: CGFloat = 10 {
        didSet {
            for tagView in tagViews {
                tagView.paddingX = paddingX
            }
            rearrangeViews()
        }
    }
    @objc open dynamic var marginY: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    @objc open dynamic var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    public enum Alignment: Int {
        case left
        case center
        case right
    }
    
    open var alignment: Alignment = .left {
        didSet {
            rearrangeViews()
        }
    }
    @objc open dynamic var shadowColor: UIColor = UIColor.white {
        didSet {
            rearrangeViews()
        }
    }
    @objc open dynamic var shadowRadius: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    @objc open dynamic var shadowOffset: CGSize = CGSize.zero {
        didSet {
            rearrangeViews()
        }
    }
    @objc open dynamic var shadowOpacity: Float = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc open dynamic var enableDeleteButton: Bool = true {
        didSet {
            for tagView in tagViews {
                tagView.enableDeleteButton = enableDeleteButton
            }
            rearrangeViews()
        }
    }
    
    @objc open dynamic var textFont: UIFont = Font.Default.Body.withSize(16) {
        didSet {
            for tagView in tagViews {
                tagView.textFont = textFont
            }
            rearrangeViews()
        }
    }
    
    open var tagDelegate: NTTagListViewDelegate?
    
    open private(set) var tagViews: [NTTagView] = []
    private(set) var tagBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = Color.Default.Tint.View
        backgroundColor = .clear
        
        setDefaultShadow()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        rearrangeViews()
    }
    
    private func rearrangeViews() {
        let views = tagViews as [UIView] + tagBackgroundViews + rowViews
        for view in views {
            view.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        for (index, tagView) in tagViews.enumerated() {
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > frame.width {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)
            }
            
            let tagBackgroundView = tagBackgroundViews[index]
            tagBackgroundView.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            tagBackgroundView.frame.size = tagView.bounds.size
            tagBackgroundView.layer.shadowColor = shadowColor.cgColor
            tagBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: tagBackgroundView.bounds, cornerRadius: cornerRadius).cgPath
            tagBackgroundView.layer.shadowOffset = shadowOffset
            tagBackgroundView.layer.shadowOpacity = shadowOpacity
            tagBackgroundView.layer.shadowRadius = shadowRadius
            tagBackgroundView.addSubview(tagView)
            currentRowView.addSubview(tagBackgroundView)
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + marginX
            
            switch alignment {
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frame.width - (currentRowWidth - marginX)) / 2
            case .right:
                currentRowView.frame.origin.x = frame.width - (currentRowWidth - marginX)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Manage tags
    
    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        let size = CGSize(width: frame.width, height: height)
        contentSize = size
        
        return size
    }
    
    open func createNewTagView(_ title: String) -> NTTagView {
        let tagView = NTTagView(title: title)
        
        tagView.textColor = textColor
        tagView.selectedTextColor = selectedTextColor
        tagView.tagBackgroundColor = tintColor
        tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
        tagView.selectedBackgroundColor = tintColor.isLight ? tintColor.darker(by: 10) : tintColor.lighter(by: 10)
        tagView.cornerRadius = cornerRadius
        tagView.borderWidth = borderWidth
        tagView.borderColor = borderColor
        tagView.selectedBorderColor = selectedBorderColor
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = textFont
        tagView.enableDeleteButton = enableDeleteButton
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
        tagView.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        
        // On long press, deselect all tags except this one
        tagView.onLongPress = { [unowned self] this in
            for tag in self.tagViews {
                tag.isSelected = (tag == this)
            }
        }
        
        return tagView
    }
    
    @discardableResult
    open func addTag(_ title: String) -> NTTagView {
        return addTagView(createNewTagView(title))
    }
    
    @discardableResult
    open func addTags(_ titles: [String]) -> [NTTagView] {
        var tagViews: [NTTagView] = []
        for title in titles {
            tagViews.append(createNewTagView(title))
        }
        return addTagViews(tagViews)
    }
    
    @discardableResult
    open func addTagViews(_ tagViews: [NTTagView]) -> [NTTagView] {
        for tagView in tagViews {
            self.tagViews.append(tagView)
            tagBackgroundViews.append(UIView(frame: tagView.bounds))
        }
        rearrangeViews()
        return tagViews
    }
    
    @discardableResult
    open func insertTag(_ title: String, at index: Int) -> NTTagView {
        return insertTagView(createNewTagView(title), at: index)
    }
    
    @discardableResult
    open func addTagView(_ tagView: NTTagView) -> NTTagView {
        tagViews.append(tagView)
        tagBackgroundViews.append(UIView(frame: tagView.bounds))
        rearrangeViews()
        tagDelegate?.tagAdded?(tagView, sender: self)
        return tagView
    }
    
    @discardableResult
    open func insertTagView(_ tagView: NTTagView, at index: Int) -> NTTagView {
        tagViews.insert(tagView, at: index)
        tagBackgroundViews.insert(UIView(frame: tagView.bounds), at: index)
        rearrangeViews()
        
        return tagView
    }
    
    open func setTitle(_ title: String, at index: Int) {
        tagViews[index].titleLabel?.text = title
    }
    
    open func removeTag(_ title: String) {
        // loop the array in reversed order to remove items during loop
        for index in stride(from: (tagViews.count - 1), through: 0, by: -1) {
            let tagView = tagViews[index]
            if tagView.currentTitle == title {
                removeTagView(tagView)
            }
        }
    }
    
    open func removeTagView(_ tagView: NTTagView) {
        tagView.removeFromSuperview()
        if let index = tagViews.index(of: tagView) {
            tagViews.remove(at: index)
            tagBackgroundViews.remove(at: index)
        }
        
        rearrangeViews()
    }
    
    open func removeAllTags() {
        let views = tagViews as [UIView] + tagBackgroundViews
        for view in views {
            view.removeFromSuperview()
        }
        tagViews = []
        tagBackgroundViews = []
        rearrangeViews()
    }
    
    open func selectedTags() -> [NTTagView] {
        return tagViews.filter() { $0.isSelected == true }
    }
    
    // MARK: - Events
    
    @objc open func tagPressed(_ sender: NTTagView) {
        sender.onTap?(sender)
        tagDelegate?.tagPressed?(sender, sender: self)
    }
    
    @objc open func deleteButtonPressed(_ closeButton: NTTagDeleteButton) {
        if let tagView = closeButton.tagView {
            tagDelegate?.tagDeleted?(tagView, sender: self)
        }
    }
}

open class NTTagView: UIButton {
    
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
    
    open var textFont: UIFont = Font.Default.Body.withSize(16) {
        didSet {
            titleLabel?.font = textFont
        }
    }
    
    open func reloadStyles() {
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
    
    open var deleteButton = NTTagDeleteButton()
    
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
    open var onTap: ((NTTagView) -> Void)?
    open var onLongPress: ((NTTagView) -> Void)?
    
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
    
    open func setupView() {
        frame.size = intrinsicContentSize
        addSubview(deleteButton)
        deleteButton.tagView = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        self.addGestureRecognizer(longPress)
    }
    
    @objc open func longPress() {
        onLongPress?(self)
    }
    
    // MARK: - layout
    
    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedStringKey.font: textFont]) ?? CGSize.zero
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

open class NTTagDeleteButton: UIButton {
    
    open weak var tagView: NTTagView?
    
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



