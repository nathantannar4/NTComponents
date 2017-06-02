//
//  NTRefreshControl.swift
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
//  Created by Nathan Tannar on 6/1/17.
//

open class NTRefreshControl: UIRefreshControl, CAAnimationDelegate {
    
    open var activityView: NTActivityView = {
        let view = NTActivityView()
        return view
    }()
    
    open var iconView: NTImageView = {
        let imageView = NTImageView()
        imageView.image = Icon.PullDownArrow
        imageView.tintColor = .white
        return imageView
    }()
    
    open override var attributedTitle: NSAttributedString? {
        set {
            titleLabel.attributedText = newValue
        }
        get {
            return titleLabel.attributedText
        }
    }
    
    open var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .caption)
        label.textAlignment = .center
        label.textColor = Color.Gray.P500
        label.text = "Pull to Refresh"
        return label
    }()
    
    // MARK: - Initialization
    
    public override init() {
        super.init(frame: .zero)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    open func setup() {
        
        tintColor = .clear
        
        addSubview(activityView)
        activityView.anchorCenterSuperview()
        activityView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
        activityView.circleLayer.fillColor = activityView.tintColor.cgColor
        activityView.addSubview(iconView)
        iconView.fillSuperview()
        
        addSubview(titleLabel)
        titleLabel.anchor(activityView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Refresh Methods
    
    open override func beginRefreshing() {
        iconView.alpha = 1
        iconView.rotate(degrees: CGFloat(Double.pi), duration: 0.3, speed: 1, completionDelegate: self)
    }
    
    open override func endRefreshing() {
        super.endRefreshing()
        activityView.circleLayer.isHidden = true
        activityView.stopAnimating()
        DispatchQueue.executeAfter(0.5) {
            self.iconView.alpha = 1
            self.activityView.circleLayer.fillColor = self.activityView.tintColor.cgColor
            self.activityView.circleLayer.isHidden = false
            self.titleLabel.isHidden = false
        }
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        activityView.circleLayer.fillColor = UIColor.clear.cgColor
        if isRefreshing {
            activityView.startAnimating()
            titleLabel.isHidden = true
        }
        super.beginRefreshing()
    }
    
    open func animationDidStart(_ anim: CAAnimation) {
        UIView.animate(withDuration: 0.29) {
            self.iconView.alpha = 0
        }
    }
}
