//
//  NTCollectionDatasourceCell.swift
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
//  Created by Nathan Tannar on 5/17/17.
//

public struct NTCollectionDatasourceData {
    public weak var dataSource: UICollectionViewDataSource?
    public weak var delegate: UICollectionViewDelegate?
    public var title: String?
    public var subtitle: String?
    public var cellSize: CGSize
    public init(dataSource: UICollectionViewDataSource?, delegate: UICollectionViewDelegate?, title: String?, subtitle: String?, cellSize: CGSize = CGSize(width: 60, height: 60)) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.title = title
        self.subtitle = subtitle
        self.cellSize = cellSize
    }
}

open class NTCollectionDatasourceCell: NTCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open override var datasourceItem: Any? {
        didSet {
            guard let data = datasourceItem as? NTCollectionDatasourceData else {
                return
            }
            collectionView.dataSource = data.dataSource
            collectionView.delegate = data.delegate
            titleLabel.text = data.title
            subtitleLabel.text = data.subtitle
            cellSize = data.cellSize
            collectionView.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open let titleLabel: NTLabel = {
        let label = NTLabel(style: .headline)
        label.adjustsFontSizeToFitWidth = true
        label.font = Font.Default.Title.withSize(13)
        return label
    }()
    
    open let subtitleLabel: NTLabel = {
        let label = NTLabel(style: .subhead)
        label.adjustsFontSizeToFitWidth = true
        label.font = Font.Default.Subtitle.withSize(11)
        return label
    }()
    
    open let actionButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.ripplePercent = 0.5
        button.rippleOverBounds = true
        button.backgroundColor = .clear
        button.rippleColor = Color.Gray.P200
        button.tintColor = Color.Gray.P800
        button.image = Icon.Arrow.Forward?.scale(to: 15)
        button.title = "View All"
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.setPreferredFontStyle(to: .caption)
        button.setTitleColor(.black, for: .highlighted)
        return button
    }()
    
    open var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    open var cellSize: CGSize = CGSize(width: 60, height: 60)
    
    open override func setupViews() {
        
        backgroundColor = .white
        separatorLineView.isHidden = false
        
        addSubview(collectionView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: actionButton.leftAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        subtitleLabel.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: actionButton.leftAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        actionButton.anchor(topAnchor, left: nil, bottom: subtitleLabel.bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 60, heightConstant: 0)
        collectionView.anchor(subtitleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    final public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = Color.Default.Background.ViewController
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    open override class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 120)
        }
    }
}
