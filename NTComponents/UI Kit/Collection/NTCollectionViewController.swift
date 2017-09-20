//
//  NTCollectionViewController.swift
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
//  Created by Nathan Tannar on 5/17/17.
//

import UIKit

open class NTCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    open let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .black
        return aiv
    }()
    
    open var layout: UICollectionViewFlowLayout? {
        get {
            return collectionViewLayout as? UICollectionViewFlowLayout
        }
    }
    
    let defaultCellId = "defaultCellId"
    let defaultFooterId = "defaultFooterId"
    let defaultHeaderId = "defaultHeaderId"
    
    // MARK: - Initialization
    
    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.Default.Background.ViewController
        collectionView?.backgroundColor = .clear
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(NTCollectionViewDefaultCell.self, forCellWithReuseIdentifier: defaultCellId)
        collectionView?.register(NTCollectionViewDefaultHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: defaultHeaderId)
        collectionView?.register(NTCollectionViewDefaultFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: defaultFooterId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterXToSuperview()
        activityIndicatorView.anchorCenterYToSuperview()
    }
    
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
        view.setNeedsDisplay()
    }
    
    // MARK: - UICollectionViewDataSource
    
    open var datasource: NTCollectionDatasource? {
        didSet {
            if let cellClasses = datasource?.cellClasses() {
                for cellClass in cellClasses {
                    collectionView?.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(cellClass))
                }
            }
            
            if let headerClasses = datasource?.headerClasses() {
                for headerClass in headerClasses {
                    collectionView?.register(headerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(headerClass))
                }
            }
            
            if let footerClasses = datasource?.footerClasses() {
                for footerClass in footerClasses {
                    collectionView?.register(footerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: NSStringFromClass(footerClass))
                }
            }
            
            collectionView?.reloadData()
        }
    }
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.numberOfSections() ?? 0
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfItems(section) ?? 0
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: NTCollectionViewCell
        
        if let cls = datasource?.cellClass(indexPath) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! NTCollectionViewCell
        } else if let cellClasses = datasource?.cellClasses(), cellClasses.count > indexPath.section {
            let cls = cellClasses[indexPath.section]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! NTCollectionViewCell
        } else if let cls = datasource?.cellClasses().first {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! NTCollectionViewCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellId, for: indexPath) as! NTCollectionViewCell
        }
        
        cell.controller = self
        cell.datasourceItem = datasource?.item(indexPath)
        return cell
    }
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView: NTCollectionViewCell
        
        if kind == UICollectionElementKindSectionHeader {
            if let classes = datasource?.headerClasses(), classes.count > indexPath.section {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(classes[indexPath.section]), for: indexPath) as! NTCollectionViewCell
            } else if let cls = datasource?.headerClasses()?.first {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! NTCollectionViewCell
            } else {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultHeaderId, for: indexPath) as! NTCollectionViewCell
            }
            reusableView.datasourceItem = datasource?.headerItem(indexPath.section)
            
        } else {
            if let classes = datasource?.footerClasses(), classes.count > indexPath.section {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(classes[indexPath.section]), for: indexPath) as! NTCollectionViewCell
            } else if let cls = datasource?.footerClasses()?.first {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! NTCollectionViewCell
            } else {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultFooterId, for: indexPath) as! NTCollectionViewCell
            }
            reusableView.datasourceItem = datasource?.footerItem(indexPath.section)
        }
        
        reusableView.controller = self
        
        return reusableView
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 44)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 20)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
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
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl?.beginRefreshing()
        }
    }
}
