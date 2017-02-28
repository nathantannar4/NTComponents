//
//  ViewController.swift
//  Engage
//
//  Created by Nathan Tannar on 1/9/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class LoginViewController: NTLoginViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginOptions = [.facebook, .twitter, .email, .google]
        self.tableView.reloadData()
    }
}
