//
//  NTActionSheetViewController.swift
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

import UIKit

open class NTActionSheetItem: NSObject {

    open var icon: UIImage?
    open var iconTint: UIColor?
    open var title: String?
    open var backgroundColor: UIColor
    open var action: (() -> Void)?

    public required init(title: String?, icon: UIImage?, iconTint: UIColor?, backgroundColor: UIColor = Color.Default.Background.ViewController, action: (() -> Void)?) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.action = action
        self.iconTint = iconTint
    }

    public convenience init(title: String?, icon: UIImage?, action: (() -> Void)?) {
        self.init(title: title, icon: icon, iconTint: Color.Default.Tint.View, backgroundColor: .white, action: action)
    }
}

open class NTActionSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate  {
    
    open override var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            super.title = newValue
        }
    }
    open var subtitle: String? {
        get {
            return subtitleLabel.text
        }
        set {
            subtitleLabel.text = newValue
        }
    }
    
    fileprivate var actions: [NTActionSheetItem] = []
    
    open var titleLabel: NTLabel = {
        let label = NTLabel(style: .callout)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    open var subtitleLabel: NTLabel = {
        let label = NTLabel(style: .caption)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    open var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.clipsToBounds = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    fileprivate var topAnchor: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    public required init(title: String? = nil, subtitle: String? = nil, actions: [NTActionSheetItem] = []) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        self.actions = actions
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    // MARK: - Standard Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    open func setup() {
        view.addSubview(tableView)
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        topAnchor = tableView.anchorWithReturnAnchors(view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIScreen.main.bounds.maxY)[0]
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(dismissActionSheet))
        tapAction.delegate = self
        view.addGestureRecognizer(tapAction)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentActionSheet()
    }
    
    open override func show(_ vc: UIViewController? = UIApplication.presentedController, sender: Any? = nil) {
        guard let viewController = vc else { return }
        viewController.present(self, animated: false, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: view)
        
        if tableView.frame.contains(point) {
            return false
        }
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    public final func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        height += (title != nil) ? 25 : 0
        height += (subtitle != nil) ? 15 : 0
        return height
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if title == nil && subtitle == nil {
            return nil
        }
        
        let header = UIView()
        
        if title != nil {
            header.addSubview(titleLabel)
            titleLabel.anchor(header.topAnchor, left: header.leftAnchor, bottom: nil, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
            titleLabel.round(corners: [.topLeft, .topRight], radius: 16)
        }
        if subtitle != nil {
            header.addSubview(subtitleLabel)
            subtitleLabel.anchor(nil, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
            if title == nil {
                subtitleLabel.round(corners: [.topLeft, .topRight], radius: 16)
            }
        }
        
        let separatorView = UIView()
        separatorView.backgroundColor = Color.Gray.P500
        header.addSubview(separatorView)
        separatorView.anchor(nil, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .white
        return footer
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NTTableViewCell()
        cell.backgroundColor = actions[indexPath.row].backgroundColor
        cell.textLabel?.text = actions[indexPath.row].title
        cell.textLabel?.textAlignment = actions[indexPath.row].icon != nil ? .left : .center
        cell.imageView?.image = actions[indexPath.row].icon?.scale(to: 44)
        cell.imageView?.tintColor = actions[indexPath.row].iconTint
        cell.imageView?.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        
        let separatorView = UIView()
        separatorView.backgroundColor = Color.Gray.P500
        cell.addSubview(separatorView)
        separatorView.anchor(nil, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        return cell
    }
   
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
            self.actions[indexPath.row].action?()
        }
    }
    
    // MARK: - NTActionSheetAction Methods
    
    @objc open func dismissActionSheet() {
        dismiss()
    }
    
    open func presentActionSheet() {
        
        let height = CGFloat(actions.count * 44) + 35
        
        tableView.reloadData()
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.view.backgroundColor = Color.Gray.P900.withAlphaComponent(0.2)
            self.topAnchor?.constant = -height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    public func insertAction(_ action: NTActionSheetItem, atIndex index: Int) {
        actions.insert(action, at: index)
        
        let height = CGFloat(actions.count * 44) + 35
        
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.topAnchor?.constant = -height
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
        })
    }
    
    open func addDismissAction() {
        let dismissAction = NTActionSheetItem(title: "Dismiss", icon: nil, iconTint: Color.Gray.P800, backgroundColor: Color.Default.Background.ViewController, action: nil)
        actions.append(dismissAction)
    }
    
    open func addDismissAction(withText text: String = "Dismiss", icon: UIImage?, iconTint: UIColor, backgroundColor: UIColor) {
        let dismissAction = NTActionSheetItem(title: text, icon: icon, iconTint: iconTint, backgroundColor: backgroundColor, action: nil)
        actions.append(dismissAction)
    }

    open override func dismiss(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        if flag {
            view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.topAnchor?.constant = 0
                self.view.layoutIfNeeded()
                self.view.backgroundColor = .clear
            }) { (success) in
                if success {
                    super.dismiss(animated: false, completion: completion)
                }
            }
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
}
