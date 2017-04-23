//
//  NTLabel.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public class NTLabel: UILabel {
    
    public convenience init(style: NTPreferredFontStyle) {
        self.init()
        self.setPreferredFontStyle(to: style)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.2
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

