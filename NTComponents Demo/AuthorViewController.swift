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
        
        view.backgroundColor = Color.Default.Tint.View
        setTitleView(title: "NTComponents", subtitle: "About")
        stretchyHeaderHeight = 150
        tableView.imageDataSource = self
        tableView.tableFooterView = UIView()
        addTopGradientToStretchyImage()
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
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.fillSuperview()
        cell.addSubview(view)
        view.anchor(nil, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: 54, heightConstant: 54)
        
        let titleLabel = NTLabel(style: .headline)
        titleLabel.text = "Nathan Tannar"
        let subtitleLabel = NTLabel(style: .subhead)
        subtitleLabel.text = "SFU Computer Engineering Student"
        cell.addSubview(titleLabel)
        cell.addSubview(subtitleLabel)
        titleLabel.anchor(cell.topAnchor, left: view.rightAnchor, bottom: nil, right: cell.rightAnchor, topConstant: 5, leftConstant: 6, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 20)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: view.rightAnchor, bottom: view.bottomAnchor, right: cell.rightAnchor, topConstant: 2, leftConstant: 6, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        navigationController?.pushViewController(NTViewController(), animated: true)
    }
    
    func imageForStretchyView(in tableView: NTTableView) -> UIImage? {
        return UIImage(named: "Background")
    }
}
