//
//  TableViewController.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 3/11/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class TableViewController: NTTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table View"
        tableView.refreshControl = refreshControl()!
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(NTViewController(), animated: true)
    }
    
    
    override func handleRefresh() {
        super.handleRefresh()
        
        DispatchQueue.executeAfter(3) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

