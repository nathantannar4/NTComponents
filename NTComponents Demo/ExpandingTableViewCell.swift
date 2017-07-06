//
//  ExpandingTableViewCell.swift
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
//  Created by Nathan Tannar on 7/4/17.
//

import NTComponents

class SelfExpandingCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    var captionTextLabel: NTLabel = {
        let label = NTLabel(style: .body)
        return label
    }()
    
    var expandedTextLabel: NTLabel = {
        let label = NTLabel(style: .caption)
        return label
    }()
    
    open var toggleButton: NTButton = {
        let button = NTButton()
        button.backgroundColor = .clear
        button.rippleOverBounds = true
        button.trackTouchLocation = false
        button.ripplePercent = 1.1
        button.image = Icon.Arrow.Down
        button.tintColor = Color.Default.Tint.View
        return button
    }()
    
    fileprivate var isExpanded: Bool = false
    fileprivate var expandedHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.isHidden = true
        detailTextLabel?.isHidden = true
        contentView.addSubview(captionTextLabel)
        contentView.addSubview(toggleButton)
        contentView.addSubview(expandedTextLabel)
        captionTextLabel.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: expandedTextLabel.topAnchor, right: toggleButton.leftAnchor, topConstant: 2, leftConstant: 16, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        toggleButton.anchor(contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 20, heightConstant: 20)
        expandedHeightConstraint = expandedTextLabel.anchorWithReturnAnchors(captionTextLabel.bottomAnchor, left: captionTextLabel.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 16, widthConstant: 0, heightConstant: .leastNonzeroMagnitude).last
        
//        toggleButton.addTarget(self, action: #selector(handleToggle(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        
        guard let tableView = superview?.superview as? UITableView, let indexPath = indexPath else {
            return
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        UIView.animate(withDuration: 0.3, animations: {
            if !selected {
                // Close
                self.toggleButton.imageView?.transform = CGAffineTransform.identity
                self.expandedHeightConstraint?.isActive = true
                self.superview?.layoutIfNeeded()
            } else {
                // Open
                self.toggleButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.expandedHeightConstraint?.isActive = false
                self.superview?.layoutIfNeeded()
            }
        }) { success in
            if success {
//                super.setSelected(selected, animated: animated)
            }
        }
    }
}

class ExpandingTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelfExpandingCell()
        cell.indexPath = indexPath
        cell.captionTextLabel.text = Lorem.sentence().capitalized
        cell.expandedTextLabel.text = Lorem.paragraph()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
