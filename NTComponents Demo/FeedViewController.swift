//
//  FeedViewController.swift
//  Engage
//
//  Created by Nathan Tannar on 5/19/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class FeedViewController: NTCollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = FeedDatasource()
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 20)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }

}

class FeedCell: NTCollectionViewCell {
    
    
    var imageView: NTImageView = {
        let imageView = NTImageView()
        imageView.image = #imageLiteral(resourceName: "Nathan")
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = Color.Default.Background.NavigationBar.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var label: NTLabel = {
        let label = NTLabel(style: .headline)
        label.text = String.random(ofLength: 16)
        return label
    }()
    
    var body: NTTextView = {
        let textView = NTTextView()
        textView.isEditable = false
        textView.text = String.random(ofLength: 200)
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        separatorLineView.isHidden = false
        
        addSubview(imageView)
        addSubview(label)
        addSubview(body)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        imageView.anchorAspectRatio()
        
        label.anchor(imageView.topAnchor, left: imageView.rightAnchor, bottom: imageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        body.anchor(label.bottomAnchor, left: imageView.leftAnchor, bottom: bottomAnchor, right: label.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

class FeedDatasource: NTCollectionDatasource {
    
    open override func item(_ indexPath: IndexPath) -> Any? {
        return nil
    }
    
    open override func numberOfItems(_ section: Int) -> Int {
        return 5
    }
    
    open override func numberOfSections() -> Int {
        return 2
    }
    
    open override func footerClasses() -> [NTCollectionViewCell.Type]? {
        return nil
    }
    
    open override func headerClasses() -> [NTCollectionViewCell.Type]? {
        return nil
    }
    
    open override func cellClasses() -> [NTCollectionViewCell.Type] {
        return [FeedCell.self, FeedCell.self]
    }
}
