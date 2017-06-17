//
//  NTProgressLineIndicator.swift
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

public enum NTProgressIndicatorState {
    case standby, loading, canceled, completed
}

open class NTProgressLineIndicator: UIView {
    
    let progressLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Default.Tint.View
        return view
    }()
    
    open var state: NTProgressIndicatorState = .standby
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    public convenience init() {
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - 4
        bounds.size.height = 4
        self.init(frame: bounds)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepare() {
        guard let parent = parentViewController else { return }
        
        anchor(parent.view.topAnchor, left: parent.view.leftAnchor, bottom: nil, right: parent.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 4)
        addSubview(progressLine)
        progressLine.frame = CGRect(x: -100, y: 0, width: 100, height: 4)
    }
    
    open func invalidate() {
        state = .canceled
        removeFromSuperview()
    }
    
    open func updateProgress(percentage: CGFloat) {
        if state != .loading {
            prepare()
        }
        state = .loading
        UIView.animate(withDuration: 2, animations: {
            self.progressLine.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * percentage, height: 4)
        }) { (success) in
            if percentage >= 100 {
                self.state = .completed
                self.progressDidComplete()
            }
        }
    }
    
    open func autoComplete(withDuration duration: Double) {
        if state != .loading {
            prepare()
        }
        state = .loading
        UIView.animate(withDuration: duration, animations: {
            self.progressLine.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 4)
        }) { (success) in
            self.state = .completed
            self.progressDidComplete()
        }
    }
    
    open func progressDidComplete() {
        if state == .completed {
            
            UIView.animate(withDuration: 0.4, animations: {
                self.frame.origin = CGPoint(x: 0, y: self.frame.origin.y - 4)
            }, completion: { (success) in
                if success {
                    self.removeFromSuperview()
                }
            })
        } else {
            Log.write(.warning, "NTProgressIndicator has not completed")
        }
    }
}
