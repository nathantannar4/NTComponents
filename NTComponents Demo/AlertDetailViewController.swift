//
//  AlertDetailViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 5/31/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class AlertDetailViewController: NTViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = NTButton()
        button.image = Icon.Delete
        button.tintColor = .white
        view.addSubview(button)
        button.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        button.anchorCenterSuperview()
        button.buttonCornerRadius = 50
        button.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    

    func hide() {
        dismiss(animated: true, completion: nil)
    }

}
