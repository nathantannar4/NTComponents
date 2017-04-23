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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = Color.Default.Tint.View
        backgroundColor = .white
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
