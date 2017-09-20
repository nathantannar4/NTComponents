//
//  NewNTTableViewController.swift
//  NTComponents
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 2/12/17.
//

public protocol NTTableViewImageDataSource: NSObjectProtocol {
    func imageForStretchyView(in tableView: NTTableView) -> UIImage?
}

open class NTTableViewController: NTViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    // Public Variables
    public var tableView: NTTableView = {
        let tableView = NTTableView()
        return tableView
    }()
    public var stretchyView = UIView()
    public var stretchyHeaderHeight: CGFloat = 0 {
        didSet {
            tableView.contentInset.top = stretchyHeaderHeight
            tableView.contentOffset = CGPoint(x: 0, y: -stretchyHeaderHeight)
            stretchyView.removeAllConstraints()
            stretchyView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: stretchyHeaderHeight)
            stretchyImageView.removeAllConstraints()
            stretchyImageView.fillSuperview()
        }
    }
    public var stretchyImageView: NTImageView = {
        let imageView = NTImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate var defaultTopContentOffset: CGFloat = 0
    
    // MARK: - Standard Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.Default.Background.ViewController
        setupStretchyImageView()
        setupTableView()
    }
    
    open func setupStretchyImageView() {
        stretchyView.addSubview(stretchyImageView)
        view.addSubview(stretchyView)
        stretchyView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: stretchyHeaderHeight)
        stretchyImageView.fillSuperview()
    }
    
    open func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStretchyViewImage()
    }
    
    // MARK: - NTTableViewImageDataSource
    
    public func updateStretchyViewImage() {
        guard let image = tableView.imageDataSource?.imageForStretchyView(in: tableView) else {
            tableView.contentInset.top = defaultTopContentOffset
            tableView.contentOffset = CGPoint(x: 0, y: -defaultTopContentOffset)
            return
        }
        
        if stretchyHeaderHeight == 0 {
            stretchyHeaderHeight = 150 // Default
        }
        
        if navigationController?.navigationBar.alpha != nil {
            if navigationController!.navigationBar.alpha <= CGFloat(0.5) {
                UIApplication.shared.statusBarStyle = .lightContent
            }
        }
        
//        tableView.contentInset.top = stretchyHeaderHeight + defaultTopContentOffset
//        tableView.contentOffset = CGPoint(x: 0, y: -stretchyHeaderHeight) 
        
        
        stretchyImageView.image = image
        stretchyView.clipsToBounds = true
    }
    
    public func addTopGradientToStretchyImage() {
        let frame = CGRect(x: stretchyImageView.frame.origin.x, y: stretchyImageView.frame.origin.x, width: view.frame.width * 2, height: stretchyHeaderHeight)
        
        stretchyImageView.layer.sublayers?.removeAll()
        
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        topGradient.locations = [0.0, 0.3]
        stretchyImageView.layer.insertSublayer(topGradient, at: 0)
    }
    
    public func addBottomGradientToStretchyImage() {
        let frame = CGRect(x: stretchyImageView.frame.origin.x, y: stretchyImageView.frame.origin.x, width: view.frame.width * 2, height: stretchyHeaderHeight)
        
        stretchyImageView.layer.sublayers?.removeAll()
        
        let bottomGradient: CAGradientLayer = CAGradientLayer()
        bottomGradient.frame = frame
        bottomGradient.colors = [UIColor.clear.cgColor, view.backgroundColor?.withAlphaComponent(0.5).cgColor ?? UIColor.groupTableViewBackground.withAlphaComponent(0.5).cgColor, view.backgroundColor?.cgColor ?? UIColor.groupTableViewBackground.cgColor]
        bottomGradient.locations = [0.6, 0.8, 1.0]
        stretchyImageView.layer.insertSublayer(bottomGradient, at: 0)
    }
    
    public func updateNavigationBar() {
        
        if parent is NTScrollableTabBarController {
            return
        }
        /*
        navigationController?.navigationBar.isTranslucent = fadeInNavBarOnScroll
        
        let offset = tableView.contentOffset.y + tableView.contentInset.top
        let ratio = offset / (tableView.contentInset.top + stretchyHeaderHeight + 200 + defaultTopContentOffset)
      
        if offset < 0 {
            if fadeInNavBarOnScroll {
                navigationController?.navigationBar.backgroundColor = UIColor.clear
                navigationController?.navigationBar.tintColor = UIColor.white
                navigationController?.navigationBar.layer.shadowOpacity = 0
                refreshTitleView(withAlpha: 0)
            }
        } else {
            if fadeInNavBarOnScroll {
                navigationController?.navigationBar.backgroundColor = Color.Default.Background.NavigationBar.withAlphaComponent(ratio)
                navigationController?.navigationBar.layer.shadowOpacity = Float(ratio) * 0.3
                refreshTitleView(withAlpha: ratio)
                if ratio >= 0 && ratio <= 1 {
                    if ratio >= 0.5 {
                        navigationController?.navigationBar.tintColor = Color.Default.Tint.NavigationBar.withAlphaComponent(ratio)
                        UIApplication.shared.statusBarStyle = .default
                    } else {
                        navigationController?.navigationBar.tintColor = UIColor(red: 1.0 - ratio, green: 1.0 - ratio, blue: 1.0 - ratio, alpha: 1.0)
                        UIApplication.shared.statusBarStyle = .lightContent
                    }
                } else {
                    navigationController?.navigationBar.backgroundColor = Color.Default.Background.NavigationBar
                    navigationController?.navigationBar.tintColor =  Color.Default.Tint.NavigationBar
                    navigationController?.navigationBar.layer.shadowOpacity = 0.3
                    refreshTitleView(withAlpha: 1)
                }
                if offset >= 10 {
                    // Accounts for bounce after offset being less than 0
                    UIApplication.shared.statusBarStyle = ratio >= 0.5 ? .default : .lightContent
                }
            } else {
                navigationController?.navigationBar.backgroundColor = Color.Default.Background.NavigationBar
                navigationController?.navigationBar.tintColor = Color.Default.Tint.NavigationBar
                navigationController?.navigationBar.layer.shadowOpacity = 0.3
                refreshTitleView(withAlpha: 1)
            }
        }
        */
    }
    
    open func reloadData() {
        tableView.reloadData()
        updateStretchyViewImage()
    }

    
    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Stops headerView from jittering on pull to refresh
        if #available(iOS 10.0, *) {
            let isRefreshing = tableView.refreshControl?.isRefreshing
            if isRefreshing == true {
                return
            }
        } else {
            if let refreshControl = tableView.backgroundView as? UIRefreshControl {
                if refreshControl.isRefreshing {
                    return
                }
            }
        }
        
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / stretchyView.bounds.height
            let headerSizevariation = ((stretchyView.bounds.height * (1.0 + headerScaleFactor)) - stretchyView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            stretchyView.layer.transform = headerTransform
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-stretchyHeaderHeight, -offset), 0)
        }
        
        updateNavigationBar()
        
        // Apply Transformation
        stretchyView.layer.transform = headerTransform
    }
    
    // MARK: - UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NTTableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NTTableViewHeaderFooterView()
        guard let title = self.tableView(tableView, titleForHeaderInSection: section) else {
            return nil
        }
        view.textLabel.text = title
        return view
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = NTTableViewHeaderFooterView()
        guard let title = self.tableView(tableView, titleForFooterInSection: section) else {
            return nil
        }
        view.textLabel.text = title
        return view
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, viewForHeaderInSection: section) == nil {
            return 0
        }
        return 24
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.tableView(tableView, viewForFooterInSection: section) == nil {
            return 0
        }
        return 24
    }
    
    // MAKR: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.write(.status, "Selected row at index path \(indexPath)")
    }
    
    // MARK: - Refresh Methods
    
    open func refreshControl() -> UIRefreshControl? {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            return rc
        }
        return nil
    }
    
    @objc open func handleRefresh() {
        
    }
}
