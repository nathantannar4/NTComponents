//
//  NTSearchSelectViewController.swift
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
//  Created by Nathan Tannar on 6/19/17.
//

open class NTSearchSelectViewController<T : Equatable>: NTSearchViewController {

    open var allowsMultipleSelection: Bool = true {
        didSet {
            if allowsMultipleSelection {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icon.Check?.scale(to: 25), style: .plain, target: self, action: #selector(confirmSelection(_:)))
                subtitle = "Select One or More"
            } else {
                navigationItem.rightBarButtonItem = nil
                subtitle = "Select One"
            }
        }
    }
    open var activityIndicatorView = NTProgressHUD()
    open var objects = [T]()
    open var showActivityIndicator: Bool = false {
        didSet {
            if showActivityIndicator {
                UIApplication.shared.beginIgnoringInteractionEvents()
                activityIndicatorView.show()
            } else {
                UIApplication.shared.endIgnoringInteractionEvents()
                activityIndicatorView.dismiss()
            }
        }
    }
    fileprivate var selectedObjects = [T]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icon.Delete?.scale(to: 25), style: .plain, target: self, action: #selector(cancelSelection(_:)))
        
        if allowsMultipleSelection {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icon.Check?.scale(to: 25), style: .plain, target: self, action: #selector(confirmSelection(_:)))
            subtitle = "Select One or More"
        }
        
        tableView.tableFooterView = UIView()
        updateResults()
    }
    
    // MARK: - NTSearchSelectViewController Methods
   
    override open func updateResults() {
        
    }
    
    @objc open func confirmSelection(_ sender: AnyObject) {
        self.searchController(confirmedSelectionOfObjects: selectedObjects)
    }
    
    @objc open func cancelSelection(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override final public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NTTableViewCell()
        cell.selectionStyle = .none
        
        if selectedObjects.contains(objects[indexPath.row]) {
            // Object isSelected
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowsMultipleSelection {
            if let index = selectedObjects.index(of: objects[indexPath.row]) {
                // Object isSelected -> Should deselect
                selectedObjects.remove(at: index)
                searchController(didCancelSelectionOfObject: objects[indexPath.row], atRow: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                // Object should be selected
                selectedObjects.append(objects[indexPath.row])
                searchController(didMakeSelectionOfObject: objects[indexPath.row], atRow: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        } else {
            searchController(confirmedSelectionOfObjects: [objects[indexPath.row]])
        }
    }
    
    // MARK: - NTSearchSelectViewController Methods
    
    open func searchController(didMakeSelectionOfObject object: T, atRow row: Int) {
        
    }
    
    open func searchController(confirmedSelectionOfObjects objects: [T]) {
        
    }
    
    open func searchController(didCancelSelectionOfObject: T, atRow row: Int) {
        
    }
}
