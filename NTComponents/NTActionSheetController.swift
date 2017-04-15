//
//  NTActionSheetController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/13/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

open class NTActionSheetAction: NSObject {
    
    public var icon: UIImage?
    public var title: String
    public var action: (() -> Void)?
    
    public required init(title: String, icon: UIImage? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
}

open class NTActionSheetController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    fileprivate let actionTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        tableView.bounces = false
        return tableView
    }()
    
    fileprivate var actions: [NTActionSheetAction] = []
    
    // MARK: - Initialization
    
    public required init(actions: [NTActionSheetAction]?) {
        self.init()
        self.actions = actions ?? []
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        actionTable.delegate = self
        actionTable.dataSource = self
        
        view.addSubview(actionTable)
        actionTable.fillSuperview()

        let tapAction = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        actionTable.addGestureRecognizer(tapAction)
    }
    
    public func addAction(_ action: NTActionSheetAction) {
        actions.append(action)
        actionTable.reloadData()
        reverseInsertDirection()
    }
    
    public func addDismissAction(withText text: String = "Dismiss", icon: UIImage? = Icon.icon("Delete_ffffff_100")) {
        let dismissAction = NTActionSheetAction(title: text, icon: icon) { 
            self.dismissSheet()
        }
        actions.append(dismissAction)
        actionTable.reloadData()
        reverseInsertDirection()
    }
    
    func reverseInsertDirection() {
        let numRows = tableView(actionTable, numberOfRowsInSection: 0)
        var contentInsetTop = UIScreen.main.bounds.height
        for i in 0..<numRows {
            contentInsetTop -= tableView(actionTable, heightForRowAt: IndexPath(item: i, section: 0))
        }
        actionTable.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)
    }
    
    public func dismissSheet() {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - UITableViewDatasource
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    final public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count 
    }
    
    final public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NTTableViewCell()
        cell.textLabel?.text = actions[indexPath.row].title
        cell.imageView?.image = actions[indexPath.row].icon?.scale(to: 30)
        cell.backgroundColor = .white
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    final public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actions[indexPath.row].action?()
    }
}
