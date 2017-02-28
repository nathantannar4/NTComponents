//
//  ViewController.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 2/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class LoginViewController: NTLoginViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginOptions = [.facebook, .twitter, .email, .google]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

