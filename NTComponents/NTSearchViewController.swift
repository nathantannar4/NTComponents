//
//  NTSearchViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 1/29/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTSearchViewController: NTTableViewController, UISearchBarDelegate {
    
    public var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = Color.Default.Tint.View
        searchBar.placeholder = "Search"
        searchBar.showsScopeBar = true
        return searchBar
    }()
    
    // MARK: - Standard Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        navigationItem.titleView = self.searchBar
        updateResults()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }
    
    // MARK: NTSearchViewController Methods
    
    open func updateResults() {
        Log.write(.warning, "You have not overridden the search results handler")
    }
    
    // MARK: - UISearchBar Delegate
    
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateResults()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBarCancelled()
    }
    
    open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    open func searchBarCancelled() {
        searchBar.text = String()
        searchBar.resignFirstResponder()
        updateResults()
    }
}

