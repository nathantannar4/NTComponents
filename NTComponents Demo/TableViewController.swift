//
//  TableViewController.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 3/11/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class TableViewController: NTTableViewController, NTTableViewImageDataSource {
    
    var delegate: NTSwipeableTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table View"
        let rc = refreshControl()
        rc?.titleLabel.textColor = .white
        tableView.refreshControl = rc
        tableView.imageDataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NTTableViewCell", for: indexPath) as! NTTableViewCell
        cell.textLabel?.text = String.random(ofLength: 10)
        cell.detailTextLabel?.text = String.random(ofLength: 30)
        return cell
    }
    
    func imageForStretchyView(in tableView: NTTableView) -> UIImage? {
        return #imageLiteral(resourceName: "Background")
    }
    
    
    override func handleRefresh() {
        super.handleRefresh()
        
        DispatchQueue.executeAfter(3) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

