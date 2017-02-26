//
//  NTButton.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public class NTButton: UIButton {
    
    public convenience init() {
        self.init(frame: .zero)
        
        layer.borderColor = Color.Defaults.buttonTint.cgColor
        tintColor = Color.Defaults.buttonTint
        titleLabel?.font = Font.Defaults.content
        setTitleColor(Color.Defaults.buttonTint, for: .normal)
        imageView?.contentMode = .scaleAspectFit
    }
}
