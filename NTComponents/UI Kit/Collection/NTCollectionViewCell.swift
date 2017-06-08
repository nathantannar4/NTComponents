//
//  NTCollectionViewCell.swift
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

open class NTCollectionViewCell: UICollectionViewCell {
    
    open var datasourceItem: Any?
    open weak var controller: NTCollectionViewController?
    
    open let separatorLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Color.Gray.P300
        lineView.isHidden = true
        return lineView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    ///Override this method to provide your own custom views.
    open func setupViews() {
        
        clipsToBounds = true
        
        addSubview(separatorLineView)
        separatorLineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open class var cellSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: 44)
        }
    }
}
