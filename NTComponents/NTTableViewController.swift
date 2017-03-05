//
//  NewNTTableViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 12/29/16.
//  Copyright © 2016 Nathan Tannar. All rights reserved.
//

public protocol NTTableViewDataSource: NSObjectProtocol {
     func imageForStretchyView(in tableView: NTTableView) -> UIImage?
}

open class NTTableViewController: NTViewController, UITableViewDelegate, UIScrollViewDelegate {
    
    // Public Variables
    public var tableView: NTTableView = NTTableView()
    public var dataSource: NTTableViewDataSource?
    
    public var stretchyView: UIView = UIView()
    public var stretchyHeaderHeight: CGFloat = 350.0
    public var stretchyImageView: UIImageView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
    }
    
    // MARK: Preperation
    
    private func prepareView() {
        self.view.backgroundColor = self.parent?.view.backgroundColor ?? UIColor.groupTableViewBackground
        
        self.stretchyImageView = UIImageView()
        self.stretchyImageView?.contentMode = .scaleAspectFill
        self.stretchyView.addSubview(self.stretchyImageView)
        self.view.addSubview(self.stretchyView)
        self.stretchyView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.stretchyHeaderHeight)
        self.stretchyImageView.fillSuperview()
        
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        self.tableView.fillSuperview()
        self.reloadData()
    }
    
    public func updateStretchyViewImage() {
        let image = self.dataSource?.imageForStretchyView(in: self.tableView)
        if image != nil {
            if self.navigationController?.navigationBar.alpha != nil {
                if self.fadeInNavBarOnScroll && self.navigationController!.navigationBar.alpha <= CGFloat(0.5) {
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            }
            /*
            self.stretchyView.removeAllConstraints()
            self.stretchyView.bindFrameToSuperviewTopBounds(withHeight: self.stretchyHeaderHeight)
            self.stretchyImageView.removeAllConstraints()
            self.stretchyImageView.bindFrameToSuperviewTopBounds(withHeight: self.stretchyHeaderHeight)
            */
            
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
        let ratio = offset / (self.tableView.contentInset.top + self.stretchyHeaderHeight + 200)
      
        if offset < 0 {
            if self.fadeInNavBarOnScroll {
                self.navigationController?.navigationBar.backgroundColor = UIColor.clear
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.layer.shadowOpacity = 0
                self.refreshTitleView(withAlpha: 0)
            }
        } else {
            if self.fadeInNavBarOnScroll {
                self.navigationController?.navigationBar.backgroundColor = Color.Defaults.navigationBarBackground.withAlphaComponent(ratio)
                self.navigationController?.navigationBar.layer.shadowOpacity = Float(ratio) * 0.3
                self.refreshTitleView(withAlpha: ratio)
                if ratio >= 0 && ratio <= 1 {
                    if ratio >= 0.5 {
                        self.navigationController?.navigationBar.tintColor = Color.Defaults.tint.withAlphaComponent(ratio)
                        UIApplication.shared.statusBarStyle = .default
                    } else {
                        self.navigationController?.navigationBar.tintColor = UIColor(red: 1.0 - ratio, green: 1.0 - ratio, blue: 1.0 - ratio, alpha: 1.0)
                        UIApplication.shared.statusBarStyle = .lightContent
                    }
                } else {
                    self.navigationController?.navigationBar.backgroundColor = Color.Defaults.navigationBarBackground
                    self.navigationController?.navigationBar.tintColor = Color.Defaults.tint
                    self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
                    self.refreshTitleView(withAlpha: 1)
                }
                if offset >= 10 {
                    // Accounts for bounce after offset being less than 0
                    UIApplication.shared.statusBarStyle = ratio >= 0.5 ? .default : .lightContent
                }
            } else {
                self.navigationController?.navigationBar.backgroundColor = Color.Defaults.navigationBarBackground
                self.navigationController?.navigationBar.tintColor = Color.Defaults.tint
                self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
                self.refreshTitleView(withAlpha: 1)
            }
        }
    }
    
    open func reloadData() {
        self.tableView.reloadData()
        self.updateStretchyViewImage()
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
