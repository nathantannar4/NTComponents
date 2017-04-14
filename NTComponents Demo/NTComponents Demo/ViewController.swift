//
//  ViewController.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 3/11/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class ViewController: NTTableViewController, NTTableViewDataSource, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NTComponents"
        subtitle = "By Nathan Tannar"
        tableView.dataSource = self
        tableView.imageDataSource = self
        stretchyHeaderHeight = 350
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Color.Defaults.tint = Color.Blue.P700
        view.backgroundColor = Color.Blue.P700
        
        let alert = NTActionSheetController()
        let action = NTActionSheetAction(title: "Google", icon: Icon.google) {
            alert.dismiss(animated: true, completion: {
                let popup = NTAlertViewController(title: "Are you sure?", subtitle: "This action cannot be undone")
                popup.makeKeyAndVisible()
            })
        }
        alert.addAction(action)
        alert.addDismissAction()
        alert.makeKeyAndVisible()
        
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

    func imageForStretchyView(in tableView: NTTableView) -> UIImage? {
        return UIImage(named: "banner.jpg")
    }
}

