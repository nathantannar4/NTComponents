//
//  NTLabel.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public enum NTLabelType {
    case title, subtitle, content
}

public class NTLabel: UILabel {
    
    public convenience init(type: NTLabelType) {
        self.init()
        switch type {
        case .title:
            textColor = Color.Defaults.titleTextColor
            font = Font.Defaults.title
        case .subtitle:
            textColor = Color.Defaults.subtitleTextColor
            font = Font.Defaults.subtitle
        case .content:
            font = Font.Defaults.content
        }
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

