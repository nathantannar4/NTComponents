//
//  NTActivityIndicator.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/29/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public enum NTActivityIndicatorState {
    case standby, loading, canceled, completed
}

open class NTActivityIndicator: UIView {
    
    let progressLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.Default.Tint.NavigationBar
        return view
    }()
    
    open var state: NTActivityIndicatorState = .standby
    open var task: (() -> Bool)?
    open var completion: ((Bool) -> Void)?
    
    fileprivate weak var navigationController: UINavigationController?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Color.Default.Background.NavigationBar
    }
    
    public convenience init(task: (() -> Bool)? = nil, completion: ((Bool) -> Void)? = nil) {
        var bounds =  UIScreen.main.bounds
        bounds.origin.y = bounds.height - 4
        bounds.size.height = 4
        self.init(frame: bounds)
        
        self.task = task
        self.completion = completion
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepare() {
        guard let parent = parentViewController else { return }
        guard let navigationController = parent.navigationController else {
            Log.write(.error, "NTProgressLine needs to be used on a view controller with a navigation controller")
            return
        }
        self.navigationController = navigationController
        
        // Adjust shadow
        setDefaultShadow()
        self.navigationController?.navigationBar.hideShadow()
        
        anchor(parent.view.topAnchor, left: parent.view.leftAnchor, bottom: nil, right: parent.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 4)
        addSubview(progressLine)
        progressLine.frame = CGRect(x: -100, y: 0, width: 100, height: 4)
    }
    
    open func invalidate() {
        guard let parent = parentViewController else { return }
        guard let navigationController = parent.navigationController else {
            Log.write(.error, "NTProgressLine needs to be used on a view controller with a navigation controller")
            return
        }
        state = .canceled
        removeFromSuperview()
        navigationController.navigationBar.setDefaultShadow()
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
                self.completion?(success)
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
            self.completion?(success)
            self.progressDidComplete()
        }
    }
    
    open func progressDidComplete() {
        if state == .completed {
            
            self.navigationController?.navigationBar.setDefaultShadow()
            
            UIView.animate(withDuration: 0.4, animations: {
                self.frame.origin = CGPoint(x: 0, y: self.frame.origin.y - 4)
            }, completion: { (success) in
                if success {
                    self.removeFromSuperview()
                }
            })
        } else {
            Log.write(.warning, "NTActivityIndicator has not completed")
        }
    }
}
