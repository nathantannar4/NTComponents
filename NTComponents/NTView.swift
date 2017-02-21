//
//  NTView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/30/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

public enum NTViewState {
    case transitioning, visible, hidden, gone
}

open class NTView: UIView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    open override func awakeFromNib() {
        for subview in self.subviews {
            subview.tintColor = Color.defaultNavbarTint
        }
    }

    public var cornersRounded: UIRectCorner = UIRectCorner()
    public var cornerRadius: CGFloat = 0

}
