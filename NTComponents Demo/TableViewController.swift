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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table View"
        let rc = refreshControl()
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
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NTTableViewCell", for: indexPath) as! NTTableViewCell
            cell.textLabel?.text = "Begin Form"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NTTableViewCell", for: indexPath) as! NTTableViewCell
            cell.textLabel?.text = "Push ViewController"
            cell.detailTextLabel?.text = String.random(ofLength: 30)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            let vc = FormViewController()
            let navVC = NTNavigationViewController(rootViewController: vc).withTitle("Form")
            present(navVC, animated: true, completion: nil)
        } else {
            let vc = AuthorViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseOut, animations: {
//            //                self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.scrollableTabBarController?.updateTabBarOrigin(hidden: false)
//        }, completion: nil)
//    }
//    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if(velocity.y>0) {
//            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
//            UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseIn, animations: {
////                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                self.scrollableTabBarController?.updateTabBarOrigin(hidden: true)
//            }, completion: nil)
//            
//        } else {
//            UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseOut, animations: {
////                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                self.scrollableTabBarController?.updateTabBarOrigin(hidden: false)
//            }, completion: nil)    
//        }
//    }
    
    func imageForStretchyView(in tableView: NTTableView) -> UIImage? {
        return #imageLiteral(resourceName: "NT Components Banner")
    }
    
    override func handleRefresh() {
        super.handleRefresh()
        
        DispatchQueue.executeAfter(3) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

