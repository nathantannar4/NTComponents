//
//  NTCollectionDatasource.swift
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

open class NTCollectionDatasource: NSObject {
    
    public var objects: [Any]?
    
    ///The cell classes that will be used to render out each section.
    open func cellClasses() -> [NTCollectionViewCell.Type] {
        return []
    }
    
    ///If you want more fine tuned control per row, override this method to provide the proper cell type that should be rendered
    open func cellClass(_ indexPath: IndexPath) -> NTCollectionViewCell.Type? {
        return nil
    }
    
    ///Override this method to provide your list with what kind of headers should be rendered per section
    open func headerClasses() -> [NTCollectionViewCell.Type]? {
        return []
    }
    
    ///Override this method to provide your list with what kind of footers should be rendered per section
    open func footerClasses() -> [NTCollectionViewCell.Type]? {
        return []
    }
    
    open func numberOfItems(_ section: Int) -> Int {
        return objects?.count ?? 0
    }
    
    open func numberOfSections() -> Int {
        return 1
    }
    
    ///For each row in your list, override this to provide it with a specific item. Access this in your DatasourceCell by overriding datasourceItem.
    open func item(_ indexPath: IndexPath) -> Any? {
        return objects?[indexPath.item]
    }
    
    ///If your headers need a special item, return it here.
    open func headerItem(_ section: Int) -> Any? {
        return nil
    }
    
    ///If your footers need a special item, return it here
    open func footerItem(_ section: Int) -> Any? {
        return nil
    }
}
