//
//  NTCollectionViewController.swift
//  Engage
//
//  Created by Nathan Tannar on 2/22/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

class NTCollectionViewController: DatasourceController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = self.getRefreshControl()
        }
        collectionView?.backgroundColor = Color.Defaults.viewControllerBackground
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
}
