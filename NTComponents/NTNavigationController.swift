//
//  NTNavigationController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 2/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

public class NTNavigationController: UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = Color.Defaults.navigationBarTint
        navigationBar.barTintColor = Color.Defaults.navigationBarBackground
        navigationBar.shadowImage = UIImage()
        navigationBar.layer.shadowColor = Color.darkGray.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationBar.layer.shadowRadius = 1
        navigationBar.layer.shadowOpacity = 0.3
    }
}
