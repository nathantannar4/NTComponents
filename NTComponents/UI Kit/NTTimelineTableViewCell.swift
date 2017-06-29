//
//  NTTimelineTableViewCell.swift
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
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//
//  Modifed by Nathan Tannar on 6/16/17.
//

public enum NTTimelineTableViewCellStyle {
    case short
    case detailed
}

open class NTTimelineTableViewCell: UITableViewCell {
    
    open var timeLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    open var descriptionTextView: NTTextView = {
        let textView = NTTextView()
        textView.isEditable = false
        return textView
    }()
    
    open var thumbnailImageView: NTImageView = {
        let imageView = NTImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open var durationLabel: NTLabel = {
        let label = NTLabel(style: .footnote)
        return label
    }()
    
    open var durationIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.Default.Tint.View
        imageView.contentMode = .scaleAspectFit
        imageView.setIconAsImage(icon: FAType.FAClockO)
        return imageView
    }()
    
    open var locationLabel: NTLabel = {
        let label = NTLabel(style: .footnote)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    open var locationIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.Default.Tint.View
        imageView.contentMode = .scaleAspectFit
        imageView.image = Icon.Map
        return imageView
    }()
    
    open var timelinePoint = TimelinePoint() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    open var timeline = Timeline() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    open var bubbleRadius: CGFloat = 3.0 {
        didSet {
            if (bubbleRadius < 0.0) {
                bubbleRadius = 0.0
            }
            self.setNeedsDisplay()
        }
    }
    
    open var bubbleColor = Color.Gray.P300
    
    open var isInitial: Bool = false {
        didSet {
            if isInitial {
                timeline.leadingColor = .clear
            } else {
                timeline.leadingColor = Color.Gray.P500
            }
            self.setNeedsDisplay()
        }
    }
    
    open var isFinal: Bool = false {
        didSet {
            if isFinal {
                timeline.trailingColor = .clear
            } else {
                timeline.trailingColor = Color.Gray.P500
            }
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(style: .default, reuseIdentifier: "NTTimelineTableViewCell")
    }
    
    public convenience init(style: NTTimelineTableViewCellStyle) {
        switch style {
        case .short:
            self.init(style: .default, reuseIdentifier: "NTTimelineTableViewCell")
        case .detailed:
            self.init(style: .subtitle, reuseIdentifier: "NTTimelineTableViewCell")
        }
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        if style == .subtitle {
            setupDetail()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        textLabel?.isHidden = true
        detailTextLabel?.isHidden = true
        imageView?.isHidden = true
        
        addSubview(timeLabel)
        addSubview(titleLabel)
        addSubview(descriptionTextView)
        addSubview(thumbnailImageView)
        
        timeLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 46, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
        
        titleLabel.anchor(timeLabel.bottomAnchor, left: timeLabel.leftAnchor, bottom: descriptionTextView.topAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        descriptionTextView.anchor(titleLabel.bottomAnchor, left: timeLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        thumbnailImageView.anchor(nil, left: timeLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 36, heightConstant: 36)
        thumbnailImageView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor, constant: 4).isActive = true
        
        selectionStyle = .none
        
    }

    open func setupDetail() {
        addSubview(durationLabel)
        addSubview(durationIconView)
        addSubview(locationIconView)
        addSubview(locationLabel)
        
        descriptionTextView.removeAllConstraints()
        descriptionTextView.anchor(titleLabel.bottomAnchor, left: timeLabel.leftAnchor, bottom: durationLabel.topAnchor, right: rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        durationIconView.anchor(descriptionTextView.bottomAnchor, left: timeLabel.leftAnchor, bottom: locationIconView.topAnchor, right: durationLabel.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        durationIconView.widthAnchor.constraint(lessThanOrEqualToConstant: 20).isActive = true
        durationIconView.anchorAspectRatio()
        
        durationLabel.anchor(durationIconView.topAnchor, left: durationIconView.rightAnchor, bottom: locationLabel.topAnchor, right: descriptionTextView.rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        locationIconView.anchor(durationIconView.bottomAnchor, left: durationIconView.leftAnchor, bottom: bottomAnchor, right: locationLabel.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 6, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        locationIconView.widthAnchor.constraint(lessThanOrEqualToConstant: 20).isActive = true
        locationIconView.anchorAspectRatio()
        
        locationLabel.anchor(locationIconView.topAnchor, left: locationIconView.rightAnchor, bottom: bottomAnchor, right: durationLabel.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 6, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // MARK: - Standard Methods
    
    override open func draw(_ rect: CGRect) {
        
        if let sublayers = self.contentView.layer.sublayers {
            for layer in sublayers {
                if layer is CAShapeLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        timeLabel.sizeToFit()
        descriptionTextView.sizeToFit()
        
        timelinePoint.position = CGPoint(x: timeline.leftMargin + timeline.width / 2, y: timeLabel.frame.origin.y + timeLabel.intrinsicContentSize.height / 2 - timelinePoint.diameter / 2)

        timeline.start = CGPoint(x: timelinePoint.position.x + timelinePoint.diameter / 2, y: 0)
        timeline.middle = CGPoint(x: timeline.start.x, y: timelinePoint.position.y)
        timeline.end = CGPoint(x: timeline.start.x, y: self.bounds.size.height)
        timeline.draw(view: self.contentView)
        
        timelinePoint.draw(view: self.contentView)
        
        if let title = timeLabel.text, !title.isEmpty {
            drawBubble()
        }
    }
    
    internal var bubble: CAShapeLayer?
    
    fileprivate func drawBubble() {
        let offset: CGFloat = 15
        let bubbleRect = CGRect(
            x: timeLabel.frame.origin.x - offset / 2,
            y: timeLabel.frame.origin.y - offset / 2,
            width: timeLabel.intrinsicContentSize.width + offset,
            height: timeLabel.intrinsicContentSize.height + offset)
        
        let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: bubbleRadius)
        let startPoint = CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 - 8)
        path.move(to: startPoint)
        path.addLine(to: startPoint)
        path.addLine(to: CGPoint(x: bubbleRect.origin.x - 8, y: bubbleRect.origin.y + bubbleRect.height / 2))
        path.addLine(to: CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 + 8))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = bubbleColor.cgColor
        shapeLayer.setDefaultShadow()
        self.bubble = shapeLayer
        
        self.contentView.layer.insertSublayer(shapeLayer, below: timeLabel.layer)
    }
}

public struct TimelinePoint {
    
    public var diameter: CGFloat = 10.0 {
        didSet {
            if (diameter < 0.0) {
                diameter = 0.0
            } else if (diameter > 100.0) {
                diameter = 100.0
            }
        }
    }
    
    public var boarderWidth: CGFloat = 2.0 {
        didSet {
            if (boarderWidth < 0.0) {
                boarderWidth = 0.0
            } else if(boarderWidth > 20.0) {
                boarderWidth = 20.0
            }
        }
    }
    
    public var color = UIColor.black
    
    public var isFilled = false
    
    internal var position = CGPoint(x: 0, y: 0)
    
    public init(diameter: CGFloat, boarderWidth: CGFloat, color: UIColor, filled: Bool) {
        self.diameter = diameter
        self.boarderWidth = boarderWidth
        self.color = color
        self.isFilled = filled
    }
    
    public init(diameter: CGFloat, color: UIColor, filled: Bool) {
        self.init(diameter: diameter, boarderWidth: 2.0, color: color, filled: filled)
    }
    
    public init(color: UIColor, filled: Bool) {
        self.init(diameter: 10.0, boarderWidth: 2.0, color: color, filled: filled)
    }
    
    public init() {
        self.init(diameter: 10.0, boarderWidth: 2.0, color: UIColor.black, filled: false)
    }
    
    public func draw(view: UIView) {
        let path = UIBezierPath(ovalIn: CGRect(x: position.x, y: position.y, width: diameter, height: diameter))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = isFilled ? color.cgColor : UIColor.white.cgColor
        shapeLayer.lineWidth = boarderWidth
        
        view.layer.addSublayer(shapeLayer)
    }
}

public struct Timeline {
    
    public var width: CGFloat = 3.0 {
        didSet {
            if (width < 0.0) {
                width = 0.0
            } else if(width > 20.0) {
                width = 20.0
            }
        }
    }
    
    public var leadingColor = Color.Gray.P500
    public var trailingColor = Color.Gray.P500
    
    internal var (start, middle, end) = (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
    
    internal var leftMargin: CGFloat = 16
    
    public init(width: CGFloat, leadingColor: UIColor, trailingColor: UIColor) {
        self.width = width
        self.leadingColor = leadingColor
        self.trailingColor = trailingColor
    }
    
    public init(leadingColor: UIColor, trailingColor: UIColor) {
        self.init(width: 3, leadingColor: leadingColor, trailingColor: trailingColor)
    }
    
    public init() {
        self.init(width: 3, leadingColor: Color.Gray.P500, trailingColor: Color.Gray.P500)
    }
    
    public func draw(view: UIView) {
        draw(view: view, from: start, to: middle, color: leadingColor)
        draw(view: view, from: middle, to: end, color: trailingColor)
    }
    
    fileprivate func draw(view: UIView, from: CGPoint, to: CGPoint, color: UIColor) {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        
        view.layer.addSublayer(shapeLayer)
    }
}
