//
//  NTCollectionUserHeaderCell.swift
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
//  Created by Nathan Tannar on 6/8/17.
//

public struct NTCollectionUserHeaderData {
    public var banner: UIImage?
    public var photo: UIImage?
    public var title: String?
    public var subtitle: String?
    public init(banner: UIImage?, photo: UIImage?, title: String?, subtitle: String?) {
        self.banner = banner
        self.photo = photo
        self.title = title
        self.subtitle = subtitle
    }
}

open class NTCollectionUserHeaderCell: NTCollectionViewCell {
    
    open override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? NTCollectionUserHeaderData else {
                return
            }
            coverImageView.image = item.banner
            titleLabel.text = item.title
            subtitleLabel.text = item.subtitle
            profileImageView.image = item.photo
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
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    open let subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subhead)
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
        
        actionButton.anchor(titleLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 64, heightConstant: 30)
        
        titleLabel.anchor(coverImageView.bottomAnchor, left: view.rightAnchor, bottom: nil, right: actionButton.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
    }
}
