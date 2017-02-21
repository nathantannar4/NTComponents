//
//  NTTableViewCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/28/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTTableViewCell: NTView {
    
    public var horizontalInset: CGFloat! = 0
    public var verticalInset: CGFloat! = 0
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    open func setDefaults() {
        self.horizontalInset = 10
        self.cornersRounded = [.allCorners]
        self.cornerRadius = 5
        self.backgroundColor = UIColor.white
    }
}
