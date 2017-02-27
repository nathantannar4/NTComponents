//
//  ViewController.swift
//  NTComponents Playground
//
//  Created by Nathan Tannar on 2/26/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class GridCell: DatasourceCell {
    override var datasourceItem: Any? {
        didSet {
            backgroundColor = datasourceItem as? UIColor
        }
    }
}

class GridDatasource: Datasource {
    
    override init() {
        super.init()
        let colors: [UIColor] = [.red, .green, .blue, .orange, .purple, .black, .yellow, .cyan, .brown, .lightGray]
        objects = colors
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [GridCell.self]
    }
    
}

class GridController: DatasourceController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout?.minimumInteritemSpacing = 0
        layout?.minimumLineSpacing = 0
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        datasource = GridDatasource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width/3) - 0
        return CGSize(width: width, height: width)
    }
    
}


