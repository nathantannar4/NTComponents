//
//  NTProgressHUD.swift
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
//  Created by Nathan Tannar on 5/29/17.
//

open class NTProgressHUD: UIView {
    
    open let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    open let activityIndicator: NTActivityView = {
        let activityView = NTActivityView()
        return activityView
    }()
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .body)
        label.font = Font.Default.Body.withSize(12)
        label.textAlignment = .center
        label.textColor = Color.Gray.P800
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indicatorView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functional Methods
    
    open func show(withTitle title: String? = nil, duration: TimeInterval? = nil) {
        alpha = 0
        guard let parent = UIApplication.presentedController else {
            return
        }
        parent.view.addSubview(self)
        fillSuperview()
        indicatorView.anchorCenterSuperview()
        indicatorView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        indicatorView.addSubview(activityIndicator)
        indicatorView.addSubview(titleLabel)
        indicatorView.addSubview(titleLabel)
        
        activityIndicator.anchor(indicatorView.topAnchor, left: indicatorView.leftAnchor, bottom: titleLabel.topAnchor, right: indicatorView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        activityIndicator.startAnimating()
        
        titleLabel.text = title
        titleLabel.anchor(nil, left: indicatorView.leftAnchor, bottom: indicatorView.bottomAnchor, right: indicatorView.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 8, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.backgroundColor = Color.Gray.P900.withAlphaComponent(0.2)
        }) { (success) in
            if success {
                guard let duration = duration else {
                    return
                }
                DispatchQueue.executeAfter(duration, closure: {
                    self.dismiss()
                })
            }
        }
    }
    
    open func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.backgroundColor = .clear
        }) { (success) in
            if success {
                self.activityIndicator.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
}
