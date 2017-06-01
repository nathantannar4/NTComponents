//
//  AuthorViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 5/30/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class AuthorViewController: NTTableViewController, NTTableViewImageDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleView(title: "NTComponents", subtitle: "About")
        stretchyHeaderHeight = 150
        tableView.imageDataSource = self
        tableView.tableFooterView = UIView()
        addTopGradientToStretchyImage()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 78
        }
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NTTableViewCell", for: indexPath) as! NTTableViewCell
        
        let view = UIView()
        view.setDefaultShadow()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Nathan"))
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.fillSuperview()
        cell.addSubview(view)
        view.anchor(nil, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        
        let titleLabel = NTLabel(style: .title)
        titleLabel.text = "Nathan Tannar"
        let subtitleLabel = NTLabel(style: .subtitle)
        subtitleLabel.text = "SFU Computer Engineering Student"
        cell.addSubview(titleLabel)
        cell.addSubview(subtitleLabel)
        titleLabel.anchor(cell.topAnchor, left: view.rightAnchor, bottom: nil, right: cell.rightAnchor, topConstant: 5, leftConstant: 6, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 20)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: view.rightAnchor, bottom: view.bottomAnchor, right: cell.rightAnchor, topConstant: 2, leftConstant: 6, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(NTViewController(), animated: true)
    }
    
    func imageForStretchyView(in tableView: NTTableView) -> UIImage? {
        return UIImage(named: "Background")
    }
}
