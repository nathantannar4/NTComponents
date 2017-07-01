//
//  ViewController.swift
//  NTResume
//
//  Created by Nathan Tannar on 6/29/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents

class ViewController: NTViewController {
    
    var bannerView: NTImageView = {
        let imageView = NTImageView(image: #imageLiteral(resourceName: "Banner"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var tagLabel: NTLabel = {
        let label = NTLabel(style: .callout)
        label.text = "Hi! I'm"
        label.textColor = .white
        return label
    }()
    
    var nameLabel: NTLabel = {
        let label = NTLabel()
        label.text = "Nathan Tannar"
        label.textColor = .white
        label.font = Font.Default.Headline.withSize(40)
        return label
    }()
    
    var headlineLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.text = "Computer Engineering Undergraduate Student\niOS Developer / Backend Developer"
        label.textColor = .white
        return label
    }()
    
    var resumeButton: NTButton = {
        let button = NTButton()
        button.setText(prefixText: "View Resume  ", icon: FAType.FAFilePdfO, postfixText: "", size: 15, forState: .normal)
        button.setIconColor(color: .white)
        button.buttonCornerRadius = 20
        button.ripplePercent = 0.3
        return button
    }()
    
    var aboutIcon: NTImageView = {
        let imageView = NTImageView()
        imageView.setIconAsImage(icon: FAType.FAInfo)
        return imageView
    }()
    
    var introLabel: NTLabel = {
        let label = NTLabel(style: .subhead)
        label.font = Font.Default.Subhead.withSize(20)
        label.textColor = .black
        label.text = "About Me"
        return label
    }()
    
    var introTextViewA: NTTextView = {
        let textView = NTTextView()
        textView.isEditable = false
        textView.text = "From a young age I knew I loved computers and was always facinated by their potential. I learned a variety of languages through school or my own self-tault learning to gain the skills I have today."
        textView.font = Font.Roboto.Light.withSize(17)
        return textView
    }()
    
    var introTextViewB: NTTextView = {
        let textView = NTTextView()
        textView.isEditable = false
        textView.text = "I became particularly interested in mobile and web development as it joined to unique aspects: designing UI/UX and programming the functionality to complement it. This is because I enjoy someone picking up something I've made in amazement.\n\nNow I am starting to learn more about servers, databases and security in a never ending pursuit of my imagination."
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bannerView)
        view.addSubview(tagLabel)
        view.addSubview(nameLabel)
        view.addSubview(headlineLabel)
        view.addSubview(resumeButton)
        view.addSubview(aboutIcon)
        view.addSubview(introLabel)
        view.addSubview(introTextViewA)
        view.addSubview(introTextViewB)
        
        bannerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300)
        
        
        tagLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 150, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 15)
        nameLabel.anchor(tagLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        headlineLabel.anchor(nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        resumeButton.anchor(headlineLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 40)
        
        aboutIcon.anchor(bannerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        introLabel.anchor(bannerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 56, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 15)
        introTextViewA.anchor(introLabel.bottomAnchor, left: introLabel.leftAnchor, bottom: introTextViewB.topAnchor, right: introLabel.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        introTextViewB.anchor(introTextViewA.bottomAnchor, left: introLabel.leftAnchor, bottom: view.bottomAnchor, right: introLabel.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

