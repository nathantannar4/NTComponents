//
//  TimelineTableViewController.swift
//  TimelineTableViewCell
//
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//

import UIKit
import NTComponents

class TimelineTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(NTTimelineTableViewCell.self, forCellReuseIdentifier: "NTTimelineTableViewCell")
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day " + String(describing: section + 1)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  NTTimelineTableViewCell()
        cell.isInitial = indexPath.row == 0
        cell.isFinal = indexPath.row + 1 == self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        cell.timeLabel.text = "\(indexPath.row + 8):30"
        cell.titleLabel.text = Lorem.words(nbWords: 3).capitalized
        cell.descriptionTextView.text = Lorem.paragraph()
        cell.thumbnailImageView.image = #imageLiteral(resourceName: "Nathan")
        
//        Becomes available if initialized with NTTimelineTableViewCell(style: .detailed)
//        cell.durationLabel.text = "60 Min"
//        cell.locationLabel.text = Lorem.words(nbWords: 2).capitalized
        
        if indexPath.row == 3 {
            cell.timeline.trailingColor = Color.Default.Tint.View
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 4 {
            cell.timeline.leadingColor = Color.Default.Tint.View
        }
        
        return cell
    }
}
