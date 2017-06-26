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

import UIKit

open class NTCollectionViewDefaultHeader: NTCollectionViewDefaultCell {
    
    open override var datasourceItem: Any? {
        didSet {
            guard let text = datasourceItem as? String else {
                return
            }
            label.text = text
        }
    }
    
    override open func setupViews() {
        super.setupViews()
        
        label.setPreferredFontStyle(to: .subhead)
        backgroundColor = Color.Default.Background.ViewController
    }
}

open class NTCollectionViewDefaultFooter: NTCollectionViewDefaultCell {
    
    open override var datasourceItem: Any? {
        didSet {
            guard let text = datasourceItem as? String else {
                return
            }
            label.text = text
        }
    }
    
    override open func setupViews() {
        super.setupViews()
        
        separatorLineView.isHidden = true
        label.textAlignment = .center
        label.setPreferredFontStyle(to: .footnote)
        backgroundColor = Color.Default.Background.ViewController
    }
}

open class NTCollectionViewDefaultCell: NTCollectionViewCell {
    
    open override var datasourceItem: Any? {
        didSet {
            guard let text = datasourceItem as? String else {
                return
            }
            label.text = text
        }
    }
    
    open var label: NTLabel = {
        let label = NTLabel(style: .body)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override open func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        separatorLineView.isHidden = false
        
        addSubview(label)
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
}
