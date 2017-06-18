//
//  NTPing.swift
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
//  Created by Nathan Tannar on 5/17/17.
//

open class NTPing: NTView {
    
    fileprivate var statusBar: UIView? {
        get {
            return UIApplication.shared.value(forKey: "statusBar") as? UIView
        }
    }
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.font = Font.Default.Caption.withSize(12)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate var currentState: NTViewState = .hidden
    
    // MARK: - Initialization
    
    public convenience init(type: NTAlertType = NTAlertType.isInfo, title: String? = nil) {
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - 20
        bounds.size.height = 20
        self.init(frame: bounds)
        
        titleLabel.text = title
        
        switch type {
        case .isInfo:
            backgroundColor = Color.Default.Status.Info
        case .isSuccess:
            backgroundColor = Color.Default.Status.Success
        case .isWarning:
            backgroundColor = Color.Default.Status.Warning
        case .isDanger:
            backgroundColor = Color.Default.Status.Danger
        }
        
        if backgroundColor!.isDark {
            titleLabel.textColor = .white
        }
    }
    
    public convenience init(title: String? = nil, color: UIColor = Color.Default.Status.Info) {
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - 20
        bounds.size.height = 20
        self.init(frame: bounds)
        
        backgroundColor = color
        titleLabel.text = title
        
        if color.isDark {
            titleLabel.textColor = .white
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Presentation Methods
    
    open func show(duration: TimeInterval = 2) {
        
        guard let view = statusBar else { return }
        view.addSubview(self)
        
        frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: self.frame.height)
        
        currentState = .transitioning
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.frame.height)
            
        }) { (finished) in
            self.currentState = .visible
            self.fillSuperview()
            
            DispatchQueue.executeAfter(duration, closure: {
                self.dismiss()
            })
        }
    }
    
    open func dismiss() {
        if currentState != .visible { return }
        
        currentState = .transitioning
        UIView.transition(with: self, duration: 0.2, options: .curveLinear, animations: {() -> Void in
            self.frame.origin = CGPoint(x: 0, y: -self.frame.height)
        }, completion: { finished in
            self.currentState = .hidden
            self.removeFromSuperview()
        })
    }
    
    open class func genericErrorMessage() {
        let ping = NTPing(type: .isDanger, title: "Sorry, an error occurred")
        ping.show()
    }
}
