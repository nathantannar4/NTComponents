//
//  NTTableView.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 12/29/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

public class NTTableView: UITableView {
    
    public var cellSeperationHeight: CGFloat = 0
    public var emptyHeaderHeight: CGFloat = 0
    public var emptyFooterHeight: CGFloat = 0
    
    public init() {
        super.init(frame: CGRect.zero, style: .grouped)
        self.setTableDefaults()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setTableDefaults() {
        self.separatorStyle = .none
        self.backgroundColor = UIColor.clear
    }
}

