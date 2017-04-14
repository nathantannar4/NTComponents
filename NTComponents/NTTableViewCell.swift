//
//  NTTableViewCell.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/28/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTTableViewCell: UITableViewCell {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        tintColor = Color.Defaults.tint
        textLabel?.font = Font.Defaults.content
        imageView?.tintColor = Color.Defaults.tint
    }
}
