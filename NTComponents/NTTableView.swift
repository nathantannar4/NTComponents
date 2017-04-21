//
//  NTTableView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/29/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

public class NTTableView: UITableView {
    
    public var imageDataSource: NTTableViewImageDataSource?
    
    public init() {
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func deselectRow(at indexPath: IndexPath, animated: Bool) {
        super.deselectRow(at: indexPath, animated: true)
    }
}

