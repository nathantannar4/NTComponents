//
//  NTSearchViewController.swift
//  NTUIKit
//
//  Created by Nathan Tannar on 1/29/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTSearchViewController: NTTableViewController, UISearchBarDelegate {
    
    public lazy var searchBar = UISearchBar()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateNavigationBar()
        self.searchBar.delegate = self
        self.searchBar.tintColor = Color.defaultNavbarTint
        self.searchBar.placeholder = "Search Users"
        self.searchBar.autocapitalizationType = .words
        self.searchBar.showsCancelButton = false
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(), style: .plain, target: nil, action: nil),UIBarButtonItem(image: UIImage(), style: .plain, target: nil, action: nil)]
        self.navigationItem.titleView = self.searchBar
        self.updateResults()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }
    
    // MARK: User Actions
    
    open func updateResults() {
        Log.write(.warning, "You have not overridden the search results handler")
    }
    
    // MARK: - UISearchBar Delegate
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateResults()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(searchBarTextDidEndEditing))
        cancelButton.tintColor = Color.defaultNavbarTint
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    public func searchBarTextDidEndEditing() {
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(), style: .plain, target: nil, action: nil),UIBarButtonItem(image: UIImage(), style: .plain, target: nil, action: nil)]
        if !self.searchBar.text!.isEmpty {
            self.searchBarCancelled()
        } else {
            self.searchBar.resignFirstResponder()
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    public func searchBarCancelled() {
        self.searchBar.text = String()
        self.searchBar.resignFirstResponder()
        self.updateResults()
    }
}

