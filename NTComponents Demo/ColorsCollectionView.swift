//
//  ColorsCollectionView.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/15/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class ColorsCollectionView: NTCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Colors"
        datasource = ColorDatasource(colors: MaterialColors().all())
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / 3
        
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

class ColorCell: NTCollectionViewCell {
    
    override var reuseIdentifier: String? {
        get {
            return "ColorCell"
        }
    }
    
    override var datasourceItem: Any? {
        didSet {
            guard let color = datasourceItem as? UIColor else { return }
            backgroundColor = color
        }
    }
}

class ColorDatasource: NTCollectionDatasource {
    
    var colors: [UIColor]!
    
    convenience init(colors: [UIColor]) {
        self.init()
        self.colors = colors
    }
    
    override func footerClasses() -> [NTCollectionViewCell.Type]? {
        return nil
    }
    
    override func headerClasses() -> [NTCollectionViewCell.Type]? {
        return nil
    }
    
    override func cellClasses() -> [NTCollectionViewCell.Type] {
        return [ColorCell.self]
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return colors[indexPath.item]
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return colors.count
    }
}
