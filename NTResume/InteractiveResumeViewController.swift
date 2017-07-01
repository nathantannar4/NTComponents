//
//  InteractiveResumeViewController.swift
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
//  Created by Nathan Tannar on 6/30/17.
//

import NTComponents

class InteractiveResumeViewController: NTCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = ResumeDatasource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section > 0 {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
        return CGSize(width: view.frame.width, height: 0)
    }
}

class BannerCell: NTCollectionViewCell {
    
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
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bannerView)
        addSubview(tagLabel)
        addSubview(nameLabel)
        addSubview(headlineLabel)
        addSubview(resumeButton)
        
        bannerView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300)
        
        
        tagLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 150, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 15)
        nameLabel.anchor(tagLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        headlineLabel.anchor(nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        resumeButton.anchor(headlineLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 40)
        
    }
    
    open override class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 300)
        }
    }
}

class HeaderCell: NTCollectionViewCell {
    
    var iconView: NTImageView = {
        let imageView = NTImageView()
        imageView.setIconAsImage(icon: FAType.FAInfo)
        return imageView
    }()
    
    var titleLabel: NTLabel = {
        let label = NTLabel(style: .subhead)
        label.font = Font.Default.Subhead.withSize(20)
        label.textColor = .black
        label.text = "About Me"
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(iconView)
        addSubview(titleLabel)
        
        iconView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 32, leftConstant: 16, bottomConstant: 2, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
}

class TextCell: NTCollectionViewCell {
    
    var topTextView: NTTextView = {
        let textView = NTTextView()
        textView.isEditable = false
        textView.text = "From a young age I knew I loved computers and was always facinated by their potential. I learned a variety of languages through school or my own self-tault learning to gain the skills I have today."
        textView.font = Font.Roboto.Light.withSize(17)
        return textView
    }()
    
    var bottomTextView: NTTextView = {
        let textView = NTTextView()
        textView.isEditable = false
        textView.text = "I became particularly interested in mobile and web development as it joined to unique aspects: designing UI/UX and programming the functionality to complement it. This is because I enjoy someone picking up something I've made in amazement.\n\nNow I am starting to learn more about servers, databases and security in a never ending pursuit of my imagination."
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(topTextView)
        addSubview(bottomTextView)
        
        topTextView.anchor(topAnchor, left: leftAnchor, bottom: bottomTextView.topAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 3, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        bottomTextView.anchor(topTextView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 3, leftConstant: 16, bottomConstant: 6, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        topTextView.anchorHeightToItem(bottomTextView)
    }
    
    open override class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 220)
        }
    }
}

class ResumeDatasource: NTCollectionDatasource {
    ///The cell classes that will be used to render out each section.
    open override func cellClasses() -> [NTCollectionViewCell.Type] {
        return [BannerCell.self, TextCell.self]
    }
    
    ///If you want more fine tuned control per row, override this method to provide the proper cell type that should be rendered
//    open override func cellClass(_ indexPath: IndexPath) -> NTCollectionViewCell.Type? {
//        return nil
//    }
    
    ///Override this method to provide your list with what kind of headers should be rendered per section
    open override func headerClasses() -> [NTCollectionViewCell.Type]? {
        return [NTCollectionViewCell.self, HeaderCell.self]
    }
    
    ///Override this method to provide your list with what kind of footers should be rendered per section
    open override func footerClasses() -> [NTCollectionViewCell.Type]? {
        return []
    }
    
    open override func numberOfItems(_ section: Int) -> Int {
        return 1
    }
    
    open override func numberOfSections() -> Int {
        return 2
    }
    
    ///For each row in your list, override this to provide it with a specific item. Access this in your DatasourceCell by overriding datasourceItem.
    open override func item(_ indexPath: IndexPath) -> Any? {
        return objects?[indexPath.item]
    }
    
    ///If your headers need a special item, return it here.
    open override func headerItem(_ section: Int) -> Any? {
        return nil
    }
    
    ///If your footers need a special item, return it here
    open override func footerItem(_ section: Int) -> Any? {
        return nil
    }
}
