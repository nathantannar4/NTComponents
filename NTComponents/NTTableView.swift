//
//  NTTableView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/29/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

public class NTTableView: UITableView {
    
    public init() {
        super.init(frame: .zero, style: .grouped)
        self.setTableDefaults()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setTableDefaults() {
        self.backgroundColor = UIColor.clear
    }
}

