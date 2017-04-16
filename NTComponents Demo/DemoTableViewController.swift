//
//  DemoTableViewController.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 3/11/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class DemoTableViewController: NTTableViewController, NTTableViewDataSource, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.imageDataSource = self
        stretchyHeaderHeight = 250
        addTopGradientToStretchyImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        return UIImage(named: "Background")
    }
}

