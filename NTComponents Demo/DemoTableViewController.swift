//
//  DemoTableViewController.swift
//  NTComponents Demo
//
//  Created by Nathan Tannar on 3/11/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTComponents

class DemoTableViewController: NTTableViewController, NTTableViewImageDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table View"
        tableView.delegate = self
        tableView.imageDataSource = self
        stretchyHeaderHeight = 250
        addTopGradientToStretchyImage()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        
//        cell.imageView?.image = UIImage(named: "Nathan")?.scale(to: 70)
        
        return cell
    }

    func imageForStretchyView(in tableView: NTTableView) -> UIImage? {
        return UIImage(named: "Background")
    }
}

