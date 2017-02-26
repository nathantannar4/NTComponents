//
//  NTTextView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public class NTTextView: UITextView {
    
    public convenience init() {
        self.init(frame: .zero)
        
        font = Font.Defaults.content
        backgroundColor = .clear
        isScrollEnabled = false
    }
}

