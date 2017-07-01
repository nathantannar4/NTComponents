//
//  RightViewController.swift
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
//  Created by Nathan Tannar on 6/29/17.
//

import NTComponents

class RightViewController: NTViewController {
    
    
    var profileView: NTImageView = {
        let imageView = NTImageView(image: #imageLiteral(resourceName: "Nathan"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var toggleButton: NTButton = {
        let button = NTButton()
        button.setIcon(icon: FAType.FAClose, forState: .normal)
        button.layer.cornerRadius = 15
        button.trackTouchLocation = false
        button.ripplePercent = 1
        return button
    }()
    
    var connectLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.text = "Connect / Github"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(profileView)
        view.addSubview(toggleButton)
        
        profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        profileView.anchorCenterXToSuperview()
        profileView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileView.anchorAspectRatio()
        
        toggleButton.anchor(profileView.topAnchor, left: nil, bottom: nil, right: profileView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: -12, widthConstant: 30, heightConstant: 30)
        
        toggleButton.addTarget(self, action: #selector(closeDrawerSide), for: .touchUpInside)
        
        view.addSubview(connectLabel)
        connectLabel.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 80, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        let icons = [FAType.FAFacebook, FAType.FAInstagram, FAType.FALinkedin, FAType.FAGithub]
        var leftAnchor = view.leftAnchor
        for icon in icons {
            let button = UIButton()
            button.setIcon(icon: icon, forState: .normal)
            button.setIconColor(color: Color.Gray.P500)
            view.addSubview(button)
            button.anchor(nil, left: leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: CGFloat(225 / icons.count), heightConstant: 30)
            leftAnchor = button.rightAnchor
        }
    }
    
    func closeDrawerSide() {
        drawerController?.closeDrawer()
    }
}
