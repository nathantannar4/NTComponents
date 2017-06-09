//
//  CollectionViewController.swift
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

import NTComponents

class Datasource: NTCollectionDatasource, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = Color.Default.Background.Button
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    open override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == 0 {
            let data = NTCollectionUserHeaderData(banner: #imageLiteral(resourceName: "Background"), photo: #imageLiteral(resourceName: "Nathan"), title: "Nathan Tannar", subtitle: "iOS Developer")
            return data
        }
        if indexPath.section == 1 {
            let data = NTCollectionDatasourceData(dataSource: self, delegate: nil, title: "Title", subtitle: "Subtitle")
            return data
        }
        return nil
    }
    
    open override func numberOfItems(_ section: Int) -> Int {
        return 1
    }
    
    open override func numberOfSections() -> Int {
        return 2
    }
    
    open override func footerClasses() -> [NTCollectionViewCell.Type]? {
        return [NTCollectionViewCell.self]
    }
    
    open override func headerClasses() -> [NTCollectionViewCell.Type]? {
        return [NTCollectionViewCell.self]
    }
    
    open override func cellClasses() -> [NTCollectionViewCell.Type] {
        return [NTCollectionUserHeaderCell.self, NTCollectionDatasourceCell.self]
    }
}

class CellDatasource: NTCollectionDatasource {
    
}

class CollectionViewController: NTCollectionViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        datasource = Datasource()
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 255)
        }
        if indexPath.section == 1{
            return CGSize(width: view.frame.width, height: 110)
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
