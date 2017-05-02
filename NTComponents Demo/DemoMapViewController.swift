//
//  DemoMapViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class DemoMapViewController: NTMapViewController {
    
    var objects: [String] = []
    
    override func searchBar(_ searchBar: NTTextField, didUpdateSearchFor query: String) -> Bool {
        
        objects.append(String.random(ofLength: 8))
        tableView.reloadData()
        
        return super.searchBar(searchBar, didUpdateSearchFor: query)
    }
    
    override func searchBarDidEndEditing(_ searchBar: NTTextField) {
        
        objects.removeAll()
        tableView.reloadSections([0], with: .none)
        
        super.searchBarDidEndEditing(searchBar)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NTTableViewCell()
        cell.textLabel?.text = objects[indexPath.row]
        cell.detailTextLabel?.text = "123 45th Avenue, City"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
}
