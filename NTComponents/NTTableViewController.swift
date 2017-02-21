//
//  NewNTTableViewController.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 12/29/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTTableViewController: NTViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    // Public Variables
    public var tableView: NTTableView = NTTableView()
    public var dataSource: NTTableViewDataSource?
    public var delegate: NTTableViewDelegate?
    
    public var stretchyView: UIView = UIView()
    public var stretchyHeaderHeight: CGFloat = 350.0
    public var stretchyImageView: UIImageView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadData()
        if self.navigationController?.navigationBar.backgroundColor != Color.defaultNavbarBackground && self.fadeInNavBarOnScroll {
            //self.tableView.contentOffset = CGPoint(x: 0, y: 0 - self.tableView.contentInset.top)
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.updateNavigationBar()
        self.reloadData()
    }
    
    // MARK: Preperation
    
    private func prepareView() {
        self.view.backgroundColor = self.parent?.view.backgroundColor ?? UIColor.groupTableViewBackground
        
        self.stretchyImageView = UIImageView()
        self.stretchyImageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.stretchyView.addSubview(self.stretchyImageView)
        self.view.addSubview(self.stretchyView)
        self.stretchyView.bindFrameToSuperviewTopBounds(withHeight: self.stretchyHeaderHeight)
        self.stretchyImageView.bindFrameToSuperviewTopBounds(withHeight: self.stretchyHeaderHeight)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.bindFrameToSuperviewBounds()
        self.reloadData()
    }
    
    public func updateStretchyViewImage() {
        let image = self.dataSource?.imageForStretchyView?(in: self.tableView)
        if image != nil {
            if self.navigationController?.navigationBar.alpha != nil {
                if self.fadeInNavBarOnScroll && self.navigationController!.navigationBar.alpha <= CGFloat(0.5) {
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            }
            
            self.stretchyView.removeAllConstraints()
            self.stretchyView.bindFrameToSuperviewTopBounds(withHeight: self.stretchyHeaderHeight)
            self.stretchyImageView.removeAllConstraints()
            self.stretchyImageView.bindFrameToSuperviewTopBounds(withHeight: self.stretchyHeaderHeight)
            
            self.stretchyImageView.image = image
            self.addGradients()
        }
        
        self.stretchyView.clipsToBounds = true
    }
    
    private func addGradients() {
        let frame = CGRect(x: self.stretchyImageView.frame.origin.x, y: self.stretchyImageView.frame.origin.x, width: self.view.frame.width * 2, height: self.stretchyHeaderHeight)
        
        self.stretchyImageView.layer.sublayers?.removeAll()
        
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        topGradient.locations = [0.0, 0.3]
        self.stretchyImageView.layer.insertSublayer(topGradient, at: 0)
        
        
        let bottomGradient: CAGradientLayer = CAGradientLayer()
        bottomGradient.frame = frame
        bottomGradient.colors = [UIColor.clear.cgColor, self.view.backgroundColor?.withAlphaComponent(0.5).cgColor ?? UIColor.groupTableViewBackground.withAlphaComponent(0.5).cgColor, self.view.backgroundColor?.cgColor ?? UIColor.groupTableViewBackground.cgColor]
        bottomGradient.locations = [0.6, 0.8, 1.0]
        self.stretchyImageView.layer.insertSublayer(bottomGradient, at: 0)
    }
    
    public func updateNavigationBar() {
        
        self.navigationController?.navigationBar.isTranslucent = self.fadeInNavBarOnScroll
        
        let offset = self.tableView.contentOffset.y + self.tableView.contentInset.top
        let ratio = offset / (self.tableView(self.tableView, heightForRowAt: IndexPath(row: 0, section: 0)) / 2 + self.tableView.contentInset.top - (self.navigationController?.navigationBar.frame.height ?? 0))
      
        if offset < 0 {
            if self.fadeInNavBarOnScroll {
                self.navigationController?.navigationBar.backgroundColor = UIColor.clear
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.layer.shadowOpacity = 0
                self.setStatusBarBackgroundColor()
                self.refreshTitleView(withAlpha: 0)
            }
        } else {
            if self.fadeInNavBarOnScroll {
                self.navigationController?.navigationBar.backgroundColor = Color.defaultNavbarBackground.withAlphaComponent(ratio)
                self.setStatusBarBackgroundColor()
                self.navigationController?.navigationBar.layer.shadowOpacity = Float(ratio) * 0.3
                self.refreshTitleView(withAlpha: ratio)
                if ratio >= 0 && ratio <= 1 {
                    if ratio >= 0.5 {
                        self.navigationController?.navigationBar.tintColor = Color.defaultNavbarTint.withAlphaComponent(ratio)
                        UIApplication.shared.statusBarStyle = .default
                    } else {
                        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 1.0 - ratio, green: 1.0 - ratio, blue: 1.0 - ratio, alpha: 1.0)
                        UIApplication.shared.statusBarStyle = .lightContent
                    }
                } else {
                    self.navigationController?.navigationBar.backgroundColor = Color.defaultNavbarBackground
                    self.setStatusBarBackgroundColor()
                    self.navigationController?.navigationBar.tintColor = Color.defaultNavbarTint
                    self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
                    self.refreshTitleView(withAlpha: 1)
                }
                if offset >= 10 {
                    // Accounts for bounce after offset being less than 0
                    UIApplication.shared.statusBarStyle = ratio >= 0.5 ? .default : .lightContent
                }
            } else {
                self.navigationController?.navigationBar.backgroundColor = Color.defaultNavbarBackground
                self.setStatusBarBackgroundColor()
                self.navigationController?.navigationBar.tintColor = Color.defaultNavbarTint
                self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
                self.refreshTitleView(withAlpha: 1)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        guard let height = self.dataSource?.tableView?(self.tableView, heightForRowAt: indexPath) else {
            guard let cell = self.dataSource?.tableView(self.tableView, cellForRowAt: indexPath) else {
                return UITableViewAutomaticDimension
            }
            let height = cell.bounds.height + self.tableView.cellSeperationHeight
            if cell.verticalInset < 0 {
                return height - ( 2 * cell.verticalInset)
            }
            return height
        }
        return height + self.tableView.cellSeperationHeight
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.dataSource?.numberOfSections(in: self.tableView) else {
            return 0
        }
        return sections
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = self.dataSource?.tableView(self.tableView, rowsInSection: section) else {
            return 0
        }
        return rows
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellView = self.dataSource?.tableView(self.tableView, cellForRowAt: indexPath) else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        if self.tableView.frame.width > self.tableView.frame.height {
            // Landscape
            cellView.bounds = CGRect(x: 0, y: 0, width: (self.tableView.frame.width - (cellView.horizontalInset * 2)) * 2 / 3, height: cellView.bounds.height - (cellView.verticalInset * 2))
        } else {
            // Portait
            cellView.bounds = CGRect(x: 0, y: 0, width: self.tableView.frame.width - (cellView.horizontalInset * 2), height: cellView.bounds.height - (cellView.verticalInset * 2))
        }
        if cellView.cornersRounded == .allCorners {
            cellView.layer.cornerRadius = cellView.cornerRadius
        } else {
            cellView.round(corners: cellView.cornersRounded, radius: cellView.cornerRadius)
        }
        cellView.center = CGPoint(x: self.tableView.frame.width / 2, y: cellView.bounds.height / 2)
        cell.addSubview(cellView)
        return cell
    }
    
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cellView = self.dataSource?.tableView?(self.tableView, cellForHeaderInSection: section) else {
            return nil
        }
        if self.tableView.frame.width > self.tableView.frame.height {
            // Landscape
            cellView.bounds = CGRect(x: 0, y: 0, width: self.tableView.frame.width * 2 / 3, height: cellView.bounds.height)
        } else {
            // Portait
            cellView.bounds = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: cellView.bounds.height)
        }
        cellView.center = CGPoint(x: self.tableView.frame.width / 2, y: cellView.bounds.height / 2)
        let headerView = UITableViewCell()
        headerView.addSubview(cellView)
        return headerView
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cellView = self.dataSource?.tableView?(self.tableView, cellForFooterInSection: section) else {
            return nil
        }
        if self.tableView.frame.width > self.tableView.frame.height {
            // Landscape
            cellView.bounds = CGRect(x: 0, y: 0, width: self.tableView.frame.width * 2 / 3, height: cellView.bounds.height)
        } else {
            // Portait
            cellView.bounds = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: cellView.bounds.height)
        }
        cellView.center = CGPoint(x: self.tableView.frame.width / 2, y: cellView.bounds.height / 2)
        let footerView = UITableViewCell()
        footerView.addSubview(cellView)
        return footerView
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerCell = self.dataSource?.tableView?(self.tableView, cellForHeaderInSection: section) else {
            return CGFloat.leastNonzeroMagnitude
        }
        guard let textLabel = headerCell.titleLabel else {
            return self.tableView.emptyHeaderHeight
        }
        return textLabel.text!.isEmpty ? self.tableView.emptyHeaderHeight : 40
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerCell = self.dataSource?.tableView?(self.tableView, cellForFooterInSection: section) else {
            return CGFloat.leastNonzeroMagnitude
        }
        guard let textLabel = footerCell.titleLabel else {
            return self.tableView.emptyFooterHeight
        }
        return textLabel.text!.isEmpty ? self.tableView.emptyFooterHeight : 30
    }
 
    open func reloadData() {
        self.tableView.reloadData()
        self.updateStretchyViewImage()
    }
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    
        self.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Stops headerView from jittering on pull to refresh
        if #available(iOS 10.0, *) {
            let isRefreshing = self.tableView.refreshControl?.isRefreshing
            if isRefreshing == true {
                return
            }
        } else {
            if let refreshControl = self.tableView.backgroundView as? UIRefreshControl {
                if refreshControl.isRefreshing {
                    return
                }
            }
        }
        
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / self.stretchyView.bounds.height
            let headerSizevariation = ((self.stretchyView.bounds.height * (1.0 + headerScaleFactor)) - self.stretchyView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            self.stretchyView.layer.transform = headerTransform
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-self.stretchyHeaderHeight, -offset), 0)
        }
        
        self.updateNavigationBar()
        
        // Apply Transformation
        self.stretchyView.layer.transform = headerTransform
    }
}
