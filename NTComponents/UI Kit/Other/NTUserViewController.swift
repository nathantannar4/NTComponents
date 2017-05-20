//
//  NTUserViewController.swift
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
//  Created by Nathan Tannar on 5/15/17.
//

open class UserDatasource: NTCollectionDatasource {
    
    open override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == 0 {
            return (bg: UIImage(), name: "Nathan Tannar", title: "iOS Developer", pic: UIImage())
        }
        return nil
    }
    
    open override func numberOfItems(_ section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 0
    }
    
    open override func numberOfSections() -> Int {
        return 1
    }
    
    open override func footerClasses() -> [NTCollectionViewCell.Type]? {
        return [NTCollectionViewCell.self]
    }
    
    open override func headerClasses() -> [NTCollectionViewCell.Type]? {
        return [NTCollectionViewCell.self]
    }
    
    open override func cellClasses() -> [NTCollectionViewCell.Type] {
        return [UserProfileCell.self]
    }
}

open class UserProfileCell: NTCollectionViewCell {
    
    open override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? (bg: UIImage, name: String, title: String, pic: UIImage?) else {
                return
            }
            coverImageView.image = item.bg
            titleLabel.text = item.name
            subtitleLabel.text = item.title
            profileImageView.image = item.pic
        }
    }
    
    open let coverImageView: NTImageView = {
        let imageView = NTImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.Default.Background.ViewController
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open let profileImageView: NTImageView = {
        let imageView = NTImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.Default.Background.ViewController
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .title)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open let subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subtitle)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open let actionButton: NTButton = {
        let button = NTButton()
        button.ripplePercent = 1.2
        button.touchUpAnimationTime = 0.3
        button.trackTouchLocation = false
        button.backgroundColor = .white
        button.layer.borderColor = Color.Default.Background.Button.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.rippleBackgroundView.layer.cornerRadius = 5
        button.title = "Follow"
        button.titleColor = Color.Default.Background.Button
        button.titleFont = Font.Default.Callout.withSize(12)
        button.rippleColor = Color.Default.Background.Button
        button.setTitleColor(.white, for: .highlighted)
        return button
    }()
    
    override open func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = Color.Gray.P500
        
        addSubview(coverImageView)
        
        let view = UIView()
        view.addSubview(profileImageView)
        view.setDefaultShadow()
        
        addSubview(view)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionButton)

        
        coverImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
        
        view.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 150, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        profileImageView.fillSuperview()
        
        actionButton.anchor(coverImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 64, heightConstant: 30)
        
        titleLabel.anchor(coverImageView.bottomAnchor, left: view.rightAnchor, bottom: nil, right: actionButton.leftAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
    }
}

open class NTProfileViewController: NTCollectionViewController {
    
    // MARK: - Standard Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        datasource = UserDatasource()
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 3 {
            return 10
        }
        return .leastNonzeroMagnitude
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 266)
        }
        
        return CGSize(width: view.frame.width, height: 44)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }
}
